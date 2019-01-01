class Bird {
  PVector pos;
  float velY;
  float radius;
  int fitness;
  double prob;
  boolean dead;
  int lastFlap = 0;
  NeuralNetwork brain;

  Bird(int x, int y) {
    pos = new PVector(x, y);
    velY = 0;
    radius = 8;
    fitness = 0;
    prob = 0;
    dead = false;
    lastFlap = time-10;
    brain = new NeuralNetwork(amtInputs, amtHidden, amtOutputs);
  }

  Bird(int x, int y, NeuralNetwork brain_) {
    pos = new PVector(x, y);
    velY = 0;
    radius = 8;
    fitness = 0;
    prob = 0;
    dead = false;
    brain = brain_;
  }

  void show() {
    if (!dead) {
      if (!show1Bird) {
        if (useImgs) {
          image(birdImg, pos.x, pos.y, radius*2, radius*2);
        } else {
          fill(255);
          noStroke();
          ellipse(pos.x, pos.y, radius*2, radius*2);
        }
      } else if (!shownBird) {
        if (useImgs) {
          image(birdImg, pos.x, pos.y, radius*2, radius*2);
        } else {
          fill(255);
          noStroke();
          ellipse(pos.x, pos.y, radius*2, radius*2);
        }
        shownBird = true;
      }
    }
  }

  void flap(Pipe pipe) {
    float[] inputs = new float[5];
    inputs[0] = map(pipe.topPos.x, pos.x, cWidth, 0, 1);
    // top of closest pipe opening
    inputs[1] = map(pipe.topHeight, 0, cHeight, 0, 1);
    // bottom of closest pipe opening
    inputs[2] = map(cHeight-pipe.bottomHeight, 0, cHeight, 0, 1);
    // bird's y position
    inputs[3] = map(pos.y, 0, cHeight, 0, 1);
    // bird's y velocity
    inputs[4] = map(velY, -5, 5, 0, 1);

    float[] prediction = brain.predict(inputs);
    if (prediction[0] > prediction[1] && lastFlap + flapEvery <= time) { 
      velY -= 5;
      lastFlap = time;
    }
  }

  Bird crossover(Bird other, int type) {
    return new Bird(startX, startY, this.brain.crossover(other.brain, type));
  }

  void mutate(float rate) {
    this.brain.mutate(rate);
  }

  void move() {
    if (!dead) {
      fitness++;
      velY += gravity; 
      pos.y += velY;
    }
  }

  void die() {
    if (!dead) {
      birdsAlive--;
    }
    dead = true;
  }

  int getFitness() {
    fitness = (fitness*fitness)/10000;
    return fitness;
  }

  boolean hit(float rectX, float rectY, float rectW, float rectH) {
    float closeX = constrain(pos.x, rectX, rectX + rectW);
    float closeY = constrain(pos.y, rectY, rectY + rectH);
    float distSq = sq(pos.x - closeX) + sq(pos.y - closeY);
    if (distSq < sq(radius)) {
      die();
      return true;
    }
    return false;
  }
}
