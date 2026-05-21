
class PitchData{ //Java won't return two things at once, so this keeps them together
  float rate;
  int index;
  PitchData(float r, int i){
    this.rate = r;
    this.index = i;
  }
}

class Instrument{
  String name;
  int[] samplePitches;
  SoundFile[] samples;//Preloaded
  String[] filePaths;
  float[] sampleStarts; //Where each sample starts actually playing
  int[] samplePlayID;
  float volumeScale;
  boolean letNotesRing;
  PApplet app;
  
  Instrument(String n, int[] pitches, String[] files, PApplet p){
    this(n, pitches, files, new float[files.length], p);
  }
  
  Instrument(String n, int[] pitches, String[] files, float[] starts, PApplet p){
    this.name = n;
    
    this.app = p;
    this.volumeScale = 1.0;
    this.letNotesRing = false;
    if (this.name.toLowerCase().indexOf("piano") >= 0){
      this.volumeScale = 0.85;
      this.letNotesRing = true;
    }else if (this.name.toLowerCase().indexOf("strings") >= 0 || this.name.toLowerCase().indexOf("violin") >= 0){
      this.volumeScale = 0.75;
    }
    this.samplePitches = new int[pitches.length];
    this.filePaths = new String[files.length];
    this.samples = new SoundFile[files.length];
    this.sampleStarts = new float[files.length];
    this.samplePlayID = new int[files.length];
    
    for (int i=0;i<pitches.length;i++){
      this.samplePitches[i] = pitches[i];
      this.filePaths[i] = files[i];
      this.sampleStarts[i] = starts[i];
      if (files[i].indexOf("piano/") >= 0 && this.sampleStarts[i] < 0.03){
        this.sampleStarts[i] = 0.03;
      }
      this.samples[i] = new SoundFile(this.app, files[i]);
    }
    
  }
  //Will be talking about this
  PitchData getPitchRate(int targetPitch){
    //First find the closest matching sample pitch and calculate from that
    //Minimum absolute differenc ebetween target pitch and sample
    int minDiff = 1000;
    int samplePitch = 0;
    int index = -1;
    for (int i=0;i<this.samplePitches.length;i++){
      int p = this.samplePitches[i];
      if (abs(p-targetPitch) < minDiff){
        minDiff = abs(p-targetPitch);
        samplePitch = p;
        index = i; //To keep track of the specific sample pitch file location
      }
    }

    //Calculate new rate based on samplePitch and targetPitch
    int semitoneDifference = targetPitch - samplePitch;
    //An octave is 12 semitones. 1 octave higher means the frequency doubles
    //12 semitones up means 2x frequency, and 12 semitones down be 0.5x frequency
    float rate = pow(2, semitoneDifference/12.0); //Calculates how much faster/slower to play te sample to get proper note
    return new PitchData(rate, index);
    
  }
  
  void playNote(int midiNote, float duration){
    playNote(midiNote, duration, 60000.0 / bpm);
  }

  void playNote(int midiNote, float duration, float quarterMs){
    PitchData info = getPitchRate(midiNote);
    stopAll(); //Stop all samples, not just the one about to play

    this.samplePlayID[info.index]++; //Stops old timers from stopping newer notes
    int playID = this.samplePlayID[info.index];
    this.samples[info.index].cue(this.sampleStarts[info.index]);
    this.samples[info.index].amp(masterVolume * this.volumeScale);
    this.samples[info.index].play(info.rate);

    if (letNotesRing){ //Piano notes get a timed release so they don't cut off too harshly
      stopLater(info.index, playID, noteStopMs(duration, quarterMs));
    }
  }

  float noteStopMs(float duration, float quarterMs){ //Vrey short piano notes need a minimum playback time
    float stopMs = duration * quarterMs;

    if (duration <= 0.25 + MUSIC_EPSILON){
      stopMs = max(150, stopMs);
    }else if (duration <= 0.5 + MUSIC_EPSILON){
      stopMs = max(180, stopMs);
    }

    return stopMs;
  }

  void stopLater(final int index, final int playID, final float waitMs){
    Thread stopThread = new Thread(new Runnable() {
      public void run() {
        try{
          Thread.sleep((long)waitMs);
        }
        catch (Exception e){
        }

        if (samplePlayID[index] == playID){
          samples[index].stop();
        }
      }
    });

    stopThread.start();
  }

  void stopForRest(){
    if (!letNotesRing){
      stopAll();
    }
  }
  
  void stopAll(){
    for (int i=0;i<this.samples.length;i++){
      this.samplePlayID[i]++;
      this.samples[i].stop();
    }
  }
}
