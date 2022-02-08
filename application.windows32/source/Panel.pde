class Panel extends Object {
  
  String[] names;
  
  Float[] a, b, c;
  
  boolean[] selection;
  
  Panel(String[] n, Float[] a, Float[] b, Float[] c, boolean[] s, int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h); 
    
    this.names = n;
    this.a = a;
    this.b = b;
    this.c = c;
    this.selection = s;  
    
  }
  
  
  public void draw() {
    
    
    
  }
    
  
  
  
}
