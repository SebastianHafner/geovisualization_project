import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import de.fhpotsdam.unfolding.*; 
import de.fhpotsdam.unfolding.data.*; 
import de.fhpotsdam.unfolding.geo.*; 
import de.fhpotsdam.unfolding.marker.*; 
import de.fhpotsdam.unfolding.utils.*; 
import java.util.List; 
import java.util.Arrays; 
import java.util.HashSet; 
import java.util.HashMap; 
import java.util.Arrays; 
import java.lang.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class geovisualization_project extends PApplet {








BackgroundMap bmap;
DotMap dmap;
Scatterplot splot;
Ternaryplot tplot;
Barplot bplot;
ParallelCoordinatesPlot pplot;
Data data;
QualitativeResults qr;
int x1, x2, y1, y2;
ROI roi = new ROI();
Plot[] plots;



public void setup() {
  size(1280, 720, P2D);
  cursor(CROSS);
  smooth();
  
  // reading data
  data = new Data("geovisualization_project_data.csv");
  
  // setting up map
  bmap = new BackgroundMap(this,width/4,0,width*3/4,height);
  dmap = new DotMap(this,data,width/4,0,width*3/4,height);
  dmap.updateMarkers(); 
  
  // setting up scatter plot
  splot = new Scatterplot(data.precision,data.recall,data.selected,70,10,height/4,height/4);
  splot.setXlabel("Recall");
  splot.setYlabel("Precision");
  splot.setYmin(0f); splot.setYmax(1f);
  splot.setXmin(0f); splot.setXmax(1f);

  // setting up bar plot
  bplot = new Barplot(data.region,data.selected,20,height/4+10,width/4-20,height/4);
  bplot.setYlabel("Regional dist.");

  // setting up parallel coordinates plot
//  Float[][] d = {data.f1,data.precision,data.recall};
//  pplot = new ParallelCoordinatesPlot(d,data.selected,0,0,width/4,width/4);
//  pplot.setActive(true);
//  String[] xLabels = {"F1","Pre","Rec"}; pplot.setXlabels(xLabels);
  
  
//    // setting up ternary plot
//  tplot = new Ternaryplot(data.f1,data.precision,data.recall,data.selected,0,0,width/4);
//  tplot.setAlabel("F1"); tplot.setBlabel("P"); tplot.setClabel("R");
  
  
  // qualitative results
  qr = new QualitativeResults(data,0, height/2, width/4, height/2);
  
  plots = new Plot[]{splot,bplot};
}

public void draw() {
  background(0, 84, 119);
  noStroke();
  
  fill(255,255,255);
  rect(0,0, width/4,height);
  
  // Draw map tiles and country markers
  qr.draw();
  for (Plot plot:plots) { plot.draw(); }; 
  bmap.draw();
  dmap.draw();
  

}


public void mousePressed() {
  x1 = mouseX;
  y1 = mouseY;
}

public void mouseDragged() {
  // getting coordinates
  x2 = mouseX; y2 = mouseY;
  // updating the region of interest
  roi.updateROI(x1,y1,x2,y2);
  // selecting data for all plots  
  for (Plot plot:plots) { plot.selectROI(roi); }
  dmap.updateMarkers(); 
}

public void mouseReleased() {
  x2 = mouseX;
  y2 = mouseY;
  // updating the region of interest
  roi.updateROI(x1,y1,x2,y2);
  // selecting points for roi
  for (Plot plot:plots) { plot.selectROI(roi); }
  // updating markers according to selection
  dmap.updateMarkers();  
}

public void mouseClicked() {
  dmap.select(mouseX,mouseY);
  qr.updateSelection();
}




class BackgroundMap extends Object {
  
  UnfoldingMap map;
  List<Marker> countryMarkers;
  
  // background color, default color white
  int backgroundc = color(37,37,37);
  
  int strokeColor = color(136,136,136);
  int fillColor = color(255, 255, 255);
  
  // color of selected points, default color orange
  int datacSelected = color(204, 102, 0);
  

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




class Barplot extends Plot { 
  
  // data array, unique entries in data array,
  // and selection for interactivity
  String[] d;
  String[] unique;
  boolean[] selection;
  
  // range of the xaxis
  int xrange;
  int yrange;
  
  // width, height and number of bars
  int wBar, hBar, nBar;
  
  HashMap<String,Integer> count;
  int countTotal;
  
  String xLabel="", yLabel="";
  
  // constructior
  Barplot(String[] d, boolean[] s, int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h);  
    this.d = d; 
    this.selection = s;
    // get unique data values
    this.unique = new HashSet<String>(Arrays.asList(d)).toArray(new String[0]);
    this.wBar = 15; // default value
    this.hBar = h-2*this.offset; // height of a bar
    this.nBar = this.unique.length;
    this.xrange = this.w-2*this.offset;
    this.yrange = this.h-2*this.offset;
    this.count = new HashMap<String,Integer>();
    
  }
  


  
  public void drawAxes() {  
    // axes
    stroke(datac);
    fill(datac);
    strokeWeight(aWeight);
    textSize(this.fontSize);
    // horizontal axis
    line(tlX+offset, tlY+h-offset, tlX+offset+xrange, tlY+h-offset);
    textAlign(CENTER);
    text(xLabel, tlX+offset, tlY+h-offset+40,xrange,100); 
    
    // vertical axis
    line(tlX+offset, tlY+h-offset, tlX+offset, tlY+offset);
    textAlign(RIGHT);
    text("1", tlX+offset-115, tlY+offset-10,100,50);
    // text("50", tlX+offset-115, tlY+h-offset-yrange/2-10,100,50);
    text("0", tlX+offset-115, tlY+h-offset-10,100,50);
    
    textAlign(CENTER);
    // vertical axis
    line(tlX+offset, tlY+h-offset, tlX+offset, tlY+offset);
    textAlign(CENTER);
    pushMatrix();
    translate(tlX+offset-18,tlY+h-offset-yrange/2);
    rotate(1.5f*PI);
    text(yLabel, 0,0);
    popMatrix();
    


  }


  public void drawData() {
    
    // counting how many selected
    countTotal = 0;
    for (String u : unique) { count.put(u,0); }
    for (int i=0;i<d.length;i++) {
      if (selection[i]) { count.put(d[i],count.get(d[i])+1); countTotal++; }
    }
    
    String label;
    int tlXbar, tlYbar; 
     hBar = 50;
    // space between bars
    int space = (xrange-wBar*nBar)/nBar; // nBar-1 spaces but half a bar as buffer left and right
    for (int i=0;i<nBar;i++) {
      tlXbar = tlX+offset+space/2+i*space+i*wBar;
      hBar = (int) (yrange/ (float) countTotal * (float) count.get(unique[i])) ;
      tlYbar = tlY+h-offset-hBar;
      strokeWeight(0);
      fill(datacSelected);
      rect(tlXbar,tlYbar,wBar,hBar);
      
      // fucked up labelling
      label = unique[i];
      if (unique[i].equals("NAF_ME")) { label="NAFME"; }
      if (unique[i].equals("NA_AU")) { label="NA"; }

      textSize(fontSize);
      textAlign(CENTER);
      stroke(datac);
      fill(datac);
      // bar label
      text(label, tlXbar+wBar/2-25, tlY+h-offset+10,50,50);
   
      
    }
  
  }
  
  public int getX(int i) {
    
    return 1;
  }
  
  public int getY(int i) {
    
    
    return 1;
  }
  
  public void setXlabel(String xlabel) { this.xLabel = xlabel; }
  public void setYlabel(String ylabel) { this.yLabel = ylabel; }
  
  
  public void selectROI(ROI roi) {}




}
class Colormap {
  
  int[] colormapBlue = {
    color(247,251,255),color(222,235,247),color(198,219,239),color(158,202,225),color(107,174,214),
    color(66,146,198),color(33,113,181),color(8,81,156),color(8,48,107)
  };
  
  // constructor
  Colormap() {}
  
  public int getColor(int n) { return this.colormapBlue[n]; }
  
}


// class to read in the data and output it in the desired format
class Data {
  
  // hashmap to store the indices
  public HashMap<String,Integer> aoiIDs;
  
  // array for selection/interactivity
  public boolean[] selected;
  
  public String[] name;
  public String[] region;
   
  // arrays to store the data
  public Float[] f1;
  public Float[] precision;
  public Float[] recall;
  
  
  // constructor
  Data(String fileName) {
    
    // load the data
    this.loadData(fileName);
    
  }
  
  
  // helper function to load the alcohole consumption data from csv file
  private void loadData(String fileName) {
  
    this.aoiIDs = new HashMap<String,Integer>();
    String[] input = loadStrings(fileName);
    String header = input[0];
    String[] rows = Arrays.copyOfRange(input, 1, input.length);
    
    this.f1 = new Float[rows.length];
    this.precision = new Float[rows.length];
    this.recall = new Float[rows.length];
    this.selected = new boolean[rows.length];
    this.name = new String[rows.length];
    this.region = new String[rows.length];
    
    for (Integer i=0;i<rows.length;i++) {
      // Reads country name and population density value from CSV row
      String row = rows[i];
      String[] columns = row.split(";");
      println("test");
      
      this.f1[i] = Float.parseFloat(columns[2]);
      this.precision[i] = Float.parseFloat(columns[3]);
      this.recall[i] = Float.parseFloat(columns[4]);
      
      this.selected[i] = false;
      
      this.name[i] = columns[1];
      this.region[i] = columns[5];
      
      this.aoiIDs.put(columns[1],i);
        
    }
    }
    
    
    // returns a data entry object according to the country
    public DataEntry get(String aoiID) {
      Integer index = this.aoiIDs.get(aoiID);
      if (index == null) {
        return null;
      }
      
      DataEntry d = new DataEntry();
      d.aoiID =  aoiID;
      d.f1 = this.f1[index];
      d.precision = this.precision[index];
      d.recall = this.recall[index];
      d.selected = this.selected[index];
      d.name = this.name[index];
      d.region = this.region[index];
      
      return d;
    }
    

}
  

  
class DataEntry {
  public String aoiID;
  public Float f1;
  public Float precision;
  public Float recall;
  public boolean selected;
  public String name;
  public String region;
}
  

class DotMap extends Object {
  
  UnfoldingMap map;
  List<Marker> siteMarkers;
  Data data;
  
  // background color, default color white
  int backgroundc = color(37,37,37);
  
  // color for axes and non selected data points, default color black
  int datac = color(40,44,55);
  
  // color of selected points, default color orange
  int datacSelected = color(204, 102, 0);
  
  // nightmode on or off, default off
  boolean darkMode = false;
  
  // selection mode on or off
  boolean selectionMode = true;
  
  // explorer mode on or off;
  boolean explorerMode = false;
  
  
  
  // constructor
  DotMap(processing.core.PApplet p, Data d, int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h);
    // set up map
    this.map = new UnfoldingMap(p, tlX, tlY, tlX+w, tlY+h);
    Location center = new Location(45.0f, 70.0f);
    map.setZoomRange(2,2);
    map.zoomAndPanTo(center, 2);
    map.setPanningRestriction(center, 2);
    MapUtils.createDefaultEventDispatcher(p, this.map);
    
    // load country polygons and adds them as markers
    List<Feature> sites = GeoJSONReader.loadData(p, "sites_points_sn7.geojson");
    this.siteMarkers = MapUtils.createSimpleMarkers(sites);
    
    // adding markers to map
    this.map.addMarkers(this.siteMarkers);
    
    // adding data
    this.data = d;
    
    //
    this.boundaries = new ROI(tlX,tlY,tlX+w,tlY+h);
    
  }
  
  // funciton to select a marker
  public void select(int x, int y) {
    if (boundaries.in(x,y)) {
      // deselect all aois first
      for (int i=0;i<data.selected.length;i++) { data.selected[i] = false; }
      
      // select the corresponding marker
      Marker marker = this.map.getFirstHitMarker(mouseX, mouseY);
      if (marker != null) {
        String aoiID = marker.getStringProperty("aoi_id");
        Integer index = data.aoiIDs.get(aoiID);
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
  }
  
  
  
    // function to update markers according to selection and selection mode
  public void updateMarkers() {
    
        // Deselect all marker
    for (Marker marker : this.map.getMarkers()) {
      String aoiID = marker.getStringProperty("aoi_id");
      Integer index = data.aoiIDs.get(aoiID);
      // if the country is in the hash map set it as selected
      if (index != null) {
        if (data.selected[index]) {
          marker.setColor(datacSelected);
        } else {
          marker.setColor(datac);
        }
        marker.setStrokeColor(datac);
        marker.setStrokeWeight(0);
      } 
    }
  }
  
  
  
  public void setZoomLevel(int zoom) {
    this.map.setZoomRange(zoom,zoom);
    this.map.zoomLevel(zoom); 
    Location center = new Location(45.0f, 70.0f);
    if (zoom<4) { this.map.setPanningRestriction(center,0); }
    else { this.map.setPanningRestriction(center,10000); }
  }
  
  
  
  
}
class Field extends Object {
  
  String text;
  
  
  Field(String t, int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h);
    this.text = t;
  
  
  
  
  }

  public void setText(String newText) { this.text = newText; } 
 
  public boolean onClick(int x, int y) {
    
  
    return true;
  }
  
  public void draw() {}
   
   
   

  
  
  
  
  
  
  
  
  
  
  
}
public Float frac(Float n, Float d) {
 return n/d; 
}


public Float getX_ternary(Float a, Float b, Float c) {
  return 0.5f*frac((2*b+c),(a+b+c));

}

public Float getY_ternary(Float a, Float b, Float c) {

  float heightT = (float) Math.sqrt(3)/2;
  return heightT*frac((c),(a+b+c));

}


      


public double getMax(double[] values){
  double result = Double.NEGATIVE_INFINITY;
  for (int i = 0; i < values.length; i++) {
    result = Math.max(result, values[i]);      
  }
  return result;
}
    
public double getMin(double[] values){
  double result = Double.POSITIVE_INFINITY;
  for (int i = 0; i < values.length; i++) {
    result = Math.min(result, values[i]);      
  }
  return result;
}

public Float getMax(Float[] values){
  Float result = Float.MIN_VALUE;
  for (int i = 0; i < values.length; i++) {
    result = Math.max(result, values[i]);      
  }
  return result;
}
    
public Float getMin(Float[] values){
  Float result = Float.MAX_VALUE;
  for (int i = 0; i < values.length; i++) {
    result = Math.min(result, values[i]);      
  }
  return result;
}

public double[] normalizeLinear(final double[] input, final double min, final double max) {
  double[] result = new double[input.length];
  for (int i = 0; i < input.length; i++) {
     result[i] =  (input[i] * 1.0f - min) / (max - min);
  }
  return result;
}


public Float[] normalizeLinear(final Float[] input, final Float min, final Float max) {
  Float[] result = new Float[input.length];
  for (int i = 0; i < input.length; i++) {
     result[i] =  (input[i] * 1.0f - min) / (max - min);
  }
  return result;
}

public double[] normalizeLinear(final int[] input, final double min, final double max) {
  double[] result = new double[input.length];
  for (int i = 0; i < input.length; i++) {
     result[i] =  (input[i] * 1.0f - min) / (max - min);
  }
  return result;
}
// abstract class for objects on the map
abstract class Object {
  
  // width and height of plot
  int w, h;
   
  // top left position
  int tlX, tlY;
  
  // boundaries of the plot
  ROI boundaries;
 
 // construction
  Object(int tlX, int tlY, int w, int h) {
    this.tlX = tlX;
    this.tlY = tlY;
    this.w = w;
    this.h = h;
    this.boundaries = new ROI(tlX,tlY,tlX+w,tlY+h);
  }
  
  // abstract function to draw the object 
  public abstract void draw();
  
  // conditional draw function
  public void draw(boolean draw) { if (draw) { draw(); } }
  

}
  
  
  
  
  
  
  
  
  
  
class Panel extends Object {
  
  String[] names;
  
  Float[] a, b, c;
  
  boolean[] selection;
  
  Panel(String[] n, Float[] a, Float[] b, Float[] c, boolean[] s, int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h); 
    
    this.names = n;
    this.a = a;
    this.b = b;
    this.c = c;
    this.selection = s;  
    
  }
  
  
  public void draw() {
    
    
    
  }
    
  
  
  
}
class ParallelCoordinatesPlot extends Plot {
  
