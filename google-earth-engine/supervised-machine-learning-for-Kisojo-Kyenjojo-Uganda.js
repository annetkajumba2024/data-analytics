var s2 = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED');

// Perform supervised classification for your city
// Kisojo, Kyenjojo Uganda
// draw a polygon over your chosen city
// var geometry = ee.Geometry.Polygon([[
//   [30.6543, 0.4909],
//  [30.8205, 0.4909],
 // [30.8205, 0.6235],
 // [30.6543, 0.6235]
//]]);
//Map.centerObject(geometry);
////////////////////////////////////////////////////////////////
// or import the shapefile for your country and filter your region of interest

// Understanding my new village, Kijumba Village, Kisojo S/County
// Kyenjojo district, Uganda

var filteredAdmin1 = admin2
  .filter(ee.Filter.eq('shapeName', 'Kisojo')); // my new village in Uganda
print(filteredAdmin1);
var geometry = filteredAdmin1.geometry();
Map.centerObject(geometry);


var filtered = s2
.filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 30))
  .filter(ee.Filter.date('2025-06-19', '2025-07-25'))
  .filter(ee.Filter.bounds(geometry))
  .select('B.*');
// check how many images
print('Number of images:', filtered.size());

var composite = filtered.median();

// Display the input composite.

var rgbVis = {min: 0.0, max: 3000, bands: ['B4', 'B3', 'B2']};
Map.addLayer(composite.clip(geometry), rgbVis, 'image');

// Add training points e.g 3 classes
// Assign a property name e.g 'landcover'
// Classes
// buidings: 0
// bareground: 1
// vegetation: 3

var gcps = Buildings.merge(Bareground).merge(Vegetation);

// Overlay the point on the image to get training data.
var training = composite.sampleRegions({
  collection: gcps, 
  properties: ['landcover'], 
  scale: 10,
  tileScale: 16
});
print(training);


// Train a classifier.
var classifier = ee.Classifier.smileRandomForest(50).train({
  features: training,  
  classProperty: 'landcover', 
  inputProperties: composite.bandNames()
});
// // Classify the image.
var classified = composite.classify(classifier);
Map.centerObject(geometry);
// Choose a 3-4-color palette
// Assign a color for each class in the following order
// Urban, Bare, Water, Vegetation
var palette = ['#cc6d8f', '#ffc107', '#1e88e5', '#004d40' ];

Map.addLayer(classified.clip(geometry), {min: 0, max: 3, palette: palette}, '2025');