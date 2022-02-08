class Colormap {
  
  color[] colormapBlue = {
    color(247,251,255),color(222,235,247),color(198,219,239),color(158,202,225),color(107,174,214),
    color(66,146,198),color(33,113,181),color(8,81,156),color(8,48,107)
  };
  
  // constructor
  Colormap() {}
  
  public color getColor(int n) { return this.colormapBlue[n]; }
  
}
