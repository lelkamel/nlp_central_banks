# ── module.py ──────────────────────────────────────────────

# ── Imports ────────────────────────────────────────────────
import os
import re
import io
import sys
import requests

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

try:
    import nltk
    import torch
    import spacy
    from tqdm import tqdm
    from umap import UMAP
    from hdbscan import HDBSCAN
    from transformers import AutoTokenizer, AutoConfig
    from sentence_transformers import SentenceTransformer
    from bertopic import BERTopic
    from sklearn.feature_extraction.text import CountVectorizer
    from nltk.corpus import stopwords
    import plotly.io as pio
    nltk.download('stopwords', quiet=True)
except ImportError as e:
    print(f"Warning: {e} — some functions will not be available")


import s3fs


# ── Data cleaning ──────────────────────────────────────────
def remove_references_section(t):
    """
    Detects and removes academic reference sections (References, Bibliography,
    Data Appendix) from the end of a speech text.

    The function first normalizes common footer patterns that appear before the
    section header (e.g. "All speeches are available online at 53 53 References"
    or "BIS central bankers speeches 19 References"), stripping page numbers and
    boilerplate text so that the header can be reliably detected.

    It then searches for the section header, and removes everything from that
    point onwards, but only if two conditions are met:
      - The header appears in the last 25% of the document (to avoid cutting
        mid-text mentions like "the references therein" or "as references show")
      - The header is not preceded by an article or determiner such as "the",
        "these", "those", "such" or "see" (which would indicate an in-text
        reference rather than a section title)

    Parameters
    ----------
    t : str
        Raw speech text.

    Returns
    -------
    str
        Cleaned text with the reference section removed, or the original text
        if no valid reference section was found.
    """
    t_normalized = re.sub(
        r'(All speeches are available online at\s*|BIS central bankers speeches\s*)?\b\d+\s*\d*\s*(References|Bibliography|Data Appendix)',
        r'\2',
        t, flags=re.IGNORECASE
    )
    match = re.search(
        r'(?<!\w)(References|Bibliography|Data Appendix)(?!\s*(?:therein|show|suggest|indicate|above|below|cited|found|include|see))',
        t_normalized, flags=re.IGNORECASE
    )
    if match:
        pos_pct = match.start() / len(t_normalized) * 100
        context_before = t_normalized[max(0, match.start()-80):match.start()]
        preceded_by_article = bool(re.search(
            r'\b(the|these|those|such|see)\s*$',
            context_before, re.IGNORECASE
        ))
        if pos_pct > 75 and not preceded_by_article:
            return t_normalized[:match.start()].strip()
    return t


def clean_text(row):
    """
    Applies a full cleaning pipeline to a single speech, using institution-
    specific rules derived from a careful inspection of the corpus.

    The following transformations are applied to all speeches:
      - Inline footnote markers [1], [2], etc. are removed
      - PDF page number artifacts (e.g. "1/2001 5") are deleted
      - Academic reference sections are removed via remove_references_section()
      - Markdown hyperlinks [text](url) are replaced by their display text only
      - Encoding artifacts from imperfect PDF extraction (e.g. "Rf6ntgen") 
        are deleted

    Institution-specific rules:
      - ECB : contact footers appended to all online publications are stripped
      - Federal Reserve : missing apostrophes introduced by PDF-to-text 
        conversion are restored (e.g. "Id" -> "I'd", "Whats" -> "What's")

    Parameters
    ----------
    row : pd.Series
        A row from the speeches DataFrame, containing at least 'text' 
        and 'CentralBank' fields.

    Returns
    -------
    str
        Fully cleaned speech text.
    """
    text = row['text']
    bank = row['CentralBank']

    text = re.sub(r'\[\d+\]', '', text)
    text = re.sub(r'\b\d{1,2}/\d{4}\s*\d*\b', '', text)
    text = remove_references_section(text)
    text = re.sub(r'\[([^\]]+)\]\([^\)]+\)', r'\1', text)
    text = re.sub(r'[A-Za-z]\d[A-Za-z]\d[A-Za-z]', '', text)

    if bank == 'European Central Bank':
        text = re.sub(r'CONTACT European Central Bank.*$', '', text, flags=re.DOTALL)

    if bank == 'Board of Governors of the Federal Reserve':
        fixes = {
            r'\bId\b':     "I'd",
            r'\bIts\b':    "It's",
            r'\bWhats\b':  "What's",
            r'\bThats\b':  "That's",
            r'\bdont\b':   "don't",
            r'\bwont\b':   "won't",
            r'\bcant\b':   "can't",
            r'\bdoesnt\b': "doesn't",
        }
        for pat, repl in fixes.items():
            text = re.sub(pat, repl, text)

    text = re.sub(r' {2,}', ' ', text)
    return text.strip()
    
# ── Chunking ───────────────────────────────────────────────
def count_tokens_batch(sentences, tokenizer, batch_size=512):
    """tokenizer must be passed explicitly."""
    all_counts = []
    for i in range(0, len(sentences), batch_size):
        batch = sentences[i:i + batch_size]
        encoded = tokenizer(
            batch,
            add_special_tokens=False,
            return_length=True,
            truncation=False,
        )
        all_counts.extend(encoded['length'])
    return all_counts


