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
    textSize(20);
    
    // horizontal axis
    line(tlX+offset, tlY+h-offset, tlX+offset+xrange, tlY+h-offset);
    textAlign(CENTER);
    text(this.xlabel, tlX+offset, tlY+h-offset+40,xrange,100); 
    
    
    textAlign(CENTER);
    text(String.valueOf(Math.round(xMax)), tlX+offset+xrange-25, tlY+h-offset+10, 50, 50);
    text(String.valueOf(Math.round(xMax-(xMax-xMin)/2)), tlX+offset+xrange/2-25, tlY+h-offset+10, 50, 50);
    text(String.valueOf(Math.round(xMin)), tlX+offset-25, tlY+h-offset+10, 50, 50);
    
    textAlign(CENTER);
    //text(, tlX+offset, tlY+h-offset+10,100,100); 
    // vertical axis
    line(tlX+offset, tlY+h-offset, tlX+offset, tlY+offset);
    textAlign(CENTER);
    pushMatrix();
    translate(tlX+offset-60,tlY+h-offset-yrange/2);
    rotate(1.5*PI);
    text(ylabel, 0,0);
    popMatrix();
    
    textAlign(RIGHT);
    text(String.valueOf(Math.round(yMax)),tlX+offset-65, tlY+h-offset-yrange-10,50,50);
    text(String.valueOf(Math.round(yMax-(yMax-yMin)/2)), tlX+offset-65, tlY+h-offset-yrange/2-10,50,50);
    text(String.valueOf(Math.round(yMin)), tlX+offset-65, tlY+h-offset-10,50,50);
    
  }
  
  
  // function to draw the data points  
  public void drawData() {
    
    // loop over all data to draw points
    for (int i=0;i<this.x.length;i++) {      
      // set color according to selection
      if (!this.selection[i]) { strokeWeight(pWeight); stroke(datac); }
      else { strokeWeight(pWeight); stroke(datacSelected); }
      
      // draw point
      noSmooth();
      point(getX(i), getY(i));
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


