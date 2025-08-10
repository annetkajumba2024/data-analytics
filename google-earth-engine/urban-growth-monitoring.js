// -----------------------------------------------------------------------------
//-------Urban Growth Monitoring in Kasese Using Landsat 8 and NDBI (2023)----
// This script uses Landsat 8 Surface Reflectance data for 2023 to calculate the 
// Normalized Difference Built-up Index (NDBI) in 
// Kasese, Uganda. 
// The NDBI highlights built-up (urban) areas by comparing SWIR1 
// and NIR reflectance values, with red indicating high built-up density and blue 
// indicating vegetation or water. 
// Author: Annet Kajumba
// Created: 10 August 2025
// NDBI mapping is valuable for monitoring urbanization trends, land-use change, 
// and infrastructure development. By identifying built-up areas, this analysis 
// supports urban planning, environmental monitoring, disaster risk management, 
// and climate resilience strategies, especially in population growing districts like 
// Yumbe and Kasese where unplanned expansion is stressing infrastructure and ecosystems.
// -----------------------------------------------------------------------------

// Import or draw the region of interest (e.g., a point or polygon).
// Import GHS Urban Centers or your shapefile via assets

var admin2 = ee.FeatureCollection('FAO/GAUL_SIMPLIFIED_500m/2015/level2');
var filteredAdmin1 = admin2
  .filter(ee.Filter.eq('ADM0_NAME', 'Uganda'))
  .filter(ee.Filter.eq('ADM1_NAME', 'Kasese'));
var geometry = filteredAdmin1.geometry();


// Load Landsat 8 Surface Reflectance data.
var landsat8 = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2')
  .filterBounds(geometry)
  .filterDate('2023-01-01', '2023-12-31') // Adjust date range as needed
  .filter(ee.Filter.lt('CLOUD_COVER', 30)) // Filter for low cloud cover
  .median() // Use median to reduce noise
  .clip(geometry);

// Function to calculate NDBI
var calculateNDBI = function(image) {
  var ndbi = image.normalizedDifference(['SR_B6', 'SR_B5']).rename('NDBI'); // SWIR1 (B6), NIR (B5)
  return image.addBands(ndbi);
};

// Apply NDBI calculation
var landsatNDBI = calculateNDBI(landsat8);

// Visualization parameters for NDBI
var ndbiVis = {
  min: -1,
  max: 1,
  // Green: low NDBI (vegetation), White: neutral (water), Red: high NDBI (built-up)
  palette: ['green', 'white', 'red'] 
};

// Center the map on the region of interest
Map.centerObject(geometry, 10);
Map.addLayer(geometry, {color: 'black'}, 'Kasese NDBI');

// Add NDBI layer to the map
Map.addLayer(landsatNDBI.select('NDBI'), ndbiVis, 'NDBI');

// Create a legend panel
var legend = ui.Panel({
  style: {
    position: 'bottom-left',
    padding: '8px 15px'
  }
});

// Add a title to the legend
var legendTitle = ui.Label({
  value: 'NDBI Legend',
  style: {
    fontWeight: 'bold',
    fontSize: '18px',
    margin: '0 0 4px 0',
    padding: '0'
  }
});
legend.add(legendTitle);

// Define the color palette and corresponding NDBI values
var palette = ndbiVis.palette;
var minNDBI = ndbiVis.min;
var maxNDBI = ndbiVis.max;

// Create a gradient bar for the legend
var gradient = ui.Thumbnail({
  image: ee.Image.pixelLonLat().select(0),
  params: {
    min: 0,
    max: 1,
    palette: palette,
    dimensions: '100x10'
  },
  style: {stretch: 'horizontal', margin: '0 0 4px 0'}
});
legend.add(gradient);

// Add labels for min, mid, and max NDBI values
var labels = ui.Panel({
  widgets: [
    ui.Label(minNDBI, {margin: '0 0 0 0'}),
    ui.Label(0, {textAlign: 'center', stretch: 'horizontal'}),
    ui.Label(maxNDBI, {margin: '0 0 0 0'})
  ],
  layout: ui.Panel.Layout.flow('horizontal')
});
legend.add(labels);

// Add descriptions for interpretation
var description = ui.Label({
  value: 'Blue: Vegetation/Water\nWhite: Neutral\nRed: Built-up Areas',
  style: {fontSize: '12px', margin: '4px 0 0 0'}
});
legend.add(description);

// Add the legend to the map
Map.add(legend);

// Optional: Export the NDBI image to Google Drive
Export.image.toDrive({
  image: landsatNDBI.select('NDBI'),
  description: 'NDBI_Example',
  scale: 30, // Landsat resolution
  region: geometry,
  maxPixels: 1e9
});