# CLEAN Trial
# GPS Coordinates Checking
# Author: Annet Kajumba
# Date created: 07/14/25

# This R script checks whether GPS coordinates from 
# enrollment, exit, chlorine monitoring surveys were collected within 
#  a 100-meter radius of the assigned health facility, using facility 
# baseline data for true locations. It flags outliers for location accuracy.

#-----------------------------------

# Install geosphere for calculating geospatial distances
install.packages("geosphere")

# Load required libraries
library(dplyr)      # for data manipulation
library(geosphere)  # for calculating geospatial distances

# Set radius threshold (in meters)
radius_m <- 100

# Load datasets
chlorine <- read.csv("C:/Users/annet/Box/Kenya_chlorine_RCT_HCF/data/1-raw data/current/CLEAN_chlorine_monitoring_WIDE.csv")
exit <- read.csv("C:/Users/annet/Box/Kenya_chlorine_RCT_HCF/data/1-raw data/current/CLEAN_exit_survey_WIDE.csv")
enrollment <- read.csv("C:/Users/annet/Box/Kenya_chlorine_RCT_HCF/data/1-raw data/current/CLEAN_enrollment_survey_WIDE.csv")
facilities <- read.csv("C:/Users/annet/Box/Kenya_chlorine_RCT_HCF/data/1-raw data/current/CLEAN_hcf_survey_WIDE.csv")

# Find any GPS-related columns in the chlorine survey
gps_candidates <- grep("lat|lon|gps|geo|location|coord", names(chlorine), value = TRUE, ignore.case = TRUE)
print(gps_candidates)


# Look for possible GPS-related columns
gps_candidates <- grep("lat|lon|gps|location", names(chlorine), value = TRUE, ignore.case = TRUE)
print(gps_candidates)


# View column names of each survey
cat("Chlorine survey columns:\n")
print(colnames(chlorine))

# Rename facility GPS columns for consistency
facilities <- facilities %>%
  rename(
    facility_id = hcf_id,
    facility_lat = gps_lat,
    facility_lon = gps_lon
  )

### Function to process and flag GPS outliers ###
flag_gps_outliers <- function(survey_df, survey_name) {
  survey_processed <- survey_df %>%
    rename(
      latitude = gps_lat,
      longitude = gps_lon,
      facility_id = hcf_id
    ) %>%
    left_join(facilities, by = "facility_id") %>%
    rowwise() %>%
    mutate(
      distance_m = distHaversine(
        c(longitude, latitude),
        c(facility_lon, facility_lat)
      )
    ) %>%
    ungroup() %>%
    mutate(outside_radius = distance_m > radius_m)
  
  # Print summary
  summary <- survey_processed %>%
    group_by(outside_radius) %>%
    summarise(count = n())
  print(paste("Summary for", survey_name))
  print(summary)
  
  # Save flagged records
  flagged <- survey_processed %>% filter(outside_radius)
  write.csv(flagged, paste0("flagged_", survey_name, "_outside_radius.csv"), row.names = FALSE)
  
  return(flagged)
}

# Run for each survey
flagged_chlorine <- flag_gps_outliers(chlorine, "chlorine_monitoring")
flagged_exit <- flag_gps_outliers(exit, "exit_survey")
flagged_enrollment <- flag_gps_outliers(enrollment, "enrollment_survey")























# Load your datasets (replace with actual file paths if reading from CSV)
# surveys <- read.csv("path_to_your_survey_data.csv")
# facilities <- read.csv("path_to_your_facility_data.csv")

# Example: preview column names
# head(surveys)
# head(facilities)

# Join survey data with facility coordinates using facility_id
survey_with_fac_coords <- surveys %>%
  left_join(facilities, by = "facility_id")

# Calculate distance in meters between the survey location and the health facility
survey_with_distances <- survey_with_fac_coords %>%
  rowwise() %>%
  mutate(
    distance_m = distHaversine(
      c(longitude, latitude), 
      c(facility_lon, facility_lat)
    )
  ) %>%
  ungroup()

# Set a radius threshold in meters (adjust if needed: 100, 200, or 500)
radius_m <- 100

# Flag surveys where the GPS point is outside the allowed radius
flagged_surveys <- survey_with_distances %>%
  filter(distance_m > radius_m)

# Summary count of surveys inside vs. outside the radius
summary_counts <- survey_with_distances %>%
  mutate(outside_radius = distance_m > radius_m) %>%
  group_by(outside_radius) %>%
  summarise(count = n())
# View the flagged surveys
View(flagged_surveys)

# Save flagged surveys to a CSV file
write.csv(flagged_surveys, "flagged_surveys_outside_radius.csv", row.names = FALSE)

# View summary counts of surveys inside/outside radius
print(summary_counts)