  // data array
  Float[][] data;
  
  // normalized data arraz
  Float[][] dataNorm;
  
  // max and min values of each axes
  Float[] max, min;
  
  // number of features
  int nFeatures;
  
  // number of data entries
  int nEntries;
  
  // interactivity
  boolean[] selection;
  
  // ranges of axes
  int xrange, yrange;
  
  // distance between axes
  int gap;
  
  // labels
  String[] xLabels;
  String yLabel;
  
  // constructor
  ParallelCoordinatesPlot(Float[][] data, boolean[] s, int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h);
    
    this.data = data;
    this.nFeatures = data.length;
    this.nEntries = data[0].length;
    this.selection = s;
    
    // initialize and populate normalized data array
    this.dataNorm = new Float[nFeatures][nEntries];
    this.max = new Float[nEntries];
    this.min = new Float[nEntries];
    for (int i=0;i<nFeatures;i++) {
      this.max[i] = getMax(data[i]);
      this.min[i] = getMin(data[i]);
      this.dataNorm[i] = normalizeLinear(data[i], min[i], max[i]);
    }
    
    // ranges are based on width and height
    this.xrange = this.w-2*this.offset;
    this.yrange = this.h-2*this.offset;
    
    this.gap = xrange/(nFeatures-1);
    
    this.xLabels = new String[nFeatures];
    for (int i=0;i<nFeatures;i++) {
      this.xLabels[i] = "test";
    }
  } 
  
  
  
  
  // function to draw the axes
  public void drawAxes() {
    
    // axes
    stroke(datac);
    fill(datac);
    strokeWeight(aWeight);
    textSize(20);
    textAlign(CENTER);
    
    pushMatrix();
    translate(tlX+offset-60,tlY+h-offset-yrange/2);
    rotate(1.5f*PI);
    text(yLabel, 0,0);
    popMatrix();
    
    // draw all vertical axes
    for (int i=0;i<nFeatures;i++)  {
      line(tlX+offset+i*gap, tlY+h-offset, tlX+offset+i*gap, tlY+offset);
      text(String.valueOf(Math.round(min[i])), tlX+offset+i*gap-50, tlY+h-offset+10, 100, 50);
      text(String.valueOf(Math.round(max[i])), tlX+offset+i*gap-50, tlY+offset-30, 100, 50); 
      text(xLabels[i], tlX+offset+i*gap-50, tlY+h-offset+40, 100, 50); 
    } 
   
  };
  
  // function to draw the points
  public void drawData() {
    // first draw non selected data
    this.drawData(false);
    // then selected one
    this.drawData(true);
  };
  
  public void drawData(boolean selected) {
    stroke(datac);
    strokeWeight(2);

    // loop over all entries and features to draw lines
    for (int i=0;i<nEntries;i++) {
      for (int j=0;j<nFeatures-1;j++) {
        int x1 = Math.round(tlX+offset+gap*j);
        int y1 = Math.round(tlY+h-offset-dataNorm[j][i]*yrange);
        int x2 = Math.round(tlX+offset+gap*(j+1));
        int y2 = Math.round(tlY+h-offset-dataNorm[j+1][i]*yrange);
        if (selected) {
          if (selection[i]) { stroke(datacSelected); line(x1, y1, x2, y2); }
        } else {
          if (!selection[i]) { stroke(datac); line(x1, y1, x2, y2); }
        }
      }  
    }
  }
  
  // function to assign labels
  public void setXlabels(String[] l) { this.xLabels = l; }
  public void setYlabel(String l) { this.yLabel = l; }
  
  //  function to compute the x position of a data point
  public int getX(int i) { return 1; }
  
  // function to compute the y position of a data point
  public int getY(int i) { return 1; }
  
  // function to update points according to selected ROI
  public void selectROI(ROI r) {
    // only update selected if the selected roi corresponds to this plot
    if (this.boundaries.in(r)) {
      
      // deselect all data
      for (int i=0;i<selection.length;i++) { selection[i] = false; }
      
      // loop over all data to change selected
      for (int i=0;i<nEntries;i++) {
        for (int j=0;j<nFeatures-1;j++) {
          int x1 = Math.round(tlX+offset+gap*j);
          int y1 = Math.round(tlY+h-offset-dataNorm[j][i]*yrange);
          int x2 = Math.round(tlX+offset+gap*(j+1));
          int y2 = Math.round(tlY+h-offset-dataNorm[j+1][i]*yrange);
          // if the point was selected, i.e. is in the roi, change to selected
          if (roi.in(x1,y1) || roi.in(x2,y2)) { selection[i] = true; }
        }    
      }      
    }
  }

}
// abstract class for scatter plot and ternary plot
abstract class Plot extends Object {
  
