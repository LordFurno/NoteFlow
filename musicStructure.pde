class MusicEvent{
  float duration; //0.25 is sixteenth, 0.5 is eigth, 1.0 is quarter, 2.0 is half, 4.0 is whole
  
  MusicEvent(float d){
    this.duration = d;
  }
}

class Measure{
  int numBeats, maxBeats; //REPLACE THIS WITH TimeSignature class in the future
  ArrayList<MusicEvent> events; //Everyihtng that happens in this measure (notes, rests, e.t.c)
  int track, id; //Track tells us which track it is (basically what isntrument and what number instrument)
  
  Measure(int n, int m, int i){ //i is the index of the msaure within the MusicalPiece class
    this.numBeats = n;
    this.maxBeats = m;
    
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
     this.family.playNote(this.midiNote); 
   }
   
}

class Rest extends MusicEvent{
  Rest(float d){
    super(d); 
  }
}
