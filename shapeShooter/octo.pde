class Octo {
  PVector pos;
  PVector vel;
  float speed;
  int r;
  boolean dead = false;
  int flash = 0;
  float rot = 0;
  float rotS; //Rotation speed
  color col;

  Octo() {
    speed = random(5, 8);
    rotS = random(-0.05,0.05);
    r = int(random(25, 40));
    col = color(random(75, 150));//Random greyscale color
    pos = new PVector(nW/2, -r);
    pos.x = random(r, nW-r);
    if (random(1) < .5) pos.x = player.pos.x; //50% chance of spawning on player
    if (pos.x - r < 0) pos.x = r;
    if (pos.x + r > nW) pos.x = nW - r;
    vel = new PVector(0, speed);
  }

  void update() {
    pos.add(vel.x*timeS, vel.y*timeS);
    rot+=rotS*timeS;//Increment rotation
  }

  void remove() {
    if (r <= 10) {//If player destroyed it
      float points = 500 * scoreM;
      score+=points;
      texts.push(new specialText(pos.x, pos.y, "+" + floor(points), 25));
      octos.remove(octos.indexOf(this));
    } else if (pos.y > nH+r || dead) { //If offscreen
      octos.remove(octos.indexOf(this));
    }
  }

  void show() {
    if (flash > 0) {
      fill(255); //Make it flash when hit
      flash--;
    } else {
      fill(col);
    }
    noStroke();
    pushMatrix();
    float angle = TWO_PI / 8;
    translate(pos.x,pos.y);
    rotate(rot);
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = cos(a) * r;
      float sy = sin(a) * r;//Draw an octogon that is rotating
      vertex(sx, sy);
    }
    endShape(CLOSE);
    popMatrix();
  }
}
//Circle to Rect collision (Octo-player) and (bullet to box and turret) and (turret bullet - player)
boolean circleRect(float cx, float cy, float radius, float rx, float ry, float rw, float rh) {
  // temporary variables to set edges for testing
  float testX = cx;
  float testY = cy;
  //rx-=rw/2;
  //ry-=rh/2;
  // which edge is closest?
  if (cx < rx-(rw/2))         testX = rx-(rw/2);     // test left edge
  else if (cx > rx+(rw/2)) testX = rx+(rw/2);       // right edge
  if (cy < ry - (rh/2))         testY = ry-(rh/2);  // top edge
  else if (cy > ry+(rh/2)) testY = ry+(rh/2);       // bottom edge
  // get distance from closest edges
  float distX = cx-testX;
  float distY = cy-testY;
  float distance = sqrt((distX*distX) + (distY*distY));
  // if the distance is less than the radius, collision!
  if (distance <= radius) {
    return true;
  }
  return false;
}
