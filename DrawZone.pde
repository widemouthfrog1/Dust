class DrawZone {
  PVector pos;
  public static final float radius = 100;
  int colour;
  int opacity;

  DrawZone(PVector pos, String mode, boolean enemy) {
    this.pos = pos;
    if(mode.equals("Blind")){
      if(enemy){
        colour = 0;
      }else{
        colour = 255;
      }
      opacity = 255;
    }else{
      colour = 255;
      opacity = 80;
    }
  }

  boolean isOn(PVector point) {
    if (pow((point.x - pos.x), 2) + pow((point.y - pos.y), 2) <= pow(radius, 2)) {
      return true;
    }
    return false;
  }

  void draw() {
    noFill();
    stroke(colour, opacity);
    ellipse(pos.x, pos.y, radius*2, radius*2);  
  }
}