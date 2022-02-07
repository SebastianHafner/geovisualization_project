import java.lang.*;

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
    return tlX+offset+Math.round(0.5*frac((2*bRel+cRel),(aRel+bRel+cRel))*range);
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

