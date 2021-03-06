class Wave {
  float xoff;
  float yoff;
  float ypos = 0;
  float amp = 20;
  PGraphics canvas;
  int index;
  int w;

  Wave(int _i, PGraphics _c, float _yo, float _yp) {
    index = _i;
    canvas = _c;
    yoff = _yo;
    ypos = _yp;
    w = canvas.width;
  }

  void draw() {
    update();
    render();
  }

  void update() {}

  void render() {
    canvas.stroke(255, 255);
    canvas.strokeWeight(1);
    canvas.noFill();
    canvas.beginShape();

    // float xoff = 0;       // Option #1: 2D Noise
    float xoff = yoff;    // Option #2: 1D Noise

    // Iterate over horizontal pixels
    int unit = 40;
    for (float x = -unit; x <= w + unit; x += unit) {
      float y = map(noise(xoff + index * 0.05, yoff), 0, 1, -1 * amp, amp) + ypos; // Option #1: 2D Noise
      // float y = map(noise(xoff), 0, 1, -50, 50) + ypos;    // Option #2: 1D Noise

      float vx = x;
      float vy = y;
      // float xd = x - mouseX;
      // float yd = y - mouseY;
      // if (abs(yd) < 100) {
      //   if (abs(xd) < 100) {
      //     vy += map(yd, -100, 100, -50, 50);
      //   }
      // }

      canvas.curveVertex(vx, vy);
      // Increment x dimension for noise
      xoff += 0.15;
    }
    // increment y dimension for noise
    yoff += 0.01;
    // vertex(width, height);
    // vertex(0, height);
    canvas.endShape();
  }

}

class WaterWave {
  float xoff;
  float yoff;
  float ypos = 0;
  float amp = 20;
  PGraphics canvas;
  int index;
  int w;
  float start = -100;
  float end = 1100;

  WaterWave(int _i, PGraphics _c, float _yo, float _yp) {
    index = _i;
    canvas = _c;
    yoff = _yo;
    ypos = _yp;
    w = canvas.width;
  }

  void draw() {
    update();
    render();
  }

  void update() {}

  void render() {
    canvas.stroke(255, 255);
    canvas.strokeWeight(1);
    canvas.noFill();
    canvas.beginShape();

    // float xoff = 0;       // Option #1: 2D Noise
    float xoff = yoff;    // Option #2: 1D Noise

    // Iterate over horizontal pixels
    int unit = 40;
    for (float x = start; x <= end; x += unit) {
      float y = map(noise(xoff + index * 0.05, yoff), 0, 1, -1 * amp, amp) + ypos; // Option #1: 2D Noise
      // float y = map(noise(xoff), 0, 1, -50, 50) + ypos;    // Option #2: 1D Noise

      float vx = x;
      float vy = y;
      // float xd = x - mouseX;
      // float yd = y - mouseY;
      // if (abs(yd) < 100) {
      //   if (abs(xd) < 100) {
      //     vy += map(yd, -100, 100, -50, 50);
      //   }
      // }

      canvas.curveVertex(vx, vy);
      // Increment x dimension for noise
      xoff += 0.15;
    }
    // increment y dimension for noise
    yoff += 0.01;
    // vertex(width, height);
    // vertex(0, height);
    canvas.endShape();
  }

}
