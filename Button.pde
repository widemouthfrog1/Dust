class Button {
  float x,y,w,h;
  int font;
  String name;
  Button(float x, float y, float w, float h, String name, int font){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.name = name;
    this.font = font;
  }
  
 void draw(){
   stroke(255, 200);
   noFill();
   rect(x-w/2, y - h/2, w, h, 7);
   textAlign(CENTER, CENTER);
   textSize(font);
   text(name, x, y-5); 
 }
 
 boolean isOn(PVector point){
   return point.x >= x - w/2 && point.x <= x+w/2 && point.y >= y - h/2 && point.y <= y+h/2;
 }
}