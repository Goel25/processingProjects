color deathCol = color(255, 0, 0);
color pathCol = color(127);
float speed = 1.5;
ArrayList<Path> paths;
int mid;
float score = 0;
float highscore = 0;
int h = 300;
boolean dead = true;

void setup() {
  size(600, 800);
  reset();
  mid = width/2;
}

void draw() {
  background(deathCol);
  if (!dead) {
    fill(0);
    textSize(20);
    textAlign(LEFT);
    //println(floor(1.051*1000)/1000);
    text("Score: " + floor(score*100)/100, 10, 20);
    score+=0.01;
    //if (score > 5) speed = 2;
    for (Path p : paths) {
      p.move();
      p.show();
    }

    if (get(mouseX, mouseY) == deathCol) {
      if (score > highscore) highscore = score;
      dead = true;
    }
  } else {
    for (Path p : paths) {
      p.show();
    }
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(35);
    String txt = "Stay on the grey path\nClick to start";
    if (highscore > 0) {
      txt += "\nHighscore: " + floor(highscore*100)/100;
      txt += "\nScore: " + floor(score*100)/100;
    }
    text(txt, width/2, height/2);
  }
}

void reset() {
  paths = new ArrayList<Path>();
  for (int i = 0; i < 4; i++) {
    paths.add(new Path(new PVector(0, h*i), -1));
  }
  speed = 1;
  score = 0;
}

void mousePressed() {
  if (dead && get(mouseX, mouseY) == pathCol) {
    dead = false;
    reset();
  }
}