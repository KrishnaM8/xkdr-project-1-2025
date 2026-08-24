library(survival)
library(survminer)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(lubridate)

cs_maindata <- read.csv("/Users/krishna/Documents/XKDR/Mumbai - Legal Systems/LSD Database/hearingsandmatters_data.csv")

cs_maindata <- cs_maindata %>%
  mutate(
    hearing_date = as.Date(hearing_date, format = "%Y-%m-%d"),
    filing_date = as.Date(filing_date, format = "%Y-%m-%d")
  ) %>%
  arrange(matter_id, hearing_date)

cs_maindata <- cs_maindata %>%
  group_by(matter_id) %>%
  summarise(
    filing_date = first(filing_date),
    first_hearing_date = min(hearing_date),
    second_hearing_date = nth(hearing_date, 2)
  ) %>%
  ungroup() %>%
  mutate(
    time_to_first_hearing = as.numeric(difftime(first_hearing_date, filing_date, units = "days")) / 365.25,
    time_to_second_hearing = as.numeric(difftime(second_hearing_date, first_hearing_date, units = "days")) / 365.25
  )

cs_filtereddata <- cs_maindata %>%
  filter(filing_date >= as.Date("2021-01-01"),
         filing_date <= as.Date("2023-12-31"))

cs_filtereddata <- cs_filtereddata %>%
  filter(time_to_first_hearing <= 0.25)

cs_filtereddata <- cs_filtereddata %>%
  mutate(
    event = ifelse(!is.na(time_to_second_hearing) & time_to_second_hearing >= 0, 1, 0)
  )

cs_value <- Surv(time = cs_filtereddata$time_to_second_hearing, 
                         event = cs_filtereddata$event)

cs_survfit <- survfit(cs_value ~ 1, data = cs_filtereddata)

print(summary(cs_survfit))

ggsurvplot(
  cs_survfit,                             
  data = cs_filtereddata,                
  risk.table = FALSE,                  
  conf.int = TRUE,                     
  conf.int.style = "ribbon",             
  palette = "Set2",                    
  xlab = "Years",                      
  ylab = "Conditional Survival Probability",       
  title = "Time to Second Hearing (Cases Filed Jan 2021 - Dec 2023)",
  surv.scale = "percent",              
  ggtheme = theme_minimal(),           
  censor.shape = "|",               
  censor.size = 4,
  xlim = c(0, 1),
  break.time.by = 0.25
)


cs_timepoints <- c(0.25, 0.5, 0.75, 1)
cs_survprob <- summary(cs_survfit, times = cs_timepoints)
print("\n Time to Second Hearing Statistics:")
for(i in seq_along(cs_timepoints)) {
  time_label <- if(cs_timepoints[i] < 1) {
    paste(round(cs_timepoints[i] * 12), "months")
  } else {
    paste(cs_timepoints[i], "year")
  }

  
  cs_hearingrate <- 1 - cs_survprob$surv[i]
  print(paste(
    "Cases getting second hearing within next",
    time_label,
    ":",
    round(cs_hearingrate * 100, 1),
    "%"
  ))
}

