class JaggedLine implements Projectile { //<>//
  public static final float maxLength = 50;
  int currentPoint;
  PVector velocity;
  PVector originalVelocity;
  ArrayList<PVector> points;
  int damage;
  float distance;
  float angle;
  boolean removed;
  int opacity;
  int colour;
  boolean touching;
  boolean wasTouching = false;
  boolean firstTime = true;
  PVector firstPoint = null;

  JaggedLine(ArrayList<PVector> points, String mode, boolean enemy) {
    this.points = points;
    distance = sqrt(pow((points.get(0).x - points.get(points.size()-1).x), 2) + pow((points.get(0).y - points.get(points.size()-1).y), 2));
    angle = atan((points.get(0).y - points.get(points.size()-1).y)/(points.get(0).x - points.get(points.size()-1).x));
    velocity = new PVector(points.get(0).x - points.get(points.size()-1).x, points.get(0).y - points.get(points.size()-1).y);
    originalVelocity =  new PVector(points.get(0).x - points.get(points.size()-1).x, points.get(0).y - points.get(points.size()-1).y);
    if (points.get(0).x - points.get(points.size()-1).x < 0) {
      angle *= -1;
    }
    removed = false;

    if (mode.equals("Blind")) {
      opacity = 255;
      if (enemy) {
        colour = 0;
      } else {
        colour = 255;
      }
    }
    if (mode.equals("Original")) {
      opacity = 200;
      colour = 255;
    }



    currentPoint = points.size()-1;

    this.damage = round(points.size());
  }
  String getType() {
    return "JaggedLine";
  }
  void setTouching(boolean touching) {
    this.touching = touching;
  }

  int getDamage() {
    return damage;
  }

  float[] abc(PVector point1, PVector point2) {
    float a, b, c;
    float[] table;

    a = -(point2.y - point1.y);
    b = point2.x - point1.x;
    c = point1.x*point2.y - point1.y*point2.x;


    table = new float[3];
    table[0] = a;
    table[1] = b;
    table[2] = c;
    return table;
  }



  float getAngle() {
    return angle;
  }

  ArrayList<PVector> getPoints() {
    return points;
  }

  PVector getPos() {
    return points.get(0);
  }

  boolean onScreen() {
    boolean onScreen = false;
    for (int i = 0; i < points.size(); i++) {
      PVector corner = points.get(i);
      if (corner.x > 0 && corner.x < width && corner.y > 0 && corner.y < height) {
        return true;
      }
    }
    return onScreen;
  }
  float k(float a, float b, float c, PVector pos) {
    return a*pos.x + b*pos.y + c;
  }

  Float s(float[] abc, PVector point1, PVector point2) {
    if ((abc[0]*(point2.x - point1.x) + abc[1]*(point2.y-point1.y)) != 0) {
      return -(abc[0]*point1.x + abc[1]*point1.y + abc[2])/(abc[0]*(point2.x - point1.x) + abc[1]*(point2.y-point1.y));
    }
    return null;
  }

  boolean isIntersecting(PVector point1, PVector point2, PVector point3, PVector point4) {
    if (s(abc(point1, point2), point3, point4) <= 1 && s(abc(point1, point2), point3, point4) >= 0) {
      return true;
    }
    return false;
  }

  PVector reflectedVector(PVector j1, PVector j2, PVector r1, PVector r2) {
    PVector j = new PVector(j2.x-j1.x, j2.y-j1.y);
    PVector r = new PVector(r2.x-r1.x, r2.y-r1.y);
    float a = PVector.angleBetween(j, r);
    if (a > PI/2) {
      a = PI - a;
    }
    return j.rotate(2*a);
  }

  boolean isIntersection(PVector j1, PVector j2, PVector r1, PVector r2) {
    Float sr = s(abc(j1, j2), r1, r2);
    Float sj = s(abc(r1, r2), j1, j2);

    if (sr == null || sr > 1 || sr < 0 || sj > 1 || sj < 0) { //if sr is null sj should be null as they are parallel lines
      return false;
    }
    return true;
  }

  Float getMag(PVector intersection, PVector j2) {
    return PVector.sub(j2, intersection).mag();
  }

  PVector movementVector(PVector j1, PVector j2, PVector r1, PVector r2) {

    if (!isIntersection(j1, j2, r1, r2)) {
      return originalVelocity;
    }
    PVector intersection = getIntersection(j1, j2, r1, r2);
    Float mag = getMag(intersection, j2);  

    PVector reflection = reflectedVector(j1, j2, r1, r2);
    reflection.setMag(mag);

    return PVector.add(PVector.sub(intersection, j1), reflection);
  }

  PVector getIntersection(PVector j1, PVector j2, PVector r1, PVector r2) {
    float s = s(abc(r1, r2), j1, j2);
    return new PVector((1-s)*j1.x + s*j2.x, (1-s)*j1.y + s*j2.y);
  }

  boolean isOn(PVector point1, PVector point2) {
    for (int i = 0; i < points.size()-1; i++) {
      if (isIntersecting(point1, point2, points.get(i), points.get(i+1))) {
        return true;
      }
    }
    return false;
  }

  void setVelocity(PVector newVelocity) {
    velocity = newVelocity;
  }

  void removeSelf() {
    removed = true;
  }

  void draw() {
    if (firstTime && touching) {
      firstPoint = points.get(0);
    }
    if (firstPoint != null && points.get(points.size()-1).equals(firstPoint)) {
      setVelocity(new PVector(points.get(0).x - points.get(points.size()-1).x, points.get(0).y - points.get(points.size()-1).y));
      originalVelocity = new PVector(points.get(0).x - points.get(points.size()-1).x, points.get(0).y - points.get(points.size()-1).y);
      firstPoint = null;
      firstTime = true;
    }
    PShape shape = createShape();
    shape.beginShape();
    for (int i = 0; i < points.size()-1; i++) {
      shape.vertex(points.get(i).x, points.get(i).y);
    }
    shape.endShape();
    shape.setStroke(color(colour, opacity));
    shape.setFill(false);
    shape(shape);

    points.get(points.size()-1).add(velocity);
    PVector removed = points.remove(points.size()-1);
    points.add(0, removed);

    wasTouching = touching;
    if (touching) {
      firstTime = false;
    }
    touching = false;
  }
}