library(survival)
library(survminer)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(lubridate)

cs_maindata <- read.csv("hearingsandmatters_data.csv")

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
    first_hearing_date = min(hearing_date)
  ) %>%
  ungroup() %>%
  mutate(
    time_to_first_hearing = as.numeric(difftime(first_hearing_date, filing_date, units = "days")) / 365.25,
  )

cs_maindata <- cs_maindata %>%
  filter(time_to_first_hearing >= 0 | is.na(time_to_first_hearing)
         )


cs_filtereddata <- cs_maindata %>%
  filter(filing_date >= as.Date("2021-01-01"),
         filing_date <= as.Date("2023-12-31"))

cs_filtereddata <- cs_filtereddata %>%
  mutate(
    event = ifelse(!is.na(time_to_first_hearing) & time_to_first_hearing >= 0, 1, 0)
  )

cs_value <- Surv(time = cs_filtereddata$time_to_first_hearing, 
                 event = cs_filtereddata$event)

cs_survfit <- survfit(cs_value ~ 1, data = cs_filtereddata)

print(summary(cs_survfit))

cs_survplot <- ggsurvplot(
  cs_survfit,                             
  data = cs_filtereddata,                
  break.time.by = 0.25,                 
  xlab = "Years",                      
  ylab = "Survival Probability",       
  title = "Time to first hearing for cases filed from Jan 2021 to Dec 2023",  
  surv.scale = "percent",              
  conf.int = TRUE,                     
  conf.int.style = "ribbon",             
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
  xlim = c(0, 1)
)

gg_plot <- cs_survplot$plot

gg_plot + 
  geom_vline(xintercept = 0.5, linetype = "dashed", color = "black", linewidth = 0.2)


cs_timepoints <- c(0.25, 0.5, 0.75, 1)
cs_survprob <- summary(cs_survfit, times = cs_timepoints)
print("Time to First Hearing Statistics:")
for(i in seq_along(cs_timepoints)) {
  time_label <- if(cs_timepoints[i] < 1) {
    paste(round(cs_timepoints[i] * 12), "months")
  } else {
    paste(cs_timepoints[i], "year")
  }
  
  
  cs_hearingrate <- 1 - cs_survprob$surv[i]
  print(paste(
    "Cases getting its first hearing within",
    time_label,
    ":",
    round(cs_hearingrate * 100, 1),
    "%"
  ))
}

