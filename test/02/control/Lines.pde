class Lines {
  PGraphics pg;
  StraightLine[] lines;
  int nOfL = 30;

  // state
  boolean visible = false;
  float lineWeight = 2;
  boolean random = false;
  boolean glitch = false;
  int glitchAmt = 40;
  float heightUpdateSpd = 0.1;


  Lines(PGraphics _p) {
    pg = _p;
    initLines();
  }
  void initLines() {
    lines = new StraightLine[nOfL];
    for (int i = 0; i < nOfL; i++) {
      lines[i] = new StraightLine(this, pg);
    }
  }
  void draw() {
    if (visible) {
      update();
      render();
    }
  }
  void update() {

  }
  void render() {
    for (int i = 0; i < nOfL; i++) {
      lines[i].draw();
    }
  }
  void reset() {
    random = false;
    for (int i = 0; i < nOfL; i++) {
      lines[i].reset();
    }
  }
  void queue() {
    heightUpdateSpd = 0.005;
    for (int i = 0; i < nOfL; i++) {
      // float h = (float)(pg.height * i) / nOfL;
      float h = map(i, 0, nOfL, 0, pg.height);
      float hdes = map(i, 0, nOfL, -0.5 * pg.height, 1.5 * pg.height);
      lines[i].left.y = h;
      lines[i].right.y = h;
      lines[i].leftHeightDes = hdes;
      lines[i].rightHeightDes = hdes;
    }
  }
}

class StraightLine {
  PGraphics pg;
  Lines lines;
  PVector left;
  PVector right;
  float leftHeightDes;
  float rightHeightDes;
  float alpha = 255;
  float alphaTarget = 255;

  StraightLine(Lines _l, PGraphics _p) {
    lines = _l;
    pg = _p;
    float h = pg.height * 0.5;
    left = new PVector(0, h);
    right = new PVector(pg.width, h);
    leftHeightDes = h;
    rightHeightDes = h;
  }
  void draw() {
    update();
    render();
  }
  void update() {
    updateHeight();
    if (lines.random) {
      randomShiftY();
    }
  }
  void render() {
    pg.stroke(255);
    pg.strokeWeight(lines.lineWeight);
    if (lines.glitch) {
      int a = lines.glitchAmt;
      pg.line(
        left.x, left.y + random(-a, a),
        right.x, right.y+ random(-a, a)
      );
    } else {
      pg.line(left.x, left.y, right.x, right.y);
    }
  }

  void reset() {
    rightHeightDes = pg.height * 0.5;
    leftHeightDes = pg.height * 0.5;
  }
  void reset(float h) {
    rightHeightDes = h;
    leftHeightDes = h;
  }
  void randomShiftY() {
    float h = pg.height;
    if (random(1) < 0.01) {
      leftHeightDes = random(-0.5 * h, 1.5 * h);
    }
    if (random(1) < 0.01) {
      rightHeightDes = random(-0.5 * h, 1.5 * h);
    }
  }
  void updateHeight() {
    float ld = leftHeightDes - left.y;
    if (abs(ld) > 0.1) {
      left.y += ld * lines.heightUpdateSpd;
    } else {
      left.y = leftHeightDes;
    }

    float rd = rightHeightDes - right.y;
    if (abs(rd) > 0.1) {
      right.y += rd * lines.heightUpdateSpd;
    } else {
      right.y = rightHeightDes;
    }
  }
}

class MovingLines {
  PGraphics pg;
  int nOfL = 10;
  float[] heightOfLines;
  float gap;
  float spd = 2;
  int count = 0;

  MovingLines(PGraphics _p) {
    pg = _p;
    init();
  }
  void init() {
    gap = float(pg.height) / nOfL;
    heightOfLines = new float[nOfL];
    for (int i = 0; i < nOfL; i++) {
      heightOfLines[i] = i * gap;
    }
  }
  void draw() {
    if (count > 0) {
      update();
      render();
      count -= 1;
    }
  }
  void update() {

  }
  void render() {
    for (int i = 0; i < nOfL; i++) {
      heightOfLines[i] += spd;
      if (heightOfLines[i] > pg.height) {
        heightOfLines[i] = 0;
      } else if (heightOfLines[i] < 0) {
        heightOfLines[i] = pg.height;
      }
      pg.stroke(255);
      pg.strokeWeight(1);
      pg.line(0, heightOfLines[i], pg.width, heightOfLines[i]);

    }
  }

  void trigger(int _c) {
    count = _c;
  }
  void trigger(int _c, int _s) {
    count = _c;
    spd = _s;
  }
}
