window.map = L.map('map').setView([52.23, 21.01], 13);
L.tileLayer('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="https://cartodb.com/attributions">CartoDB</a>',
}).addTo(window.map);
cluster_group = L.markerClusterGroup()
geojson_ajax = new L.GeoJSON.AJAX("/wifi_observations.geojson")
geojson_ajax.on 'data:loaded', ->
  cluster_group.addLayer(geojson_ajax)
  window.map.addLayer(cluster_group)