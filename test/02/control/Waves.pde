class Waves {
  int nOfW = 20;
  ArrayList<Wave> waves;
  PGraphics pg;
  float ypos = 0;
  float band = 200;
  boolean visible = true;

  Waves(PGraphics _p) {
    pg = _p;
    waves = new  ArrayList<Wave>();
    float h = (pg.height - band) + ypos;
    for (int i = 0; i < nOfW; i++) {
      float y = (band * (i + 0.5)) / nOfW + h * 0.5;
      waves.add(new Wave(i, pg, y * 0.01, y));
    }
  }
  void draw() {
    if (visible) {
      update();
      render();
    }
  }
  void update() {
    // pg.beginDraw();
    pg.background(0);
    for (int i = 0; i < nOfW; i++) {
      waves.get(i).draw();
    }
    // pg.endDraw();
  }
  void render() {
    // pgout.image(pg, 0, 0);
  }

  void setAmp(float value) {
    for (int i = 0; i < nOfW; i++) {
      waves.get(i).amp = value;
    }
  }
  void setBand(float _b) {
    band = _b;
    updatePos();
  }
  void setYPos(float _ypos) {
    ypos = _ypos;
    updatePos();
  }
  void updatePos() {
    float h = (pg.height - band) + ypos;
    for (int i = 0; i < nOfW; i++) {
      float y = (band * (i + 0.5)) / nOfW + h * 0.5;
      waves.get(i).ypos = y;
    }
  }
}


class Water {
  int nOfW = 20;
  ArrayList<WaterWave> waves;
  PGraphics pg;
  float band = 0;
  float ypos = 300;
  float gap = -50;

  Water(PGraphics _p) {
    pg = _p;
    waves = new ArrayList<WaterWave>();
    float h = (pg.height - band);
    for (int i = 0; i < nOfW; i++) {
      float y = (h * (i + 0.5)) / nOfW + band * 0.5;
      WaterWave ww = new WaterWave(i, pg, y * 0.01, ypos);
      ww.start -= i * 150;
      ww.end += i * 150;
      waves.add(ww);
    }
  }
  void draw() {
    update();
    render();
  }
  void update() {
    // pg.beginDraw();
    // pg.background(0);

    for (int i = 0; i < nOfW; i++) {
      waves.get(i).draw();
      pg.translate(0, 0, gap);
    }
    // pg.endDraw();
  }
  void render() {

  }

  void setAmp(float value) {
    for (int i = 0; i < nOfW; i++) {
      waves.get(i).amp = value;
    }
  }
  void setBand(float _b) {
    band = _b;
    float h = (pg.height - band);
    for (int i = 0; i < nOfW; i++) {
      float y = (h * (i + 0.5)) / nOfW + band * 0.5;
      waves.get(i).ypos = y;
    }
  }
  void setYPos(float _ypos) {
    ypos = _ypos;
    float h = (pg.height - band);
    for (int i = 0; i < nOfW; i++) {
      float y = (h * (i + 0.5)) / nOfW + band * 0.5;
      waves.get(i).ypos = ypos;
    }
  }

  void setGap(float _g) {
    gap = _g;
  }
}
