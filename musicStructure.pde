float MUSIC_EPSILON = 0.001;

class MusicEvent{
  float duration; //0.25 is sixteenth, 0.5 is eigth, 1.0 is quarter, 2.0 is half, 4.0 is whole
  //Given that the bpm is x, we have x/60 beats per second. 
  MusicEvent(float d){
    this.duration = d;
  }
  
  boolean isRest(){
    return this instanceof Rest;
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
  
  float restDuration(){
    float total = 0;
    for (MusicEvent e: events){
      if (e instanceof Rest){
        total += e.duration;
      }
    }
    return total;
  }
  
  boolean changeEvent(MusicEvent e, int i){
    //This method updates the events list, subdividing or eating rests as needed
    MusicEvent oldEvent = this.events.get(i);

    if (abs(e.duration-oldEvent.duration) < MUSIC_EPSILON){
      //If duration matches no subdividing is needed, can directly replace
      this.events.set(i, e);
      return true;
    }else if(e.duration < oldEvent.duration){
      //This means we have to add more rests to subdivide 
      int mult = int(oldEvent.duration / e.duration); //How many times the new note can fit into the old note
      float leftover = oldEvent.duration - e.duration*mult;
      //mult tells us how to subdivide this
      this.events.set(i, e);//First replace this note and then add mult-1 rests
      for (int j=1;j<=mult-1;j++){
        this.events.add(i+j, new Rest(e.duration));
      }
      if (leftover > MUSIC_EPSILON){
        this.events.add(i+mult, new Rest(leftover));
      }
      return true;
   
    }else{
      //If the new event is longer, eat the rests after it until it fits
      float needed = e.duration - oldEvent.duration;
      int j = i+1;
      while (needed > MUSIC_EPSILON && j < this.events.size()){
        MusicEvent next = this.events.get(j);
        if (!(next instanceof Rest)){
          return false;
        }
        needed -= next.duration;
        j++;
      }
      
      if (needed > MUSIC_EPSILON){
        return false;
      }
      
      this.events.set(i, e);
      
      float extra = -needed;
      for (int k=j-1;k>i;k--){
        this.events.remove(k);
      }
      if (extra > MUSIC_EPSILON){
        this.events.add(i+1, new Rest(extra));
      }
      
      return true;
    }
  }
  
  boolean isFull(){
    return abs(beatsRemaining()) < MUSIC_EPSILON; //Not exactly 0 because processing is weird
  }
  boolean canAdd(MusicEvent e){
    return restDuration() >= e.duration - MUSIC_EPSILON;
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
  
  volatile boolean playing;
  
  MusicalPiece(String name, KeySignature k, TimeSignature t, int tempo){
    this.title = name;
    this.keySig = k;
    this.timeSig = t;
    this.tempo = tempo;
    this.instruments = new ArrayList<Instrument>();
    this.tracks = new ArrayList<ArrayList<Measure>>();
    this.playing = false;
  }
  
  int measureCount(){
    if (tracks.size()==0){
      return 0;
    }
    return tracks.get(0).size();
  }
  
  Measure getMeasure(int trackID, int measureID){
    return tracks.get(trackID).get(measureID);
  }
  
  void addMeasure(int trackID, int i){ //i is the index within the track itself
     //Adds a measure to trackID track
     this.tracks.get(trackID).add(new Measure(trackID,i,this.timeSig));
  }
  
  void addMeasure(){ //Add measures for every track
    for (int t=0;t<tracks.size();t++){
      addMeasure(t, tracks.get(t).size());
    }
  }
  
  void addInstrument(Instrument instrument){
    int trackID = tracks.size(); //New index 
    instruments.add(instrument);
    tracks.add(new ArrayList<Measure>());
    
    int count = max(1, measureCount());
    for (int i=0;i<count;i++){
      addMeasure(trackID, i);
    }
  }
  
  boolean placeEvent(int trackID, int measureID, int eventID, MusicEvent event){
    Measure measure = getMeasure(trackID, measureID);
    MusicEvent oldEvent = measure.events.get(eventID);
    
    if (!(oldEvent instanceof Rest)){
      return false;
    }
    return measure.changeEvent(event, eventID);
  }
  
  boolean editEvent(int trackID, int measureID, int eventID, MusicEvent event){
    Measure measure = getMeasure(trackID, measureID);
    return measure.changeEvent(event, eventID);
  }
  
  void startPlayback(){
    play();
  }
  
  //Need to do threads for playing as to not interrupt the drawing and other issues
  void play(){
    if (playing){
      return;
    }
    
    playing = true;
    Thread playbackThread = new Thread(new Runnable() {
      public void run() {
        //1 quarter note is 1000ms at 60bpm
        float quarterMs = 60000.0 / tempo; //Converts to milliseconds
        
        for (int m=0; m<measureCount() && playing; m++){ //Goes through each measure
          float currentBeat = 0;
          
          while (currentBeat < timeSig.measureDuration() - MUSIC_EPSILON && playing){
            float smallestDuration = timeSig.measureDuration();
            //Need ot track smallest because of multiple tracks
            //Having potentially diffent beats to go through
            
            for (int t=0;t<tracks.size();t++){ //Goesthrough each track
              Measure measure = getMeasure(t, m);
              MusicEvent event = eventAtBeat(measure, currentBeat);
              
              if (event != null){//Someting there
                if (event instanceof Note){ //Is a note
                  Note n = (Note) event;
                  int resolved = measure.resolvePitch(n.midiNote, keySig);
                  n.family.playNote(resolved, n.duration);
                }else{
                  instruments.get(t).stopAll(); //Stop playing for this specific track
                }
                
                smallestDuration = min(smallestDuration, event.duration);
              }
            }
            
            waitForBeats(smallestDuration, quarterMs);
            currentBeat += smallestDuration;
          }
        }
        
        stopAllInstruments();
        playing = false;
      }
    });
    
    playbackThread.start();
  }
  
  void stopPlayback(){
    playing = false;
    stopAllInstruments();
  }
  
  MusicEvent eventAtBeat(Measure measure, float beat){
    float currentBeat = 0;
    
    for (MusicEvent event: measure.events){
      if (abs(currentBeat-beat) < MUSIC_EPSILON){
        return event;
      }
      currentBeat += event.duration;
    }
    
    return null;
  }
  
  void waitForBeats(float beats, float quarterMs){//Wait for these many beats
    try{ //Need to put this in try except bc java is annoying
      Thread.sleep((long)(beats * quarterMs));
    }
      catch (Exception e){
    }
  }
  
  void stopAllInstruments(){
    for (Instrument instrument: instruments){
      instrument.stopAll();
    }
  }
}
