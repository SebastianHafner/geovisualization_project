// abstract class for objects on the map
abstract class Object {
  
  // width and height of plot
  int w, h;
   
  // top left position
  int tlX, tlY;
  
  // boundaries of the plot
  ROI boundaries;
 
 // construction
  Object(int tlX, int tlY, int w, int h) {
    this.tlX = tlX;
    this.tlY = tlY;
    this.w = w;
    this.h = h;
    this.boundaries = new ROI(tlX,tlY,tlX+w,tlY+h);
  }
  
  // abstract function to draw the object 
  abstract void draw();
  
  // conditional draw function
  public void draw(boolean draw) { if (draw) { draw(); } }
  

}
  
  
  
  
  
  
  
  
  
  
