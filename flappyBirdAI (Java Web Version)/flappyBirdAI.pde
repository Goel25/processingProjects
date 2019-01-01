GeneticAlgorithm ga;
Pipe[] pipes;

PImage birdImg;
PImage pipeImg;
PImage pipeFlippedImg;
boolean useImgs = true;

int pipeWidth = 30;
int pipeGap = 100;
float gravity = .1;
float pipeSpeed = 3;
final float originalPipeSpeed = 3;
final float speedUpBy = .000;
int spacing = 300;

final int flapEvery = 3;
final int amtInputs = 5;
final int amtHidden = 4;
final int amtOutputs = 2;
final int startX = 50;
final int startY = 250;
final int popSize = 350;
int time = 0;
int gameScore = 0;

boolean show1Bird = false;
boolean shownBird = false;
boolean showDebug = false;

int allTimeBestScore = 0;
Bird allTimeBestBird;//TODO FIX THE DEBUG OF BEST BIRD EVER, AND MAKE ONE TO SHOW BEST SCORE EVER

int birdsAlive = popSize;

int gameSpeed = 1;

final int cWidth = 900;
final int cHeight = 500;

void setup() {
  birdImg = loadImage("bird.png");
  pipeImg = loadImage("pipe.png");
  pipeFlippedImg = loadImage("pipeFlipped.png");
  //size(800, 500);
  fullScreen();
  Bird[] population = new Bird[popSize];
  for (int i = 0; i < population.length; i++) {
    population[i] = new Bird(startX, startY);
  }
  ga = new GeneticAlgorithm(population, 0.002);

  ArrayList<Pipe> pipes_ = new ArrayList<Pipe>();

  for (int x = 0; x < cWidth; x+= spacing) {
    pipes_.add(new Pipe(x + cWidth, pipeWidth));
  }
  pipes = new Pipe[pipes_.size()];
  for (int i = 0; i < pipes_.size(); i++) {
    pipes[i] = pipes_.get(i);
  }


  //int pipeIndex = 0;
  ////pipes = new Pipe[(int) ceil(cWidth/spacing)];
  //pipes = new Pipe[5];

  ////for (int x = 0; x < cWidth; x+=spacing) {
  ////  pipes[x/spacing] = new Pipe(x, pipeWidth);
  ////  pipeIndex++;
  ////}


  //for (int i = 0; i < pipes.length; i++) {
  //  pipes[i] = new Pipe(cWidth+(i*spacing), pipeWidth);
  //}
}

void draw() {
  for (int j = 0; j < gameSpeed; j++) {
    pushMatrix();
    background(75, 75, 255);
    scale((float)height/(float)cHeight);
    if (birdsAlive > 0) {
      Pipe closestPipe = null;
      float record = 99999;
      for (Pipe p : pipes) {
        float dist = p.topPos.x - startX;
        if (dist > 0 && dist < record) {
          closestPipe = p;
          record = p.topPos.x - startX;
        }
      }
      shownBird = false;
      for (Bird bird : ga.pop) {
        bird.flap(closestPipe);
        bird.move();
        bird.show();
        for (Pipe pipe : pipes) {
          if (
            bird.pos.y > cHeight - bird.radius
            || bird.pos.y < bird.radius
            || bird.hit(pipe.topPos.x, pipe.topPos.y, pipeWidth, pipe.topHeight)
            || bird.hit(pipe.bottomPos.x, pipe.bottomPos.y, pipeWidth, pipe.bottomHeight)) {
            bird.die();
          }
        }
      }

      for (Pipe pipe : pipes) {
        pipe.move();
        pipe.show();//FIX WEIRD CURLY BRACKETS!
      }
      if (gameScore > allTimeBestScore) {
        allTimeBestScore = gameScore;
      }

      pipeSpeed += speedUpBy;
    } else {
      pipeSpeed = originalPipeSpeed;
      //Do the evolving stuff
      birdsAlive = popSize;
      ga.evolveNextGen();

      ArrayList<Pipe> pipes_ = new ArrayList<Pipe>();

      for (int x = 0; x < cWidth; x+= spacing) {
        pipes_.add(new Pipe(x + cWidth, pipeWidth));
      }
      pipes = new Pipe[pipes_.size()];
      for (int i = 0; i < pipes_.size(); i++) {
        pipes[i] = pipes_.get(i);
      }
      gameScore = 0;
    }
    time++;
    popMatrix();
    stroke(0);
  }
  if (showDebug) {
    textSize(20);
    fill(0, 255, 0);
    textAlign(LEFT);//Make it show only 1 bird!
    
    text("Generation: " + ga.generation + "\nScore: " + gameScore + "\nAll Time Best Score: " + allTimeBestScore
      + "\nSpeed: " + gameSpeed + "\nAlive: " + birdsAlive + "\nDead " + (popSize - birdsAlive), 5, 20);
  }
}

void keyPressed() {
  if (key == 'd') {
    showDebug = !showDebug;
  } else if (key == '=') {
    gameSpeed++;
    if (mousePressed) {
      gameSpeed +=9;
    }
  } else if (key == '-') {
    if (gameSpeed > 0) {
      gameSpeed--;
    }
    if (mousePressed && gameSpeed > 9) {
      gameSpeed -=9;
    }
  } else if (key == 'i') {
    useImgs = !useImgs;
  } else if (key == '1') {
    show1Bird = !show1Bird;
  }
}
