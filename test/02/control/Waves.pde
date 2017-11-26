float mouseControl;
class Waves {
  int nOfW = 20;
  ArrayList<Wave> waves;
  PGraphics pg;

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
    mouseControl = map(mouseY, 0, pg.height, 0, 0.01);
    // mouseControl = 0;
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
  void setBand(float band) {
    float h = (pg.height - band);
    for (int i = 0; i < nOfW; i++) {
      float y = (h * (i + 0.5)) / nOfW + band * 0.5;
      waves.get(i).ypos = y;
    }
  }
}
