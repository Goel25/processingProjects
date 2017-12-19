class Player {
  PVector pos;
  PVector vel;
  PVector aim; //Where the tip of the barrel is
  float speed = 3.5;
  int w = 23;
  int h = 23;
  float len = 25;
  int lives;
  int flash = 0; //For the flashing white animation
  int power = 0;
  float lastShot = 0;//So you can only fire every frame
  float powerTime = 0; //How much longer until the powerup runs out
  boolean left = false;//If player is moving left (left arrow key)
  boolean right = false;//If player is moving right (right arrow key)

  Player() {
    lives = 3;
    pos = new PVector(nW/2-(w/2), (nH-h)-15);
    vel = new PVector(0, 0);
    aim = new PVector(0, len);
  }

  void powerUp() {
    if (power > 0 && powerTime > 0) {
      if (power == 1) {//Autofire
        if (time >= lastShot + 3) {
          shoot(0);
          lastShot = time;
        }
        powerTime-=1;
      } else if (power == 2) {//Slo-mo
        powerTime-=3*timeS;
      } else if (power == 5) { //Triple shot
        powerTime--;
      } else if (power == 6) { //Double points
        scoreM = 2;
        powerTime-=0.5;
      }
    }
    if (powerTime <= 0) {
      power = 0;
      powerTime = 0;//If player doesnt have a powerup, reset powerups
      timeS = 1;
      scoreM = 1;
    }
  }

  void move() {
    if (left) vel.x--;
    if (right) vel.x++;
    vel.setMag(speed);
    pos.add(vel.x*timeS, vel.y*timeS);
    if (pos.x < w/2) pos.x = w/2;
    if (pos.x > nW-(w/2)) pos.x = nW-(w/2);
    vel.mult(0);
  }

  void show() {
    noStroke();
    color strokeC; //Color of barrel
    if (flash > 0) {
      fill(255);
      strokeC = color(255);//Make player and barrel flash
      flash--;
    } else {
      fill(0, 0, 255);
      strokeC = color(0, 0, 255);
    }
    rect(pos.x-(w/2), pos.y-(w/2), w, w);
    stroke(strokeC);
    strokeWeight(5);
    if (mode == 1) {
      PVector mouse = new PVector(mouseX-orginX, mouseY-orginY);
      mouse.div(scl);
      mouse.sub(pos);
      mouse = setMag(mouse, len);
      // mouse.setMag(len);
      aim = new PVector(mouse.x, mouse.y);//mouse.copy();//Make barrel aim towards mouse
    }
    line(pos.x, pos.y, aim.x+pos.x, aim.y+pos.y);
    if (power != 0) {
      pushMatrix();
      scale(1/scl);//Un-scale
      imageMode(CENTER);
      //tint(255,powerTime); //Makes image more transparent
      float size = map(powerTime, 300, 0, 1, .025);
      if (power != 3) {
        image(powerupImgs[power], pos.x*scl, pos.y*scl, w*scl*size, w*scl*size);
      } else {
        image(heartImg, pos.x*scl, pos.y*scl, w*scl*size, w*scl*size);
      }
      popMatrix();
      //tint(255);//Undos transparency, so other images arent
      imageMode(CORNER);
    }
  }

  boolean hit() {
    // for (Kami k : kamis) {
    for (int i = 0; i < kamis.size(); i++) {
      Kami k = kamis.get(i);
      PVector kPos = new PVector(k.pos.x + k.vel.x, k.pos.y + k.vel.y);
      if  (pos.x + w/2 > kPos.x - k.w/2 && pos.x - w/2 < kPos.x + k.w/2) {
        if (pos.y + h/2 > kPos.y - k.h/2 && pos.y - h/2 < kPos.y + k.h/2) {
          k.dead = true; //If kami has crashed into player
          return true;
        }
      }
    }

    for (Box b : boxes) {
      if (circleRect(b.pos.x, b.pos.y, b.r, pos.x, pos.y, w, h)) {
        b.dead = true;//If boxes inner circle hit player
        return true;
      } else {
        if  (pos.x + w/2 > b.pos.x - b.w/2 && pos.x - w/2 < b.pos.x + b.w/2) {
          if (pos.y + h/2 > b.pos.y - b.h/2 && pos.y - h/2 < b.pos.y + b.h/2) {
            b.dead = true;//If boxes rect hit player
            return true;
          }
        }
      }
    }

    for (Octo o : octos) {
      if (circleRect(o.pos.x, o.pos.y, o.r, pos.x, pos.y, w, h)) {
        o.dead = true;//If octo has hit player
        return true;
      }
    }

    for (Bullet b : bullets) {
      if (b.parent == 1 && circleRect(b.pos.x, b.pos.y, b.r, pos.x, pos.y, w, h)) {
        b.dead = true;//If a turrets bullet has hit player
        return true;
      }
    }

    for (Turret t : turrets) {
      if  (pos.x + w/2 > t.pos.x - t.w/2 && pos.x - w/2 < t.pos.x + t.w/2) {
        if (pos.y + h/2 > t.pos.y - t.h/2 && pos.y - h/2 < t.pos.y + t.h/2) {
          t.dead = true; //If turret hit player
          return true;
        }
      }
    }
    return false;
  }
}

