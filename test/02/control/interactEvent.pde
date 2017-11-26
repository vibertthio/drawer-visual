void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println("--------");
  println("Note On:");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);

  if (pitch == 0) {
    staticRectangles.turnOn();
  } else {
    staticRectangles.turnOff();
  }
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  println("--------");
  println("Note Off:");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println("--------");
  println("Controller Change:");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
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
