class MusicEvent{
  float duration; //0.25 is sixteenth, 0.5 is eigth, 1.0 is quarter, 2.0 is half, 4.0 is whole
  //Given that the bpm is x, we have x/60 beats per second. 
  MusicEvent(float d){
    this.duration = d;
  }
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

class Measure{
  int track, id, bpm; //What track this belongs to, the id is the index within the track
  TimeSignature timeSig;
  ArrayList<MusicEvent> events; //Everyihtng that happens in this measure (notes, rests, e.t.c)
  //I keep this as an arraylist to keep general processing simple, but in theory the max length of htis list is set (based on the time signature)
  HashMap<Integer, Integer> withinMeasureAccidentals = new HashMap<Integer, Integer>();
  
  Measure(int track, int id, TimeSignature timeSig){ //id is the index of the measure within the MusicalPiece class for that specific track
    this.track = track;
    this.id = id;
    this.timeSig = timeSig;
    this.events = new ArrayList<MusicEvent>();
    
    for (int i=0;i<this.timeSig.beatsPerMeasure();i++){
      //Intialize it with the proper rests for this time signature
      Rest r = new Rest(this.timeSig.beatDuration());
      this.events.add(r);
    }
    
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
    return timeSig.measureDuration() - beatUsed();
  }
  
  void addEvent(MusicEvent e, int i){ 
    //This is a pretty complicated method
    //Here is how this works:
    //We have an index i where this new note is being added.
    //This method iwl update the events list, to usbdivide the surrounding rests, and add/remove rests
    //The idea is that we're replacing the i'th note in events list.
    if (e.duration==this.events.get(i).duration){
      //If duration matches no subdividing is needed, can directly replace
      this.events.set(i, e);
    }else if(e.duration < this.events.get(i).duration){
      //This means we have to add more rests to subdivide 
      //Note that this shold always be an integer, so don't nede to worry aobut that
      int mult = int(this.events.get(i).duration / e.duration); //How many times the new note can fit into the old note
      //mult tells us how to subdivide this
      this.events.set(i, e);//Firs treplace this note and then add mult-1 rests
      for (int j=1;j<=mult-1;j++){
        this.events.add(i+j, new Rest(e.duration));
      }
   
    }else{
      //This is where it get complicated, because in theory old stuff shold just getpushed forward, but that funcaionlity
      //doesn't work at tihs level of abstraction. That's a musicPiece level method, hmmm
      //For now just ignore if it would exceed
      if (canAdd(e){
         
      }
      
    }
    
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
  int resolvePitch(int midiNote, KeySignature keySig){
    int pitchClass = midiNote%12;
    
    if (withinMeasureAccidentals.containsKey(pitchClass)){
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
  
  MusicalPiece(String name, KeySignature k, TimeSignature t, int tempo){
    this.title = name;
    this.keySig = k;
    this.timeSig = t;
    this.tempo = tempo;
  }
  
  void addMeasure(int trackID, int i){ //i is the index within the track itself
     //Adds a measure to trackID track
     this.tracks.get(trackID).add(new Measure(trackID,i,this.timeSig));
  }
  
  void addTrack(){
    int trackID = tracks.size(); //New index 
    tracks.add(new ArrayList<Measure>());
    addMeasure(trackID, 0); //0 because first measure within this track
  }
  
  
}
