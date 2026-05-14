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
int[] sharpMidi = {5, 0, 7, 2, 9, 4, 11};
int[] flatMidi  = {11, 4, 9, 2, 7, 0, 5};
String[] sharpMajorKeys = {"C", "G", "D", "A", "E", "B", "F#", "C#"};
String[] flatMajorKeys = {"C", "F", "Bb", "Eb", "Ab", "Db", "Gb", "Cb"};

// ---- Nav bar data ----
String[] navLabels = {"Features", "Library", "Explore Demo's", "FAQ"};
int[] navX;       // initialized in setup
int[] navW = {90, 70, 160, 42};
int[] navScreens; // initialized in setup
int navY = 50;
int navBoxH = 28;
int navPad  = 6;

void setup() {
  size(1000, 700);
  frameRate(60);

  // Now headerX and page constants exist, safe to use
  navX = new int[]{headerX, headerX+150, headerX+280, headerX+480};
  navScreens = new int[]{demosPage, libraryPage, demosPage, homePage};


  MusicalPiece temp = createDemo1(this);
  Demo demo1 = new Demo(temp);
  demo1.playDemo();

  //Save/load test
  //SavedPiece sp = new SavedPiece("data/test_save.json", temp);
  //sp.createFile();
  //MusicalPiece loaded = loadPiece("data/test_save.json", this);
  
  //println("Loaded " + loaded.title + "\n" + loaded.tempo + " BPM");
  //ArrayList<Measure> firstTrack = loaded.tracks.get(0);
  
  //for (int m=0;m<firstTrack.size();m++){
  //  Measure measure = firstTrack.get(m);
  //  print("Measure" + (m+1) + ": ");
  //  for (MusicEvent event : measure.events){
  //    if (event instanceof Note){
  //      print("Note midi = " + ((Note)event).midiNote + " dur = " + event.duration);
  //    }else{
  //      print("Rest dur = " + event.duration);
  //    }
  //    println();
  //  }
  //  println();
  //}
}

void draw() {
  drawScreen();
}
