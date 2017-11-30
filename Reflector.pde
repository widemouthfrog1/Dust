class Reflector {
  public static final float maxLength = 50;
  ArrayList<PVector> points;
  boolean reflecting;
  int pointNum;
  double opacity;
  boolean removed;
  boolean touching;
  int tooLong = 0;

  Reflector(ArrayList<PVector> points) {
    this.points = points;
    pointNum = points.size()-3;
    opacity = 255;
  }

  void setTouching(boolean touching) {
    this.touching = touching;
  }

  void draw() {
    if (pointNum > 1) {
      PShape shape = createShape();

      shape.beginShape();

      for (int i = 0; i < pointNum; i++) {
        shape.vertex(points.get(i).x, points.get(i).y);
      }
      shape.endShape();
      shape.setFill(false);
      shape.setStroke(color(255, 200));
      shape(shape);
    }

    PShape shape2 = createShape();

    shape2.beginShape();

    shape2.vertex(points.get(points.size()-1).x, points.get(points.size()-1).y);
    shape2.vertex(points.get(pointNum).x, points.get(pointNum).y);
    shape2.endShape();
    shape2.setFill(false);
    shape2.setStroke(color(255, (int)opacity));
    shape(shape2);

    if (pointNum > 2) {
      pointNum--;
    } else if (pointNum > 1) {
      pointNum -= 2;
    } else {
      reflecting = true;
      tooLong++;
      //Had to check if they were touching a JaggedLine and if they were 
      //to stick around longer or weird stuff would happen when the reflector disappeared.
      //This lead to them sometimes getting stuck, so I hard coded the maximum time they could
      //be around for to 200 game ticks (or a little bit more)
      if (!touching || tooLong > 200) { 
        
        if (points.size() < 25) {
          opacity -= 10;
        } else {
          opacity -= 2.5;
        }
      }
    }
    if (opacity <= 0) {
      removed = true;
    }
    if(touching){
      touching = false;
    }
  }
}