class DebugLine {
  ArrayList<PVector> points;
  DebugLine(ArrayList<PVector> points) {
    this.points = points;
  }
  
  void draw(){
    for(int i = 0; i < points.size()-1; i++){
      line(points.get(i).x, points.get(i).y, points.get(i+1).x, points.get(i+1).y);
    }
  }
}