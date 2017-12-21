class Path {
  PVector pos;
  int w = 25;
  int type;

  Path(PVector p, int type_) {
    pos = new PVector(p.x, p.y);
    type = type_;//floor(random(2));
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y);
    int midleft = mid-(w/2);

    fill(pathCol);
    noStroke();
    // type = 0;
    switch(type) {
    case 0:
      float strokeW = w*1.5;
      rect(midleft, 0, w, 100-strokeW);
      rect(midleft, 210+strokeW, w, h-200-strokeW);
      noFill();
      strokeWeight(strokeW);
      stroke(pathCol);
      ellipse(width/2, h/2, 200, 200);
      break;
    case 1:
      rect(midleft-150,h-80,150+w,30);
      rect(midleft-150,h-143,w,93);
      rect(midleft-150,h-143,150+w,30);
      rect(midleft,h-206,w,93);
      rect(midleft+w,h-206,150,30);
      rect(midleft+w+150,h-269,w,93);
      rect(midleft+w,h-269,150,30);
      rect(midleft,h-299,w,60);
      break;
    default:
      rect(midleft, 0, w, h);
      break;
    }

    noStroke();
    rect(midleft, h-50, w, 60);
    popMatrix();
  }

  void move() {
    pos.y+=speed;
    if (pos.y >= height) {
      int top = height;
      for (Path p : paths) {
        if (p.pos.y < top) top = int(p.pos.y);
      }
      pos.y = top-h;
      type = floor(random(2));
    }
  }
}
