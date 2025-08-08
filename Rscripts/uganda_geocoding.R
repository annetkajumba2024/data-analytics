library(sf)
library(readxl)
library(tidygeocoder)
library(mapview)
library(tidyverse)
library(readr)
library(dplyr)
library(leaflet)

# Load Uganda 2024 census data with the districts

uganda_districts <- read_csv("02_05e/data/uganda_geocoding.csv")

# Geocode each district/city name to get their geographical coordinates

uganda_districts_geo <- uganda_districts %>% 
  geocode(
    city = Location,
    country = Country,
    method = "iq"
  )

View(uganda_districts_geo)

# This code adjusts the coordinates for districts whose centers have become cities 
# (e.g., Mbarara, Gulu, Masaka, Hoima, Jinja, Arua, etc).
# After geocoding, both the city and its corresponding district often share the same coordinates,
# leading to overlapping points on the map.
# To visually separate them, this code shifts the district locations slightly southwest
# by subtracting 0.04 from both latitude and longitude.
# Uncomment this code if there are overlapping points between cities and districts

# uganda_districts_geo <- uganda_districts_geo %>%
#   mutate(
#     long = case_when(
#       Location == "Mbarara" ~ long - 0.04,
#       Location == "Gulu" ~ long - 0.04,
#       Location == "Masaka" ~ long - 0.04,
#       Location == "Hoima" ~ long - 0.04,
#       Location == "Jinja" ~ long - 0.04,
#       Location == "Arua" ~ long - 0.04,
#       TRUE ~ long
#     ),
#     lat = case_when(
#       Location == "Mbarara" ~ lat - 0.04,
#       Location == "Gulu" ~ lat - 0.04,
#       Location == "Masaka" ~ lat - 0.04,
#       Location == "Hoima" ~ lat - 0.04,
#       Location == "Jinja" ~ lat - 0.04,
#       Location == "Arua" ~ lat - 0.04,
#       TRUE ~ lat
#     )
#   )

write_csv(uganda_districts_geo, "uganda_districts_geocoded.csv")

uganda_districts_geo <- read_csv("02_05e/data/uganda_geocoding.csv")
View(uganda_districts_geo)

# Ensure coordinates are numeric
uganda_districts_geo <- uganda_districts_geo %>%
  mutate(
    lat = as.numeric(lat),
    long = as.numeric(long)
  )

# Check if any values are NAs
summary(uganda_districts_geo$lat)
summary(uganda_districts_geo$long)

# Filter valid rows in there are NAs 
# or use google map or long.net to get coordinates for the missing ones
# Uncomment code to filter NAs

# uganda_geo_clean <- uganda_districts_geo %>%
  #filter(!is.na(lat) & !is.na(long))

# Convert to shapefile
uganda_sf <- st_as_sf(uganda_districts_geo, coords = c("long", "lat"), crs = 4326)

# View summary to confirm geometry is filled
summary(uganda_sf)
View(uganda_sf)

# Save the shapefile
st_write(
  uganda_sf,
  "02_05e/data/shapefiles/uganda_districts_geocoded.shp",
  delete_dsn = TRUE
)

# Set mapview to auto-zoom to data extent
mapviewOptions(fgb = FALSE) 

# Plot the map and color by school leavers aged 6 to 17
mapview(uganda_sf, zcol = "PerSchLv6_17", label = "Location")

uganda_sfgeo <- st_read("02_05e/data/shapefiles/uganda_districts_geocoded.shp")

# View attribute table
View(uganda_sfgeo)

mapview(uganda_sfgeo)



