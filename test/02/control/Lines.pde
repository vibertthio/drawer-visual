class Lines {
  PGraphics pg;
  StraightLine[] lines;
  int nOfL = 30;

  // state
  boolean visible = false;
  boolean hr = true;
  float lineWeight = 2;
  boolean random = false;
  boolean glitch = false;
  int glitchAmt = 40;
  float yUpdateSpd = 0.1;


  Lines(PGraphics _p) {
    pg = _p;
    initLines();
  }
  Lines(PGraphics _p, boolean _hr) {
    pg = _p;
    hr = _hr;
    initLines();
  }
  Lines(PGraphics _p, boolean _hr, int _n) {
    pg = _p;
    hr = _hr;
    nOfL = _n;
    initLines();
  }
  void initLines() {
    lines = new StraightLine[nOfL];
    for (int i = 0; i < nOfL; i++) {
      lines[i] = new StraightLine(this, pg, hr);
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
    for (int i = 0; i < nOfL; i++) {
      // float h = (float)(pg.height * i) / nOfL;
      if (hr) {
        float h = map(i, 0, nOfL, 0, pg.height);
        lines[i].leftHeightDes = h;
        lines[i].rightHeightDes = h;
      } else {
        float w = map(i, 0, nOfL, 0, pg.width);
        lines[i].leftWidthDes = w;
        lines[i].rightWidthDes = w;
      }
    }
  }
  void expand() {
    yUpdateSpd = 0.005;
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
  boolean hr = true;
  Lines lines;
  PVector left;
  PVector right;
  float leftHeightDes;
  float rightHeightDes;
  float leftWidthDes;
  float rightWidthDes;
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
  StraightLine(Lines _l, PGraphics _p, boolean _h) {
    hr = _h;
    if (hr) {
      lines = _l;
      pg = _p;
      float h = pg.height * 0.5;
      left = new PVector(0, h);
      right = new PVector(pg.width, h);
      leftHeightDes = h;
      rightHeightDes = h;
    } else {
      lines = _l;
      pg = _p;
      float w = pg.width * 0.5;
      left = new PVector(w, 0);
      right = new PVector(w, pg.height);
      leftWidthDes = w;
      rightWidthDes = w;
    }
  }
  void draw() {
    update();
    render();
  }
  void update() {
    if (hr) {
      updateY();
      if (lines.random) {
        randomShiftY();
      }
    } else {
      updateX();
      if (lines.random) {
        randomShiftX();
      }
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
    if (hr) {
      rightHeightDes = pg.height * 0.5;
      leftHeightDes = pg.height * 0.5;
    } else {
      leftWidthDes = pg.width * 0.5;
      rightWidthDes = pg.width * 0.5;
    }
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
  void randomShiftX() {
    float w = pg.width;
    if (random(1) < 0.01) {
      leftWidthDes = random(0, w);
    }
    if (random(1) < 0.01) {
      rightWidthDes = random(0, w);
    }
  }
  void updateY() {
    float ld = leftHeightDes - left.y;
    if (abs(ld) > 0.1) {
      left.y += ld * lines.yUpdateSpd;
    } else {
      left.y = leftHeightDes;
    }

    float rd = rightHeightDes - right.y;
    if (abs(rd) > 0.1) {
      right.y += rd * lines.yUpdateSpd;
    } else {
      right.y = rightHeightDes;
    }
  }
  void updateX() {
    float ld = leftWidthDes - left.x;
    if (abs(ld) > 0.1) {
      left.x += ld * lines.yUpdateSpd;
    } else {
      left.x = leftWidthDes;
    }

    float rd = rightWidthDes - right.x;
    if (abs(rd) > 0.1) {
      right.x += rd * lines.yUpdateSpd;
    } else {
      right.x = rightWidthDes;
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
        int index = (i + 1) % heightOfLines.length;
        heightOfLines[i] = heightOfLines[index] - gap;
      } else if (heightOfLines[i] < 0) {
        int index = (i - 1);
        if (index < 0) { index = heightOfLines.length - 1; }
        heightOfLines[i] = heightOfLines[index] + gap;
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
