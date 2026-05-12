# 🏦 NLP Central Banks

> Assessing the different layers of communication of central banks using NLP techniques.

---

## 👥 Contributors

| Name | Role |
|------|------|
| Lyna El Kamel | BERTopic analysis & social media comparison |
| Lisa Chardon-Denizot | Word2Vec embeddings |
| Sofiene Taamouti | Last section analysis |

---

## 📁 Repository Structure

```
nlp_central_banks/
│
├── 📂 lyna_work/                  # BERTopic Analysis on classical speeches
│   ├── preprocessing.ipynb        # Data cleaning and preparation
│   └── topic_modelling.ipynb      # BERTopic modeling + figures
│
├── 📂 lisa_work/                  # Word2Vec embeddings analysis
│   ├── preprocessing.ipynb        # Data cleaning and preparation
│   └── word2vec.ipynb             # Main analysis
    └── two_other_datasets.ipynb   #Comparaison with Bloomberg news and general audience news datasets    
│
├── 📂 sofiene_work/               # Last section analysis
│   ├── complexity_drivers.R
│   └── prep_data_reg.R
│
├── 📂 data/                       # Raw and processed data
│
├── social_mediavsclassic.ipynb    # Descriptive statistics: central bank vs social media
├── requirements.txt               # Python dependencies
└── README.md
```

---

## 📌 Project Sections

### 1. BERTopic Analysis — Classical Speeches (`lyna_work/`)
*Corresponds to Section 1 and Appendix of the paper.*

- **Preprocessing** (`preprocessing.ipynb`): text cleaning, tokenization, and preparation of central bank speeches.
- **Topic Modelling** (`topic_modelling.ipynb`): BERTopic modeling with figures and results.

### 1bis. Social Media vs Classical Communication (`social_mediavsclassic.ipynb`)
Descriptive statistics comparing central bank communication with social media communication. Corresponds to the first section of the report.

### 2. Word2Vec Embeddings — (`lisa_work/`)
- **Preprocessing** (`preprocessing.ipynb`): data preparation for embedding analysis.
- **Word2Vec** (`word2vec.ipynb`): main analysis using word embeddings.

### 3. Last Section Analysis — (`sofiene_work/`)
Analysis of the final part of the paper.

---

## ⚙️ Requirements

Install dependencies with:

```bash
pip install -r requirements.txt
```

---

## 📄 Paper

This repository supports the research paper on central bank communication layers. The `Proposal_updated.pdf` contains the initial research proposal.
