library(readxl)
library(tidyverse)
library(fixest)

trust_data <- read_excel("data/bc_trust_data.xlsx")
inf_data <- read_excel("data/data_inf.xlsx")
complexity_data <- read_csv("C:/Users/sofie/Desktop/ENSAE/3A/Projet EPD/df_with_depth.csv") %>%
  filter(CentralBank %in% c("Bank of England",
 "Board of Governors of the Federal Reserve",
 "European Central Bank")
  ) %>%
  select(Date, CentralBank, flesch_score)

complexity_data_clean <- complexity_data %>%
  mutate(year = year(Date)) %>%
  group_by(year, CentralBank) %>%
  summarise(avg_complexity = mean(flesch_score))

inf_data_long <- inf_data %>%
  pivot_longer(
    cols = c(US_inf, EA_inf, UK_inf),
    names_to = "CentralBank",
    values_to = "inflation"
  ) %>%
  mutate(CentralBank = case_when(
    CentralBank == "US_inf" ~ "Board of Governors of the Federal Reserve",
    CentralBank == "EA_inf" ~ "European Central Bank",
    CentralBank == "UK_inf" ~ "Bank of England"
  ))

trust_data_long <- trust_data %>%
  pivot_longer(
    cols = contains("trust"),
    names_to = "CentralBank",
    values_to = "Trust"
  ) %>%
  mutate(CentralBank = case_when(
    CentralBank == "Fed_trust" ~ "Board of Governors of the Federal Reserve",
    CentralBank == "ECB_trust" ~ "European Central Bank",
    CentralBank == "BoE_trust" ~ "Bank of England"
  ))

colnames(trust_data_long)[1] <- "year"

data_reg <- complexity_data_clean %>%
  merge(inf_data_long, by = c("year", "CentralBank")) %>%
  merge(trust_data_long, by = c("year", "CentralBank")) %>%
  arrange(CentralBank, year) %>%
  group_by(CentralBank) %>%
  mutate(
    inflation_l1 = lag(inflation, 1),
    Trust_l1 = lag(Trust, 1)
  ) %>%
  ungroup()

#regression time !

mod <- feols(
  avg_complexity ~ inflation_l1 + Trust_l1 | year + CentralBank,
  data = data_reg
)

summary(mod)
