import codeanticode.syphon.*;

PGraphics pg;
PGraphics pgout;
PShader shade;
SyphonServer server;
int state = 4;
int stateLimit = 4;
boolean usingShader = true;
GlowManager postProduction;

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
  // pg.rectMode(CENTER);
  // pg.fill(255);
  // pg.rect(pg.width * 0.5, pg.height * 0.5, 100, 100);
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

  // pgout = postProduction.dowGlow(pg);
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
  shaderSetup();
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

  // postProduction = new GlowManager();
  // postProduction.initGlow(this, pg, 0.25f);
  // postProduction.blur.set("blurSize", 7);
  // postProduction.blur.set("sigma", 3.0f);
  // postProduction.glowShader.set("BlendMode", 0);
}
void shaderUpdate() {

  // TEST
  // float brt = map(mouseX, 0, width, 0, 0.5);
  // int rad = (int) map(mouseY, 0, height, 0, 3);
  // println("brt: " + brt + ", rad: " + rad);
  // shade.set("brt", map(mouseX, 0, width, 0, 0.5));
  // shade.set("rad", (int) map(mouseY, 0, height, 0, 3));

  float brt = 0.1 + 0.1 * sin(float(millis()) / 300.0);
  int rad = 2;
  // println("brt: " + brt + ", rad: " + rad);
  shade.set("brt", brt);
  shade.set("rad", rad);
}
void keyPressed() {
  if (key == 'z') {
    state += 1;
    if (state > stateLimit) {
      state = 0;
    }
    if (state == 1) {
      resetRecs_2();
    }
    if (state == 3) {
      wavesInteract();
    }
  } else if (key == ' ') {
    println("trigger shader");
    usingShader = !usingShader;
  } else if (state == 0) {
    resetRecs_1();
    if (key == '1') {
      recs_1[0].reset();
      recs_1[0].start();
    } else if (key == '2') {
      recs_1[1].reset();
      recs_1[1].start();
    } else if (key == '3') {
      recs_1[0].start();
      recs_1_state[0] = true;
    } else if (key == '4') {
      recs_1[1].start();
      recs_1_state[1] = true;
    }
  } else if (state == 1) {
    if (key == '1') {
      resetRecs_2();
      recs_2[0].start();
    }
    if (key == '2') {
      resetRecs_2();
      recs_2[5].start();
    }
  } else if (state == 2) {
    if (key == '1') {
      recs_3[0].hdes = 2;
    }
    if (key == '2') {
      recs_3[0].hdes = pg.height;
    }
  } else if (state == 4) {
    if (key == '1') {
      if (!lines.random) {
        lines.random = true;
      } else {
        lines.reset();
      }
    } else if (key == '2') {
      lines.glitch = !lines.glitch;
    } else if (key == '3') {
      lines.queue();
    }
  }
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
}
void rectanglesUpdate() {
  float w = pg.width;
  float h = pg.height;
  if (state == 0) {
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
  } else if (state == 1) {
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
}
void rectanglesDraw() {
  if (state == 0) {
    for (int i = 0; i < recs_1.length; i++) {
      recs_1[i].draw();
    }
  } else if (state == 1) {
    for (int i = 0; i < recs_2.length; i++) {
      recs_2[i].draw();
    }
  } else if (state == 2) {
    for (int i = 0; i < recs_3.length; i++) {
      recs_3[i].draw();
    }
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
