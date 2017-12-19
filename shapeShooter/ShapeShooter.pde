//Made in May 2017
PImage heartImg;
int flashTime = 4;
int highscore = 0;
int orginX = 0; //The newOrgin for scaling
int orginY = 0;
float scl;
int nW = 911;//The normal height, which will be scaled
int nH = 512; //The normal width, which will be scaled
int mode = 0; //0 - Startscreen, 1 - Play
float time = 0;//The ingame time
float timeS = 1;//The time Speed (for slomo)
float scoreM = 1; //Score Multiplier
float score = 0;
int fps = 35;//The desired frameRate, increase to make game more difficult
Player player;
float boxSpawn = 0;
float octoSpawn = 0;
float turretSpawn = 0;
float powerupSpawn = 0;
PImage powerupImgs[] = new PImage[7];
ArrayList<Bullet>bullets = new ArrayList<Bullet>(); //Arrays to store everything
ArrayList<Kami>kamis = new ArrayList<Kami>();
ArrayList<Box>boxes = new ArrayList<Box>();
ArrayList<Octo>octos = new ArrayList<Octo>();
ArrayList<Turret>turrets = new ArrayList<Turret>();
ArrayList<Powerup>powerups = new ArrayList<Powerup>();
texts = [];
// ArrayList<specialText>texts = new ArrayList<specialText>();

void setup() {
  heartImg = loadImage("Heart.png", "png");
  for (int i = 1; i < powerupImgs.length; i++) {
    if (i != 0 && i != 3) {
      powerupImgs[i] = loadImage("powerup0" + i + ".png", "png");
    }
  }
  // fullScreen(); //MAYBE ADD P2D, SO IT RUNS A LITTLE FASTER
  size(window.innerWidth, window.innerHeight);
  //surface.setResizable(true);
  reset(); //Resets all vars
  noCursor(); //Hides the cursor
}

void draw() {
  //rszScl(); //set the scl var
  pushMatrix();
  translate(orginX, orginY); //Translate to new orgin for scl to work
  scale(scl); //Scale
  background(255);
  fill(200);
  noStroke();
  rect(0, 0, nW, nH); //Background

  if (mode == 0) { //start
    startScreen();
  } else if (mode == 1) { //play
    play();
  } else if (mode == 2) {
    pause();
    rszScl();
  }
  popMatrix();
  if (orginX != 0 || orginY != 0) {
    removeBorder(); //Make black background that covers things when window proportions are off
  }
  pushMatrix();
  scale(scl);
  float mX = mouseX/scl;
  float mY = mouseY/scl;
  strokeWeight(3);
  stroke(255);
  int w = 20;
  int space = 5;
  line(mX-w, mY, mX-space, mY); //Crosshair
  line(mX+w, mY, mX+space, mY);
  line(mX, mY-w, mX, mY-space);
  line(mX, mY+w, mX, mY+space);
  popMatrix();
}

void heart(float x, float y, float w, float h) {
  image(heartImg, x, y, w, h); //Draw the heart
}

void keyPressed() {
  if (mode == 0 && key == ' ') {//Game over screen
    reset();
    mode = 1;//Start game
  } else if (mode == 1 || mode == 2) {//If its playing or paused
    if (keyCode == LEFT) player.left = true;//Move
    if (keyCode == RIGHT) player.right = true;
    if (key == 'p' || key == ' ') {
      if (mode == 1) {
        mode = 2;//Pause game
      } else if (mode == 2) {
        mode = 1;//Un-pause game
      }
    }
  }
}

void keyReleased() {
  if (mode == 1 || mode == 2) {
    if (keyCode == LEFT) player.left = false;  //Lets you hold down keys
    if (keyCode == RIGHT) player.right = false;
  }
}

void rszScl() {
  scl = height/float(nH);
  if (width < nW*scl) scl = width/float(nW); //Get what the scl should be

  if (width > nW) orginX = int((width/2) - (nW/2*scl));//Get where the new orgin should be
  if (height > nH) orginY = int((height/2) - (nH/2*scl));
}

void removeBorder() {
  noStroke();
  fill(0);
  rect(0, 0, orginX, height); //Draws black boxes where screen proportions are off
  rect(orginX+(nW*scl), 0, width, height);
  rect(0, 0, width, orginY);
  rect(0, orginY+(nH*scl), width, height);
}

PVector setMag(PVector v, float newMag) {
  float mag = sqrt((v.x * v.x) + (v.y * v.y));

  v.x /= mag;
  v.y /= mag;

  v.x *= newMag;
  v.y *= newMag;

  return new PVector(v.x, v.y);
}
