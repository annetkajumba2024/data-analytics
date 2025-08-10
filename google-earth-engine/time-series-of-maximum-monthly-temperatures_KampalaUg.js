// -----------------------------------------------------------------------------
// -----29-Year Maximum Temperature Time Series Analysis Using TerraClimate------
//-----------------------------------------------------------------------------------
// This script uses the TerraClimate dataset to generate a 29-year (1996–2024) 
// time series of maximum monthly temperatures for Kampala, Uganda. 
// It  filters the TerraClimate dataset by date and location, selects the 'tmmx' 
// band (maximum temperature), scales the values by 0.1 to convert them into 
// °C, and charts the average temperature over time. 
// The output includes a time-series plot and a map visualization of the region.
// Author: Annet Kajumba
// Created: July 20th, 2025

// --------------Importance--------------------
// Long-term temperature records help detect climate change trends, 
// seasonal patterns, and anomalies in a specific location. This information 
// is critical for environmental monitoring, agricultural planning, 
// infrastructure resilience, and climate adaptation strategies.
// --------------------------------------------------------------------------- 
 // Kampala, Uganda
// You can replace with your own geometry (e.g., a polygon drawn on GEE map or imported shapefile).
  
  
// Import GHS Urban Centers or your shapefile via assets
var urban = ee.FeatureCollection("projects/ee-annetkajumba2014/assets/ghs_urban_centers"); 
var filtered = urban
  .filter(ee.Filter.eq('UC_NM_MN', 'Kampala'))
  .filter(ee.Filter.eq('CTR_MN_NM', 'Uganda'));

var geometry = filtered.geometry();
Map.centerObject(geometry);  

// Load the TerraClimate collection
var terraclimate = ee.ImageCollection("IDAHO_EPSCOR/TERRACLIMATE");

// Select the 'tmmx' band
// Filter the collection to the desired date range (50-year time range)
var filtered = terraclimate
  .filter(ee.Filter.date('1996-03-03', '2024-07-31'))
  .filter(ee.Filter.bounds(geometry))
  .select('tmmx');  // Max temperature band

// Scale the band values
// The 'tmnx' band has a scaling factor of 0.1 as per
// https://developers.google.com/earth-engine/datasets/catalog/IDAHO_EPSCOR_TERRACLIMATE#bands
// This means that we need to multiply each pixel value by 0.1
// to obtain the actual temparature value
// Function that applies the scaling factor to the each image 

var scaleValues = function(image) {
  var scaledImage = image.multiply(0.1);
    // Multiplying creates a new image that doesn't have the same properties
    // Use copyProperties() function to copy timestamp to new image
   // copy the system:time_start property 
   // from the originalimage
  return scaledImage
    .copyProperties(image, ['system:time_start']);
};
// map() a function and multiply each image
var tmaxScaled = filtered.map(scaleValues);

// Check pixel resolution
var image = ee.Image(terraclimate.first())
print(image.projection().nominalScale())

// Display a time-series chart
var chart = ui.Chart.image.series({
  imageCollection: tmaxScaled,
  region: geometry,
  reducer: ee.Reducer.mean(),
  scale: 10
}).setOptions({
      lineWidth: 1,
      pointSize: 2,
      title: 'Kampala Maximum Monthly Temperature T-Series (1996–2024)',
      vAxis: {title: 'Temperature (°C)'},
      hAxis: {title: '', format: 'YYYY-MMM'}
    });
    
print(chart);
Map.addLayer(geometry, {color: 'green'}, 'Location');