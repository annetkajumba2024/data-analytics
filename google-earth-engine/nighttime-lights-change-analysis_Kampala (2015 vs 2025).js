// -----------------------------------------------------------------------------
// -----Nighttime Lights Change Analysis for Kampala (2015 vs 2025)---------
// This script uses VIIRS Nighttime Day/Night Band Composites to extract and 
// compare night light intensity over Kampala, Uganda, for May 2015 and May 2020.
// The script uses urban center boundaries to clip to Kampala and exports 
// GeoTIFF images for both years. 
// Nighttime lights serve as a proxy for economic 
// activity, urban growth, and infrastructure development, making them useful 
// for studying changes over time—such as the economic impacts of events like 
// the COVID-19 pandemic.
// Author: Annet Kajumba
// Created: July 14, 2025
// -----------------------------------------------------------------------------



// Import datasets
// VIIRS Nighttime Day/Night Band Composites

var v1 = ee.ImageCollection("VIIRS/STRAYLIGHT/VNP46A3"); 

// Import GHS Urban Centers or your shapefile via assets
var urban = ee.FeatureCollection("projects/ee-annetkajumba2014/assets/ghs_urban_centers"); 

var filtered = urban
  .filter(ee.Filter.eq('UC_NM_MN', 'Kampala'))
  .filter(ee.Filter.eq('CTR_MN_NM', 'Uganda'));

var geometry = filtered.geometry();
Map.centerObject(geometry, 10);

// Load the VIIRS Nighttime Day/Night Band Composites collection.
// Filter the collection to the date range.
// Extract the 'avg_rad' band which represents the nighttime lights.

// May 2015
var may2015 = v1
  .filter(ee.Filter.date('2015-05-01', '2015-06-01'))
  .select('avg_rad')
  .first();
var image2015 = ee.Image(may2015).clip(geometry);

// May 2020 (during COVID-19 pandemic)
var may2020 = v1
  .filter(ee.Filter.date('2025-05-01', '2025-06-01'))
  .select('avg_rad')
  .first();
var image2020 = ee.Image(may2025).clip(geometry);

// Visualization settings
var avgVis = {
  min: 0.0,
  max: 30,
  bands: 'avg_rad'
};

// Add layers to the map
Map.addLayer(image2015, avgVis, 'Night Lights - May 2015');
Map.addLayer(image2025, avgVis, 'Night Lights - May 2025');

// Export May 2015 image
Export.image.toDrive({
  image: image2015,
  description: 'Kampala_NightLights_May2015',
  folder: 'earthengine',
  fileNamePrefix: 'kampala_nightlights_may2015',
  region: geometry,
  scale: 500,
  maxPixels: 1e9,
  fileFormat: 'GeoTIFF'
});

// Export May 2020 image
Export.image.toDrive({
  image: image2025,
  description: 'Kampala_NightLights_May2025',
  folder: 'earthengine',
  fileNamePrefix: 'kampala_nightlights_may2025',
  region: geometry,
  scale: 500,
  maxPixels: 1e9,
  fileFormat: 'GeoTIFF'
});
