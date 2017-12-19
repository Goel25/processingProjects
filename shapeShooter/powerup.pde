class Powerup {
  PVector pos;
  float r;
  boolean dead = false;
  int health;
  int type;
  int flash;
  /*
   1: Autofire, 2: Slo-mo, 3: Extra life
   4: Clear screen, 5: Triple shot, 6: Double points*/
  Powerup() {
    type = floor(random(1, 7));
    r = random(22, 25);
    health = 3;
    pos = new PVector(random(r, nW-r), nH/1.75);
  }

  void show() {
    if (flash > 0) {
      fill(255);
      flash--;
    } else {
      fill(0, 0, 255);
    }
    ellipse(pos.x, pos.y, r*2, r*2);
    pushMatrix();
    scale(1/scl);//Un-scale
    imageMode(CENTER);
    if (type != 3) {
      image(powerupImgs[type], pos.x*scl, pos.y*scl, r*1.5*scl, r*1.5*scl); //Draw hearts with their own scale
    } else {
      image(heartImg, pos.x*scl, pos.y*scl, r*1.5*scl, r*1.5*scl);
    }
    popMatrix();
    imageMode(CORNER);
  }

  void update() {
    r-=0.03 * timeS;//Shrink
    if (r < 1) {
      dead = true;
    }
  }

  void remove() {
    if (health <= 0) {
      if (type != 3 && type != 4) {
        player.power = type;//Give player a powerup
        player.powerTime = floor(random(250, 300));//Lasts a random amount of time
      } else {
        if (type == 3) player.lives++;//Extra-life
        if (type == 4) clearScreen();//Clear screen
      }
    }
    if (dead || health <= 0) powerups.remove(powerups.indexOf(this));//Remove it
  }
}

void clearScreen() {
  int buSize = bullets.size();
  int boSize = boxes.size();
  int kSize = kamis.size();
  int oSize = octos.size();
  int tSize = turrets.size();//Kill everything on screen and give player points for it
  int max = boSize;
  if (oSize > max) max = oSize;
  if (tSize > max) max = tSize;
  if (buSize > max) max = buSize;
  for (int i = max-1; i >= 0; i--) {
    if (i < boSize)  boxes.get(i).w = 0;
    if (i < buSize && bullets.get(i).parent == 1) bullets.get(i).dead = true;
    if (i < oSize)   octos.get(i).r = 0;
    if (i < tSize)   turrets.get(i).health = 0;
  }

  for (int i = kSize-1; i >= 0; i--) {
    Kami k = kamis.get(i);
    k.flash+=flashTime;
    kamis.get(i).dead = true;
    float points = 100 * scoreM;//Kill all kamis
    score += points;
    texts.push(new specialText(kamis.get(i).pos.x, kamis.get(i).pos.y, "+" + floor(points), 15));
  }
}
