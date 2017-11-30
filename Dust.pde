ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
ArrayList<JaggedLine> jaggedLines = new ArrayList<JaggedLine>();
ArrayList<Button> buttons = new ArrayList<Button>();
ArrayList<FadingLine> failedAttempts = new ArrayList<FadingLine>();
ArrayList<Reflector> reflectors = new ArrayList<Reflector>();
ArrayList<PVector> currentPoints = new ArrayList<PVector>();
ArrayList<PImage> backgrounds = new ArrayList<PImage>();
boolean leftPressed = false;
boolean leftReleased = false;
boolean rightPressed = false;
boolean rightReleased = false;
DrawZone drawZone;
DrawZone enemyDrawZone;
PImage background, mouse;
Player player;
Enemy enemy;
boolean canEnd = false;
boolean play = false;
boolean firstDraw = false;
boolean changing = false;
int chalkBoardNumber = 0;
int increasingOrDecreasing = 0;


void setup() {
  size(600, 600);

  backgrounds.add(loadImage("ChalkBoard.jpg"));
  for (int i = 0; i < 512; i += 2) {
    backgrounds.add(loadImage("ChalkBoardErode"+i+".jpg"));
  }

  background = backgrounds.get(0);
  mouse = loadImage("ChalkMouse.png");
  cursor(mouse);


  buttons.add(new Button(width/2, height/2 - 20, 200, 80, "Play", 42));
  buttons.add(new Button(width/2, height/2 + 80, 200, 80, "Original", 36));
  buttons.add(new Button(width/2, height/2 + 180, 200, 80, "Normal", 36));
  buttons.add(new Button(width/2, height/2, 200, 80, "Main Menu", 36));
}

void menu() {
  for (int i = 0; i < buttons.size()-1; i++) {
    buttons.get(i).draw();
  }
  textAlign(CENTER);
  textSize(200);
  text("Dust", width/2, height/4 + 50);
  if (!changing) { //if the background is not changing

    if (leftPressed) {
      for (int i = 0; i < buttons.size(); i++) {
        if (buttons.get(i).name.equals("Play")) {
          if (buttons.get(i).isOn(new PVector(mouseX, mouseY))) {
            play = true;
            firstDraw = true;
          }
        }
        if (buttons.get(i).name.equals("Original")) {
          if (buttons.get(i).isOn(new PVector(mouseX, mouseY))) {
            buttons.remove(i);
            buttons.add(1, new Button(width/2, height/2 + 80, 200, 80, "Blind", 36));
            changing = true;
            break;
          }
        }
        if (buttons.get(i).name.equals("Blind")) {
          if (buttons.get(i).isOn(new PVector(mouseX, mouseY))) {
            buttons.remove(i);
            buttons.add(1, new Button(width/2, height/2 + 80, 200, 80, "Original", 36));
            changing = true;
            break;
          }
        }
        if (buttons.get(i).name.equals("Easy")) {
          if (buttons.get(i).isOn(new PVector(mouseX, mouseY))) {
            buttons.remove(i);
            buttons.add(2, new Button(width/2, height/2 + 180, 200, 80, "Normal", 36));
            break;
          }
        }
        if (buttons.get(i).name.equals("Normal")) {
          if (buttons.get(i).isOn(new PVector(mouseX, mouseY))) {
            buttons.remove(i);
            buttons.add(2, new Button(width/2, height/2 + 180, 200, 80, "Hard", 36));
            break;
          }
        }
        if (buttons.get(i).name.equals("Hard")) {
          if (buttons.get(i).isOn(new PVector(mouseX, mouseY))) {
            buttons.remove(i);
            buttons.add(2, new Button(width/2, height/2 + 180, 200, 80, "Easy", 36));
            break;
          }
        }
      }
      leftPressed = false;
    }
  } else {
    if (increasingOrDecreasing == 0 && chalkBoardNumber == 0) {//set whether to erode the background
      increasingOrDecreasing = 1;
      chalkBoardNumber += increasingOrDecreasing;
    }
    if (increasingOrDecreasing == 0 && chalkBoardNumber == 256) {// or unerode the background
      increasingOrDecreasing = -1;
      chalkBoardNumber += increasingOrDecreasing;
    }
    if (chalkBoardNumber != 0 && chalkBoardNumber != 256) {//actually erode/unerode if not the first or last image
      background = backgrounds.get(chalkBoardNumber);
      chalkBoardNumber += increasingOrDecreasing;
    } else { //if it's the first or last image stop changing
      background = backgrounds.get(chalkBoardNumber);
      changing = false;
      increasingOrDecreasing = 0;
    }
  }
}

