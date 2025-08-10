#########################################
#------Mapping poverty in Uganda with NASA’s GRDI data and R programming-------
# Author: Annet Kajumba
# Created: 8th August, 2025
#########################################
# Load libraries
libs <- c(
  "tidyverse", "rgeoboundaries", "sf", "terra", "rayshader",
  "tmap", "viridis", "ggspatial", "scales",
  "leaflet", "mapview", "htmlwidgets",
  "exactextractr", "stars", "spatstat",
  "rnaturalearth", "geodata", "elevatr", "rdhs"
)

# Load Uganda districts shapefile
uganda_admn2 <- sf::st_read("data/shapefiles/geoBoundaries-UGA-ADM3-all/geoBoundaries-UGA-ADM3.shp")

# 2. Global Gridded Relative Deprivation Index (GRDI), Version 1
# https://www.earthdata.nasa.gov/data/catalog/sedac-ciesin-sedac-pmp-grdi-2010-2020-1.00
# Search under data catalog: Global Gridded Relative Deprivation Index (GRDI), Version 1
# Metrics used: child dependency ratio, degree of built up areas, infant mortality rates,
# subnational human development index e.g education, health, and standards of living,
# and nighttime lights satelite data
# sign up on earth data, serach for the data then download it and copy it
# in the working directory where your code will be running
# unzip it
grdi <- terra::rast("povmap-grdi-v1.tif")

# crop GRDI by ugandan shapefile

ug_4326 <- uganda_admn2 |>
  sf::st_transform(
    4326
  )

ug_grdi <- terra::crop(
  grdi,
  terra::vect(ug_4326),
  snap = "in",
  mask = T
)

# Display results

terra::plot(ug_grdi, main = "GRDI cropped to Uganda")

# Average GRDI with Zonal Statistics

ug_grdi_zs <- terra::zonal(
  ug_grdi,
  terra::vect(
    ug_4326
  ),
  fun = "mean",
  na.rm = T
)

# Display results
print(ug_grdi_zs)

ug_grdi <- cbind(
  ug_4326,
  ug_grdi_zs
)

print(ug_grdi)

names(ug_grdi)[2] <- "grdi"


# Now all the data required is merged
# Mapping codes

# Map

p1 <- ggplot() +
  geom_sf(
    data = ug_grdi,
    aes(
      fill = grdi
    ),
    color = "grey10",
    size = .25,
    alpha = .75
  ) +
  geom_sf_label(
    data = ug_grdi,
    aes(
      label = round(grdi, 1)
    ),
    color = "grey10",
    size = 2,
    label.size = NA,
    alpha = .5
  ) +
  scale_fill_gradientn(
    name = "GRDI",
    colors = rev(hcl.colors(
      8, "Plasma",
      alpha =  .85
    ))
  ) +
  coord_sf(crs = 4326) +
  theme_void() +
  theme(
    legend.position = "right",
    plot.margin = unit(
      c(
        t = -3, r = 2,
        b = -3, l = .5
      ), "lines"
    )
  ) +
  labs(
    title = "Relative deprivation index (2010-2020)",
    caption = "Data: Global Gridded Relative Deprivation Index, v.1"
  )

ggsave(
  "ug-grdi.png", p1,
  width = 7, height = 7,
  units = "in", bg = "white"
)

# Display results using this; 
print(p1)  

# or
getwd(); list.files(pattern = "ug-grdi.png")

# 6. 3D map

ug_grdi_mat <- rayshader::raster_to_matrix(
  ug_grdi
)

cols <- rev(hcl.colors(
  8, "Inferno"
))

texture <- colorRampPalette(cols)(256)

ug_grdi_mat |>
  rayshader::height_shade(
    texture = texture
  ) |>
  plot_3d(
    ug_grdi_mat,
    zscale = 1,
    solid = F,
    shadow = T,
    shadow_darkness = .99,
    sunangle = 315,
    zoom = .4,
    phi = 30,
    theta = -30
  )

rayshader::render_camera(
  phi = 85,
  zoom = .6,
  theta = 0
)

rayshader::render_snapshot(
  "ug_grdi-snapshot.png"
)

rayshader::render_highquality(
  filename = "ug-grdi.png",
  preview = T,
  light = T,
  lightdirection = 315,
  lightintensity = 1100,
  lightaltitude = 60,
  interactive = F,
  parellel = T,
  width = 4000, height = 4000
)