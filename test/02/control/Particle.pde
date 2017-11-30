class Particles {
  PGraphics pg;
  Particle[] ps;
  int nOfP = 200;
  float rad = 100;

  Particles(PGraphics _p) {
    pg = _p;
    ps = new Particle[nOfP];
    for (int i = 0; i < nOfP; i++) {
      float phy = random(PI);
      float angle = random(2 * PI);
      float x = rad * sin(phy) * cos(angle);
      float y = rad * sin(phy) * sin(angle);
      float z = rad * cos(phy);
      ps[i] = new Particle(pg, x, y, z);
    }
  }

  void draw() {
    pg.translate(width/2, height/2);
    pg.rotateY(frameCount * 0.02);
    for (int i = 0; i < nOfP; i++) {
      ps[i].draw();
    }
    if (frameCount % 5 == 0) {
      update();
    }
  }

  void update() {
    float rad = 100 * (1 + 0.3 * sin(0.05 * frameCount));
    for (int i = 0; i < nOfP; i++) {
      float phy = random(PI);
      float angle = random(2 * PI);
      ps[i].xpos = rad * sin(phy) * cos(angle);
      ps[i].ypos = rad * sin(phy) * sin(angle);
      ps[i].zpos = rad * cos(phy);
    }
  }
}

class Particle {
  PGraphics pg;
  float xpos;
  float ypos;
  float zpos;

  Particle(PGraphics _p, float _x, float _y, float _z) {
    pg = _p;
    xpos = _x;
    ypos = _y;
    zpos = _z;
  }

  void draw() {
    update();
    render();
  }

  void update() {

  }

  void render() {
    pg.pushMatrix();
    // pg.translate(xpos, ypos, zpos);
    pg.translate(
      xpos + random(10),
      ypos + random(10),
      zpos + random(10)
    );
    pg.stroke(255);
    pg.strokeWeight(3);
    pg.point(0, 0, 0);
    pg.popMatrix();
  }
}
