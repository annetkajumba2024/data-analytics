//------Multi-Index Remote Sensing Analysis---------------
// ----of Kampala and Wakiso Districts Using Sentinel-2 Data (2023)-------

// This script processes Sentinel-2 imagery (2023)
// to calculate and visualize key spectral indices for Kampala and Wakiso districts, Uganda. 
// filtering cloud-free images (<30% cloud cover)
// and computing:
// NDVI (Normalized Difference Vegetation Index) for vegetation health monitoring
// MNDWI (Modified Normalized Difference Water Index) for water body detection
// SAVI (Soil-Adjusted Vegetation Index) for vegetation analysis in areas with low vegetation cover
// And NDBI (Normalized Difference Built-up Index) for detecting built-up areas
// Author: Annet Kajumba
// Created: 07th July 2025
// In Google Earth Engine

// -----Reuse guide-------
// to calculate and visualize these indices for your region/district/subcounty
// edit these two codes;
// .filter(ee.Filter.eq('ADM0_NAME', 'Uganda')) # your country
// replace .filter(ee.Filter.inList('ADM1_NAME', ['Kampala', 'Wakiso']));
// with; .filter(ee.Filter.eq('ADM1_NAME', 'Kampala')); # your districts
// use this code if its for your subcounty
// .filter(ee.Filter.eq('ADM0_NAME', 'Uganda')) # your country
// .filter(ee.Filter.eq('ADM1_NAME', 'Kampala')) # your district/region/state
// .filter(ee.Filter.eq('ADM2_NAME', 'Uganda')) # your district/county/subcounty
// or import the shapefile for subcounties in your state and filter your sub county

var s2 = ee.ImageCollection('COPERNICUS/S2_HARMONIZED');
var admin2 = ee.FeatureCollection('FAO/GAUL_SIMPLIFIED_500m/2015/level2');

var filteredAdmin1 = admin2
  .filter(ee.Filter.eq('ADM0_NAME', 'Uganda'))
  .filter(ee.Filter.inList('ADM1_NAME', ['Kampala', 'Wakiso']));
var geometry = filteredAdmin1.geometry();
Map.centerObject(geometry);

var filteredS2 = s2.filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 30))
  .filter(ee.Filter.date('2023-01-01', '2024-01-01'))
  .filter(ee.Filter.bounds(geometry));
print(filteredS2.size());

var image = filteredS2.median(); 

// Calculate  Normalized Difference Vegetation Index (NDVI)
// 'NIR' (B8) and 'RED' (B4)
var ndvi = image.normalizedDifference(['B8', 'B4']).rename(['ndvi']);
// Calculate Modified Normalized Difference Water Index (MNDWI)
// 'GREEN' (B3) and 'SWIR1' (B11)
var mndwi = image.normalizedDifference(['B3', 'B11']).rename(['mndwi']); 

// Calculate Soil-adjusted Vegetation Index (SAVI)
// 1.5 * ((NIR - RED) / (NIR + RED + 0.5))

// For more complex indices, you can use the expression() function

// Note: 
// For the SAVI formula, the pixel values need to convert to reflectances
// Multiplyng the pixel values by 'scale' gives us the reflectance value
// The scale value is 0.0001 for Sentinel-2 dataset

var savi = image.expression(
    '1.5 * ((NIR - RED) / (NIR + RED + 0.5))', {
      'NIR': image.select('B8').multiply(0.0001),
      'RED': image.select('B4').multiply(0.0001),
}).rename('savi');

// Calculate the Normalized Difference Built-Up Index (NDBI) for the image
// Hint: NDBI = (SWIR1 – NIR) / (SWIR1 + NIR)
// Visualize the built-up area using a 'red' palette

var ndbi = image.normalizedDifference(['B11','B8']).rename('ndbi');


var rgbVis = {min: 0.0, max: 3000, bands: ['B4', 'B3', 'B2']};
var ndviVis = {min:0, max:0.7, palette: ['white', 'green']};
var ndwiVis = {min:0, max:0.5, palette: ['white', 'blue']};
var saVis = {min:0, max:0.7, palette: ['white', 'green']};
var nbVis = {min: 0, max: 0.7, palette: ['white', 'red']};


Map.addLayer(image.clip(geometry), rgbVis, 'Image');
Map.addLayer(mndwi.clip(geometry), ndwiVis, 'mndwi');
Map.addLayer(savi.clip(geometry), saVis, 'savi');
Map.addLayer(ndvi.clip(geometry), ndviVis, 'ndvi');
Map.addLayer(ndbi.clip(geometry), nbVis, 'ndbi');

