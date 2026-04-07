library(readxl)
library(haven)
library(tidyverse)


#US Fed
confidence_Fed = read_excel("data/fed_confidence.xlsx")

#Bank of England
confidence_BoE <- read_excel("data/BoE_confidence.xlsx", 
range = "A238:DC248",
col_names = FALSE) %>%
  na.omit()


# renommer la première colonne
names(confidence_BoE)[1] <- "category"

start_date <- ymd("1999-11-01")  

# donner des noms temporaires aux colonnes de mois
names(confidence_BoE)[-1] <- as.character(seq.Date(
  from = start_date,
  by = "3 months",
  length.out = ncol(confidence_BoE) - 1
))

confidence_BoE_tidy <- confidence_BoE %>%
  pivot_longer(
    cols = -category,
    names_to = "month",
    values_to = "Total satisfied"
  ) %>%
  filter(category == "Total satisfied") %>%
  select(-category)

#ECB
#variable of interest: treu_ecb. 1: trust ; 2: no trust

ecb_confidence <- read_dta("data/harmonised_EB_2004-2021_v3-0-0.dta") 

ecb_confidence <- ecb_confidence %>%
  select(year, treu_ecb) %>%
  na.omit() 




