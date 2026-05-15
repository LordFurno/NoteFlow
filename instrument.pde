
class PitchData{ //Have to do this bceause I want to return multiple values and java is annoying
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
  PApplet app;
  
  Instrument(String n, int[] pitches, String[] files, PApplet p){
    this(n, pitches, files, new float[files.length], p);
  }
  
  Instrument(String n, int[] pitches, String[] files, float[] starts, PApplet p){
    this.name = n;
    
    this.app = p;
    this.samplePitches = new int[pitches.length];
    this.filePaths = new String[files.length];
    this.samples = new SoundFile[files.length];
    this.sampleStarts = new float[files.length];
    
    for (int i=0;i<pitches.length;i++){
      this.samplePitches[i] = pitches[i];
      this.filePaths[i] = files[i];
      this.sampleStarts[i] = starts[i];
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
    PitchData info = getPitchRate(midiNote);
    stopAll(); //Stop all samples, not just the one about to play (prevents overlap when switching between sample files)
    this.samples[info.index].cue(this.sampleStarts[info.index]);
    this.samples[info.index].play(info.rate);

  }
  
  void stopAll(){
    for (SoundFile s: this.samples){
      s.stop();
    }
  }
}
