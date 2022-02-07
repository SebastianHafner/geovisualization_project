class Switch extends Object {
  
  // text to be displayed
  String title;
  
  // switch of or off
  boolean isOn = false;
  
  // colors
  color buttonc = color(255,255,255);
  color onc = color(43, 144, 217);
  color offc = color(255,0,0);
  color outline = color(0,0,0);
  
  // constructor
  Switch(String title, int tlX, int tlY) {
    // call constructor of parent class with
    // default width 100 and default height 50
    super(tlX,tlY,100,50);  
    this.title = title;
  }
  
  // function to draw the switch
  public void draw() {
    // always draw the title
    this.drawTitle();
    if (isOn) {
    // draw button for when it is switched on
    this.drawOnSwitch();
    } else {
    // draw button for when it is switched off
    this.drawOffSwitch();
    }  
  }
  
  // function to draw the turned on switch
  public void drawOnSwitch() {
    fill(buttonc);
    rect(tlX,tlY,w/3,h);
      
    fill(onc);
    rect(tlX+w/3,tlY,w/3*2,h);
  }
  
  // function to draw the turned off switch
  public void drawOffSwitch() {
    fill(offc);
    rect(tlX,tlY,w/3*2,h);
    
    fill(buttonc);
    rect(tlX+w/3*2,tlY,w/3,h);
  }
  
  // function to draw the title next to switch
  public void drawTitle() {
    textSize(32);
    textAlign(LEFT);
    fill(buttonc);
    text(this.title, tlX+w+20, tlY+(h-32)/2,250,h); 
    
  }
  
  // setter function for status
  public void setStatus(boolean input) { this.isOn = input; }
  
  // getter function for status
  public boolean getStatus() { return isOn; }

  
  // on clock function to change from on to off and vice versq  
  public void onClick(int xpos, int ypos) {
    if (boundaries.in(xpos,ypos)) { // check if user clicked on the button
      // if so change the status of the switch
      if (isOn) { this.setStatus(false); }
      else { this.setStatus(true); }
    }
  }
  

}
