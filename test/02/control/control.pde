import codeanticode.syphon.*;
import themidibus.*;

PGraphics pg;
PGraphics pg3d;
PGraphics pgout;
PShader shade;
PShader shade3d;
SyphonServer server;
MidiBus midi;
int state = 4;
int stateLimit = 4;
boolean on = true;
boolean three = true;
boolean usingShader = true;
float shaderBlinkAmount = 1;

// universal
MovingLines movingLines;
StaticRectangles[] srec;

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
Water water;
Particles p;

// state : 4
Lines lines;
Lines verticalLines;

// basic
void settings() {
  // size(1280, 380, P2D);
  size(960, 384, P2D);
  PJOGL.profile=1;
}
void setup() {
  generalInit();
  rectanglesInit();
  wavesInit();
  linesInit();
  threeInit();
}
void draw() {
  if (on) {
    if (!three) {
      twoDraw();
    } else {
      threeDraw();
    }

    image(pgout, 0, 0);
    server.sendImage(pgout);
  }
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
  // pg = createGraphics(1920, 380);
  // pgout = createGraphics(1920, 380, P2D);
  pg = createGraphics(width, height);
  pg3d = createGraphics(width, height, P3D);
  pgout = createGraphics(width, height, P2D);
  server = new SyphonServer(this, "Processing Syphon");
  midi = new MidiBus(this, "APC40 mkII", -1);
  // midi = new MidiBus(this, -1, -1);
  shaderSetup();

  movingLines = new MovingLines(pg);
  srec = new StaticRectangles[4];
  srec[0] = new StaticRectangles(pg, 0);
  srec[1] = new StaticRectangles(pg, 1);
  srec[2] = new StaticRectangles(pg, 2);
  srec[3] = new StaticRectangles(pg, 3);
}
void shaderSetup() {
  shade = loadShader("neon.glsl");
  shade.set("rad", 2);
  shade.set("amt", 1);

  shade3d = loadShader("channels.glsl");
  shade3d.set("rbias", 0.005, 0.0);
  shade3d.set("gbias", 0.0, 0.0);
  shade3d.set("bbias", 0.0, 0.0);
  shade3d.set("rmult", 1.0, 1.0);
  shade3d.set("gmult", 1.0, 1.0);
  shade3d.set("bmult", 1.0, 1.0);
}
void shaderUpdate() {
  shade.set("time", millis());
  shade.set("amt", shaderBlinkAmount);
}
void testDraw() {
  pg.rectMode(CENTER);
  pg.fill(255);
  pg.rect(pg.width * 0.5, pg.height * 0.5, 100, 100);
}
void generalDraw() {
  movingLines.draw();
  for (int i = 0; i < srec.length; i++) {
    srec[i].draw();
  }
}
void twoDraw() {
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
}
void threeInit() {
  water = new Water(pg3d);
}
void threeDraw() {
  pg3d.beginDraw();
  pg3d.background(0);
  // pg3d.translate(pg3d.width * 0.5, pg3d.height * 0.5);
  // pg3d.sphere(50);
  water.draw();
  pg3d.endDraw();

  pgout.beginDraw();
  pgout.shader(shade3d);
  pgout.image(pg3d, 0, 0);
  pgout.resetShader();
  pgout.endDraw();
}

// recs
void rectanglesInit() {
  float w = pg.width;
  float h = pg.height;
  recs_1 = new Rectangle[2];
  recs_1[0] = new Rectangle(pg, w * -0.4, 0, w * 0.4, h);
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
  // waves.setAmp(0);
}
void wavesDraw() {
  waves.draw();
  // if (frameCount % 5 == 0) {
  //   wavesInteract();
  // }
}
void wavesInteract() {
  waves.setAmp(map(mouseY, 0, height, 0, 250));
  waves.setBand(map(mouseX, 0, width, 0, pg.height - 900));
}

// lines
void linesInit() {
  lines = new Lines(pg, true, 10);
  verticalLines = new Lines(pg, false);
  lines.reset();
  verticalLines.reset();
}
void linesDraw() {
  lines.draw();
  verticalLines.draw();
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
