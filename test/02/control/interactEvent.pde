int chan = 0;

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println("--------");
  println("Note On:");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);

  if (chan == 0) {
    if (pitch >= 0 && pitch < 4) {
      resetRecs_1();
    }
    switch(pitch) {
      case 0:
        recs_1[0].reset();
        recs_1[0].start();
        break;
      case 1:
        recs_1[1].reset();
        recs_1[1].start();
        break;
      case 2:
        recs_1[0].start();
        recs_1_state[0] = true;
        break;
      case 3:
        recs_1[1].start();
        recs_1_state[1] = true;
        break;

      case 4:
        resetRecs_2();
        recs_2[0].start();
        break;
      case 5:
        resetRecs_2();
        recs_2[5].start();
        break;

      case 8:
        recs_3[0].hdes = 0;
        break;
      case 9:
        recs_3[0].hdes = 2;
        break;
      case 10:
        recs_3[0].hdes = pg.height;
        break;

      case 11:
        lines.visible = !lines.visible;
        break;
      case 12:
        lines.heightUpdateSpd = 0.1;
        if (!lines.random) {
          lines.random = true;
        } else {
          lines.reset();
        }
        break;
      case 13:
        lines.glitch = !lines.glitch;
        break;
      case 14:
        lines.queue();
        break;

      case 16:
        movingLines.trigger(40, 5);
        break;
      case 17:
        movingLines.trigger(40, -5);
        break;

    }
  } else if (chan == 1) {
    switch(pitch) {
      case 0:
        staticRectangles.turnOnEasingFor(800);
        break;
      case 1:
        staticRectangles.turnOneOnEasingFor(800, 0);
        break;
      case 2:
        staticRectangles.turnOneOnEasingFor(800, 1);
        staticRectangles.turnOneOnEasingFor(800, 2);
        break;
      case 3:
        staticRectangles.triggerSequence(0);
        break;
      case 4:
        staticRectangles.triggerAsyncSequence(0);
        break;
      case 5:
        staticRectangles.triggerAsyncSequence(1);
        break;
      case 6:
        staticRectangles.triggerAsyncSequence(2);
        break;
    }
  }
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  // println("--------");
  // println("Note Off:");
  // println("Channel:"+channel);
  // println("Pitch:"+pitch);
  // println("Velocity:"+velocity);
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  // println("--------");
  // println("Controller Change:");
  // println("Channel:"+channel);
  // println("Number:"+number);
  // println("Value:"+value);
  if (number == 23) {
    chan = channel;
  }
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
      lines.heightUpdateSpd = 0.1;
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
