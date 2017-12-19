void play() {
  timeS = 1;//Default
  scoreM = 1;//Default
  if (player.power == 2 && player.powerTime > 0) timeS = 0.25;//If player has slomo, make it half speed
  if (player.power == 6 && player.powerTime > 0) scoreM = 2; //If player has doublepoints, set scoreM to 2
  timeS = timeS/(frameRate/fps);//Calculate a certain speed, so the difficulty is the same on all different FPS
  int buSize = bullets.size();
  int boSize = boxes.size();
  int kSize = kamis.size();
  int oSize = octos.size();//caching size of arrayLists for further use
  int tSize = turrets.size();
  int pSize = powerups.size();
  fill(0);
  textSize(25);
  textAlign(LEFT);
  String scoreTxt = "Score: " + floor(score);
  if (player.powerTime > 0) scoreTxt += "\nPowerup: " + floor(player.powerTime);
  text(scoreTxt, 10, 30);//Display score
  displayHearts();
  time+=timeS;//Increase time
  score+=0.05*timeS;//Increase score
  if (timeS == 1) time = floor(time);
  if (time > boxSpawn+50 && abs(time - turretSpawn) >= 25) {
    boxes.add(new Box()); //Spawn box every 50 time and it is 25 time away from the last turretSpawned
    boxSpawn = time;
  } else if (score >= 1000 && time > octoSpawn+60) {
    octos.add(new Octo()); //Spawn octo every 60 time if score >= 1K
    octoSpawn = time;
  } else if (score >= 2000 &&  time > turretSpawn+95 && abs(time - boxSpawn) >= 25) {
    //Spawn turret every 95 time, if score >= 2K && it is 25 time away from the last boxSpawned
    turrets.add(new Turret());
    turretSpawn = time;
  }
  if (time >= powerupSpawn+200 && random(1) < .225) {
    powerups.add(new Powerup());
    powerupSpawn = time;
  }

  for (int i = pSize-1; i >= 0; i--) {
    Powerup p = powerups.get(i);
    p.show();//Update powerups
    p.update();
  }

  for (int i = kSize-1; i >= 0; i--) {
    Kami k = kamis.get(i);
    k.show();//Update kamis
    k.move();
  }

  for (int i = oSize-1; i >= 0; i--) {
    Octo o = octos.get(i);
    o.show();//Update octos
    o.update();
  }

  for (int i = buSize-1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.show();
    b.move();//Update bullets
    b.hit();
  }

  for (int i = tSize-1; i >= 0; i--) {
    Turret t = turrets.get(i);
    t.aim();
    t.show();//Update turrets
    t.update();
  }

  for (int i = boSize-1; i >= 0; i--) {
    Box b = boxes.get(i);
    b.show();//Update boxes
    b.update();
  }
  player.powerUp();
  player.move();//Update player
  player.show();
  // console.log(texts.size());
  for (int i = texts.length-1; i >= 0; i--) {
    texts[i].show();//Update special text
    if (texts[i].life < 0) texts.splice(i, 1);//Remove it
  }

  if (player.hit()) {
    player.flash+=flashTime;
    player.lives--;//If players hit, subtract life
  }

  int max = boSize;
  if (buSize > max) max = buSize;
  if (kSize > max) max = kSize;
  if (oSize > max) max = oSize;//Find the biggest arrayList
  if (tSize > max) max = tSize;
  if (pSize > max) max = pSize;
  for (int i = max-1; i >= 0; i--) {
    if (i < buSize)  bullets.get(i).remove();
    if (i < boSize)  boxes.get(i).remove();
    if (i < kSize)   kamis.get(i).remove();
    if (i < oSize)   octos.get(i).remove();//If it exists, remove it
    if (i < tSize)   turrets.get(i).remove();
    if (i < pSize)   powerups.get(i).remove();
  }

  if (player.lives <= 0) {
    if (score > highscore) highscore = int(score);
    mode = 0;//If you lose
  }
}

void startScreen() {
  rszScl();

  displayGame();//Display everything

  textSize(35);
  textAlign(CENTER);
  fill(0);
  float tW = textWidth("Shape Shooter");
  text("Shape Shooter", nW/2, 50);
  textSize(18);
  textLeading(19);
  String txtD = "Avoid the army of attacking shapes!\nDestroy them to gain points!\nCollect powerups to help you!\nMove - arrow keys\nShoot - click";
  text(txtD, nW/2, 80);
  String txt = "Press SPACE to start\nPresss P or SPACE to pause\nPress ESC to quit";//Default text to display
  if (highscore > 0) txt += "\n\nHighscore: " + highscore;//if you just played, show your highscore too
  text(txt, nW/2, 180);
  textSize(15);
  textAlign(LEFT);
  text("By: Leo Gagnon", (nW/2)+(tW/2)+5, 50);
}

void displayGame() {
  String txt = "";
  if (score > 0) txt += "Score: " + floor(score);
  if (player.powerTime > 0) txt += "\nPowerup: " + floor(player.powerTime);
  textSize(25);
  textAlign(LEFT);
  fill(0);
  text(txt, 10, 30);
  for (int i = bullets.size()-1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.show();
  }
  if (score > 0) {
    player.show();
  }
  for (int i = kamis.size()-1; i >= 0; i--) {
    Kami k = kamis.get(i);
    k.show();
  }

  for (int i = turrets.size()-1; i >= 0; i--) {
    Turret t = turrets.get(i);
    t.show();
  }

  for (int i = boxes.size()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    b.show();
  }
  for (int i = octos.size()-1; i >= 0; i--) {
    Octo o = octos.get(i);
    o.show();
  }
  for (int i = powerups.size()-1; i >= 0; i--) {
    Powerup p = powerups.get(i);
    p.show();
  }

  for (int i = texts.length-1; i >= 0; i--) {
    texts[i].show();
    if (texts[i].life < 0) texts.splice(i, 1);
  }
}

void pause() {
  displayHearts();
  displayGame();
  textAlign(CENTER, CENTER);
  textSize(50);
  fill(0);
  text("PAUSED", nW*.5, nH*.5);
}

void reset() {
  bullets = new ArrayList<Bullet>();
  kamis = new ArrayList<Kami>();
  boxes = new ArrayList<Box>();
  octos = new ArrayList<Octo>();//Reset all variables
  turrets = new ArrayList<Turret>();
  powerups = new ArrayList<Powerup>();
  player = new Player();
  boxSpawn = 0;
  octoSpawn = 0;
  turretSpawn = 0;
  powerupSpawn = 0;
  time = 0;
  score = 0;
  timeS = 1;
  scoreM = 1;
  rszScl();
}

void displayHearts() {
  pushMatrix();
  scale(1/scl);//Un-scale
  for (int i = 0; i < player.lives; i++) {
    heart((10+(i*45))*scl, (nH-50)*scl, 40*scl, 40*scl); //Draw hearts with their own scale
  }
  popMatrix();
}
