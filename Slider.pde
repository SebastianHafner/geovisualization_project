class Slider extends Object {
  // text to be displayed
  String title;
  
  // min and max value
  int min, max;
  
  // value of switch
  int value;
  
  // width and height of button
  int hButton = 50;
  int wButton = 33;
  
  // position of upper left corner
  int ulXbox, ulYbox;
  
  // length for values
  int l; 
  int step;
  
  // colors
  color buttonc = color(255,255,255);
  color backgroundc = color(100, 120);
  
  
  Slider(String title, int ulX, int ulY, int w, int min, int max, int defaultV) {
    super(ulX,ulY,w,100);
    this.title = title;
    this.ulXbox = ulX;
    this.ulYbox = ulY+50;
    this.min = min;
    this.max = max;
    this.value = defaultV;
    this.l = w-wButton;
    this.step = l/(max-min);
  }
  
  
  public void draw() {
    
    textSize(32);
    textAlign(LEFT);
    fill(buttonc);
    text(this.title+": "+String.valueOf(value), tlX, tlY,w,h-hButton); 

    fill(backgroundc);
    rect(ulXbox,ulYbox,w,hButton);  
  
    fill(buttonc);
    rect(ulXbox+(value-min)*step,ulYbox,wButton,hButton);  
  }

    
    
  

  
  
  // on clock function to change from on to off and vice versq  
  public void onClick(int xpos, int ypos) {
    if (boundaries.in(xpos,ypos)) { // check if user clicked on the button
      // if so change the value of the slider according to the clicked position
      for (int i=0;i<=max-min;i++) {
        if (xpos>(ulXbox+i*step) && xpos<(ulXbox+(i+1)*step)) {
           this.value = min+i; 
        }
      }
      println(this.value); 

    }
  }
  
  // function to return the current value of the slider
  public int getValue() { return this.value; }
  
  
}