  // background color, default color white
  int backgroundc = color(255, 255, 255);
  
  // color for axes and non selected data points, default color black
  int datac = color(40,44,55);
  
  // color of selected points, default color orange
  int datacSelected = color(204, 102, 0);
  
  // should plot be drawn
  boolean isActive = true;
  
  // stroke weight of axes and points
  int aWeight = 3;
  int pWeight = 4;
  
  // offset of the axes
  int offset = 25;
  
  int fontSize = 14;
  
  // constructor
  Plot(int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h); 
  }
  
  // function to draw the plot
  public void draw() {
    if (isActive) {
      // box
      fill(backgroundc);
      noStroke();
      rect(tlX, tlY, w, h);
      stroke(153);
      // axes
      this.drawAxes();
      // data
      this.drawData();
    }
  }
  
  // setter and getter function for active
  public void setActive(boolean input) { this.isActive=input; }
  public boolean getActive() { return this.isActive; }
  
  // setter function for background color
  public void setBackgroundColor(int c) { this.backgroundc = c; }
  
  // setter function for data color
  public void setDataColor(int c) { this.datac = c; }
  
  // setter function for data selected color
  public void setDataSelectedColor(int c) { this.datacSelected = c; }
  
  // abstract function to draw the axes
  abstract public void drawAxes();
  
  // abstract function to draw the points
  abstract public void drawData();
  
  // abstract function to compute the x position of a data point
  abstract public int getX(int i);
  
  // abstract function to compute the y position of a data point
  abstract public int getY(int i);
  
  // abstract function to update points according to selected ROI
  abstract public void selectROI(ROI r);
}
class QualitativeResults extends Object {
   
