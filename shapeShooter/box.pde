class Box {
  PVector pos;
  PVector vel;
  float speed;
  boolean dead = false;
  int w;
  int h;
  int r; //For the circle in the middle
  int flash = 0; //To make if flash white when hit
  float spawnRate;//Spawning
  float lastSpawn;

  Box() {
    w = int(random(100, 200));//Random width
    h = 10;
    r = 17;
    speed = 3;
    lastSpawn = time;
    spawnRate = random(60, 125) - map(score, 0, 3500, -15, 20);
    spawnRate = constrain(spawnRate, 25, 150);
    pos = new PVector(nW/2, -r);
    if (random(1) < .25) {
      pos.x = player.pos.x; //25% change of spawning where player is
    } else {
      pos.x = random(w/2, nW-(w/2));//Random pos
    }
    if (pos.x - (w/2) < 0) pos.x = w/2;
    if (pos.x + (w/2) > nW) pos.x = nW - (w/2);

    vel = new PVector(0, speed); //Velocity moving down
  }

  void show() {
    if (flash > 0) {
      fill(255); //Make it flash white
      flash--;
    } else {
      fill(255, 0, 0); //Normal color
    }
    noStroke();
    ellipse(pos.x, pos.y, r*2, r*2);//Draw the center circle
    rect(pos.x-(w/2), pos.y-(h/2), w, h);//Draw the rect
  }

  void update() {
    pos.add(vel.x*timeS, vel.y*timeS); //Move at speed * timeSpeed (for slo-mo)

    if (pos.y < player.pos.y && time > lastSpawn + spawnRate && random(1) < .25) {//Spawn triangles
      kamis.add(new Kami(pos.x, pos.y));
      lastSpawn = time;
    }
  }

  void remove() {
    if (pos.y >= nH+(r) || dead) {
      boxes.remove(boxes.indexOf(this)); //If its offscreen
    } else if (w <= 35) {
      float points = 250 * scoreM; //Give score when destroyed
      score += points;
      texts.push(new specialText(pos.x, pos.y, "+" + floor(points), 20));
      boxes.remove(boxes.indexOf(this));
    }
  }
}
