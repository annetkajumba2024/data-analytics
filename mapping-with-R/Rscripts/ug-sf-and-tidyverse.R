###################################################################################
# Mapping with R
# This script uses Uganda's 2024 census data to create
# a shapefile for Uganda with district, country, subregion, lat, long, and total population
# --------------R Script-----------------------------------------------------
#----------------Created by Annet Kajumba----------------------------------------------------------
library(sf)
library(readxl)
library(tidygeocoder)
library(mapview)
library(tidyverse)
library(readr)
library(dplyr)
library(leaflet)
library(viridis)

# Load data
uganda_districts <- read_csv("Ug_Education and PovertyData.csv")

# Select only the required columns
uganda_districts <- uganda_districts %>%
  select(Location, Country, SubReg, lat, long, TotPop)
View(uganda_districts)

# Save cleaned file
write_csv(uganda_districts, "Ugfilter/Uganda_TotalPopulation.csv")

# Ensure coordinates are numeric
uganda_districts <- uganda_districts %>%
  mutate(
    lat = as.numeric(lat),
    long = as.numeric(long)
  )

# Check if any values are NAs
summary(uganda_districts$lat)
summary(uganda_districts$long)

# Filter valid rows in there are NAs 
# or use google map or long.net to get coordinates for the missing ones
# Uncomment code to filter NAs

# uganda_geo_clean <- uganda_districts_geo %>%
#filter(!is.na(lat) & !is.na(long))

# Convert to shapefile
ugandaTP_sf <- st_as_sf(uganda_districts, coords = c("long", "lat"), crs = 4326)

# View summary to confirm geometry is filled
summary(ugandaTP_sf)
View(ugandaTP_sf)

# Save the shapefile to both directories
st_write(ugandaTP_sf, "Ug_CreatedShapefiles/uganda_districts.shp", delete_dsn = TRUE)
st_write(ugandaTP_sf, "03_03e/data/ug_districts/uganda_districts.shp", delete_dsn = TRUE)

# Set mapview to auto-zoom to data extent
mapviewOptions(fgb = FALSE) 

# Plot the map and color by school leavers aged 6 to 17
mapview(ugandaTP_sf, zcol = "TotPop", label = "Location")

# lets see Population by subregion

uganda_subregion_pop <- ugandaTP_sf %>%
  group_by(SubReg) %>%
  summarise(
    TotPop = sum(TotPop, na.rm = TRUE),
    geometry = st_union(geometry),  # merge geometries
    .groups = "drop"
  ) %>%
  st_as_sf()

# Display the results
mapviewOptions(fgb = FALSE)
mapview(uganda_subregion_pop, zcol = "TotPop", label = "Subregion")


# Display the created shapefile
# Load file 
uganda_tp <- st_read("03_03e/data/ug_districts/uganda_districts.shp")
# View attribute table
View(uganda_tp)
# Display on map
mapview(uganda_tp)


#--------------------------------------------------------------------
#------------------------------------------------------------------
#----------Do more filtering------------------------------------
# Education in Uganda
#--------------------------------------------------------------
#=========================================================
# Load files

ugandasp <- st_read("03_03e/data/ug_districts/uganda_districts.shp")
uganda_data <- read_csv("Ug_Education and PovertyData.csv")
View(uganda_data)

# Drop unwanted variables or columns
uganda_data <- uganda_data %>%
  select(-Country, -SubReg, -TotPop)
View(uganda_data)


# Join shapefile with data
uganda_edu <- ugandasp %>%
  left_join(uganda_data, by = c("Location" = "Location"))
View(uganda_edu)

# Convert to shapefile
uganda_sf1 <- st_as_sf(uganda_edu, coords = geometry, crs = 4326)

# View summary to confirm geometry is filled
summary(uganda_sf1)
View(uganda_sf1)

# Save the shapefile to both directories
st_write(uganda_sf1, "Ug_CreatedShapefiles/ug_EducPov.shp", delete_dsn = TRUE)
st_write(uganda_sf1, "03_03e/data/ug_districts/Ug_EduPov.shp", delete_dsn = TRUE)

# Set mapview to auto-zoom to data extent
mapviewOptions(fgb = FALSE) 

#------- Plot the map and color by no school children aged 3 to 6-------
mapview(uganda_sf1, zcol = "PerNot3_6", label = "Location")

#------ Plot the map and color by school leavers aged 6 to 17---------
mapview(uganda_sf1, zcol = "SchLeave6_17", label = "Location")

# -------Plot the map and color by youth(18-30yrs) not in anything-------
mapview(uganda_sf1, zcol = "NEET18_30P", label = "Location")

# -------Plot the map and color by youth(15-24yrs) not in anything------
mapview(uganda_sf1, zcol = "NEET15_24N", label = "Location")

#-----Plot the map and color by susbisitence economy------
mapview(uganda_sf1, zcol = "Subsistence Economy", label = "Location")

