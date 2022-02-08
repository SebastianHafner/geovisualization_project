class QualitativeResults extends Object {
   
  Data data;
  PImage img;
  String aoiID;
  boolean singleSelect;
  int offset = 25;
  
  
  
  QualitativeResults(Data data, int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h); 
    this.data = data;
    this.singleSelect = false;
    
  }
  
  
  public void updateSelection() {
    int sumSelected = 0;
    for (Integer i=0;i<this.data.selected.length;i++) {
      // Reads country name and population density value from CSV row
      if (this.data.selected[i]) {
        sumSelected = sumSelected + 1;
        this.aoiID = this.data.name[i];
      }
    }
    if (sumSelected == 1) {
      this.singleSelect = true;
      this.img = loadImage(aoiID + ".jpg");
    }
    
  }
  
  public void draw() {
    if (this.singleSelect) {
      image(this.img, this.tlX+offset, this.tlY+offset, this.w-2*offset, this.h-2*offset);
    } else {
        fill(255,255,255);
        rect(this.tlX+offset, this.tlY+offset, this.w-2*offset, this.h-2*offset);
    }
  }
  
}