  Data data;
  PImage img;
  String aoiID;
  boolean singleSelect;
  int offset = 25;
  
  
  
  QualitativeResults(Data data, int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h); 
    this.data = data;
    this.singleSelect = false;
    
  }
  
  
  public void updateSelection() {
    int sumSelected = 0;
    for (Integer i=0;i<this.data.selected.length;i++) {
      // Reads country name and population density value from CSV row
      if (this.data.selected[i]) {
        sumSelected = sumSelected + 1;
        this.aoiID = this.data.name[i];
      }
    }
    if (sumSelected == 1) {
      this.singleSelect = true;
      this.img = loadImage(aoiID + ".jpg");
    }
    
  }
  
  public void draw() {
    if (this.singleSelect) {
      image(this.img, this.tlX+offset, this.tlY+offset, this.w-2*offset, this.h-2*offset);
    } else {
        fill(255,255,255);
        rect(this.tlX+offset, this.tlY+offset, this.w-2*offset, this.h-2*offset);
    }
  }
  
}
class ROI {
  
  //  upper left and lower right point that define the roi
  int ulX, ulY, lrX, lrY;
  
  // constructor
  ROI(int x1, int y1, int x2, int y2) {
    this.updateROI(x1,y1,x2,y2);
  }
  
  // constructor
  ROI() {}