def process_corpus(df, nlp, tokenizer, max_tokens=450, overlap_sents=2, batch_size=64):
    """
    nlp      : spaCy model
    tokenizer: HuggingFace tokenizer
    """
    records = []
    texts   = df['text_clean'].tolist()
    indices = df.index.tolist()

    print("Sentence segmentation (spaCy)...")
    docs = list(tqdm(
        nlp.pipe(texts, batch_size=batch_size),
        total=len(texts),
        desc="spaCy"
    ))

    print("Chunking...")
    for doc, idx in tqdm(zip(docs, indices), total=len(docs), desc="Chunking"):
        row = df.loc[idx]
        sentences = [s.text.strip() for s in doc.sents if s.text.strip()]
        if not sentences:
            continue

        token_counts = count_tokens_batch(sentences, tokenizer)
        chunks, current_sents, current_tokens = [], [], 0

        for sent, n_tok in zip(sentences, token_counts):
            if n_tok > max_tokens:
                if current_sents:
                    chunks.append(" ".join(current_sents))
                chunks.append(sent)
                current_sents, current_tokens = [], 0
                continue

            if current_tokens + n_tok > max_tokens and current_sents:
                chunks.append(" ".join(current_sents))
                current_sents = current_sents[-overlap_sents:]
                current_tokens = sum(
                    count_tokens_batch([s], tokenizer)[0]
                    for s in current_sents
                )

            current_sents.append(sent)
            current_tokens += n_tok

        if current_sents:
            chunks.append(" ".join(current_sents))

        for i, chunk in enumerate(chunks):
            records.append({
                'doc_id':      row['Unnamed: 0'],
                'chunk_id':    i,
                'CentralBank': row['CentralBank'],
                'Date':        row['Date'],
                'Year':        row['Year'],
                'Authorname':  row['Authorname'],
                'Role':        row['Role'],
                'Source':      row['Source'],
                'chunk_text':  chunk,
                'n_words':     len(chunk.split()),
            })

    return pd.DataFrame(records)


# ── Stopwords & Vectorizer ─────────────────────────────────
def get_stopwords():
    standard_stopwords = list(stopwords.words('english'))
    additional_stopwords = [
        "ecb", "eurosystem", "eurozone", "fed", "federal", "reserve",
        "fomc", "boe", "bank", "banks", "central", "committee",
        "council", "governing", "board",
        "european", "england", "governors",
        "european union", "european commission", "european parliament",
        "imf", "international monetary fund",
        "bis", "bank international settlements",
        "oecd", "world bank", "g7", "g20",
        "united nations", "wto",
        "united states", "america", "american",
        "germany", "german", "france", "french",
        "italy", "italian", "spain", "spanish",
        "japan", "japanese", "china", "chinese",
        "uk", "britain", "british",
        "greece", "greek", "portugal", "portuguese",
        "ireland", "irish", "netherlands", "dutch",
        "switzerland", "swiss", "sweden", "swedish",
        "denmark", "danish", "norway", "norwegian",
        "canada", "canadian", "australia", "australian",
        "euro", "area", "zone", "region", "regions",
        "global", "international", "domestic",
        "world", "worldwide", "cross", "border",
        "president", "governor", "chairman", "vice", "deputy",
        "mr", "mrs", "dr", "professor", "minister",
        "government", "governments",
        "today", "thank", "thanks", "pleasure", "honored", "welcome",
        "morning", "afternoon", "evening", "conference", "symposium",
        "ladies", "gentlemen", "colleagues", "friends",
        "speech", "remarks", "address", "statement", "introductory",
        "keynote", "presentation", "lecture",
        "year", "years", "month", "months", "day", "days",
        "time", "times", "period", "periods",
        "recent", "recently", "current", "currently",
        "past", "future", "last", "next", "first", "second",
        "quarter", "quarters", "decade", "decades",
        "economy", "economic", "economies",
        "growth", "rate", "rates",
        "policy", "policies",
        "market", "markets",
        "percent", "percentage",
        "billion", "trillion", "million",
        "also", "however", "therefore", "thus", "indeed",
        "moreover", "furthermore", "course", "fact", "example",
        "important", "significant", "particular", "general",
        "well", "said", "say", "know", "think",
        "need", "want", "make", "take", "come", "going",
        "one", "two", "three", "many", "much", "large", "small",
        "including", "would", "could", "should", "may", "might",
        "act", "law", "regulation", "framework", "mandate",
        "article", "treaty", "agreement",
        "community", "communities", "community development",
        "reinvestment", "cra", "neighborhood", "neighborhoods",
        "financial", "monetary", "stability",
        "inflation", "risk", "capital", "interest", "system",
        "new", "price", "crisis", "debt",
        "support", "measures", "asset", "purchases",
        "banknotes", "coins", "cash", "currency",
    ]
    return list(set(standard_stopwords + additional_stopwords))



# ── Plotly setup ───────────────────────────────────────────
def setup_plotly():
    if 'nbformat' in sys.modules:
        del sys.modules['nbformat']
    import nbformat
    if 'plotly.io._renderers' in sys.modules:
        del sys.modules['plotly.io._renderers']
    import plotly.io._renderers
    pio.renderers.default = "notebook_connected"
    print(f"nbformat : {nbformat.__version__}")