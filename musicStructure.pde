class MusicEvent{
  float duration; //0.25 is sixteenth, 0.5 is eigth, 1.0 is quarter, 2.0 is half, 4.0 is whole
  //Given that the bpm is x, we have x/60 beats per second. 
  MusicEvent(float d){
    this.duration = d;
  }
}

class Measure{
  int track, id, bpm;
  TimeSignature timeSig;
  ArrayList<MusicEvent> events; //Everyihtng that happens in this measure (notes, rests, e.t.c)
  HashMap<Integer, Integer> withinMeasureAccidentals = new HashMap<Integer, Integer>();
  
  Measure(int track, int id, TimeSignature timeSig){ //i is the index of the msaure within the MusicalPiece class
    this.track = track;
    this.id = id;
    this.timeSig = timeSig;
    this.events = new ArrayList<MusicEvent>();
    this.withinMeasureAccidentals = new HashMap<Integer, Integer>();
  }
  float beatUsed(){
    float total = 0;
    for (MusicEvent e: events){
      total += e.duration;
    }
    return total;
  }
  float beatsRemaining(){
    return timeSig.measureDuration() - beatsUsed();
  }
  
  boolean isFull(){
    return beatsRemaining() < 0.001; //Not exacyl 0 because processing is weird
  }
  boolean canAdd(MusicEvent e){
    return beatsRemaining() >= e.duration - 0.001;
  }
  
  //Call this manually when a user places an accidental on a note in this measure
  void applyAccidental(int pitchClass, int modifier){
    withinMeasureAccidentals.put(pitchClass, modifier); //Future notes have same accidental
  }
  
  void clearAccidentals(){
    withinMeasureAccidentals.clear(); 
  }
  
  //Resolve when midi pitch using key sig + any within-measure accidentals
  //Within-measure accidentals take prio over key signature, this is normal music
  int resolvePitch(int midiNote, KeySignature keySig) {
    int pitchClass = midiNote%12;
    
    if (withinMeasureAccidentals.containsKey(pitchClass)) {
      return midiNote + withinMeasureAccidentals.get(pitchClass);
    }
    return keySig.modifyPitch(midiNote);
  }
}

class MusicalPiece{
  String title;
  ArrayList<Instrument> instruments;
  ArrayList<ArrayList<Measure>> tracks; //tracks.get(i) = all measures for instrument i
  KeySignature keySig;
  TimeSignature timeSig;
  int tempo; //BPM
  
  
  
}


class Note extends MusicEvent{
   int midiNote;
   Instrument family;
   Note(float d, int note, Instrument i){
     super(d);
     this.midiNote = note;
     this.family = i;
   }
   
   void play(){
     this.family.playNote(this.midiNote, this.duration); 
   }
   
}

class Rest extends MusicEvent{
  Rest(float d){
    super(d); 
  }
}
