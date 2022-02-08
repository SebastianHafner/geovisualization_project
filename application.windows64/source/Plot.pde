// abstract class for scatter plot and ternary plot
abstract class Plot extends Object {
  
  // background color, default color white
  color backgroundc = color(255, 255, 255);
  
  // color for axes and non selected data points, default color black
  color datac = color(40,44,55);
  
  // color of selected points, default color orange
  color datacSelected = color(204, 102, 0);
  
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
  public void setBackgroundColor(color c) { this.backgroundc = c; }
  
  // setter function for data color
  public void setDataColor(color c) { this.datac = c; }
  
  // setter function for data selected color
  public void setDataSelectedColor(color c) { this.datacSelected = c; }
  
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
