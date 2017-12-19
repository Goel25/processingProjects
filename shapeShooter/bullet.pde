class Bullet {
  PVector pos;
  PVector vel;
  float speed = 6;
  float r = 2.5;
  int parent; //If it is from player or turret
  boolean dead = false;

  /*Bullet(float x_, float y_, float tx_, float ty_, int p_) {
  // console.log("HERERERERERER!");
    parent = p_;
    pos = new PVector(x_, y_);
    vel = new PVector(tx_, ty_); //Takes a starting pos, and a target pos
    vel.sub(pos);
    // vel.setMag(speed);
    vel = setMag(vel, speed);
  }

  Bullet(float x_, float y_, float r_, int p_, float speed_) {
    parent = p_;
    speed = speed_;
    pos = new PVector(x_, y_);
    vel = new PVector(speed * cos(r_), speed * sin(r_);); //Takes a starting pos and an angle
    // vel.x = speed * cos(r_);
    // vel.y = speed * sin(r_);


    console.log(speed);
  }*/

  Bullet(int type, float x_, float y_, int p_, float tx_, float ty_, float r_, float speed_) {
    if (type == 0) { //First constructor
      parent = p_;//TODO Get bullets to move
      pos = new PVector(x_, y_);
      vel = new PVector(tx_, ty_); //Takes a starting pos, and a target pos
      vel.sub(pos);
      vel.setMag(speed);
      vel = setMag(vel, speed);
    } else {//Second constructor
      parent = p_;
      speed = speed_;
      pos = new PVector(x_, y_);
      vel = new PVector(speed * cos(r_), speed * sin(r_)); //Takes a starting pos and an angle
      // vel.x = speed * cos(r_);
      // vel.y = speed * sin(r_); //TODO MAKE IT JUST ONE CONSTRUCTOR, BECAUSE JS ONLY ALLOWS ONE!!!

    }
  }

  void show() {
    noStroke();
    if (parent == 0) {
      fill(51); //Players bullet is grey
    } else {
      fill(255, 0, 0);//Turrets bullet is red
    }
    ellipse(pos.x, pos.y, r*2, r*2);
  }

  void move() {
    // console.log(vel.x + "    " + vel.y);
    pos.add(vel.x*timeS, vel.y*timeS); //Move * slomo
    if (pos.x < 0 || pos.x > nW || pos.y < 0 || pos.y > nH) {
      dead = true; //If its offscreen
    }
  }

  void remove() {
    if (dead) bullets.remove(bullets.indexOf(this));//Remove it
  }

  void hit() {
    if (parent == 0) {
      for (int i = kamis.size()-1; i >= 0; i--) {
        Kami k = kamis.get(i); //If it is close enough to tip of a Kami, its colliding
        if (dist(pos.x, pos.y, k.pos.x, k.pos.y) < r+ ((k.h+k.w)/2)) {
          k.die();
          break;
        }
      }

      for (int i = octos.size()-1; i >= 0; i--) {
        Octo o = octos.get(i);
        if (dist(pos.x, pos.y, o.pos.x, o.pos.y) < r+o.r) {
          o.flash+=flashTime; //Colliding with octo
          octos.get(i).r-=3;
          dead = true;
          break;
        }
      }

      for (int i = powerups.size()-1; i >= 0; i--) {
        Powerup p = powerups.get(i);
        if (dist(pos.x, pos.y, p.pos.x, p.pos.y) < r + p.r) {
          p.flash+=flashTime;
          p.health--;//Colliding with powerup
          dead = true;
          break;
        }
      }

      for (Turret t : turrets) {
        if (circleRect(pos.x, pos.y, r, t.pos.x, t.pos.y, t.w, t.h)) {
          t.flash+=flashTime;
          t.health--; //Colliding with turret
          dead = true;
          break;
        }
      }

      for (Box b : boxes) {
        if (pos.dist(b.pos) < r + b.r) {
          b.flash+=flashTime;
          b.w -= 12;
          dead = true;
          break; //Colliding with boxes middle circle, gives extra points
        } else {
          float nX = b.pos.x - (b.w/2);
          float nY = b.pos.y - (b.h/2);
          if (pos.x + r > nX && pos.y + r > nY) {
            if (pos.x - r < nX + b.w && pos.y - r < nY + b.h) {
              b.flash+=flashTime;
              b.w -= 7;//Colliding with boxes box, gives less points
              dead = true;
              break;
            }
          }
        }
      }
    }
  }
}