  // function to set the values of roi
  public void updateROI(int x1, int y1, int x2, int y2) {
    // compute the correct coordinates for ul and lr
    // x coordinate
    if (x1<x2) { ulX = x1; lrX = x2; }
    else {ulX = x2; lrX = x1; }
    // y coordinate
    if (y1<y2) { ulY = y1; lrY = y2; }
    else { ulY = y2; lrY = y1; }
    
    if (ulX==lrX && ulY==lrY) {
      ulX = ulX-10;
      ulY = ulY-10;
      lrX = lrX+10;
      lrY = lrY+10; 
    }
  }
  
  //function to draw the region of interest
  public void draw() {
    stroke(0,0,0);
    strokeWeight(1);
    noFill();
    rect(ulX,ulY,lrX-ulX,lrY-ulY);
  }

  // function to print the upper left and lower right point
  public void print() {
    println("UL: (", this.ulX, ",", this.ulY, ")");  
    println("LR: (", this.lrX, ",", this.lrY, ")");
    
  }
  
  // function to check if a point on the screen is in the roi
  public boolean in(int x, int y) {
    if (ulX<x && ulY<y && lrX>x && lrY>y) { return true; }
    return false;
  }
  
  // function to check if a roi is in this roi
  public boolean in(ROI roi) {
    if (ulX<roi.ulX && ulY<roi.ulY && lrX>roi.lrX && lrY>roi.lrY) { return true; }
    return false;
  }

}
class Scatterplot extends Plot {
  
