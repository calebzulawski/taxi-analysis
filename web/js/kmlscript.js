/**
 * @fileoverview Sample showing capturing a KML file click
 *   and displaying the contents in a side panel instead of
 *   an InfoWindow
 */

var map;
var src = '/kml/pickup_full.kml';

/**
 * Initializes the map and calls the function that creates polylines.
 */
function initialize() {
  map = new google.maps.Map(document.getElementById('map-canvas'), {
    center: new google.maps.LatLng(40.7127, -74.0059),
    zoom: 10,
    mapTypeId: google.maps.MapTypeId.TERRAIN
  });
  loadKmlLayer(src, map);
}

/**
 * Adds a KMLLayer based on the URL passed. Clicking on a marker
 * results in the balloon content being loaded into the right-hand div.
 * @param {string} src A URL for a KML file.
 */
function loadKmlLayer(src, map) {
  var kmlLayer = new google.maps.KmlLayer({
    url: src
  });
  kmlLayer.setMap(map)
}

google.maps.event.addDomListener(window, 'load', initialize);