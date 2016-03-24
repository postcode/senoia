
var map;

function map_initialize(map_id) {
        
  var mapOptions = {
    center: new google.maps.LatLng(37.773972, -122.431297),
    zoom: 12,
    mapTypeId: google.maps.MapTypeId.NORMAL,
    panControl: true,
    scaleControl: false,
    streetViewControl: true,
    overviewMapControl: true
  };
  // initializing map
  map = new google.maps.Map(document.getElementById(map_id),mapOptions);

  var drawingManager = new google.maps.drawing.DrawingManager({
    drawingMode: null,
    drawingControl: true,
    drawingControlOptions: {
      position: google.maps.ControlPosition.TOP_CENTER,
      drawingModes: [
        google.maps.drawing.OverlayType.MARKER,
        google.maps.drawing.OverlayType.POLYGON,
      ]
    }
  });
  drawingManager.setMap(map);

  google.maps.event.addListener(map, 'click', function(event) {    // event for click-put marker on map and pass coordinates to hidden fields in form
    console.log($('#lat', '#lat_'+map_id))
    $('#lat', '#lat_'+map_id).val(event.latLng.lat());
    $('#lng', '#lng_'+map_id).val(event.latLng.lng());
  });

  google.maps.event.addListener(drawingManager, 'overlaycomplete', function(event) {
  if (event.type == google.maps.drawing.OverlayType.MARKER) {
    console.log(event)
    console.log(event.overlay.position.lat())
    console.log($('#lat_'+map_id).parents(".reveal-modal"))
    $('#lng_'+map_id).parents(".reveal-modal").find(".save-modal",".modal-footer")
                                              .prop("disabled", false)
                                              .removeClass("disabled")
    $('#lng_'+map_id).parents(".reveal-modal").find(".location_warning",".modal-footer").hide()
    $('#lat', '#lat_'+map_id).val(event.overlay.position.lat());
    $('#lng', '#lng_'+map_id).val(event.overlay.position.lng());
  } else if (event.type == google.maps.drawing.OverlayType.POLYGON) {
    console.log(event.overlay.getPath().getArray())
    $('#service_area', '#service_area_'+map_id).val(event.overlay.getPath().getArray());
    console.log( $('#service_area', '#service_area_'+map_id).val())
  }
});
        
}

function reloadMap(map_id) {
  var test = document.getElementById(map_id)
  google.maps.event.trigger(test, 'resize');
}


