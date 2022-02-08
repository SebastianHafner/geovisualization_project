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
int x1, x2, y1, y2;
ROI roi = new ROI();
Plot[] plots;



void setup() {
  size(1280, 720, P2D);
  cursor(CROSS);
  smooth();
  
  // reading data
  data = new Data("alcohol_data.csv");
  
  // setting up map
  bmap = new BackgroundMap(this,data,0,0,width,height);
  dmap = new DotMap(this,data,0,0,width,height);
  
  
  // setting up scatter plot
  splot = new Scatterplot(data.total,data.years,data.selected,width/5+100,height/3*2,width/4,height/3);
  splot.setXlabel("Recall");
  splot.setYlabel("Precision");
  splot.setYmin(40f); splot.setYmax(90f);
  splot.setXmin(0f); splot.setXmax(800f);
  
  
  plots = new Plot[]{splot};
}

void draw() {
  background(217, 225, 232);
  noStroke();
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
  bmap.updateMarkers();  
}

void mouseReleased() {
  x2 = mouseX;
  y2 = mouseY;
  // updating the region of interest
  roi.updateROI(x1,y1,x2,y2);
  // selecting points for roi
  for (Plot plot:plots) { plot.selectROI(roi); }
  // updating markers according to selection
  bmap.updateMarkers();  
}

void mouseClicked() {
  bmap.select(mouseX,mouseY);
}




