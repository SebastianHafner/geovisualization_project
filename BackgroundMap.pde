class BackgroundMap extends Object {
  
  UnfoldingMap map;
  List<Marker> countryMarkers;
  
  // background color, default color white
  color backgroundc = color(37,37,37);
  
  // color for axes and non selected data points, default color black
  color datac = color(136,136,136);
  
  // color of selected points, default color orange
  color datacSelected = color(204, 102, 0);
  

  // explorer mode on or off;
  boolean explorerMode = false;
  
  
  // constructor
  BackgroundMap(processing.core.PApplet p, Data d, int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h);
    // set up map
    this.map = new UnfoldingMap(p, tlX, tlY, tlX+w, tlY+h);
    Location center = new Location(30.0f, 50.0f);
    map.setZoomRange(2,2);
    map.zoomAndPanTo(center, 2);
    map.setPanningRestriction(center, 0);
    MapUtils.createDefaultEventDispatcher(p, this.map);
    
    // load country polygons and adds them as markers
    List<Feature> countries = GeoJSONReader.loadData(p, "countries.geo.json");
    this.countryMarkers = MapUtils.createSimpleMarkers(countries);
    
    // adding markers to map
    this.map.addMarkers(this.countryMarkers);
    
    //
    this.boundaries = new ROI(tlX,tlY,tlX+w,tlY+h);
    
  }
  
  // function to draw markers
  private void shadeCountries(boolean shade) {
    for (Marker marker : this.countryMarkers) {
      // Find data for country of the current marker
      String country = marker.getStringProperty("name");
      marker.setColor(color(100, 120));
      marker.setStrokeColor(datac);
      marker.setStrokeWeight(1);
    }
  }
  
  // funciton to select a marker
  public void select(int x, int y) {
    if (boundaries.in(x,y)) {
      // deselect all countries first
      for (int i=0;i<data.selected.length;i++) { data.selected[i] = false; }
      
      // select the corresponding marker
      Marker marker = this.map.getFirstHitMarker(mouseX, mouseY);
      if (marker != null) {
        String country = marker.getStringProperty("name");
        Integer index = data.countries.get(country);
        // if the country is in the hash map set it as selected
        if (index != null) {
          data.selected[index] = true;
          this.updateMarkers();
        } 
      }  
    }
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
  public void updateMarkers() {
    // Deselect all marker
    for (Marker marker : this.map.getMarkers()) {
      marker.setStrokeColor(datac);
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