void mousePressed() {
  if (mode == 1 && mouseButton == LEFT) {
    if (time >= player.lastShot+1) {
      shoot(0, null, null);//Single-shot
      player.lastShot = time;//Shooting cooldown
    }
    if (player.power == 5 && player.powerTime > 0) {//Triple shot
      float tx = (mouseX-orginX)/scl;
      float ty = (mouseY-orginY)/scl;
      PVector target = new PVector(tx, ty);
      target.sub(player.pos);
      target.setMag(player.len*2);
      PVector left = new PVector(target.x, target.y); //target.copy();
      left.rotate(0.1);
      shoot(1, left.x+player.pos.x, left.y+player.pos.y);
      PVector right = new PVector(target.x, target.y); //target.copy();
      right.rotate(-0.1);
      shoot(1, right.x+player.pos.x, right.y+player.pos.y);
    }
  }
}
//int type, float x_, float y_, int p_, float tx_, float ty_, float r_, float speed_  <---- Bullet constructor

void shoot(int type, float tx, float ty) {
  if (type == 0) {
    float tx = (mouseX-orginX)/scl;
    float ty = (mouseY-orginY)/scl;//Shoots at mouse
    PVector mouse = new PVector(mouseX-orginX, mouseY-orginY);
    mouse.div(scl);
    mouse.sub(player.pos);
    // mouse.setMag(player.len);
    mouse = setMag(mouse, player.len);
    bullets.add(new Bullet(0, player.pos.x+mouse.x, player.pos.y+mouse.y, 0, tx, ty, null, null));
  } else {
    PVector mouse = new PVector(mouseX-orginX, mouseY-orginY);
    mouse.div(scl);
    mouse.sub(player.pos);//Shoot towards target x and target y
    // mouse.setMag(player.len);
    mouse = setMag(mouse, player.len);
    bullets.add(new Bullet(0, player.pos.x+mouse.x, player.pos.y+mouse.y, 0, tx, ty, null, null));
  }
}

//MAKE shoot into one function because JS doesn't support same name, diff arg functions
/*
void shoot() {
  float tx = (mouseX-orginX)/scl;
  float ty = (mouseY-orginY)/scl;//Shoots at mouse
  PVector mouse = new PVector(mouseX-orginX, mouseY-orginY);
  mouse.div(scl);
  mouse.sub(player.pos);
  // mouse.setMag(player.len);
  // mouse = setMag(mouse, player.len);
  console.log(":(");
  bullets.add(new Bullet(0, player.pos.x+mouse.x, player.pos.y+mouse.y, 0, tx, ty, null, null));
}

void shoot(float tx, float ty) {
  PVector mouse = new PVector(mouseX-orginX, mouseY-orginY);
  mouse.div(scl);
  console.log("1231241234");
  mouse.sub(player.pos);//Shoot towards target x and target y
  // mouse.setMag(player.len);
  mouse = setMag(mouse, player.len);
  bullets.add(new Bullet(0, player.pos.x+mouse.x, player.pos.y+mouse.y, 0, tx, ty, null, null));
}*/
