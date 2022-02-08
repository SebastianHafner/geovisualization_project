import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.utils.*;
import java.util.List;

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



void setup() {
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

void draw() {
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
  qr.updateSelection();
}




