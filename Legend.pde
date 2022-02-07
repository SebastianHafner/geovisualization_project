class Legend extends Object {
  
  Float[] data;
  
  // number of classes
  int nclasses = 5;
  
  // offset between the boxes
  int offset = 20;
  
  // min and max value of data
  Float min, max;
  
  color labelc = color(40,44,55);
  color boundaryc = color(100, 120);
  
  int hLegend;
  
  Colormap colormap;
  
  String title = "";
  
  // constructor
  Legend(Float[] data, int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h);
    this.data = data;
    // leave some space for the title
    this.hLegend = h-40;
    this.colormap = new Colormap();
    this.min = getMin(data);
    this.max = getMax(data);
  }
  
  // setters for max and min
  public void setMax(Float m) { this.max=m; }
  public void setMin(Float m) { this.min=m; }
  
  // setter for title
  public void setTitle(String t) { this.title=t; }
  
  // setter for number of classes
  public void setNumberClasses(int n) { this.nclasses = n; }
  
  // function to draw
  public void draw() {
    // height of a box is the plot height minus the total offset between the boxes
    // divided by the number of classes
    int hBox = Math.round((hLegend-(nclasses)*offset)/(nclasses+1));
    int wBox = w/2;
    
    // coordinates of the box
    int tlXbox = tlX;
    int tlYbox = tlY+h-hBox;
    
    // title
    stroke(labelc);
    fill(labelc);
    textSize(20);
    textAlign(LEFT);
    text("No data", tlXbox+wBox+20, tlYbox+(hBox-20)/2,100,100);
    
    // draw the no data box
    stroke(boundaryc);
    strokeWeight(3);
    fill(color(100, 120));
    rect(tlXbox,tlYbox,wBox,hBox); 
    
    stroke(labelc);
    fill(labelc);
    textSize(20);
    textAlign(LEFT);
    text(title, tlX, tlY,400,100); 
    
    // step to calculate the color value
    float step = (max-min)/nclasses;
    String label = "";
    int from, to;
    float value, transparency;
    
    for (int i=0;i<nclasses;i++) {
      
      // get color of the box
      value = min+i*step+step/2;
      fill(colormap.getColor(i));
      
      // get its position, taking into account no data box
      tlYbox = tlY+h-hBox-offset-(i*hBox+i*offset)-hBox;
      
      // draw it
      stroke(boundaryc);
      strokeWeight(3);
      rect(tlXbox,tlYbox,wBox,hBox);
      
      // box label 
      stroke(labelc);
      fill(labelc);
      textSize(20);
      from = Math.round(value-step/2);
      to = Math.round(value+step/2);
      label = "("+Integer.toString(from) + "," + Integer.toString(to)+"]";
      text(label, tlXbox+wBox+20, tlYbox+(hBox-20)/2,100,100); 
      
    }   
  }
  

  
}
