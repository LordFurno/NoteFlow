import processing.sound.*;
import g4p_controls.*;


// ---- Available instruments ----
Instrument piano;
Instrument violin;
ArrayList<Instrument> availableInstruments;

// ---- Global settings ----
int bpm = 120;
TimeSignature defaultTimeSig;
KeySignature  defaultKeySig;
int[] sharpMidi = {5, 0, 7, 2, 9, 4, 11}; // F, C, G, D, A, E, B
int[] flatMidi  = {11, 4, 9, 2, 7, 0, 5};  // B, E, A, D, G, C, F
String[] sharpMajorKeys = {"C", "G", "D", "A", "E", "B", "F#", "C#"};
String[] flatMajorKeys = {"C", "F", "Bb", "Eb", "Ab", "Db", "Gb", "Cb"};

void setup() {
  size(1000, 700); 
  frameRate(60);
  
  MusicalPiece temp = createDemo1(this);
  Demo demo1 = new Demo(temp);
  demo1.playDemo();
  
  
 
}

void draw() {
  drawScreen();
}
