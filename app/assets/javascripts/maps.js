

function gmap_show(asset) {
  if ((asset.lat == null) || (asset.lng == null) ) {    // validation check if coordinates are there
    return 0;
  }

  handler = Gmaps.build('Google');    // map init
  handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
    markers = handler.addMarkers([    // put marker method
      {
        "lat": asset.lat,    // coordinates from parameter asset
        "lng": asset.lng,
        "picture": {    // setup marker icon
          "url": 'http://www.planet-action.org/img/2009/interieur/icons/orange-dot.png',
          "width":  32,
          "height": 32
        },
        "infowindow": "<b>" + asset.name + "</b> "
      }
    ]);
    handler.bounds.extendWith(markers);
    handler.fitMapToBounds();
    handler.getMap().setZoom(12);    // set the default zoom of the map
  });
}

function gmap_form(asset, map_id) {
  handler = Gmaps.build('Google');    // map init
  handler.buildMap({ provider: {}, internal: {id: map_id}}, function(){
    if (asset && asset.lat && asset.lng) {    // statement check - new or edit view
      markers = handler.addMarkers([    // print existent marker
        {
          "lat": asset.lat,
          "lng": asset.lng,
          "picture": {
            "url": 'http://www.planet-action.org/img/2009/interieur/icons/orange-dot.png',
            "width":  32,
            "height": 32
          },
          "infowindow": "<b>" + asset.name + "</b> "
        }
      ]);
      handler.bounds.extendWith(markers);
      handler.fitMapToBounds();
      handler.getMap().setZoom(12);
    }
    else {    // show the empty map
      handler.fitMapToBounds();
      handler.map.centerOn([37.773972, -122.431297]);
      handler.getMap().setZoom(12);
    }
  });

  var markerOnMap;

  function placeMarker(location) {    // simply method for put new marker on map
    if (markerOnMap) {
      markerOnMap.setPosition(location);
    }
    else {
      markerOnMap = new google.maps.Marker({
        position: location,
        map: handler.getMap()
      });
    }
  }

  google.maps.event.addListener(handler.getMap(), 'click', function(event) {    // event for click-put marker on map and pass coordinates to hidden fields in form
    placeMarker(event.latLng);
    console.log($('#lat', '#lat_'+map_id))
    $('#lat', '#lat_'+map_id).val(event.latLng.lat());
    $('#lng', '#lng_'+map_id).val(event.latLng.lng());
  });
}



