class QualitativeResults extends Object {
   
  PImage img;
  String aoiID;
  boolean active;
  
  
  
  QualitativeResults(int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h); 
    this.active = true;
  }
  
  
  public void updateAOI(String aoiID) {
    this.aoiID = aoiID;
    this.img = loadImage(aoiID + ".jpg");
  }
  
  
  public void draw() {
    if (this.active) {
      image(this.img, this.tlX, this.tlY, this.w, this.h);
    }
  }
    
  
  
  
}
