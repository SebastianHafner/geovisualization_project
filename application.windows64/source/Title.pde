class Title extends Object {
  
  String text;
  
  // colors
  color buttonc = color(255,255,255);
  
  Title(String t, int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h);
    this.text = t; 
  }
  
  public void draw() {
    textSize(32);
    textAlign(CENTER);
    fill(buttonc);
    text(this.text, tlX, tlY,w,h); 
  }
  
}
