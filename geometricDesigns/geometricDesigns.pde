float t = 0;
float scl = 1;

void setup() {
  size(window.innerWidth, window.innerHeight-4); //500, 700
  t = random(0, 100);
  scl = height / 700;
  background(20);
}

void draw() {
  pushMatrix();

  background(0);
  stroke(255);
  strokeWeight(5);
  translate(width/2, height/2);
  scale(scl);

  float amt = 10; // (sin(t / 300) * 10) + 5;

  for (int i = 0; i < amt; i++) {
    float thisT = t - (i * sin(t / 50) * cos(t / 10) * 5) + 4;

    float r = (sin(thisT / 50) + 1) * 127.5;
    float g = (cos(thisT / 25) + 1) * 127.5;
    float b = (cos(thisT / 10) + 1.5) * 127.5;
    float a = ((sin(-thisT / 150) + 1) * 127.5) + 100;
    stroke(r, g, b, a);

    float x1 = sin(thisT / 10) * 80;
    float y1 = sin(thisT / 50) * 135 + sin(thisT / 25) * 150;
    float x2 = cos(thisT / 20) * 90;
    float y2 = sin(thisT / 100) * -135;

    line(x1, y1, x2, y2);
  }
  t += 0.7;//(sin(frameCount / 50) + .7) * 0.7;//map(mouseX, 0, width, -3, 3);
  popMatrix();
}
