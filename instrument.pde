
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
  PApplet app;
  Instrument(String n, int[] pitches, String[] files, PApplet p){
    this.name = n;
    
    this.app = p;
    this.samplePitches = new int[pitches.length];
    this.filePaths = new String[files.length];
    this.samples = new SoundFile[files.length];
    
    for (int i=0;i<pitches.length;i++){
      this.samplePitches[i] = pitches[i];
      this.filePaths[i] = files[i];
      this.samples[i] = new SoundFile(this.app, files[i]);
    }
    
  }
  
  PitchData getPitchRate(int targetPitch){
    //First find the closest matching sample pitch and calculate from that
    int minDiff = 1000;
    int samplePitch = 0;
    int index = -1;
    for (int i=0;i<this.samplePitches.length;i++){
      int p = this.samplePitches[i];
      if (abs(p-targetPitch) < minDiff){
        //This is better
        minDiff = abs(p-targetPitch);
        samplePitch = p;
        index = i; //To keep track of the specific sample pitch file location
      }
    }
    //Calculate new rate based on samplePitch and targetPitch
    int semitoneDifference = targetPitch - samplePitch;
    float rate = pow(2, semitoneDifference/12.0);
    return new PitchData(rate, index);
    
  }
  
  void playNote(int midiNote, float duration){
    PitchData info = getPitchRate(midiNote);
    this.samples[info.index].stop();
    this.samples[info.index].rate(info.rate);
    this.samples[info.index].play();
    
  }
  
  void stopAll(){
    for (SoundFile s: this.samples){
      s.stop();
    }
  }
}
