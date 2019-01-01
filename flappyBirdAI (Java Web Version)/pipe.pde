class Pipe {
  PVector topPos;
  float w;
  float topHeight;
  PVector bottomPos;
  float bottomHeight;

  Pipe(int x, float w_) {
    topHeight = random(20, cHeight-pipeGap-20);
    topPos = new PVector(x, 0);
    bottomPos = new PVector(x, topHeight + pipeGap);
    bottomHeight = cHeight - bottomPos.y;
    w = w_;
  }

  void show() {
    if (useImgs) {
      image(pipeFlippedImg, topPos.x, topPos.y, w, topHeight);
      image(pipeImg, bottomPos.x, cHeight, w, -bottomHeight);
    } else {
      fill(255);
      noStroke();
      rect(topPos.x, topPos.y, w, topHeight);
      rect(bottomPos.x, bottomPos.y, w, bottomHeight);
    }
  }

  void move() {
    topPos.x -= pipeSpeed;
    bottomPos.x -= pipeSpeed;
    if (topPos.x < -w) {
      gameScore++;
      topHeight = random(10, cHeight-pipeGap-10);
      int xPos;
      float record = 0;
      for (Pipe p : pipes) {
         if (p != this) {
           if (p.topPos.x > record) {
              record = p.topPos.x; 
           }
         }
      }
      
      
      topPos = new PVector(record+spacing, 0);
      bottomPos = new PVector(record+spacing, topHeight + pipeGap);
      bottomHeight = cHeight - bottomPos.y;
    }
  }
}
