class Waves {
  int nOfW = 20;
  ArrayList<Wave> waves;
  PGraphics pg;
  float ypos = 0;
  float band = 200;

  Waves(PGraphics _p) {
    pg = _p;
    waves = new  ArrayList<Wave>();
    float band = 600;
    float h = (pg.height - band);
    for (int i = 0; i < nOfW; i++) {
      float y = (h * (i + 0.5)) / nOfW + band * 0.5;
      waves.add(new Wave(i, pg, y * 0.01, y));
    }
  }
  void draw() {
    update();
    render();
  }
  void update() {
    pg.beginDraw();
    pg.background(0);
    for (int i = 0; i < nOfW; i++) {
      waves.get(i).draw();
    }
    pg.endDraw();
  }
  void render() {
    tint(255, 20);
    image(pg, 0, 0);
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
  }
}

class Water {
  int nOfW = 20;
  ArrayList<Wave> waves;
  PGraphics pg;
  float ypos = 0;
  float band = 0;

  Water(PGraphics _p) {
    pg = _p;
    waves = new  ArrayList<Wave>();
    float band = 600;
    float h = (pg.height - band);
    for (int i = 0; i < nOfW; i++) {
      float y = (h * (i + 0.5)) / nOfW + band * 0.5;
      waves.add(new Wave(i, pg, y * 0.01, y));
    }
  }
  void draw() {
    update();
    render();
  }
  void update() {
    pg.beginDraw();
    pg.background(0);
    for (int i = 0; i < nOfW; i++) {
      waves.get(i).draw();
    }
    pg.endDraw();
  }
  void render() {
    tint(255, 20);
    image(pg, 0, 0);
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
  }
}
