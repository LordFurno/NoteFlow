class DemoEqualizer {
  MusicalPiece piece;
  int startMs = 0;
  float[] bars = new float[12];
  String[] labels = {"C","C#","D","D#","E","F","F#","G","G#","A","A#","B"};
  //Different colours for each track/intsrument
  void start(MusicalPiece newPiece){
    stop();
    piece = newPiece;
    startMs = millis();
    clearBars();
    piece.startPlayback();
  }

  void stop(){
    if (piece != null){
      piece.stopPlayback();
      piece = null;
    }
  }

  String displayTitle(){
    if (piece == null){
      return "Demo Equalizer";
    }
    return piece.title + " Equalizer";
  }

  boolean draw(){
    if (piece == null){
      textSize(24);
      fill(255);
      textAlign(CENTER);
      text("Click a demo card to start the visualizer", width/2, 350);
      decayBars();
      drawBars();
      return false;
    }

    if (updateBars()){
      stop();
      return true;
    }

    drawBars();
    drawProgress();
    return false;
  }

  boolean updateBars(){ //Updates bars by going through the music piece itself
    decayBars(); //Have them go down

    float quarterMs = 60000.0 / this.piece.tempo; //How many milliseconds for one quarter note
    float totalBeat = (millis() - startMs) / quarterMs; //How many beats have passed since the demo has started
    
    float measureDuration = this.piece.timeSig.measureDuration(); 
    int measureID = int(totalBeat / measureDuration); //Finds the current measure based on total beats

    if (measureID >= this.piece.measureCount()){
      return true;
    }

    float beatInMeasure = totalBeat - measureID * measureDuration; //Beat position in the current measure

    for (int t=0;t<this.piece.tracks.size();t++){ //For each track
      if (measureID >= this.piece.tracks.get(t).size()){
        continue;
      }

      Measure measure = this.piece.getMeasure(t, measureID); //Current measure
      float currentBeat = 0;

      for (MusicEvent event: measure.events){
        float nextBeat = currentBeat + event.duration;

        if (beatInMeasure >= currentBeat - MUSIC_EPSILON && beatInMeasure < nextBeat - MUSIC_EPSILON){
          //If this event is in beat
          boostBar(event, measure, beatInMeasure, currentBeat);
        }

        currentBeat = nextBeat;
      }
    }

    return false;
  }

  void boostBar(MusicEvent event, Measure measure, float beatInMeasure, float eventBeat){
    if (event instanceof Note){
      Note n = (Note) event;
      int midiNote = measure.resolveEventPitch(n, piece.keySig);
      int bar = midiNote % bars.length; //What note based on midi

      float noteAge = beatInMeasure - eventBeat;
      float strength = 1.0 - (noteAge / max(event.duration, MUSIC_EPSILON)) * 0.45; //Scale strength based on duration
      float targetHeight = map(midiNote, 50, 90, 90, 330) * strength;

      bars[bar] = max(bars[bar], targetHeight);
    }
  }

  void decayBars(){
    for (int i=0;i<bars.length;i++){
      bars[i] *= 0.9;
    }
  }

  void clearBars(){
    for (int i=0;i<bars.length;i++){
      bars[i] = 0;
    }
  }

  void drawBars(){
    float left = 100;
    float bottom = 610;
    float barGap = 10;
    float barW = (width - left*2 - barGap*11) / 12.0;

    noStroke();
    for (int i=0;i<bars.length;i++){
      float x = left + i * (barW + barGap);
      float h = constrain(bars[i], 18, 360);

      fill(255, 255, 255, 35);
      rect(x, bottom - 360, barW, 360, 5);

      fill(119, 61, 255);
      rect(x, bottom - h, barW, h, 5);

      fill(255, 220);
      rect(x, bottom - h, barW, min(12, h), 5);

      fill(255);
      textSize(14);
      textAlign(CENTER);
      text(labels[i], x + barW/2, bottom + 25);
    }
  }

  void drawProgress(){
    float quarterMs = 60000.0 / piece.tempo;
    float totalBeat = (millis() - startMs) / quarterMs;
    float measureDuration = piece.timeSig.measureDuration();
    int measureID = int(totalBeat / measureDuration);
    float beatInMeasure = totalBeat - measureID * measureDuration;

    textSize(22);
    fill(255);
    textAlign(CENTER);
    text("Measure " + (measureID+1) + "  Beat " + nf(beatInMeasure+1, 1, 2), width/2, 205);
  }
}