  // data points for axes
  Float[] x, y; 
  
  Float xMax, xMin, yMax, yMin;
  
  // normalized data
  Float[] xNorm, yNorm;
  
  // for interactivity
  boolean[] selection;
  
  // ranges of axes
  int xrange, yrange;
  
  // x and y axis labels
  String xlabel="", ylabel="";  
  
  Scatterplot(Float[] x, Float[] y, boolean[] s, int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h);
    
    // default data of axes
    this.x = x;
    this.y = y;
    
    this.xMax = getMax(x);
    this.xMin = getMin(x);
    this.yMax = getMax(y);
    this.yMin = getMin(y);
    this.xNorm = normalizeLinear(x, xMin, xMax);
    this.yNorm = normalizeLinear(y, yMin, yMax);
    
    this.selection = s;
    
    // ranges are based on width and height
    this.xrange = this.w-2*this.offset;
    this.yrange = this.h-2*this.offset;
    
  }
  
  
  
  public void drawAxes() {
    // axes
    stroke(datac);
    fill(datac);
    strokeWeight(aWeight);
    textSize(this.fontSize);
    
    // horizontal axis
    line(tlX+offset, tlY+h-offset, tlX+offset+xrange, tlY+h-offset);
    textAlign(CENTER);
    text(this.xlabel, tlX+offset, tlY+h-offset+10,xrange,100); 
    
    
    textAlign(CENTER);
    text(String.valueOf(Math.round(xMax)), tlX+offset+xrange-25, tlY+h-offset+10, 50, 50);
    // text(String.valueOf(Math.round(xMax-(xMax-xMin)/2)), tlX+offset+xrange/2-25, tlY+h-offset+10, 50, 50);
    text(String.valueOf(Math.round(xMin)), tlX+offset-25, tlY+h-offset+10, 50, 50);
    
    textAlign(CENTER);
    //text(, tlX+offset, tlY+h-offset+10,100,100); 
    // vertical axis
    line(tlX+offset, tlY+h-offset, tlX+offset, tlY+offset);
    textAlign(CENTER);
    pushMatrix();
    translate(tlX+offset-16,tlY+h-offset-yrange/2);
    rotate(1.5f*PI);
    text(ylabel, 0,0);
    popMatrix();
    
    textAlign(RIGHT);
    text(String.valueOf(Math.round(yMax)),tlX+offset-65, tlY+h-offset-yrange-10,50,50);
    // text(String.valueOf(Math.round(yMax-(yMax-yMin)/2)), tlX+offset-65, tlY+h-offset-yrange/2-10,50,50);
    text(String.valueOf(Math.round(yMin)), tlX+offset-65, tlY+h-offset-10,50,50);
    
  }
  
  
  // function to draw the data points  
  public void drawData() {
    
    // loop over all data to draw unselected points
    for (int i=0;i<this.x.length;i++) {      
      // set color according to selection
      if (!this.selection[i]) {
        strokeWeight(pWeight);
        stroke(datac);
        // draw point
        noSmooth();
        point(getX(i), getY(i));
      }
    }
        // loop over all data to draw selected points
    for (int i=0;i<this.x.length;i++) {      
      if (this.selection[i]) {
        strokeWeight(pWeight);
        stroke(datacSelected);
        // draw point
        noSmooth();
        point(getX(i), getY(i));
      }
    }
  }
  
  public int getX(int i) { return tlX+offset+Math.round(xNorm[i]*xrange); }
  public int getY(int i) { return tlY+h-offset-Math.round(yNorm[i]*yrange); }
  
  public void setXlabel(String xlabel) { this.xlabel = xlabel; }
  public void setYlabel(String ylabel) { this.ylabel = ylabel; }
  
  public void setXmax(Float m) { this.xMax = m; this.xNorm = normalizeLinear(x, xMin, xMax); }
  public void setXmin(Float m) { this.xMin = m; this.xNorm = normalizeLinear(x, xMin, xMax); }
  public void setYmax(Float m) { this.yMax = m; this.yNorm = normalizeLinear(y, yMin, yMax); }
  public void setYmin(Float m) { this.yMin = m; this.yNorm = normalizeLinear(y, yMin, yMax); }
  
  
  // function to update points according to selected ROI
  public void selectROI(ROI r) {
    // only update selected if the selected roi corresponds to this plot
    if (this.boundaries.in(r)) {
      println("in scatter plot");
      // loop over all data to change selected
      for (int i=0;i<selection.length;i++) {
        // if the point was selected, i.e. is in the roi, change to selected
        if (roi.in(getX(i),getY(i))) { selection[i] = true; }
        else { selection[i] = false; }
      }
    }
  }
  
}


