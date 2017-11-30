import codeanticode.syphon.*;

PGraphics pg;
PGraphics pgout;
PShader shade;
SyphonServer server;
Particles p;

void settings() {
  size(1280, 380, P3D);
  PJOGL.profile=1;
}

void setup() {
  pg = createGraphics(1280, 380, P3D);
  pgout = createGraphics(1280, 380, P2D);
  server = new SyphonServer(this, "Processing Syphon");
  shaderSetup();

  p = new Particles(pg);
}

void draw() {
  pg.beginDraw();
  pg.background(0);
  p.draw();
  pg.endDraw();

  pgout.beginDraw();
  pgout.shader(shade);
  pgout.image(pg, 0, 0);
  pgout.endDraw();

  image(pgout, 0, 0);
  server.sendImage(pgout);
}

void shaderSetup() {
  shade = loadShader("channels.glsl");
  shade.set("rbias", 0.005, 0.0);
  shade.set("gbias", 0.0, 0.0);
  shade.set("bbias", 0.0, 0.0);
  shade.set("rmult", 1.0, 1.0);
  shade.set("gmult", 1.0, 1.0);
  shade.set("bmult", 1.0, 1.0);
}
