library(survival)
library(survminer)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(lubridate)

cs_maindata_wdisp <- read.csv("/Users/krishna/Documents/XKDR/Mumbai - Legal Systems/LSD Database/hearingsandmatters_data2.csv")

cs_maindata_wdisp <- cs_maindata_wdisp %>%
  mutate(
    hearing_date = as.Date(hearing_date, format = "%Y-%m-%d"),
    filing_date = as.Date(filing_date, format = "%Y-%m-%d"),
    disposal_date = as.Date(disposal_date, format = "%Y-%m-%d")
  ) %>%
  arrange(matter_id, hearing_date)

cs_maindata_wdisp <- cs_maindata_wdisp %>%
  group_by(matter_id) %>%
  summarise(
    filing_date = first(filing_date),
    first_hearing_date = min(hearing_date),
    disposal_date = first(disposal_date)
  ) %>%
  ungroup() %>%
  mutate(
    time_to_first_hearing = as.numeric(difftime(first_hearing_date, filing_date, units = "days")) / 365.25,
    time_to_disposal = as.numeric(difftime(disposal_date, first_hearing_date, units = "days")) / 365.25
  )

cs_maindata_wdisp <- cs_maindata_wdisp %>%
  filter(time_to_first_hearing >= 0 | is.na(time_to_first_hearing), 
         time_to_disposal >= 0 | is.na(time_to_disposal))

cs_filtereddata_wdisp <- cs_maindata_wdisp %>%
  filter(filing_date >= as.Date("2017-01-01"),
         filing_date <= as.Date("2019-12-31"))

cs_filtereddata_wdisp <- cs_filtereddata_wdisp %>%
  mutate(
    event = ifelse(!is.na(time_to_disposal) & time_to_disposal >= 0
                   & time_to_first_hearing <= 0.25, 1, 0)
  )

cs_value <- Surv(time = cs_filtereddata_wdisp$time_to_disposal, 
                 event = cs_filtereddata_wdisp$event)

cs_survfit <- survfit(cs_value ~ 1, data = cs_filtereddata_wdisp)

print(summary(cs_survfit))

cs_survplot <- ggsurvplot(
  cs_survfit,                             
  data = cs_filtereddata_wdisp,                
  break.time.by = 0.25,                 
  xlab = "Years",                      
  ylab = "Conditional Survival Probability",       
  title = "Conditioned time to disposal for cases filed from Jan 2017 to Dec 2019",  
  surv.scale = "percent",              
  conf.int = TRUE,                     
  conf.int.style = "ribbon", 
  conf.int.fill = "lightcoral",
  palette = "Set5",
  legend.labs = "NCLT",
  ggtheme = theme_minimal() +
    theme(
      plot.margin = margin(0.5, 1, 0.5, 1, "cm"),  # Add space on the sides
      axis.line = element_line(color = "black", size = 0.5),  
      axis.ticks = element_line(color = "black", size = 0.5),  
      legend.position = "bottom",
      legend.title = element_blank(),  
      plot.title = element_text(size = 10, face = "bold")  # Adjust title text size and bold
    ),         
  censor.shape = "|",               
  censor.size = 1,
  linetype = "solid",  # Adjust line type
  linewidth = 1.2,  # Adjust line width
  xlim = c(0, 7)
)

gg_plot <- cs_survplot$plot

gg_plot + 
  geom_vline(xintercept = 0.5, linetype = "dashed", color = "black", linewidth = 0.2)  # Add vertical reference line


cs_timepoints <- c(0.25, 0.5, 0.75, 1, 2, 3)
cs_survprob <- summary(cs_survfit, times = cs_timepoints)
print("\n Time to Second Hearing Statistics:")
for(i in seq_along(cs_timepoints)) {
  time_label <- if(cs_timepoints[i] < 1) {
    paste(round(cs_timepoints[i] * 12), "months")
  } else {
    paste(cs_timepoints[i], "years")
  }
  
  
  cs_hearingrate <- 1 - cs_survprob$surv[i]
  print(paste(
    "Cases getting disposed off within next",
    time_label,
    ", given the first hearing happened within 3 months of filing:",
    round(cs_hearingrate * 100, 1),
    "%"
  ))
}