void endGameScreen(boolean won) {
  if (won) {
    text("You Won!", width/2, height/4);
  } else {
    text("You Lost!", width/2, height/4);
  }
  buttons.get(3).draw();
  if (leftPressed) {
    if (buttons.get(3).isOn(new PVector(mouseX, mouseY))) {
      play = false;
      player = null;
      enemy = null;
      while (!projectiles.isEmpty()) {
        projectiles.remove(0);
      }
      while (!failedAttempts.isEmpty()) {
        failedAttempts.remove(0);
      }
      while (!reflectors.isEmpty()) {
        reflectors.remove(0);
      }
    }
    leftPressed = false;
  }
}

void game(String difficulty, String mode) {
  if (firstDraw) {
    player = new Player(new PVector(width/2, 13*height/16), mode);
    enemy = new Enemy(new PVector(width/2, 3*height/16), difficulty, mode);
    drawZone = new DrawZone(new PVector(width/2, 13*height/16), mode, false);
    enemyDrawZone = new DrawZone(new PVector(width/2, 3*height/16), mode, true);
  }
  if (mode.equals("Blind")) {
    noStroke();
    fill(255);
    rect(0, 0, width, height/2);
    stroke(0);
  }

  for (int i = 0; i < projectiles.size(); i++) {
    ArrayList<PVector> projectilePoints = projectiles.get(i).getPoints();
    for (int j = 0; j < projectilePoints.size(); j++) {
      if (player.isOn(projectilePoints.get(i))) {
        player.damage(0.05);
      }
      if (enemy.isOn(projectilePoints.get(i))) {
        enemy.damage(0.05);
      }
    }
  }

  for (int i = 0; i < jaggedLines.size(); i++) {
    for (int j = 0; j < reflectors.size(); j++) {
      Reflector rline = reflectors.get(j);
      if (rline.reflecting) {

        JaggedLine jline = jaggedLines.get(i);
        PVector j1 = jline.points.get(jline.points.size()-1);
        PVector j2 = PVector.add(jline.points.get(jline.points.size()-1), jline.originalVelocity);
        PVector r1 = rline.points.get(0);
        PVector r2 = rline.points.get(rline.points.size()-1);
        PVector movementVector = jline.movementVector(j1, j2, r1, r2);
        if (!jline.originalVelocity.equals(movementVector)) {
          jline.setVelocity(movementVector);
          rline.setTouching(true);
          jline.setTouching(true);
        }
      }
    }
  }
  if (canEnd && player.health <= 0) {
    text("You Lose", width/2, height/2);
    return;
  }

  if (canEnd && enemy.health <= 0) {
    text("You Win!", width/2, height/2);
    return;
  }
  player.draw();
  enemy.draw();



  if (enemy.doneDrawing) {
    JaggedLine jline = new JaggedLine(enemy.currentPoints, mode, true);
    projectiles.add(jline); 
    jaggedLines.add(jline);
    enemy.resetDrawing();
  }

  for (int i = 0; i < failedAttempts.size(); i++) {
    failedAttempts.get(i).draw();
  }
  for (int i = 0; i < failedAttempts.size(); i++) {
    if (failedAttempts.get(i).removed) {
      failedAttempts.remove(failedAttempts.get(i));
    }
  }
  drawZone.draw();
  enemyDrawZone.draw();
  if (mode.equals("Blind")) {
    stroke(255, 255);
  } else {
    stroke(255, 200);
  }
  PShape currentShape = createShape();
  currentShape.beginShape();
  for (int i = 0; i < currentPoints.size()-1; i++) {
    currentShape.vertex(currentPoints.get(i).x, currentPoints.get(i).y);
  }
  currentShape.endShape();
  currentShape.setFill(false);
  shape(currentShape);
  for (int i = 0; i < projectiles.size(); i++) {
    projectiles.get(i).draw();
  }
  for (int i = 0; i < reflectors.size(); i++) {
    if (reflectors.get(i).removed) {
      reflectors.remove(reflectors.get(i));
    }
  }
  for (int i = 0; i < reflectors.size(); i++) {
    reflectors.get(i).draw();
  }

  for (int i = 0; i < projectiles.size(); i++) {
    if (!projectiles.get(i).onScreen()) {
      projectiles.remove(projectiles.get(i));
    }
  }
  
  if (leftPressed) {
    currentPoints.add(new PVector(mouseX, mouseY));
    if (!drawZone.isOn(currentPoints.get(currentPoints.size()-1))) {
      failedAttempts.add(new FadingLine(currentPoints));
      currentPoints = new ArrayList<PVector>();
    } else {
      if (leftReleased) {
        leftPressed = false;
        leftReleased = false;
        removeDuplicatePoints(currentPoints);
        if (isJaggedLine(currentPoints)) {
          JaggedLine jline =  new JaggedLine(currentPoints, mode, false);
          projectiles.add(jline);
          jaggedLines.add(jline);
        } else if (isReflector(currentPoints)) {
          reflectors.add( new Reflector(currentPoints));
        } else {
          failedAttempts.add(new FadingLine(currentPoints));
        }

        currentPoints = new ArrayList<PVector>();
      }
    }
  }
  if(leftReleased){
    if (!drawZone.isOn(new PVector(mouseX, mouseY))) {
      leftReleased = false;
    }
  }
  firstDraw = false;
}

