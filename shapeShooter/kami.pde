class Kami {
  PVector pos;
  PVector vel;
  PVector acc;
  float speed = 3.4;
  float maxForce = 0.4;
  int flash = 0;
  float h = 25;
  float w = 20;
  boolean dead = false;

  Kami(float x_, float y_) {
    pos = new PVector(x_, y_);
    vel = new PVector();
    acc = new PVector();
  }

  void move() {
    acc.set(player.pos.x, player.pos.y);
    acc.sub(pos);
    if (acc.mag() > maxForce) {
      acc = setMag(acc, maxForce); //acc.limit(maxForce);  //Move towards player
    }
    vel.add(acc);
    vel = setMag(vel, speed); //vel.setMag(speed);

    pos.add(vel.x*timeS, vel.y*timeS);
    acc.mult(0);
    if (pos.y > nH) {
      dead = true;//If its to far below screen
    }
  }

  void remove() {
    if (dead) kamis.remove(kamis.indexOf(this));
  }

  void die() {
    flash+=flashTime;
    dead = true;
    float points = 100 * scoreM; //Give points
    score += points;
    texts.push(new specialText(pos.x, pos.y, "+" + floor(points), 15));
    dead = true;//"+100" text ^^
  }

  void show() {
    float x1 = 0;
    float y1 = -(h/2);
    float x2 = -(w/2);
    float y2 = (h/2);
    float x3 = (w/2);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.heading()+PI/2); //Draw a triangle rotated with vel direction
    beginShape();
    if (flash > 0) {
      fill(255);
      flash--;
    } else {
      fill(255, 0, 0);
    }
    stroke(0);
    strokeWeight(3);
    vertex(x1, y1);
    vertex(x2, y2);
    vertex(x3, y2);
    endShape(CLOSE);
    popMatrix();
  }
}
