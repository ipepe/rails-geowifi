debounce = (func, threshold, execAsap) ->
  timeout = null
  (args...) ->
    obj = this
    delayed = ->
      func.apply(obj, args) unless execAsap
      timeout = null
    if timeout
      clearTimeout(timeout)
    else if (execAsap)
      func.apply(obj, args)
    timeout = setTimeout delayed, threshold || 100

$().ready ->
  window.map = L.map('map').setView([52.23, 21.01], 13);
  L.tileLayer('http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="https://cartodb.com/attributions">CartoDB</a>',
  }).addTo(window.map);
  cluster_group = null
  geojson_ajax = new L.GeoJSON.AJAX("/wifi_positions.geojson?limit=200000")
  geojson_ajax.on 'data:loaded', ->
    if cluster_group
      map.removeLayer(cluster_group)
    cluster_group = L.markerClusterGroup()

    cluster_group.addLayer(L.geoJSON(geojson_ajax.toGeoJSON(), {
      onEachFeature: ( (feature, layer) ->
        if feature.properties?.bssid
          layer.bindPopup("<a href=\"/wifi_positions/#{feature.properties.bssid}.html\">#{feature.properties.bssid} #{feature.properties.ssid}</a>")
      )
    }))
    window.map.addLayer(cluster_group)