void draw() {
  image(background, 0, 0);
  stroke(255, 200);
  strokeWeight(3);
  if (play) {
    if (player == null || player.health > 0 && enemy.health > 0) {
      game(buttons.get(2).name, buttons.get(1).name);
    } else {
      endGameScreen(player.health > 0);
    }
  } else {
    menu();
  }
}

void removeDuplicatePoints(ArrayList<PVector> points) {
  PVector point1;
  PVector point2;
  int i = 1;
  while (i < points.size()) {
    point1 = points.get(i-1);
    point2 = points.get(i);
    while ( point2.x - point1.x == 0 && point2.y - point1.y == 0) {
      points.remove(i);
      if (i < points.size()) {
        point2 = points.get(i);
      } else {
        break;
      }
    }
    i++;
  }
}


ArrayList<PVector> findVertices(ArrayList<PVector> points) {
  if (points.size() < 5) {
    return null;
  }
  ArrayList<PVector> vertices = new ArrayList<PVector>();
  ArrayList<PVector> simplified = new ArrayList<PVector>();
  ArrayList<PVector> simplifiedPoints = new ArrayList<PVector>();
  simplifiedPoints.add(points.get(0));
  for (int i = 0; i < points.size(); i += 4) {
    int next = i+4;
    while (next >= points.size()) {
      next--;
    }
    simplified.add(new PVector(points.get(next).x - points.get(i).x, points.get(next).y - points.get(i).y)); //approximates the shape/line created by the user
    simplifiedPoints.add(points.get(next));
  }
  vertices.add(simplifiedPoints.get(0));//add the first vertex
  for (int i = 0; i < simplified.size()-1; i++) {
    //add all the vertices inbetween
    if (PVector.angleBetween(simplified.get(i), simplified.get(i+1)) > 4*PI/9) { 
      //if the angle between them is greater than 80 degrees 
      //(actually checking if the angle between the end of the first vector and the start of the next is less that 100 degrees)
      vertices.add(simplifiedPoints.get(i+1));
    }
    if (PVector.angleBetween(simplified.get(i), simplified.get(i+1)) < 4*PI/9 && PVector.angleBetween(simplified.get(i), simplified.get(i+1)) > PI/4) {

      if (i+2 < simplified.size() && PVector.angleBetween(simplified.get(i+1), simplified.get(i+2)) < 4*PI/9 && PVector.angleBetween(simplified.get(i), simplified.get(i+2)) > PI/4) {
        //add the intersection of the lines formed by the vector i and the vector i + 2
        vertices.add(intersection(simplifiedPoints.get(i), simplifiedPoints.get(i+1), simplifiedPoints.get(i+2), simplifiedPoints.get(i+3)));
      }
    }
  }
  vertices.add(simplifiedPoints.get(simplifiedPoints.size()-1));//add the last vertex
  return vertices;
}

