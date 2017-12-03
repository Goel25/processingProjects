void reset() {
  shapes = new ArrayList<Shape>();
  //scl = ; //TO-DO Add scaling! and highscore
  totals = new int[6];
  score = 0; //The players score
  time = 90 * 60;

  totals[0] = 45; //30 Dots
  totals[1] = 15; //30 circles
  totals[2] = 12; //8 triangles
  totals[3] = 10; //7 squares
  totals[4] = 8; //5 pentagons
  totals[5] = 3; //3 hexagons

  for (int i = 0; i < totals.length; i++) {
    for (int j = 0; j < totals[i]; j++) {
      int r = floor(map(i, 0, totals.length, 3, 25));
      int margin = r+border+15;
      int x = floor(random(margin, nW-margin));
      int y = floor(random(margin, nH-margin));
      shapes.add(new Shape(x, y, r, i));
    }
  }

  player = shapes.get(totals[0]);
}

void mouseClicked() {
  if (mode == 0) {
    reset();
    mode = 1;
  }
}


void play() {

  time-=timeS/1.5;
  player.move();
  player.eat();
  int moveR = player.perceptionR*4;//The radius in which things will move

  fill(255);
  noStroke();
  ellipse(player.pos.x, player.pos.y, moveR * 2, moveR * 2);

  // console.log(player.perceptionR);
  // console.log(shapes.get(75).pos);
  for (int i = shapes.size()-1; i >= 0; i--) {
    Shape s = shapes.get(i);
    if (s != player) {

      if (dist(s.pos.x, s.pos.y, player.pos.x,player.pos.y) < moveR) {
        s.move();
        s.eat();
        s.show();
        if (s.dead) {
          shapes.remove(i);
        }
      }
    }
  }
  player.show();
  /*loadPixels();
  int minDist = (moveR*2);
  minDist *= minDist;
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++)
    // pixels[i + j * width] = color(0,0,255);
    int x = floor(abs(player.pos.x - i));
    int y = floor(abs(player.pos.y - j));
    if ((x*x + y*y) > minDist) {
      pixels[i + j * width] = color(0, 0,255);
    }
  }
  updatePixels();*/
  // noFill();
  // stroke(0);
  // int strokeW = nW * 2; //This is probably not working because the diameter is negative and something gets inverted
  // console.log(nW + "    nW");
  // strokeWeight(strokeW);
  // int diameter = (((moveR*2) - strokeW) + -50) * -1;
  // console.log(moveR + "=moveR    " + strokeW + "=strokeW");
  // ellipse(player.pos.x, player.pos.y, diameter, diameter);//Add the black so you can only see a little
  textAlign(CENTER);
  int txtSize = 35;
  textSize(txtSize);
  fill(0, 0, 255);
  text("Time: " + floor(time/60) + "\nScore: " + score, nW/2, nH-(txtSize*2));
  //Add death when run out of time! and a way to end game if necesary
  if (time < 0) {
    mode = 0;
    showStart = true;
    if (score > highscore) highscore = score;
  }
}

void keyPressed() {
  if (key == 'k' || key == 'K') {
    time = 0;
    if (time < 0) time = 0;
  }
}
