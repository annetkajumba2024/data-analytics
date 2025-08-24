# -------------------------------
# X-mother-survey-crossref
# Objective: Compare reported vs submitted survey counts across datasets
# -------------------------------

library(readr)
library(dplyr)
library(stringr)
library(tidyr)

# Load data using actual paths
# From my dayasets, each dataset corresponds to a different survey type (daily reporting, enrollment,
# exit, 7-day follow-up, 28-day follow-up, environmental sampling, chlorine monitoring).
# The daily reporting (dr) dataset contains the "reported" survey counts by facility/date,
# while the others contain the actual survey submissions ("submitted").


dr   <- read_csv("C:/Users/annet/CLEAN_daily_reporting_WIDE.csv")
enr  <- read_csv("C:/Users/annet/CLEAN_enrollment_survey_WIDE.csv")
exit1 <- read_csv("C:/Users/annet/CLEAN_exit_survey_WIDE.csv")
s7   <- read_csv("C:/Users/annet/CLEAN 7day survey_WIDE.csv")
s28  <- read_csv("C:/Users/annet/current/CLEAN 28day survey_WIDE.csv")
evir <- read_csv("C:/Users/annet/current/CLEAN_environmental_sampling_form_WIDE.csv")
clm  <- read_csv("C:/Users/annet/current/CLEAN_chlorine_monitoring_WIDE.csv")



#-------------------------------
# Preprocess Dates
#-------------------------------
dr$visit_date    <- as.Date(dr$survey_date, format = "%m/%d/%Y")
enr$visit_date   <- as.Date(enr$enrollment_survey_date, format = "%m/%d/%Y")
exit1$visit_date <- as.Date(exit1$exit_survey_date, format = "%m/%d/%Y")
s7$visit_date    <- as.Date(s7$survey_date_7day, format = "%m/%d/%Y")
s28$visit_date   <- as.Date(s28$survey_date_28day, format = "%m/%d/%Y")
evir$visit_date  <- as.Date(evir$survey_date, format = "%m/%d/%Y")
clm$visit_date   <- as.Date(clm$visit_date, format = "%m/%d/%Y") 


# --- Function: Check mismatch with facility
# Compares reported survey counts (from daily reporting) with the actual submitted
# survey records for a given survey type, grouped by facility and date.
# Flags mismatches where reported count ≠ submitted count.


check_mismatch <- function(dr, actual, survey_type, reported_col, facility_col = "facility_ID") {
  reported <- dr %>%
    select(visit_date, !!sym(reported_col), facility_ID) %>%
    rename(reported_count = !!sym(reported_col))
  
  submitted <- actual %>%
    rename(facility_ID = !!sym(facility_col)) %>%
    group_by(facility_ID, visit_date) %>%
    summarise(submitted_count = n(), .groups = "drop")
  
  result <- reported %>%
    left_join(submitted, by = c("facility_ID", "visit_date")) %>%
    mutate(submitted_count = replace_na(submitted_count, 0)) %>%
    filter(reported_count != submitted_count)
  
  if (nrow(result) > 0) {
    cat("\n⚠️ Mismatch in", survey_type, "- reported vs actual submissions\n")
    print(result)
  } else {
    cat("\n✅", survey_type, "- all entries match\n")
  }
}

# --- Function: Check mismatch without facility
check_mismatch_nofacility <- function(dr, actual, survey_type, reported_col) {
  reported <- dr %>%
    select(visit_date, !!sym(reported_col)) %>%
    rename(reported_count = !!sym(reported_col))
  
  submitted <- actual %>%
    group_by(visit_date) %>%
    summarise(submitted_count = n(), .groups = "drop")
  
  result <- reported %>%
    left_join(submitted, by = "visit_date") %>%
    mutate(submitted_count = replace_na(submitted_count, 0)) %>%
    filter(reported_count != submitted_count)
  
  if (nrow(result) > 0) {
    cat("\n⚠️ Mismatch in", survey_type, "- reported vs actual submissions (by date only)\n")
    print(result)
  } else {
    cat("\n✅", survey_type, "- all entries match (by date only)\n")
  }
}

# --- Run mismatch checks
check_mismatch(dr, enr, "Enrollment", "enrollment_number", facility_col = "facility_id")
check_mismatch(dr, exit1, "Exit", "exit_number", facility_col = "facility_ID")
check_mismatch_nofacility(dr, s7, "7-Day Follow-up", "seven_day_number")
check_mismatch_nofacility(dr, s28, "28-Day Follow-up", "twentyeight_day_number")
check_mismatch(dr, evir, "Environmental Sampling", "env_hcf", facility_col = "facility_id")
check_mismatch(dr, clm, "Chlorine Monitoring", "chlorine_mon_hcf", facility_col = "hcf")