class Selection extends Object {
  
  int nFields;
  
  Scatterplot splot;
  
  
  Field[] fields;
  
  // constructor
  Selection (int n, String[] names, int tlX, int tlY, int w, int h)   {
    super(tlX,tlY,w,h);
    this.nFields = n;
    this.fields = new Field[nFields];
    
    for (int i=0;i<nFields;i++) {

    }
      
  }
  
  public void draw() {}
  
  public void onClick(int x, int y) {
  
    for (int i=0;i<nFields;i++) {
      if (fields[i].onClick(x, y)) {
      
      }  
      
    }
  
    
  }
  
  
  
  
  
  
  
  
  
  
}


class Ternaryplot extends Plot {
  
  // data points for axes
  Float[] a, b, c; 
  
  boolean[] selection;
  
  // all 3 axes have the same range
  int range;
  
  // labels for the axes
  String aLabel="", bLabel="", cLabel="";
  
  // height of the triangle
  float heightRel;
  int heightT;

  // constructor
  Ternaryplot(Float[] a, Float[] b, Float[] c, boolean[] s, int tlX, int tlY, int l) {
    super(tlX,tlY,l,(int) Math.round(Math.sqrt(3)/2*(l-2*40)+2*40));
    // default data of axes
    this.a = a;
    this.b = b;
    this.c = c;

    this.selection = s;
    
    this.range = l-2*this.offset;
    this.heightRel = (float) Math.sqrt(3)/2;
    this.heightT = Math.round(this.heightRel*this.range);
  }
  
