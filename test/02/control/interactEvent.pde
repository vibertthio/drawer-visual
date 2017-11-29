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
        lines.yUpdateSpd = 0.1;
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

      case 24:
        waves.visible = !waves.visible;
        break;

      case 32:
        verticalLines.visible = !verticalLines.visible;
        break;
      case 33:
        if (!verticalLines.random) {
          verticalLines.random = true;
        } else {
          verticalLines.reset();
        }
        break;
      case 34:
        verticalLines.queue();
        break;

    }
  } else if (chan == 1) {
    switch(pitch) {
      case 0:
        srec[0].turnOnEasingFor(800);
        break;
      case 1:
        srec[0].turnOneOnEasingFor(800, 0);
        break;
      case 2:
        srec[0].turnOneOnEasingFor(800, 2);
        srec[0].turnOneOnEasingFor(800, 3);
        srec[0].turnOneOnEasingFor(800, 4);
        break;
      case 3:
        srec[0].triggerSequence(0);
        break;
      case 4:
        srec[0].triggerAsyncSequence(0);
        break;
      case 5:
        srec[0].triggerAsyncSequence(1);
        break;
      case 6:
        srec[0].triggerAsyncSequence(2);
        break;

      case 8:
        srec[1].turnOneOnEasingFor(800, 0);
        break;
      case 9:
        srec[1].turnOneOnEasingFor(800, 1);
        break;
      case 10:
        srec[1].turnOneOnEasingFor(800, 2);
        break;

      case 16:
        srec[2].turnOneOnEasingFor(800, 0);
        break;
      case 17:
        srec[2].turnOneOnEasingFor(800, 1);
        break;
      case 18:
        srec[2].turnOneOnEasingFor(800, 2);
        break;
      case 19:
        srec[2].turnFourRandSequence(20);
        break;
      case 20:
        srec[2].triggerRandBlink();
        break;

      case 24:
        srec[3].turnOneOnEasingFor(800, 0);
        srec[3].turnOneOnEasingFor(800, 1);
        srec[3].turnOneOnEasingFor(800, 2);
        srec[3].turnOneOnEasingFor(800, 3);
        break;
      case 25:
        srec[3].turnOneOnEasingFor(800, 4);
        srec[3].turnOneOnEasingFor(800, 5);
        srec[3].turnOneOnEasingFor(800, 6);
        srec[3].turnOneOnEasingFor(800, 7);
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
  println("--------");
  println("Controller Change:");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
  if (channel == 0) {
    switch(number) {
      case 16:
        waves.setBand(map(value, 0, 127, 0, pg.height - 900));
        break;
      case 17:
        waves.setAmp(map(value, 0, 127, 0, 250));
        break;
    }
  }

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
      lines.yUpdateSpd = 0.1;
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
