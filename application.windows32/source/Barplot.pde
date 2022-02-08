import java.util.Arrays;
import java.util.HashSet;
import java.util.HashMap;

class Barplot extends Plot { 
  
  // data array, unique entries in data array,
  // and selection for interactivity
  String[] d;
  String[] unique;
  boolean[] selection;
  
  // range of the xaxis
  int xrange;
  int yrange;
  
  // width, height and number of bars
  int wBar, hBar, nBar;
  
  HashMap<String,Integer> count;
  int countTotal;
  
  String xLabel="", yLabel="";
  
  // constructior
  Barplot(String[] d, boolean[] s, int tlX, int tlY, int w, int h) {
    super(tlX,tlY,w,h);  
    this.d = d; 
    this.selection = s;
    // get unique data values
    this.unique = new HashSet<String>(Arrays.asList(d)).toArray(new String[0]);
    this.wBar = 15; // default value
    this.hBar = h-2*this.offset; // height of a bar
    this.nBar = this.unique.length;
    this.xrange = this.w-2*this.offset;
    this.yrange = this.h-2*this.offset;
    this.count = new HashMap<String,Integer>();
    
  }
  


  
  public void drawAxes() {  
    // axes
    stroke(datac);
    fill(datac);
    strokeWeight(aWeight);
    textSize(this.fontSize);
    // horizontal axis
    line(tlX+offset, tlY+h-offset, tlX+offset+xrange, tlY+h-offset);
    textAlign(CENTER);
    text(xLabel, tlX+offset, tlY+h-offset+40,xrange,100); 
    
    // vertical axis
    line(tlX+offset, tlY+h-offset, tlX+offset, tlY+offset);
    textAlign(RIGHT);
    text("1", tlX+offset-115, tlY+offset-10,100,50);
    // text("50", tlX+offset-115, tlY+h-offset-yrange/2-10,100,50);
    text("0", tlX+offset-115, tlY+h-offset-10,100,50);
    
    textAlign(CENTER);
    // vertical axis
    line(tlX+offset, tlY+h-offset, tlX+offset, tlY+offset);
    textAlign(CENTER);
    pushMatrix();
    translate(tlX+offset-18,tlY+h-offset-yrange/2);
    rotate(1.5*PI);
    text(yLabel, 0,0);
    popMatrix();
    


  }


  public void drawData() {
    
    // counting how many selected
    countTotal = 0;
    for (String u : unique) { count.put(u,0); }
    for (int i=0;i<d.length;i++) {
      if (selection[i]) { count.put(d[i],count.get(d[i])+1); countTotal++; }
    }
    
    String label;
    int tlXbar, tlYbar; 
     hBar = 50;
    // space between bars
    int space = (xrange-wBar*nBar)/nBar; // nBar-1 spaces but half a bar as buffer left and right
    for (int i=0;i<nBar;i++) {
      tlXbar = tlX+offset+space/2+i*space+i*wBar;
      hBar = (int) (yrange/ (float) countTotal * (float) count.get(unique[i])) ;
      tlYbar = tlY+h-offset-hBar;
      strokeWeight(0);
      fill(datacSelected);
      rect(tlXbar,tlYbar,wBar,hBar);
      
      // fucked up labelling
      label = unique[i];
      if (unique[i].equals("NAF_ME")) { label="NAFME"; }
      if (unique[i].equals("NA_AU")) { label="NA"; }

      textSize(fontSize);
      textAlign(CENTER);
      stroke(datac);
      fill(datac);
      // bar label
      text(label, tlXbar+wBar/2-25, tlY+h-offset+10,50,50);
   
      
    }
  
  }
  
  public int getX(int i) {
    
    return 1;
  }
  
  public int getY(int i) {
    
    
    return 1;
  }
  
  public void setXlabel(String xlabel) { this.xLabel = xlabel; }
  public void setYlabel(String ylabel) { this.yLabel = ylabel; }
  
  
  public void selectROI(ROI roi) {}




}
