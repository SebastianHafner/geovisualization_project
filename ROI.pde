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
