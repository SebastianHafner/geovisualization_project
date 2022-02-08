class BackgroundMap extends Object {
  
  UnfoldingMap map;
  List<Marker> countryMarkers;
  
  // background color, default color white
  color backgroundc = color(37,37,37);
  
  color strokeColor = color(136,136,136);
  color fillColor = color(255, 255, 255);
  
  // color of selected points, default color orange
  color datacSelected = color(204, 102, 0);
  

  // explorer mode on or off;
  boolean explorerMode = false;
  
  
  // constructor
  BackgroundMap(processing.core.PApplet p, int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h);
    // set up map
    this.map = new UnfoldingMap(p, tlX, tlY, tlX+w, tlY+h);
    Location center = new Location(45.0f, 70.0f);
    map.setZoomRange(2,2);
    map.zoomAndPanTo(center, 2);
    map.setPanningRestriction(center, 0);
    MapUtils.createDefaultEventDispatcher(p, this.map);
    
    // load country polygons and adds them as markers
    List<Feature> countries = GeoJSONReader.loadData(p, "countries.geo.json");
    this.countryMarkers = MapUtils.createSimpleMarkers(countries);
    
    // adding markers to map
    this.map.addMarkers(this.countryMarkers);
    this.colorMarkers();
    
    //
    this.boundaries = new ROI(tlX,tlY,tlX+w,tlY+h);
    
  }
  
    
  public void draw() {
    map.draw();
    // adding details on demand
    if (boundaries.in(mouseX,mouseY)) {
      // select the corresponding marker
      Marker marker = this.map.getFirstHitMarker(mouseX, mouseY);
      if (marker != null) {
        String country = marker.getStringProperty("name");
        textAlign(LEFT);
        text(country,mouseX+40,mouseY); 
      }  
    }

  }
  
   // function to update markers according to selection and selection mode
  public void colorMarkers() {
    // Deselect all marker
    for (Marker marker : this.map.getMarkers()) {
      marker.setColor(fillColor);
      marker.setStrokeColor(strokeColor);
      marker.setStrokeWeight(1);
    }
  }
  
  
  public void setZoomLevel(int zoom) {
    this.map.setZoomRange(zoom,zoom);
    this.map.zoomLevel(zoom); 
    Location center = new Location(30.0f, 50.0f);
    if (zoom<4) { this.map.setPanningRestriction(center,0); }
    else { this.map.setPanningRestriction(center,10000); }
  }
  
  
  
  
}
