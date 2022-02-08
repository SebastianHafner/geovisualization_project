import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.utils.*;
import java.util.List;

BackgroundMap bmap;
DotMap dmap;
Scatterplot splot;
Data data;
QualitativeResults qr;
int x1, x2, y1, y2;
ROI roi = new ROI();
Plot[] plots;



void setup() {
  size(1280, 720, P2D);
  cursor(CROSS);
  smooth();
  
  // reading data
  data = new Data("geovisualization_project_data.csv");
  
  // setting up map
  bmap = new BackgroundMap(this,width/4,0,width*3/4,height);
  dmap = new DotMap(this,data,width/4,0,width*3/4,height);
  
  // setting up scatter plot
  splot = new Scatterplot(data.precision,data.recall,data.selected,0,0,width/4,width/4);
  splot.setXlabel("Recall");
  splot.setYlabel("Precision");
  splot.setYmin(0f); splot.setYmax(100f);
  splot.setXmin(0f); splot.setXmax(100f);
  
  // qualitative results
  qr = new QualitativeResults(0, height/2, width/4, height/2);
  qr.updateAOI("L15-0457E-1135N_1831_3648_13");
  qr.draw();
  
  plots = new Plot[]{splot};
}

void draw() {
  background(217, 225, 232);
  noStroke();
  
  fill(255,255,255);
  rect(0,0, width/5,height);
  
  for (Plot plot:plots) { plot.draw(); }

  // Draw map tiles and country markers
  bmap.draw();
  dmap.draw();

}


void mousePressed() {
  x1 = mouseX;
  y1 = mouseY;
}

void mouseDragged() {
  // getting coordinates
  x2 = mouseX; y2 = mouseY;
  // updating the region of interest
  roi.updateROI(x1,y1,x2,y2);
  // selecting data for all plots  
  for (Plot plot:plots) { plot.selectROI(roi); }
  // updating choropleth markers
  dmap.updateMarkers();  
}

void mouseReleased() {
  x2 = mouseX;
  y2 = mouseY;
  // updating the region of interest
  roi.updateROI(x1,y1,x2,y2);
  // selecting points for roi
  for (Plot plot:plots) { plot.selectROI(roi); }
  // updating markers according to selection
  dmap.updateMarkers();  
}

void mouseClicked() {
  dmap.select(mouseX,mouseY);
}




