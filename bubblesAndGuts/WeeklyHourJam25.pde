//Made for the WeeklyHourJam25 2017 in June (https://itch.io/jam/weekly-hour-game-jam---w25-2017)
ArrayList<Shape> shapes = new ArrayList<Shape>();
Shape player = null;
int border = 100; //The border, so Shapes dont get to close or stuck in edges
float scl = 1;
int nW = 1536;//The normal height, which will be scaled
int nH = 864; //The normal width, which will be scaled
int totals[] = new int[6];
int score = 0; //The players score
int highscore = 0;
int fps = 60;
float timeS = 1;
int time = 90 * 60; //The time in seconds (although it changes based on frameRate)
PFont font;
int mode = 0;
boolean showStart = true;

void setup() {
  size(1536, 864); //1536, 864
  // fullScreen();
  // surface.setResizable(true);
  rszScl();
  // font = loadFont("Roboto-Medium-48.vlw");
  // textFont(font);
  imageMode(CENTER);
  background(255);
}

void draw() {
  if (pmouseX != mouseX) { //If the mosuewas moved
    mouseX = mouseX * 2; //Half value because of scaled canvas
  }
  if (pmouseY != mouseY) { //If the mosuewas moved
    mouseY = mouseY * 2; //Half value because of scaled canvas
  }

  PVector v = new PVector(999, 888);
  // console.log(v + "    before");
  // v = setMag(v, 10);
  // console.log(v + "    after");



  timeS = 1.5;
  timeS = timeS / (frameRate/fps);
  pushMatrix();//Translate to new orgin for scl to work
  scale(scl); //Scale
  //mouseX/=scl;
  //mouseY/=scl;

  if (mode == 0 && showStart) {
    fill(255);
    stroke(255, 0, 0);
    strokeWeight(2);
    rect(-3, -3, (nW*scl)+6, (nH*scl)+6); //Background
    fill(0, 0, 255);
    textSize(50);
    textAlign(CENTER);
    text("Bubbles and Guts", nW/2, 150);
    textSize(25);
    text(
      "You are the blue shape, eat green shapes to gain points\nYou become whatever eats you\nThe more sides on a shape, the higher the tier, and the more points when eaten\nGet as many points as you can, within 90 seconds\n\nPress 'K' to end the round early"
      , nW/2, 190);
    fill(255, 0, 0);
    textSize(30);
    String txt = "Click to play!";
    if (highscore > 0) txt += "\nHighscore: " + highscore;
    text(txt, nW/2, 400);
    showStart = false;
  } else if (mode == 1) {
    background(0);
    // fill(255);
    // stroke(255, 255, 0);
    // strokeWeight(2);
    // rect(-3, -3, (nW*scl)+6, (nH*scl)+6); //Background
    play();
  }

  popMatrix();
  noFill();
  stroke(255, 0, 0);
  strokeWeight(2);
  rect(-3, -3, (nW*scl)+6, (nH*scl)+6); //Background
}

void rszScl() {
  // scl = height/float(nH);
  scl = float(nH) / height;
  if (width < nW*scl) scl = float(nW) / width;//scl = width/float(nW); //Get what the scl should be
  console.log(scl);
}
