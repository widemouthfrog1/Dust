interface Projectile { //just in case I got around to adding more projectiles
  int getDamage();
  PVector getPos();
  float getAngle();
  boolean isOn(PVector point1, PVector point2);
  String getType();
  boolean onScreen();
  ArrayList<PVector> getPoints();
  void draw();
  void removeSelf();
}