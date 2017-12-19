class Turret {
  PVector pos;
  PVector vel;
  int w;
  int h;
  int speed;
  boolean dead = false;
  int len;//Barrel length
  float health = 5;
  int lastShot;
  int flash = 0;//Make it flash white
  float rot;//The angle of the barrel
  float rotS;//maxSpeed that the barrel can turn

  Turret() {
    w = 32;
    h = 32;
    speed = 3;
    rot = PI/2;//Start facing down
    rotS = 0.01;
    lastShot = floor(time);
    len = 30;
    pos = new PVector(nW/2, -(len+(h/2)));
    pos.x = random(w/2, nW-(w/2));
    vel = new PVector(0, speed);
  }

  void update() {
    pos.add(vel.x*timeS, vel.y*timeS);
    if (time >= lastShot + 65 && pos.y < (player.pos.y-(player.h/2))-50) {
      float newX = float(len) * cos(rot);//Shoot at direction its facing
      float newY = float(len) * sin(rot);
      // bullets.add(new Bullet(pos.x+newX, pos.y+newY, rot, 1, 4.0));
      //int type, float x_, float y_, int p_, float tx_, float ty_, float r_, float speed_
      bullets.add(new Bullet(1, pos.x + newX, pos.y + newY, 1, null, null, rot, 4.0));
      lastShot = floor(time);
    }
  }

  void remove() {
    if (health <= 0) {
      float points = 750 * scoreM;
      score+=points;//When player killed it
      texts.push(new specialText(pos.x, pos.y, "+" + floor(points), 28));
      turrets.remove(turrets.indexOf(this));
    } else if (pos.y > nH+(h/2) || dead) {
      turrets.remove(turrets.indexOf(this));//Remove it
    }
  }

  void aim() {
    float desired = atan2(player.pos.y-pos.y, player.pos.x-pos.x);
    if (abs(desired-rot) <= rotS*timeS) {
      rot = desired;//So it doesnt shake (if desired it 0.05,then it goes to 0.1,then back to 0)
    } else if (desired > rot) {
      rot += rotS*timeS;//Move towards desired
    } else {
      rot -= rotS*timeS;//Move towards desired
    }
    rot+= random(-0.01, 0.01)*timeS;//Make it slightly innacurate
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(255, 0, 0);
    color strokeC = color(255, 0, 0);//Barrel color
    if (flash > 0) {
      fill(255);
      strokeC = color(255);
      flash--;//Flash white
    } else {
      fill(255, 0, 0);
    }
    noStroke();
    rect(-w/2, -h/2, w, h);

    rotate(rot);
    strokeWeight(7);
    stroke(strokeC);
    line(0, 0, len, 0);//Draw barrel
    popMatrix();
  }
}