boolean isReflector(ArrayList<PVector> points) {
  ArrayList<PVector> vertices = findVertices(points);
  if (vertices == null) {
    return false;
  }
  if (vertices.size() != 2) {
    return false;
  }
  PVector line = new PVector(vertices.get(1).x - vertices.get(0).x, vertices.get(1).y - vertices.get(0).y);
  if (line.mag() > Reflector.maxLength) {
    return false;
  }
  return true;
}

boolean isJaggedLine(ArrayList<PVector> points) {
  ArrayList<PVector> vertices = findVertices(points);
  if (vertices == null) {
    return false;
  }
  ArrayList<PVector> edges = new ArrayList<PVector>();
  for (int i = 0; i < vertices.size()-1; i++) {
    edges.add(new PVector(vertices.get(i+1).x - vertices.get(i).x, vertices.get(i+1).y - vertices.get(i).y));
  }
  if (edges.size() < 2) {
    return false;
  }
  for (int i = 0; i < edges.size(); i++) {
    if (edges.get(i).mag() > JaggedLine.maxLength) {
      return false;
    }
    if (i > 1) {
      //if the lines make a U shape return false
      //note edges 0 - 2 will contain vertices 0 - 3
      //in terms of i point0 = i-1, point1 = i, point2 = i+1, point3 = i+2
      if (k(abc(vertices.get(i), vertices.get(i+1)), vertices.get(i-1)) > 0) {
        if (k(abc(vertices.get(i-1), vertices.get(i)), vertices.get(i-2)) > 0) {
          if (k(abc(vertices.get(i-1), vertices.get(i)), vertices.get(i+1)) > 0) {
            return false;
          }
        } else {
          if (k(abc(vertices.get(i-1), vertices.get(i)), vertices.get(i+1)) < 0) {
            return false;
          }
        }
      } else {
        if (k(abc(vertices.get(i-1), vertices.get(i)), vertices.get(i-2)) > 0) {
          if (k(abc(vertices.get(i-1), vertices.get(i)), vertices.get(i+1)) > 0) {
            return false;
          }
        } else {
          if (k(abc(vertices.get(i-1), vertices.get(i)), vertices.get(i+1)) < 0) {
            return false;
          }
        }
      }
    }
  }
  return true;
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

float k(float[] abc, PVector pos) {
  return abc[0]*pos.x + abc[1]*pos.y + abc[2];
}

Float s(float[] abc, PVector bp1, PVector bp2) {
  if (abc[0]*(bp2.x - bp1.x) + abc[1]*(bp2.y-bp1.y) != 0) { //if the lines are not parallel
    return -(abc[0]*bp1.x + abc[1]*bp1.y + abc[2])/(abc[0]*(bp2.x - bp1.x) + abc[1]*(bp2.y-bp1.y));
  }
  return null;
}

PVector intersection(PVector ap1, PVector ap2, PVector bp1, PVector bp2) {

  Float s = s(abc(bp1, bp2), ap1, ap2);
  float xi;
  float yi;
  if (s != null) {
    //x and y of intersection
    xi = (1-s)*ap1.x + s*ap2.x; 
    yi = (1-s)*ap1.y + s*ap2.y;

    //A new PVector at that intersection
    return new PVector(xi, yi);
  }
  return null;
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    rightPressed = true;
  }
  if (mouseButton == LEFT) {
    leftPressed = true;
  }
}
void mouseReleased() {

  if (mouseButton == RIGHT) {
    rightReleased = true;
  }
  if (mouseButton == LEFT) {
    leftReleased = true;
  }
}