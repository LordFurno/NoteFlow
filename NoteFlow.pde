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

EditManager editManager;
MusicalPiece userPiece;
Instrument composeInstrument;
float selectedDuration = 1.0;

// ---- Save Popup ----
boolean showSavePopup = false;
String projectNameInput = "";
boolean confirmSaveChecked = false;
ArrayList<String> savedProjects = new ArrayList<String>();

// ---- Volume ----
float masterVolume = 0.8;


// ---- Nav bar data ----
String[] navLabels = {"Features", "Library", "Explore Demo's", "FAQ"};
int[] navX;       
int[] navW = {90, 70, 160, 42};
int[] navScreens; 
int navY = 50;
int navBoxH = 28;
int navPad = 6;

// ---- Demo visualizer data ----
DemoEqualizer demoEqualizer;

void setup() {
  size(1000, 730);
  frameRate(60);

  navX = new int[]{headerX, headerX+150, headerX+280, headerX+480};
  navScreens = new int[]{demosPage, libraryPage, demosPage, homePage};
  demoEqualizer = new DemoEqualizer();
  editManager = new EditManager();
  
  createGUI();
  

  //Create the default composition instrument
  int[] pianoPitches = {60};
  String[] pianoFiles = {"piano/C4.aiff"};
  float[] pianoStarts = {0.0};
  composeInstrument = new Instrument("Piano", pianoPitches, pianoFiles, pianoStarts, this);
  
  //Create blank 4 measure piece in C major, 4/4
  userPiece = new MusicalPiece("My Piece", new KeySignature(true, 0), new TimeSignature(4, 4), 120);
  userPiece.addInstrument(composeInstrument);
  userPiece.addMeasures(3);//adds 3 more measures
  
  loadSavedProjects();
  
  
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
