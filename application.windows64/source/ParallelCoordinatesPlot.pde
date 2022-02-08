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
    rotate(1.5*PI);
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
