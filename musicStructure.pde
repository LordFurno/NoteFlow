class MusicEvent{
  float duration; //0.25 is sixteenth, 0.5 is eigth, 1.0 is quarter, 2.0 is half, 4.0 is whole
  //Given that the bpm is x, we have x/60 beats per second. 
  MusicEvent(float d){
    this.duration = d;
  }
}

class Measure{
  int numBeats, maxBeats; //REPLACE THIS WITH TimeSignature class in the future
  ArrayList<MusicEvent> events; //Everyihtng that happens in this measure (notes, rests, e.t.c)
  int track, id; //Track tells us which track it is (basically what isntrument and what number instrument)
  int bpm;
  Measure(int n, int m, int i, int b){ //i is the index of the msaure within the MusicalPiece class
    this.numBeats = n;
    this.maxBeats = m;
    this.bpm = b;
    
  }
  
  float beatToMillis(float beats){
    //Beats is the value of the note (quarter, eight,e.t.c)
    return beats*(60.0/this.bpm)*1000.0;
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
