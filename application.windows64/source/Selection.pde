class Selection extends Object {
  
  int nFields;
  
  Scatterplot splot;
  
  
  Field[] fields;
  
  // constructor
  Selection (int n, String[] names, int tlX, int tlY, int w, int h)   {
    super(tlX,tlY,w,h);
    this.nFields = n;
    this.fields = new Field[nFields];
    
    for (int i=0;i<nFields;i++) {

    }
      
  }
  
  public void draw() {}
  
  public void onClick(int x, int y) {
  
    for (int i=0;i<nFields;i++) {
      if (fields[i].onClick(x, y)) {
      
      }  
      
    }
  
    
  }
  
  
  
  
  
  
  
  
  
  
}
