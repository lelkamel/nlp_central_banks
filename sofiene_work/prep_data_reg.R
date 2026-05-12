library(readxl)
library(haven)
library(tidyverse)
library(writexl)

######
## Let's deal first with trust data
######

#US Fed
confidence_Fed = read_excel("data/fed_confidence.xlsx") %>%
  arrange(Year)

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
  select(-category) %>%
  mutate(year = year(month)) %>%
  group_by(year) %>%
  summarise("Total satisfied" = mean(`Total satisfied`, na.rm = TRUE))

#ECB
#variable of interest: treu_ecb. 1: trust ; 2: no trust

df_ecb <- read_dta("data/harmonised_EB_2004-2021_v3-0-0.dta") 

df_ecb_p2 <- read_excel("data/ecb_complement.xlsx") %>%
  mutate(year = year(year)) %>%
  group_by(year) %>%
  summarise(prop_confident = mean(prop_confident))

ecb_confidence_p1 <- df_ecb %>%
  select(year, treu_ecb) %>%
  na.omit() %>%
  group_by(year) %>%
  summarise(prop_confident = mean(treu_ecb == 1)*100)

ecb_confidence <- bind_rows(df_ecb_p2, ecb_confidence_p1) %>%
  arrange(year)

#confidence dataset
names(ecb_confidence)[1] <- "date"
names(confidence_BoE_tidy)[1] <- "date"
names(confidence_Fed)[1] <- "date"

cf_df <- ecb_confidence %>%
  inner_join(confidence_BoE_tidy, by = "date") %>%
  inner_join(confidence_Fed, by = "date")

names(cf_df)[2:4] <- c("ECB_trust", "BoE_trust", "Fed_trust")

write_xlsx(cf_df, "data/bc_trust_data.xlsx")

######
## Now we deal with inflation data
######

ecb_inf <- read_excel("data/inflation_data/ECB_data.xlsx", range = "B15:C46") 

UK_inf <- read_excel("data/inflation_data/UK_data.xlsx", sheet = "Annual") %>%
  mutate(date = as.numeric(year(observation_date))) %>%
  select(-observation_date)

US_inf <- read_csv("data/inflation_data/US_data.csv") %>%
  mutate(
    inf = (CPIAUCSL/lag(CPIAUCSL, 12) - 1)*100
  ) %>%
  mutate(year = year(observation_date)) %>%
  group_by(year) %>%
  summarise(inf = mean(inf, na.rm = TRUE))

names(UK_inf)[2] <- "year"
names(ecb_inf)[1] <- "year"

ecb_inf$year <- as.numeric(ecb_inf$year)

#inf data

inf_data <- US_inf %>%
  inner_join(ecb_inf, by = "year") %>%
  inner_join(UK_inf, by = "year")

names(inf_data)[2:4] <- c("US_inf", "EA_inf", "UK_inf")

write_xlsx(inf_data, "data/data_inf.xlsx")
