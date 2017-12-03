class Shape {
  PVector pos;
  PVector vel;
  PVector acc;
  int tier = 0;
  float accRate = 0.5;
  int r;
  boolean dead = false;
  float maxSpeed = 4;
  PVector searchPos; //If it doesnt have a target move randomly towards this
  int perceptionR = 30; //How far it can see

  Shape(int x, int y, int r_, int t) {
    r = r_;
    perceptionR = r*5;
    tier = t;
    maxSpeed = 3 - map(tier, 0, 6, 0, 1);
    pos = new PVector(x, y);
    searchPos = newSearchPos();
    vel = new PVector();
    acc = new PVector();
  }

  void move() {
    if (tier > 0) {
      if (this != player) {
        int recordDist = 999;
        PVector target = new PVector(pos.x, pos.y);
        boolean move = false;
        for (Shape s : shapes) {
          int dist = floor(sqrt((pos.x - s.pos.x) * (pos.x - s.pos.x) + (pos.y - s.pos.y) * (pos.y-s.pos.y)));//floor(pos.dist(s.pos));
          if (s != this && dist < perceptionR) {

            if (tier - 1 == s.tier && dist < recordDist) {
              recordDist = dist;//Move towards closest prey
              target = s.pos.get();
              move = true;
            }

            if (tier + 1 == s.tier) {
              PVector flee = PVector.sub(s.pos, pos); //The fleeing force
              flee.mult(-1); //Make it point in opposite direction
              float mag = map(dist, r, perceptionR, accRate*1.3, accRate*.1);
              // flee.setMag(mag);
              flee = setMag(flee, mag);

              acc.add(flee);
              move = true;
            }
          }
        }

        if (move) {
          acc.add(PVector.sub(target, pos));

          searchPos = newSearchPos();
        } else {
          int theDist = floor(dist(pos.x, pos.y, searchPos.x, searchPos.y));
          if (theDist < r*3 || (tier == 1 && theDist < r*5)) { //When it gets close enough, pick a new pos
            searchPos = newSearchPos();
          }
          acc.add(PVector.sub(searchPos, pos));
        }
      } else {

        float mX = (mouseX / scl);
        float mY = (mouseY / scl); //Player movement
        float x = mX - pos.x;
        float y = mY - pos.y;
        acc.set(x, y);
      }
      acc = setMag(acc, accRate);
      acc.add(boundaries());
      vel.add(acc.x*timeS, acc.y*timeS);
      float speed = (this == player) ? maxSpeed*1.4 : maxSpeed;

      float vmag = sqrt((vel.x * vel.x) + (vel.y * vel.y));

      if (vmag > speed) {
        vel = setMag(vel, speed);
      }

      pos.add(vel);
      acc.mult(0);

      pos.x = constrain(pos.x, r, nW-r);
      pos.y = constrain(pos.y, r, nH-r);

    }
  }

  void eat() {
    for (Shape s : shapes) {
      if (s != this && tier-1 == s.tier && dist(pos.x, pos.y, s.pos.x, s.pos.y) < r + s.r) {
        if (this == player) {
          score += 3 + floor(map(s.tier, 0, totals.length, 3, 15));
        } else if (s == player) {
          player = this;
        }
        s.dead = true;
      }
    }
  }

  void show() {
    strokeWeight(3);
    stroke(0);
    color c = color(255);
    if (tier+1 == player.tier)      c = color(0, 255, 0);
    else if (tier-1 == player.tier) c = color(255, 0, 0);
    else if (this == player)        c = color(0, 0, 255);
    fill(c);
    if (tier > 1) {
      polygon(pos.x, pos.y, vel.heading(), r, tier+1);
    } else {
      ellipse(pos.x, pos.y, r*2, r*2);
    }

    //fill(255);
    //textSize(r*1.5);
    //textAlign(CENTER, CENTER);
    //text(tier, pos.x, pos.y);
  }

  PVector newSearchPos() {
    PVector nextPos = new PVector(10, 0); //Start at starting location
    int mag = floor(random(perceptionR*0.2, perceptionR*0.8));
    float rotAngle =  random(TWO_PI);
    nextPos.rotate(rotAngle);
    nextPos.setMag(mag);

    nextPos.add(pos);//Make it relative to current pos
    nextPos.x = constrain(nextPos.x, r+border, nW-(r+border));
    nextPos.y = constrain(nextPos.y, r+border, nH-(r+border));

    return nextPos;
  }

  PVector boundaries() {
    int left = r;
    int right = nW - r;
    int top = r;
    int bottom = nH - r;
    float maxMag = maxSpeed * 0.3;
    float minMag = maxSpeed * 0.005;
    PVector boundary = new PVector(0, 0);

    if (pos.x < border + r) boundary.x += map(pos.x, r, left + border, maxMag, minMag);
    if (pos.x > right - border) boundary.x -= map(pos.x, right, right + border, maxMag, minMag);

    if (pos.y < border + r) boundary.y += map(pos.y, r, top + border, maxMag, minMag);
    if (pos.y > bottom - border) boundary.y -= map(pos.y, bottom, bottom - border, maxMag, minMag);

    return boundary;
  }
}
void polygon(float x, float y, float rot, int r, int sides) {
  pushMatrix();
  float angle = TWO_PI / sides;//Draw a polygon with "sides" sides
  translate(x, y);
  rotate(rot);
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = cos(a) * r;
    float sy = sin(a) * r;
    vertex(sx, sy);
  }
  endShape(CLOSE);
  popMatrix();
}

PVector setMag(PVector v, float newMag) {
  float mag = sqrt((v.x * v.x) + (v.y * v.y));

  v.x /= mag;
  v.y /= mag;

  v.x *= newMag;
  v.y *= newMag;

  return new PVector(v.x, v.y);
}
