import codeanticode.syphon.*;
import themidibus.*;

PGraphics pg;
PGraphics pgout;
PShader shade;
SyphonServer server;
MidiBus midi;
int state = 4;
int stateLimit = 4;
boolean usingShader = true;

// universal
MovingLines movingLines;
StaticRectangles staticRectangles;

// state: 0
Rectangle[] recs_1;
boolean[] recs_1_state = { false, false };

// state: 1
Rectangle[] recs_2;
boolean[] recs_2_state = { false, false };

// state : 2
Rectangle[] recs_3;

// state : 3
Waves waves;

// state : 4
Lines lines;

// basic
void settings() {
  size(1920, 380, P2D);
  PJOGL.profile=1;
}
void setup() {
  generalInit();
  rectanglesInit();
  wavesInit();
  linesInit();
}
void draw() {
  pg.beginDraw();
  pg.background(0);
  // testDraw();
  generalDraw();
  rectanglesUpdate();
  rectanglesDraw();
  wavesDraw();
  linesDraw();
  pg.endDraw();

  pgout.beginDraw();
  if (usingShader) {
    shaderUpdate();
    pgout.shader(shade);
  }
  tintUpdate();
  pgout.image(pg, 0, 0);
  pgout.resetShader();
  pgout.endDraw();

  image(pgout, 0, 0);
  server.sendImage(pgout);
}

// utils
void tintUpdate() {
  if (state == 3) {
    tint(255, 20);
  } else {
    tint(255, 255);
  }
}
void generalInit() {
  pg = createGraphics(1920, 380);
  pgout = createGraphics(1920, 380, P2D);
  server = new SyphonServer(this, "Processing Syphon");
  midi = new MidiBus(this, "APC40 mkII", -1);
  shaderSetup();

  movingLines = new MovingLines(pg);
  staticRectangles = new StaticRectangles(pg);
}
void shaderSetup() {
  // shade = loadShader("blur.glsl");
  // shade.set("offset", 0.1, 0.1);

  // shade = loadShader("blur_2.glsl");
  // shade.set("texOffset", 1.0, 1.0);
  // shade.set("blurSize", 20);
  // shade.set("horizontalPass", 1);
  // shade.set("sigma", 2.5);

  shade = loadShader("neon.glsl");
  shade.set("rad", 2);
}
void shaderUpdate() {
  shade.set("time", millis());
}
void testDraw() {
  pg.rectMode(CENTER);
  pg.fill(255);
  pg.rect(pg.width * 0.5, pg.height * 0.5, 100, 100);
}
void generalDraw() {
  movingLines.draw();
  staticRectangles.draw();
}

// recs
void rectanglesInit() {
  float w = pg.width;
  float h = pg.height;
  recs_1 = new Rectangle[2];
  recs_1[0] = new Rectangle(pg, w * -0.1, 0, w * 0.1, h);
  recs_1[1] = new Rectangle(pg, 0, h * -0.4, w, h * 0.4);
  recs_1[1].setDes(new PVector(0, h));
  recs_1[1].timer.limit = 300;

  resetRecs_2();

  recs_3 = new Rectangle[1];
  recs_3[0] = new Rectangle(pg, w * 0.5, h * 0.5, w, h);
  recs_3[0].centered = true;
  recs_3[0].hdes = 0;
}
void rectanglesUpdate() {
  float w = pg.width;
  float h = pg.height;

  if (recs_1_state[0]) {
    if (recs_1[0].arrived) {
      recs_1[0].reset();
      recs_1[0].start();
    }
  }

  if (recs_1_state[1]) {
    if (recs_1[1].arrived) {
      recs_1[1].reset();
      recs_1[1].start();
    }
  }

  for (int i = 0; i < 4; i++) {
    if (recs_2[i].arrived) {
      recs_2[i].arrived = false;
      if (recs_2_state[0]) {
        recs_2[i + 1].setNewDes(new PVector(w, 0));
      }
      recs_2[i + 1].reset();
      recs_2[i + 1].start();
    }

    if (recs_2[i + 5].arrived) {
      recs_2[i + 5].arrived = false;
      if (recs_2_state[1]) {
        recs_2[i + 6].setNewDes(new PVector(0, h));
      }
      recs_2[i + 6].reset();
      recs_2[i + 6].start();
    }
  }

  if (!recs_2_state[0]) {
    if (recs_2[4].arrived) {
      recs_2[0].setNewDes(new PVector(w, 0));
      recs_2[0].reset();
      recs_2[0].start();
      recs_2_state[0] = true;
    }
  }

  if (!recs_2_state[1]) {
    if (recs_2[9].arrived) {
      recs_2[5].setNewDes(new PVector(0, h));
      recs_2[5].reset();
      recs_2[5].start();
      recs_2_state[1] = true;
    }
  }
}
void rectanglesDraw() {
  for (int i = 0; i < recs_1.length; i++) {
    recs_1[i].draw();
  }
  for (int i = 0; i < recs_2.length; i++) {
    recs_2[i].draw();
  }
  for (int i = 0; i < recs_3.length; i++) {
    recs_3[i].draw();
  }
}

// waves
void wavesInit() {
  waves = new Waves(pg);
}
void wavesDraw() {
  if (state == 3) {
    waves.draw();
    if (frameCount % 5 == 0) {
      wavesInteract();
    }
  }
}
void wavesInteract() {
  float band = 600;
  waves.setAmp(map(mouseY, 0, height, 0, 250));
  waves.setBand(map(mouseX, 0, width, pg.height, 600));
}

// lines
void linesInit() {
  lines = new Lines(pg);
  lines.reset();
}
void linesDraw() {
  if (state == 4) {
    lines.draw();
  }
}

// reset
void resetRecs_1() {
  recs_1_state[0] = false;
  recs_1_state[1] = false;
  recs_1[0].reset();
  recs_1[1].reset();
}
void resetRecs_2() {
  recs_2_state[0] = false;
  recs_2_state[1] = false;
  float w = pg.width;
  float h = pg.height;
  recs_2 = new Rectangle[10];
  for (int i = 0; i < 5; i++) {
    recs_2[i] = new Rectangle(pg, w * -0.2, 0, w * 0.2, h);
    recs_2[i].setDes(new PVector((4 - i) * w * 0.2, 0));
    recs_2[i].timer.limit = 400;

    recs_2[i + 5] = new Rectangle(pg, 0, h * -0.2, w, h * 0.2);
    recs_2[i + 5].setDes(new PVector(0, (4 - i) * h * 0.2));
    recs_2[i + 5].timer.limit = 400;
  }
}
