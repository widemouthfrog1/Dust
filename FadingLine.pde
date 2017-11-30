class FadingLine {
  ArrayList<PVector> points;
  int colour = 200;
  boolean removed = false;
  FadingLine(ArrayList<PVector> points) {
    this.points = points;
  }

  void draw() {
    stroke(255, colour);
    PShape shape = createShape();
    shape.beginShape();
    for (int i = 0; i < points.size()-1; i++) {
      shape.vertex(points.get(i).x, points.get(i).y);
    }
    shape.endShape();
    shape.setFill(false);
    shape(shape);
    stroke(255, 200);
    colour -= 5;
    if (colour <= 0) {
      removeSelf();
    }
  }
  void removeSelf() {
    removed = true;
  }
}