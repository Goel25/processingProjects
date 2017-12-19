class specialText {
  PVector pos;
  float rot;
  String txt;
  float tW;
  int life;
  int size;

  specialText(float x_, float y_, String txt_, int size_) {
    pos = new PVector(x_, y_);
    txt = txt_;
    tW = textWidth(txt_);
    life = 1000;
    size = size_+floor(random(-2, 3));
    rot = random(-PI/8, PI/8);//Random angle
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rot);
    fill(0, life);
    noStroke();//Display text that fades away
    textSize(size);
    text(txt, -tW/2, size);
    popMatrix();
    life-=10*timeS;//When its dead, its removed in play()
  }
}
