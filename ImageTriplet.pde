class ImageTriplet extends Object {
  
  String text;
  
  
  ImageTriplet(String t, int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h);
    this.text = t;
  
  
  
  
  }

  public void setText(String newText) { this.text = newText; } 
 
  public boolean onClick(int x, int y) {
    
  
    return true;
  }
  
  public void draw() {}
   
   
   

  
  
  
  
  
  
  
  
  
  
  
}
