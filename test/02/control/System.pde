class StaticRectangles {
  PGraphics pg;
  StaticRectangle[] strips;
  int nOfStrips = 3;
  int nOfCol = 1;

  StaticRectangles(PGraphics _p) {
    pg = _p;
    strips = new StaticRectangle[nOfStrips];
    float w = pg.width / 3.0;
    float h = pg.height;
    strips[0] = new StaticRectangle(pg, 0, 0, 0, w, h);
    strips[1] = new StaticRectangle(pg, 1, w, 0, w, h);
    strips[2] = new StaticRectangle(pg, 2, w * 2, 0, w, h);
  }
  public void draw() {
    // println("draw");
    update();
    render();
  }
  void update() {
    updateSequence();
    updateComplexSequence();
    updateAsyncSequence();
    updateComplexAsyncSequence();
  }
  void render() {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].draw();
    }
  }

  void turnOn() {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].turnOn();
    }
  }
  void turnOn(int time) {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].turnOn(time);
    }
  }
  void turnOnEasing(int time) {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].turnOnEasing(time);
    }
  }
  void turnOnFor(int time, int ll) {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].turnOnFor(time, ll);
    }
  }
  void turnOnEasingFor(int time) {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].turnOnEasingFor(time);
    }
  }
  void turnOnEasingForCol(int time, int col) {
    int nInCol = nOfStrips / nOfCol;
    for (int i = col * nInCol, n = (col + 1) * nInCol; i < n; i += 1) {
      strips[i].turnOnEasingFor(time);
    }
  }
  void turnOneOn(int id) {
    strips[id].turnOn();
  }
  void turnOneOn(int id, int time) {
    strips[id].turnOn(time);
  }
  void turnOneOnFor(int id, int time, int ll) {
    strips[id].turnOnFor(time, ll);
  }
  void turnRandOneOnFor(int time, int ll) {
    turnOneOnFor(int(random(nOfStrips)),time, ll);
  }
  void turnRandMultipleOnFor(int time, int ll) {
    final int NUM = int(random(nOfStrips));
    final IntList nums = new IntList(NUM);

    for (int rnd, i = 0; i != NUM; nums.append(rnd), ++i)
    do {
      rnd = (int) random(nOfStrips);
    } while (nums.hasValue(rnd));

    for (int i = 0; i < NUM; i++) {
      turnOneOnFor(nums.get(i), time, ll);
    }
  }
  void turnMultipleOnFor(int time, int ll, int number) {
    final int NUM = number;
    final IntList nums = new IntList(NUM);

    for (int rnd, i = 0; i != NUM; nums.append(rnd), ++i)
    do {
      rnd = (int) random(nOfStrips);
    } while (nums.hasValue(rnd));

    for (int i = 0; i < NUM; i++) {
      turnOneOnFor(nums.get(i), time, ll);
    }
  }
  void turnOff() {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].turnOff();
    }
  }
  void turnOff(int time) {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].turnOff(time);
    }
  }
  void turnOffEasing(int time) {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].turnOffEasing(time);
    }
  }
  void turnOneOff(int id) {
    strips[id].turnOff();
  }
  void turnOneOff(int id, int time) {
    strips[id].turnOff(time);
  }
  void dimRepeat(int time, int ll) {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].dimRepeat(time, ll);
    }
  }
  void dimRepeatCol(int time, int ll, int col) {
    int nInCol = nOfStrips / nOfCol;
    for (int i = col * nInCol, n = (col + 1) * nInCol; i < n; i += 1) {
      strips[i].dimRepeat(time, ll);
    }
  }
  void blink() {
    for (int i = 0; i < nOfStrips; i++) {
      strips[i].blink();
    }
  }

  boolean turnSequenceActivate = false;
  int sequenceTriggerIndex = 0;
  boolean bangSequence = false;
  int turnSequenceTime = 100;
  int turnSequenceIndex = 0;
  int turnSequenceCount = 0;
  int turnSequenceCountLimit = 5;
  int[][] sequenceSet = {
    { 0, 7, 8 }, // 0
    { 3, 4, 11 },
    { 0, 3, 4, 7, 8, 11 },
    { 0, 4, 8, 1, 5, 9, 2, 6, 10, 3, 7, 11 },
    { 0, 11, 4, 8 },
    { 9, 2, 1, 10 }, // 5
    { 0, 4, 8, 1, 5, 9 },
    { 10, 6, 2, 11, 7, 3 },
    { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
    { 8, 9, 10, 11, 4, 5, 6, 7, 0, 1, 2, 3 },
    { 0, 1, 2, 3}, // 10
    { 3, 2, 1, 0},
    { 0, 3, 2, 1},
    { 0, 2, 1, 3},
    { 4, 5, 6, 7},
    { 7, 6, 5, 4}, // 15
    { 4, 7, 5, 6},
    { 7, 5, 6, 4},
    { 8, 9, 10, 11},
    { 11, 10, 9, 8},
    { 8, 11, 10, 9}, // 20
    { 8, 10, 9, 11},
    { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},
    { 11, 10, 9, 8, 3, 2, 1, 0 },
    { 0, 1, 2, 3, 8, 9, 10, 11 },
    { 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1 ,0}, // 25
    { 0, 7, 8, 3, 4, 11},
    { 11, 4, 3, 8, 7, 0},
    { 0, 1, 2, 3, 7, 6, 5, 4, 8, 9, 10, 11,
      10, 9, 8, 4, 5, 6, 7, 3, 2, 1, 0 },
    { 3, 2, 1, 0, 4, 5, 6, 7, 11, 10, 9, 8,
      9, 10, 11, 7, 6, 5, 4, 0, 1, 2, 3 },
    { 0, 0, 0, 0}, // 30 // this one if for random sequence, don't modify it
  };
  int[] sequence;

  void triggerSequence() {
    triggerSequence(sequenceTriggerIndex);
    // turnSequenceActivate = !turnSequenceActivate;
    // turnSequenceCount = 0;
  }
  void triggerSequence(int index) {
    turnOff();
    if (index == sequenceTriggerIndex) {
      turnSequenceActivate = !turnSequenceActivate;
    } else {
      turnSequenceActivate = true;
    }

    sequenceTriggerIndex = index;
    sequence = sequenceSet[index%sequenceSet.length];
    turnSequenceIndex = 0;
    turnSequenceCount = 0;
  }
  void triggerSequence(int index, int time) {
    triggerSequence(index);
    turnSequenceTime = time;
  }
  void bangSequence(int index, int time) {
    triggerSequence(index, time);
    bangSequence = true;
  }
  void updateSequence() {
    if (turnSequenceActivate) {
      turnSequenceCount++;
      if (turnSequenceCount > turnSequenceCountLimit) {
        // int prev = (turnSequenceIndex > 0)? (turnSequenceIndex - 1) : (sequence.length - 1);
        // turnOneOn(sequence[turnSequenceIndex], turnSequenceTime);
        // turnOneOff(sequence[prev], turnSequenceTime);
        turnOneOnFor(sequence[turnSequenceIndex], turnSequenceTime, 20);
        turnSequenceIndex = (turnSequenceIndex + 1) % sequence.length;
        turnSequenceCount = 0;

        if (bangSequence && turnSequenceIndex == 0) {
          triggerSequence();
          bangSequence = false;
        }
      }
    }
  }

  // complex sequence (一次會執行不只一條燈)
  boolean complexSequenceActivate = false;
  int complexSequenceTriggerIndex = 0;
  boolean bangComplexSequence = false;
  int complexSequenceTime = 20;
  int complexSequenceDur = 50;
  int complexSequenceIndex = 0;
  int complexSequenceCount = 0;
  int complexSequenceCountLimit = 5;
  int[][][] complexSequenceSet = {
    {
      {0, 1, 2, 3},
      {4, 5, 6, 7},
      {8, 9, 10, 11},
    },
    {
      {8, 9, 10, 11},
      {4, 5, 6, 7},
      {0, 1, 2, 3},
    },
    {
      {0, 4, 8},
      {1, 5, 9},
      {2, 6, 10},
      {3, 7, 11},
    },
    {
      {3, 7, 11},
      {2, 6, 10},
      {1, 5, 9},
      {0, 4, 8},
    },
  };
  int[][] complexSequence;
  void triggerComplexSequence() {
    triggerComplexSequence(complexSequenceTriggerIndex);
    // complexSequenceActivate = !complexSequenceActivate;
    // complexSequenceCount = 0;
  }
  void triggerComplexSequence(int index) {
    if (index == complexSequenceTriggerIndex) {
      complexSequenceActivate = !complexSequenceActivate;
    } else {
      complexSequenceActivate = true;
    }

    complexSequenceTriggerIndex = index;
    complexSequence = complexSequenceSet[index%complexSequenceSet.length];
    complexSequenceIndex = 0;
    complexSequenceCount = 0;
  }
  void bangComplexSequence(int index) {
    triggerComplexSequence(index);
    bangComplexSequence = true;
  }
  void updateComplexSequence() {
    if (complexSequenceActivate) {
      complexSequenceCount++;
      if (complexSequenceCount > complexSequenceCountLimit) {
        for (int i = 0, n = complexSequence[complexSequenceIndex].length; i < n; i++) {
          turnOneOnFor(complexSequence[complexSequenceIndex][i], complexSequenceDur, complexSequenceTime);
        }
        complexSequenceIndex = (complexSequenceIndex + 1) % complexSequence.length;
        complexSequenceCount = 0;

        if (bangComplexSequence && complexSequenceIndex == 0) {
          triggerComplexSequence();
          bangComplexSequence = false;
        }
      }
    }
  }



  // asynce sequence （同個數字要被cue到兩次才會開關。 一次亮暗一條）
  boolean asyncSequenceActivate = false;
  int asyncSequenceTriggerIndex = 0;
  boolean bangAsyncSequence = false;
  int asyncSequenceTime = 50;
  int asyncSequenceIndex = 0;
  int asyncSequenceCount = 0;
  int asyncSequenceCountLimit = 2;
  int[][] asyncSequenceSet = {
    { 0, 1, 2, 3, 3, 2, 1, 0 },     //0
    { 4, 5, 6, 7, 7, 6, 5, 4 },
    { 8, 9, 10, 11, 11, 10, 9, 8 },

    { 3, 2, 1, 0, 0, 1, 2, 3 },
    { 7, 6, 5, 4, 4, 5, 6, 7 },
    { 11, 10, 9, 8, 8, 9, 10, 11 },  //5

    { 0, 1, 2, 3, 7, 6, 5, 4, 8, 9, 10, 11,
      11, 10, 9, 8, 4, 5, 6, 7, 3, 2, 1, 0 },  //6
    { 3, 2, 1, 0, 4, 5, 6, 7, 11, 10, 9, 8,
      8, 9, 10, 11, 7, 6, 5, 4, 0, 1, 2, 3 },  //7
  };
  boolean[] asyncRecord = {
    false, false, false, false,
    false, false, false, false,
    false, false, false, false,
  };
  int[] asyncSequence;

  void triggerAsyncSequence() {
    triggerAsyncSequence(asyncSequenceTriggerIndex);
    // asyncSequenceActivate = !asyncSequenceActivate;
    // asyncSequenceCount = 0;
  }
  void triggerAsyncSequence(int index) {
    for (int i = 0, n = nOfStrips; i < n; i++) {
      asyncRecord[i] = false;
    }
    turnOff();
    if (index == asyncSequenceTriggerIndex) {
      asyncSequenceActivate = !asyncSequenceActivate;
    } else {
      asyncSequenceActivate = true;
    }

    asyncSequenceTriggerIndex = index;
    asyncSequence = asyncSequenceSet[index%asyncSequenceSet.length];
    asyncSequenceIndex = 0;
    asyncSequenceCount = 0;
  }
  void bangAsyncSequence(int index) {
    triggerAsyncSequence(index);
    bangAsyncSequence = true;
  }
  void updateAsyncSequence() {
    if (asyncSequenceActivate) {
      asyncSequenceCount++;
      if (asyncSequenceCount > asyncSequenceCountLimit) {

        if (asyncRecord[asyncSequence[asyncSequenceIndex]]) {
          turnOneOff(asyncSequence[asyncSequenceIndex], asyncSequenceTime);
        } else {
          turnOneOn(asyncSequence[asyncSequenceIndex], asyncSequenceTime);
        }
        asyncRecord[asyncSequence[asyncSequenceIndex]] = !asyncRecord[asyncSequence[asyncSequenceIndex]];
        asyncSequenceIndex = (asyncSequenceIndex + 1) % asyncSequence.length;
        asyncSequenceCount = 0;

        if (bangAsyncSequence && asyncSequenceIndex == 0) {
          triggerAsyncSequence();
          bangAsyncSequence = false;
        }
      }
    }
  }

  // complex async sequence （一次亮暗好幾條）
  boolean complexAsyncSequenceActivate = false;
  int complexAsyncSequenceTriggerIndex = 0;
  boolean bangComplexAsyncSequence = false;
  int complexAsyncSequenceTime = 50;
  int complexAsyncSequenceIndex = 0;
  int complexAsyncSequenceCount = 0;
  int complexAsyncSequenceCountLimit = 3;
  int[][][] complexAsyncSequenceSet = {
    {
      { 0, 4, 8 },
      { 1, 5, 9 },
      { 2, 6, 10 },
      { 3, 7, 11 },
      { 3, 7, 11 },
      { 2, 6, 10 },
      { 1, 5, 9 },
      { 0, 4, 8 },
    },
    {
      { 3, 7, 11 },
      { 2, 6, 10 },
      { 1, 5, 9 },
      { 0, 4, 8 },
      { 0, 4, 8 },
      { 1, 5, 9 },
      { 2, 6, 10 },
      { 3, 7, 11 },
    },
  };
  boolean[] complexAsyncRecord = {
    false, false, false, false,
    false, false, false, false,
    false, false, false, false,
  };
  int[][] complexAsyncSequence;

  void triggerComplexAsyncSequence() {
    triggerComplexAsyncSequence(complexAsyncSequenceTriggerIndex);
    // complexAsyncSequenceActivate = !complexAsyncSequenceActivate;
    // complexAsyncSequenceCount = 0;
  }
  void triggerComplexAsyncSequence(int index) {
    for (int i = 0, n = nOfStrips; i < n; i++) {
      complexAsyncRecord[i] = false;
    }
    turnOff();
    if (index == complexAsyncSequenceTriggerIndex) {
      complexAsyncSequenceActivate = !complexAsyncSequenceActivate;
    } else {
      complexAsyncSequenceActivate = true;
    }

    complexAsyncSequenceTriggerIndex = index;
    complexAsyncSequence = complexAsyncSequenceSet[index%complexAsyncSequenceSet.length];
    complexAsyncSequenceIndex = 0;
    complexAsyncSequenceCount = 0;
  }
  void bangComplexAsyncSequence(int index) {
    triggerComplexAsyncSequence(index);
    bangComplexAsyncSequence = true;
  }
  void updateComplexAsyncSequence() {
    if (complexAsyncSequenceActivate) {
      complexAsyncSequenceCount++;
      if (complexAsyncSequenceCount > complexAsyncSequenceCountLimit) {

        int[] cas = complexAsyncSequence[complexAsyncSequenceIndex];
        for (int i = 0, n = cas.length; i < n; i++) {
          if (complexAsyncRecord[cas[i]]) {
            turnOneOff(cas[i], complexAsyncSequenceTime);
          } else {
            turnOneOn(cas[i], complexAsyncSequenceTime);
          }
          complexAsyncRecord[cas[i]] = !complexAsyncRecord[cas[i]];
        }
        complexAsyncSequenceIndex = (complexAsyncSequenceIndex + 1) % complexAsyncSequence.length;
        complexAsyncSequenceCount = 0;

        if (bangComplexAsyncSequence && complexAsyncSequenceIndex == 0) {
          triggerComplexAsyncSequence();
          bangComplexAsyncSequence = false;
        }
      }
    }
  }


  // rand sequence, length = 4
  final int RANDSEQUENCE = 30;
  void turnFourRandSequence(int time) {
    final int NUM = 4;
    final IntList nums = new IntList(NUM);

    for (int rnd, i = 0; i <= NUM; nums.append(rnd), ++i)
    do {
      rnd = (int) random(nOfStrips);
    } while (nums.hasValue(rnd));

    for (int i = 0; i < NUM; i++) {
      sequenceSet[RANDSEQUENCE][i] = nums.get(i);
    }
    triggerSequence(RANDSEQUENCE, time);
  }
  void bangFourRandSequence(int time) {
    final int NUM = 4;
    final IntList nums = new IntList(NUM);

    for (int rnd, i = 0; i <= NUM; nums.append(rnd), ++i)
    do {
      rnd = (int) random(nOfStrips);
    } while (nums.hasValue(rnd));

    for (int i = 0; i < NUM; i++) {
      sequenceSet[RANDSEQUENCE][i] = nums.get(i);
    }
    bangSequence(RANDSEQUENCE, time);
  }

  // rand on off
  int randomDimOnOffTime = 100;
  void turnRandOneOn() {
    int rnd;
    do {
      rnd = (int) random(nOfStrips);
    }  while (strips[rnd].alpha > 0);
    turnOneOn(rnd, randomDimOnOffTime);
  }
  void turnRandOneOff() {
    int rnd;
    do {
      rnd = (int) random(nOfStrips);
    }  while (strips[rnd].alpha < 100);
    turnOneOff(rnd, randomDimOnOffTime);
  }

}
