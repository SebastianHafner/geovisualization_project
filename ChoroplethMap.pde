class ChoroplethMap extends Object {
  
  UnfoldingMap map;
  List<Marker> countryMarkers;
  Data data;
  
  // background color, default color white
  color backgroundc = color(37,37,37);
  
  // color for axes and non selected data points, default color black
  color datac = color(136,136,136);
  
  // color of selected points, default color orange
  color datacSelected = color(204, 102, 0);
  
  // nightmode on or off, default off
  boolean darkMode = false;
  
  // selection mode on or off
  boolean selectionMode = true;
  
  // explorer mode on or off;
  boolean explorerMode = false;
  
  // number of classes
  int nclasses = 5;
  
  
  // constructor
  ChoroplethMap(processing.core.PApplet p, Data d, int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h);
    // set up map
    this.map = new UnfoldingMap(p, tlX, tlY, tlX+w, tlY+h);
    Location center = new Location(30.0f, 50.0f);
    map.setZoomRange(3,3);
    map.zoomAndPanTo(center, 3);
    map.setPanningRestriction(center, 0);
    MapUtils.createDefaultEventDispatcher(p, this.map);
    
    // load country polygons and adds them as markers
    List<Feature> countries = GeoJSONReader.loadData(p, "countries.geo.json");
    this.countryMarkers = MapUtils.createSimpleMarkers(countries);
    
    // adding markers to map
    this.map.addMarkers(this.countryMarkers);
    
    // adding data
    this.data = d;
    
    //
    this.boundaries = new ROI(tlX,tlY,tlX+w,tlY+h);
    
    // assign colors to countries according to data
    this.setSelectionMode(false);
    
  }
  
  // function to draw markers
  private void shadeCountries(boolean shade) {
    Colormap colormap = new Colormap();
    float min = 40f;
    float max = 90f;
    float step = (max-min)/nclasses;
    float value = 0;
    for (Marker marker : this.countryMarkers) {
      // Find data for country of the current marker
      
      String country = marker.getStringProperty("name");
      DataEntry dataEntry = this.data.get(country);
      
      
      if (dataEntry != null && dataEntry.years != null) {
        if (shade) {
          // find correct class and set the color of marker accordingly
          for (int i=0;i<nclasses;i++) {
            if (dataEntry.years>min+i*step && dataEntry.years<=min+(i+1)*step) {
              marker.setColor(colormap.getColor(i));
            }
          }               
        } else {
          marker.setColor(color(100, 120));
        }
               
      } else {
        // No value available
        marker.setColor(color(100, 120));
      }
      marker.setStrokeColor(datac);
      marker.setStrokeWeight(1);
    }
  }
  
  public void setNumberClasses(int n) {
    this.nclasses = n;
    if (selectionMode) { shadeCountries(true); }
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
        Integer index = data.countries.get(country);
        // if the country is in the hash map set it as selected
        if (index != null) {
          textAlign(LEFT);
          text(country,mouseX+40,mouseY);
          text("Life expectancy: "+Math.round(data.years[index]),mouseX+40,mouseY+20);
          text("Alcohol consumpiton: "+Math.round(data.total[index]),mouseX+40,mouseY+40);
        } 
      }  
    }

  }
  
  
  
    // function to update markers according to selection and selection mode
  public void updateMarkers() {
    // Deselect all marker
    for (Marker marker : this.map.getMarkers()) {
      //marker.setSelected(false);
      String country = marker.getStringProperty("name");
      DataEntry dataEntry = this.data.get(country);
      // if the country is in the hash map
      if (dataEntry != null) {
        if (selectionMode) {
        // coloring is dependent of mode 
          if (dataEntry.selected) {
            marker.setColor(color(204, 102, 0));
            //marker.showLabel = true;
                  
          } else {
            marker.setColor(color(100, 120));
            
          }
        } else {
          if (dataEntry.selected) {
            marker.setStrokeColor(color(204, 102, 0));
            marker.setStrokeWeight(2);
            
          } else {
            marker.setStrokeColor(datac);
            marker.setStrokeWeight(1);
            
            
          }          
        }
      }
    }
  }
  
  public void setSelectionMode(boolean input) {
    this.selectionMode = input;
    if (selectionMode) {shadeCountries(false); }
    else { this.shadeCountries(true); }   
  }
  
  public void setZoomLevel(int zoom) {
    this.map.setZoomRange(zoom,zoom);
    this.map.zoomLevel(zoom); 
    Location center = new Location(30.0f, 50.0f);
    if (zoom<4) { this.map.setPanningRestriction(center,0); }
    else { this.map.setPanningRestriction(center,10000); }
  }
  
  
  
  
}