  // function to draw the axes of the plot
  public void drawAxes() {
    // axes still wrong
    stroke(datac);
    fill(datac);
    strokeWeight(aWeight);
    textSize(20);

    // axis 1
    line(tlX+offset, tlY+h-offset, tlX+w-offset, tlY+h-offset);
    textAlign(LEFT);
    text(this.aLabel, tlX+offset-20, tlY+h-offset+10,100,100); 
    // axis 2
    line(tlX+offset, tlY+h-offset, tlX+offset+range/2, tlY+h-offset-heightT);
    textAlign(RIGHT);
    text(this.bLabel, tlX+w-offset-80, tlY+h-offset+10,100,100); 
    // axis 3
    line(tlX+w-offset, tlY+h-offset, tlX+offset+range/2, tlY+h-offset-heightT);
    textAlign(CENTER);
    text(this.cLabel, tlX+offset+range/2-50, tlY+h-offset-heightT-40,100,100);
    
  }
  
  // function to draw the data points  
  public void drawData() {

    // loop over all data to draw points
    for (int i=0;i<this.a.length;i++) {
      
      // set color according to selection
      strokeWeight(pWeight);
      if (!selection[i]) { stroke(datac); }
      else { stroke(datacSelected); }
      
      // draw point
      noSmooth();
      point(getX(i), getY(i));
    }
  }
  
  // function to calculate relative x pos in ternary plot
  public int getX(int i) {
    Float sum = a[i]+b[i]+c[i];
    Float aRel = 100/sum*a[i];
    Float bRel = 100/sum*b[i];
    Float cRel = 100/sum*c[i];
    return tlX+offset+Math.round(0.5f*frac((2*bRel+cRel),(aRel+bRel+cRel))*range);
  }

  // function to calculate relative y pos in ternary plot
  public int getY(int i) {
    Float sum = a[i]+b[i]+c[i];
    Float aRel = 100/sum*a[i];
    Float bRel = 100/sum*b[i];
    Float cRel = 100/sum*c[i];
    return tlY+h-offset-Math.round(heightRel*frac((cRel),(aRel+bRel+cRel))*range);
  }
  
  // function to update points according to selected ROI
  public void selectROI(ROI r) {
    // only update selected if the selected roi corresponds to this plot
    if (this.boundaries.in(r)) {
      println("in ternary plot");
      // loop over all data to change selected
      for (int i=0;i<selection.length;i++) {
        // calculate relative percentage
        Float sum = a[i]+b[i]+c[i];
        Float aRel = 100/sum*a[i];
        Float bRel = 100/sum*b[i];
        Float cRel = 100/sum*c[i];
      
      
        // if the point was selected, i.e. is in the roi, change to selected
        if (roi.in(getX(i),getY(i))) { selection[i] = true; }
        else { selection[i] = false; }
      }
    }
  }
  
  public void setAlabel(String alabel) { this.aLabel = alabel; }
  public void setBlabel(String blabel) { this.bLabel = blabel; }
  public void setClabel(String clabel) { this.cLabel = clabel; }
  
  
}
class Title extends Object {
  
  String text;
  
  // colors
  int buttonc = color(255,255,255);
  
  Title(String t, int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h);
    this.text = t; 
  }
  
  public void draw() {
    textSize(32);
    textAlign(CENTER);
    fill(buttonc);
    text(this.text, tlX, tlY,w,h); 
  }
  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "geovisualization_project" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
