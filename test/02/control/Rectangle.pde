class Rectangle {
  PGraphics pg;
  PVector org;
  PVector pos;
  PVector des;
  float w;
  float h;
  float wdes;
  float hdes;
  float alpha = 255;
  TimeLine timer;
  boolean activated = false;
  boolean arrived = false;
  boolean centered = false;

  Rectangle(PGraphics _p, float _x, float _y, float _w, float _h) {
    init(_p, _x, _y, _w, _h);
  }
  Rectangle(PGraphics _p, float _x, float _y) {
    init(_p, _x, _y, _p.width * 0.2, _p.height);
  }

  void init(PGraphics _p, float _x, float _y, float _w, float _h) {
    pg = _p;
    org = new PVector(_x, _y);
    pos = new PVector(_x, _y);
    des = new PVector(pg.width, _y);

    w = _w;
    h = _h;
    wdes = _w;
    hdes = _h;
    timer = new TimeLine(500);
  }
  void draw() {
    update();
    render();
  }
  void update() {
    if (activated) {
      float ratio = timer.getPowInOut(2);
      pos = PVector.lerp(org, des, ratio);
      if (ratio >= 1) {
        activated = false;
        arrived = true;
      }
    }
    updateH();
  }
  void render() {
    pg.pushMatrix();
    if (centered) {
      pg.rectMode(CENTER);
    } else {
      pg.rectMode(CORNER);
    }
    pg.translate(pos.x, pos.y);
    // pg.translate(
    //   xpos + random(10),
    //   ypos + random(10),
    //   zpos + random(10)
    // );
    pg.noStroke();
    pg.fill(255);
    pg.rect(0, 0, w, h);
    pg.popMatrix();
  }

  void start() {
    activated = true;
    timer.startTimer();
  }
  void reset() {
    activated = false;
    arrived = false;
    pos = org.copy();
  }
  void setDes(PVector _d) {
    des = _d.copy();
  }
  void setNewDes(PVector _d) {
    arrived = false;
    org = pos.copy();
    des = _d.copy();
  }
  void updateH() {
    if (abs(hdes - h) < 0.1) {
      h = hdes;
    } else {
      h += (hdes - h) * 0.1;
    }
  }

}
