class StaticRectangle {
  PGraphics pg;
  int id;
  float xpos;
  float ypos;
  float length = 300;

  TimeLine dimTimer;

  // state
  boolean independentControl = false;
  boolean repeatBreathing = false;

  // temperary
  boolean dimming = false;
  float alpha = 255;
  float targetAlpha;
  float initialAlpha;
  int dimTime = 0;

  // blink function
  boolean blink = false;
  TimeLine turnOnTimer;

  // easing
  boolean easing = false;
  boolean easingBlink = false;
  float easeRatio;
  float dimOnEaseRatio = 8;
  float dimOffEaseRatio = 0.2;


  StaticRectangle(PGraphics _p, int _id, float _x, float _y) {
    pg = _p;
    id = _id;
    xpos = _x;
    ypos = _y;
    // xpos = width / 2 - length / 2;
    // ypos = height / 2;

    // Timers
    dimTimer = new TimeLine(300);
    turnOnTimer = new TimeLine(50);
  }
  void draw() {
    update();
    render();
  }
  void update() {
    if (dimming) {
      float ratio = 0;
      if (repeatBreathing) {
        ratio = dimTimer.repeatBreathMovement();
      } else if (easing) {
        ratio = dimTimer.getPowIn(easeRatio);
      } else {
        ratio = dimTimer.liner();
      }

      alpha = initialAlpha +
        (targetAlpha - initialAlpha) * ratio;

      if (!dimTimer.state) {
        // alpha = targetAlpha;
        easing = false;
        dimming = false;
        repeatBreathing = false;
      }
    // } else if (blink) {
    }
    if (blink) {
      // println("blink check!!");
      if (turnOnTimer.liner() == 1) {
        if (easingBlink) {
          turnOffEasing(dimTime / 2);
          easingBlink = false;
        } else {
          turnOff(dimTime);
        }
        blink = false;
      }
    }
  }
  void render() {
    pg.pushMatrix();
    pg.translate(xpos, ypos);
    pg.rectMode(CENTER);
    pg.noStroke();
    pg.fill(255, alpha);
    pg.rect(0, 0, 200, 200);
    pg.popMatrix();
  }
  void turnOn() {
    repeatBreathing = false;
    independentControl = false;
    dimming = false;
    alpha = 255;
    initialAlpha = 255;
    targetAlpha = 255;
  }
  void turnOn(int time) {
    repeatBreathing = false;
    independentControl = false;
    dimming = true;
    dimTimer.limit = time;
    dimTimer.startTimer();
    initialAlpha = alpha;
    targetAlpha = 255;
  }
  void turnOnEasing(int time) {
    turnOn(time);
    easeRatio = dimOnEaseRatio;
    easing = true;
  }
  void turnOnEasing(int time, int ratio) {
    dimOnEaseRatio = ratio;
    turnOnEasing(time);
  }
  void turnOff() {
    repeatBreathing = false;
    independentControl = false;
    dimming = false;
    alpha = 0;
    initialAlpha = 0;
    targetAlpha = 0;
  }
  void turnOff(int time) {
    repeatBreathing = false;
    independentControl = false;
    dimming = true;
    dimTimer.limit = time;
    dimTimer.startTimer();
    initialAlpha = alpha;
    targetAlpha = 0;
  }
  void turnOffEasing(int time) {
    turnOff(time);
    easeRatio = dimOffEaseRatio;
    easing = true;
  }
  void turnOffEasing(int time, int ratio) {
    dimOffEaseRatio = ratio;
    turnOffEasing(time);
  }
  void turnOnFor(int time) {
    repeatBreathing = false;
    blink = true;
    dimTime = 0;
    turnOn();
    turnOnTimer.limit = time;
    turnOnTimer.startTimer();
  }
  void turnOnFor(int time, int ll) {
    repeatBreathing = false;
    blink = true;
    dimTime = ll;
    turnOn(dimTime);
    turnOnTimer.limit = time;
    turnOnTimer.startTimer();
  }
  void turnOnEasingFor(int time) {
    // only one param here,
    // because the length of dimming and opening
    // must match at usual cases

    repeatBreathing = false;
    blink = true;
    easingBlink = true;
    dimTime = time;
    turnOnEasing(time);
    turnOnTimer.limit = time;
    turnOnTimer.startTimer();
  }

  void blink() {
    turnOnFor(20);
  }
  void setLimit(int ll) {
    dimTimer.limit = ll;
  }

  void dimRepeat(int time, int ll) {
    alpha = 0;
    repeatBreathing = true;
    dimming = true;
    initialAlpha = 0;
    targetAlpha = 255;
    dimTimer.limit = ll;
    dimTimer.repeatTime = time;
    dimTimer.breathState = false;
    dimTimer.startTimer();
  }
  void dimRepeatInverse(int time, int ll) {
    alpha = 255;
    repeatBreathing = true;
    dimming = true;
    initialAlpha = 255;
    targetAlpha = 0;
    dimTimer.limit = ll;
    dimTimer.repeatTime = time;
    dimTimer.breathState = false;
    dimTimer.startTimer();
  }
}
