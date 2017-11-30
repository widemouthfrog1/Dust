class Player {
  PVector pos;
  float health;
  ArrayList<PVector> points = new ArrayList<PVector>();


  Player(PVector pos, String mode) {
    this.pos = pos;
    health = 100;
    points.add(new PVector(0, -5));
    points.add(new PVector(5, -8));
    points.add(new PVector(5, 0));
    points.add(new PVector(0, 10));
    points.add(new PVector(-5, 0));
    points.add(new PVector(-5, -8));
    if(mode.equals("Blind")){
      health = 255/2;
    }
    if(mode.equals("Original")){
      health = 100;
    }
  }

  void reset() {
    points.set(0, new PVector(0, -5));
    points.set(1, new PVector(5, -8));
    points.set(2, new PVector(5, 0));
    points.set(3, new PVector(0, 10));
    points.set(4, new PVector(-5, 0));
    points.set(5, new PVector(-5, -8));
  }

  void translateByPos() {
    for (int i = 0; i < points.size(); i++) {
      points.set(i, new PVector(points.get(i).x +pos.x, points.get(i).y +pos.y));
    }
  }

  void rotatePoints(float angle) {
    for (int i = 0; i < points.size(); i++) {
      points.set(i, new PVector(points.get(i).x*cos(angle) - points.get(i).y*sin(angle), points.get(i).x*sin(angle) + points.get(i).y*cos(angle)));
    }
  }

  void scalePoints(float scale) {
    for (int i = 0; i < points.size(); i++) {
      points.set(i, points.get(i).mult(scale));
    }
  }

  void draw() {
    reset();
    scalePoints(2);
    rotatePoints(new PVector(pos.x - mouseX, pos.y - mouseY).heading());
    rotatePoints(PI/2);
    translateByPos();
    strokeWeight(6);
    drawShape();
    strokeWeight(3);
  }

  boolean isOn(PVector point) {//refer to enemy isOn(PVector point) method
    if(!(isIntersecting(point, points.get(4), points.get(2), points.get(5)) ||
    isIntersecting(point, points.get(2), points.get(4), points.get(5)) ||
    isIntersecting(point, points.get(5), points.get(2), points.get(4)))){
      return true;
    }
    
    if(!(isIntersecting(point, points.get(4), points.get(2), points.get(1)) ||
    isIntersecting(point, points.get(2), points.get(4), points.get(1)) ||
    isIntersecting(point, points.get(1), points.get(2), points.get(4)))){
      return true;
    }
    
    if(!(isIntersecting(point, points.get(4), points.get(2), points.get(3)) ||
    isIntersecting(point, points.get(2), points.get(4), points.get(3)) ||
    isIntersecting(point, points.get(3), points.get(2), points.get(4)))){
      return true;
    }
    
    return false;
  }


  Float s(float[] abc, PVector point1, PVector point2) {
    if ((abc[0]*(point2.x - point1.x) + abc[1]*(point2.y-point1.y)) != 0) {
      return -(abc[0]*point1.x + abc[1]*point1.y + abc[2])/(abc[0]*(point2.x - point1.x) + abc[1]*(point2.y-point1.y));
    }
    return null;
  }

  boolean isIntersecting(PVector point3, PVector point4, PVector point1, PVector point2) {
    Float s = s(abc(point1, point2), point3, point4);
    if (s != null && s < 1 && s > 0) {
      return true;
    }
    return false;
  }
  
  void damage(float damage){
    health -= damage;
  }

  void drawShape() {
    PShape shape = createShape();
    shape.beginShape();
    for (int i = 0; i < points.size(); i++) {
      shape.vertex(points.get(i).x, points.get(i).y);
    }
    shape.endShape(CLOSE);
    shape.setFill(false);
    shape.setStroke(color(255, (int)2*health));
    shape(shape);
  }
}