import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.utils.*;
import java.util.List;

ChoroplethMap cmap;
Scatterplot splot;
Ternaryplot tplot;
ParallelCoordinatesPlot pplot;
Barplot bplot;
Legend leg;
Data data;
Title titleSettings, titleInformation;
Switch switchCMap, switchPlot;
Slider sliderClass, sliderZoom;
int x1, x2, y1, y2;
ROI roi = new ROI();
Plot[] plots;
Title[] titles;
Slider[] sliders;
Switch[] switches;


void setup() {
  size(2736, 1824-50, P2D);
  cursor(CROSS);
  smooth();
  
  // reading data
  data = new Data("alcohol_data.csv");
  
  // setting up map
  cmap = new ChoroplethMap(this,data,width/5,0,width/5*4,height/3*2);
  leg = new Legend(data.years,width/5+100,height/3+100,200,height/3-120);
  leg.setMin(40f); leg.setMax(90f); leg.setTitle("Life expectancy in years");
  
  // setting up scatter plot
  splot = new Scatterplot(data.total,data.years,data.selected,width/5+100,height/3*2,width/4,height/3);
  splot.setXlabel("Alcohol consumption (liters per capita per year)");
  splot.setYlabel("Life expectancy (years)");
  splot.setYmin(40f); splot.setYmax(90f);
  splot.setXmin(0f); splot.setXmax(800f);
  
  // setting up ternary plot
  tplot = new Ternaryplot(data.beer,data.wine,data.spirit,data.selected,width/5+width/4+100,height/3*2,width/4);
  tplot.setAlabel("Beer"); tplot.setBlabel("Wine"); tplot.setClabel("Spirit");
  
  // setting up bar plot
  bplot = new Barplot(data.continent,data.selected,width/4+width/4+width/5+100,height/3*2,width/4,height/3);
  bplot.setXlabel("Continent"); bplot.setYlabel("Country distribution");
  
  // setting up parallel coordinates plot
  Float[][] d = {data.beer,data.spirit,data.wine,data.total};
  pplot = new ParallelCoordinatesPlot(d,data.selected,width/4+width/4+width/5+100,height/3*2,width/4,height/3);
  pplot.setActive(false);
  String[] xLabels = {"Beer","Spirit","Wine","Total"}; pplot.setXlabels(xLabels);
  pplot.setYlabel("Alcohol consumption (liters per capita per year)");
  plots = new Plot[]{splot,tplot,bplot,pplot};

  // setting up titles
  titleSettings = new Title("Settings", 40, 100, width/5-2*40, 50);
  titleInformation = new Title("WHO data (2010)", 40, height-100, width/5-2*40, 50);
  
  // setting up switches
  switchCMap = new Switch("Choropleth Map", 40, 200); switchCMap.setStatus(true);
  switchPlot = new Switch("Plot switch", 40, 300); switchPlot.setStatus(true);
  
  // setting up sliders
  sliderClass = new Slider("Number of classes",40,400,width/5-2*40,2,8,5);
  sliderZoom = new Slider("Zoom level",40,550,width/5-2*40,3,7,3);
  
  // creating arrays for easy access
  titles = new Title[]{titleSettings,titleInformation};
  sliders = new Slider[]{sliderClass,sliderZoom};
  switches = new Switch[]{switchCMap,switchPlot};
}

void draw() {
  background(217, 225, 232);
  noStroke();
  fill(40,44,55);
  rect(0,0,width/5,height);
  
  for (Title title:titles) { title.draw(); }
  for (Switch switchh:switches) { switchh.draw(); }
  for (Slider slider:sliders) { slider.draw(); }
  for (Plot plot:plots) { plot.draw(); }

  // Draw map tiles and country markers
  cmap.draw();
  leg.draw(switchCMap.getStatus());
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
  cmap.updateMarkers();  
}

void mouseReleased() {
  x2 = mouseX;
  y2 = mouseY;
  // updating the region of interest
  roi.updateROI(x1,y1,x2,y2);
  // selecting points for roi
  for (Plot plot:plots) { plot.selectROI(roi); }
  // updating markers according to selection
  cmap.updateMarkers();  
}

void mouseClicked() {
  for (Switch switchh:switches) { switchh.onClick(mouseX,mouseY); }
  for (Slider slider:sliders) { slider.onClick(mouseX,mouseY); }
  
  // adjusting map view according to switches and sliders
  cmap.setNumberClasses(sliderClass.getValue());
  leg.setNumberClasses(sliderClass.getValue());
  cmap.setZoomLevel(sliderZoom.getValue());
  cmap.setSelectionMode(!switchCMap.getStatus());
  cmap.select(mouseX,mouseY);
  
  // switching between plots
  bplot.setActive(switchPlot.getStatus());
  pplot.setActive(!switchPlot.getStatus());
}




