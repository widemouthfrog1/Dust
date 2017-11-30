class Enemy {  //<>//
  PVector pos;
  float health;
  ArrayList<PVector> points = new ArrayList<PVector>();
  ArrayList<PVector> currentShape = new ArrayList<PVector>(); //holds all the points of the shape being drawn
  ArrayList<PVector> currentPoints = new ArrayList<PVector>(); //holds the drawn points of the shape being drawn
  ArrayList<ArrayList<PVector>> shapes = new ArrayList<ArrayList<PVector>>();
  int numOfShapes = 12;
  float lineLength = 20;
  float lineWidth = 10;
  int timer = int(random(50, 100));
  int pointNum = 0;
  boolean doneDrawing = false;
  float randomAngle = 0;
  String difficulty;
  int colour;
  int opacity;
  

  Enemy(PVector pos, String difficulty, String mode) {
    this.difficulty = difficulty;
    this.pos = pos;
    
    points.add(new PVector(0, -5)); //the basic shape of the enemy/player
    points.add(new PVector(5, -8));
    points.add(new PVector(5, 0));
    points.add(new PVector(0, 10));
    points.add(new PVector(-5, 0));
    points.add(new PVector(-5, -8));
    
    if(mode.equals("Blind")){
      colour = 0;
      health = 255/2;
      opacity = 255;
    }
    if(mode.equals("Original")){
      colour = 255;
      health = 100;
      opacity = 200;
    }

    for (int i = 0; i < numOfShapes; i++) {
      shapes.add(new ArrayList<PVector>());
    }
    addShapes();
  }

  void resetDrawing() {
    doneDrawing = false;
    currentPoints = new ArrayList<PVector>();
    currentShape = new ArrayList<PVector>();
    timer = int(random(50, 100));
  }
  
  float randomAngleVarience(){
    if(difficulty.equals("Easy")){
      return 0.15;  
    }
    if(difficulty.equals("Normal")){
      return 0.1;  
    }
    return 0;
  }

  void addShapes() {
    //two lined jag right
    shapes.get(0).add(new PVector(0, 0));
    shapes.get(0).add(new PVector(lineWidth, -lineLength));
    shapes.get(0).add(new PVector(0, -2*lineLength));

    //two lined jag left
    shapes.get(1).add(new PVector(0, 0));
    shapes.get(1).add(new PVector(-lineWidth, -lineLength));
    shapes.get(1).add(new PVector(0, -2*lineLength));

    //three lined jag right
    shapes.get(2).add(new PVector(0, 0));
    shapes.get(2).add(new PVector(lineWidth, -lineLength));
    shapes.get(2).add(new PVector(-lineWidth, -2*lineLength));
    shapes.get(2).add(new PVector(0, -3*lineLength));

    //three lined jag left
    shapes.get(3).add(new PVector(0, 0));
    shapes.get(3).add(new PVector(-lineWidth, -lineLength));
    shapes.get(3).add(new PVector(lineWidth, -2*lineLength));
    shapes.get(3).add(new PVector(0, -3*lineLength));
    
    float angle = 0.13;
    //two lined jag right on right
    shapes.get(4).add(new PVector(0, 0));
    shapes.get(4).add(new PVector(lineWidth, -lineLength));
    shapes.get(4).add(new PVector(0, -2*lineLength));
    
    for(int i = 0; i < shapes.get(4).size(); i++){
      shapes.get(4).set(i, new PVector(shapes.get(4).get(i).x*cos(angle) - shapes.get(4).get(i).y*sin(angle), shapes.get(4).get(i).x*sin(angle) + shapes.get(4).get(i).y*cos(angle)));
    }
    for(int i = 0; i < shapes.get(4).size(); i++){
      shapes.get(4).set(i, new PVector(shapes.get(4).get(i).x + DrawZone.radius/2, shapes.get(4).get(i).y - DrawZone.radius/2));
    }

    //two lined jag left on right
    shapes.get(5).add(new PVector(0, 0));
    shapes.get(5).add(new PVector(-lineWidth, -lineLength));
    shapes.get(5).add(new PVector(0, -2*lineLength));
    
    for(int i = 0; i < shapes.get(5).size(); i++){
      shapes.get(5).set(i, new PVector(shapes.get(5).get(i).x*cos(angle) - shapes.get(5).get(i).y*sin(angle), shapes.get(5).get(i).x*sin(angle) + shapes.get(5).get(i).y*cos(angle)));
    }
    for(int i = 0; i < shapes.get(5).size(); i++){
      shapes.get(5).set(i, new PVector(shapes.get(5).get(i).x + DrawZone.radius/2, shapes.get(5).get(i).y - DrawZone.radius/2));
    }

    //three lined jag right on right
    shapes.get(6).add(new PVector(0, 0));
    shapes.get(6).add(new PVector(lineWidth, -lineLength));
    shapes.get(6).add(new PVector(-lineWidth, -2*lineLength));
    shapes.get(6).add(new PVector(0, -3*lineLength));
    
    for(int i = 0; i < shapes.get(6).size(); i++){
      shapes.get(6).set(i, new PVector(shapes.get(6).get(i).x*cos(angle) - shapes.get(6).get(i).y*sin(angle), shapes.get(6).get(i).x*sin(angle) + shapes.get(6).get(i).y*cos(angle)));
    }
    for(int i = 0; i < shapes.get(6).size(); i++){
      shapes.get(6).set(i, new PVector(shapes.get(6).get(i).x + DrawZone.radius/2, shapes.get(6).get(i).y - DrawZone.radius/2));
    }

    //three lined jag left on right
    shapes.get(7).add(new PVector(0, 0));
    shapes.get(7).add(new PVector(-lineWidth, -lineLength));
    shapes.get(7).add(new PVector(lineWidth, -2*lineLength));
    shapes.get(7).add(new PVector(0, -3*lineLength));
    
    for(int i = 0; i < shapes.get(7).size(); i++){
      shapes.get(7).set(i, new PVector(shapes.get(7).get(i).x*cos(angle) - shapes.get(7).get(i).y*sin(angle), shapes.get(7).get(i).x*sin(angle) + shapes.get(7).get(i).y*cos(angle)));
    }
    for(int i = 0; i < shapes.get(7).size(); i++){
      shapes.get(7).set(i, new PVector(shapes.get(7).get(i).x + DrawZone.radius/2, shapes.get(7).get(i).y - DrawZone.radius/2));
    }
    
    angle = -0.13;
    //two lined jag left
    shapes.get(8).add(new PVector(0, 0));
    shapes.get(8).add(new PVector(lineWidth, -lineLength));
    shapes.get(8).add(new PVector(0, -2*lineLength));
    
    for(int i = 0; i < shapes.get(8).size(); i++){
      shapes.get(8).set(i, new PVector(shapes.get(8).get(i).x*cos(angle) - shapes.get(8).get(i).y*sin(angle), shapes.get(8).get(i).x*sin(angle) + shapes.get(8).get(i).y*cos(angle)));
    }
    for(int i = 0; i < shapes.get(8).size(); i++){
      shapes.get(8).set(i, new PVector(shapes.get(8).get(i).x - DrawZone.radius/2, shapes.get(8).get(i).y - DrawZone.radius/2));
    }

    //two lined jag left on left
    shapes.get(9).add(new PVector(0, 0));
    shapes.get(9).add(new PVector(-lineWidth, -lineLength));
    shapes.get(9).add(new PVector(0, -2*lineLength));
    
    for(int i = 0; i < shapes.get(9).size(); i++){
      shapes.get(9).set(i, new PVector(shapes.get(9).get(i).x*cos(angle) - shapes.get(9).get(i).y*sin(angle), shapes.get(9).get(i).x*sin(angle) + shapes.get(9).get(i).y*cos(angle)));
    }
    for(int i = 0; i < shapes.get(9).size(); i++){
      shapes.get(9).set(i, new PVector(shapes.get(9).get(i).x - DrawZone.radius/2, shapes.get(9).get(i).y - DrawZone.radius/2));
    }

    //three lined jag right on left
    shapes.get(10).add(new PVector(0, 0));
    shapes.get(10).add(new PVector(lineWidth, -lineLength));
    shapes.get(10).add(new PVector(-lineWidth, -2*lineLength));
    shapes.get(10).add(new PVector(0, -3*lineLength));
    
    for(int i = 0; i < shapes.get(10).size(); i++){
      shapes.get(10).set(i, new PVector(shapes.get(10).get(i).x*cos(angle) - shapes.get(10).get(i).y*sin(angle), shapes.get(10).get(i).x*sin(angle) + shapes.get(10).get(i).y*cos(angle)));
    }
    for(int i = 0; i < shapes.get(10).size(); i++){
      shapes.get(10).set(i, new PVector(shapes.get(10).get(i).x - DrawZone.radius/2, shapes.get(10).get(i).y - DrawZone.radius/2));
    }

    //three lined jag left on left
    shapes.get(11).add(new PVector(0, 0));
    shapes.get(11).add(new PVector(-lineWidth, -lineLength));
    shapes.get(11).add(new PVector(lineWidth, -2*lineLength));
    shapes.get(11).add(new PVector(0, -3*lineLength));
    
    for(int i = 0; i < shapes.get(11).size(); i++){
      shapes.get(11).set(i, new PVector(shapes.get(11).get(i).x*cos(angle) - shapes.get(11).get(i).y*sin(angle), shapes.get(11).get(i).x*sin(angle) + shapes.get(11).get(i).y*cos(angle)));
    }
    for(int i = 0; i < shapes.get(11).size(); i++){
      shapes.get(11).set(i, new PVector(shapes.get(11).get(i).x - DrawZone.radius/2, shapes.get(11).get(i).y - DrawZone.radius/2));
    }
  }
  
  

  void pickShape(int number) {
    currentShape.add(shapes.get(number).get(0));
    currentShape.addAll(linearInterpolation(int(random(5, 20)), shapes.get(number).get(0), shapes.get(number).get(1))); 
    currentShape.add(shapes.get(number).get(1));
    currentShape.addAll(linearInterpolation(int(random(5, 20)), shapes.get(number).get(1), shapes.get(number).get(2))); 
    currentShape.add(shapes.get(number).get(2));
    if (number > 1 && number < 4 || number > 5 && number <8 || number > 9) {
      currentShape.addAll(linearInterpolation(int(random(10, 30)), shapes.get(number).get(2), shapes.get(number).get(3))); 
      currentShape.add(shapes.get(number).get(3));
    }
  }

  ArrayList<PVector> linearInterpolation(int threshold, PVector point1, PVector point2) {
    PVector vector = new PVector(point2.x - point1.x, point2.y - point1.y); //create a vector of the line between the 2 points
    vector.setMag(vector.mag()/float(threshold)); //set the magnitude of it to where the 1st point (as opposed to the 0th) would go
    ArrayList<PVector> line = new ArrayList<PVector>();
    float magnitude = 1;
    if (point2.x > point1.x) { //checks whether x is decreasing or increasing a vector is added
      while (point1.x + vector.x*magnitude <= point2.x) {
        line.add(new PVector(point1.x + vector.x*magnitude, point1.y + vector.y*magnitude)); //add the points inbetween
        magnitude++;
      }
    } else {
      while (point1.x + vector.x*magnitude >= point2.x) {
        line.add(new PVector(point1.x + vector.x*magnitude, point1.y + vector.y*magnitude)); //add the points inbetween
        magnitude++;
      }
    }
    return line;
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

  void rotatePoints(float angle, ArrayList<PVector> points) {
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
    if (currentPoints.isEmpty()) {
      timer--;
    }
    if (timer == 0) {
      if (currentPoints.isEmpty()) {

        pickShape(int(random(numOfShapes)));
        randomAngle = random(-randomAngleVarience(), randomAngleVarience());
        pointNum = 0;
      } else {
        pointNum++;
      }

      currentPoints.add(new PVector(currentShape.get(pointNum).x + pos.x, currentShape.get(pointNum).y + pos.y + DrawZone.radius - 5));
    }
    if (pointNum == currentShape.size()-1) {
      doneDrawing = true;
    }
    reset();
    scalePoints(2);
    if (!currentPoints.isEmpty()) {
      rotatePoints(new PVector(pos.x - currentPoints.get(pointNum).x, pos.y - currentPoints.get(pointNum).y).heading(), points);
      rotatePoints(PI/2, points);
    }

    translateByPos();
    strokeWeight(6);
    drawShape();
    strokeWeight(3);

    drawLine();
    if (doneDrawing) {
      for (int i = 0; i < currentPoints.size(); i++) {
        currentPoints.set(i, new PVector(currentPoints.get(i).x - pos.x, currentPoints.get(i).y - pos.y - DrawZone.radius + 5));
      }
      rotatePoints(randomAngle, currentPoints);
      for (int i = 0; i < currentPoints.size(); i++) {
        currentPoints.set(i, new PVector(currentPoints.get(i).x + pos.x, currentPoints.get(i).y + pos.y + DrawZone.radius - 5));
      }
    }
  }

  boolean isOn(PVector point) { //splits the shape into triangles and then checks if there is an intersection with the shape
                                //drawing a line between the point and the corners of those triangles 
    if (!(isIntersecting(point, points.get(4), points.get(2), points.get(5)) ||
      isIntersecting(point, points.get(2), points.get(4), points.get(5)) ||
      isIntersecting(point, points.get(5), points.get(2), points.get(4)))) {
      return true;
    }

    if (!(isIntersecting(point, points.get(4), points.get(2), points.get(1)) ||
      isIntersecting(point, points.get(2), points.get(4), points.get(1)) ||
      isIntersecting(point, points.get(1), points.get(2), points.get(4)))) {
      return true;
    }

    if (!(isIntersecting(point, points.get(4), points.get(2), points.get(3)) ||
      isIntersecting(point, points.get(2), points.get(4), points.get(3)) ||
      isIntersecting(point, points.get(3), points.get(2), points.get(4)))) {
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

  void damage(float damage) {
    health -= damage;
  }

  void drawShape() {
    PShape shape = createShape(); //I chose shapes over lines because lines created small dots wherever they overlapped due to transparency
    shape.beginShape();
    for (int i = 0; i < points.size(); i++) {
      shape.vertex(points.get(i).x, points.get(i).y);
    }
    shape.endShape(CLOSE);
    shape.setFill(false);
    shape.setStroke(color(colour, (int)2*health));
    shape(shape);
  }

  void drawLine() {
    //transform the points so they can be drawn{
    for (int i = 0; i < currentPoints.size(); i++) {
      currentPoints.set(i, new PVector(currentPoints.get(i).x - pos.x, currentPoints.get(i).y - pos.y - DrawZone.radius + 5));
    }
    rotatePoints(randomAngle, currentPoints);
    for (int i = 0; i < currentPoints.size(); i++) {
      currentPoints.set(i, new PVector(currentPoints.get(i).x + pos.x, currentPoints.get(i).y + pos.y + DrawZone.radius - 5));
    }
    //}
    PShape line = createShape();
    line.beginShape();
    for (int i = 0; i < currentPoints.size(); i++) {
      line.vertex(currentPoints.get(i).x, currentPoints.get(i).y);
    }
    line.endShape();
    line.setFill(false);
    line.setStroke(color(colour, opacity));
    shape(line);
    //transform them back so the next time you go to draw them the translations won't stack{
    for (int i = 0; i < currentPoints.size(); i++) {
      currentPoints.set(i, new PVector(currentPoints.get(i).x - pos.x, currentPoints.get(i).y - pos.y - DrawZone.radius + 5));
    }
    rotatePoints(-randomAngle, currentPoints);
    for (int i = 0; i < currentPoints.size(); i++) {
      currentPoints.set(i, new PVector(currentPoints.get(i).x + pos.x, currentPoints.get(i).y + pos.y + DrawZone.radius - 5));
    }
    //}
  }
}