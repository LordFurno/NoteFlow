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
int minEditorMidi = 48;
int maxEditorMidi = 84;
String[] instrumentNames = {"Piano", "Alto sax"};
boolean syncingInstrumentDropdown = false;

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
  
  //Create blank 4 measure piece in C major, 4/4
  makeBlankUserPiece("My Piece");
  
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

Instrument createPianoInstrument(String name){
  int[] pianoPitches = {60};
  String[] pianoFiles = {"piano/C4.aiff"};
  float[] pianoStarts = {0.0};
  return new Instrument(name, pianoPitches, pianoFiles, pianoStarts, this);
}

Instrument createAltoSaxInstrument(String name){
  int[] saxPitches = {60, 55, 74};
  String[] saxFiles = {"altoSax/C4.aif", "altoSax/G3.aif", "altoSax/D5.aif"};
  float[] saxStarts = {0.21, 0.4, 0.2};
  return new Instrument(name, saxPitches, saxFiles, saxStarts, this);
}

Instrument createInstrumentByName(String name){
  if (name.equals("Alto sax")){
    return createAltoSaxInstrument(name);
  }

  return createPianoInstrument("Piano");
}

String selectedInstrumentName(){
  if (InstrumentKey == null){
    return "Piano";
  }

  int selected = InstrumentKey.getSelectedIndex();
  if (selected >= 0 && selected < instrumentNames.length){
    return instrumentNames[selected];
  }

  return "Piano";
}

int instrumentIndexForName(String name){
  for (int i=0;i<instrumentNames.length;i++){
    if (instrumentNames[i].equals(name)){
      return i;
    }
  }

  return 0;
}

void syncInstrumentDropdown(){
  if (InstrumentKey == null || userPiece == null || userPiece.instruments.size() == 0){
    return;
  }

  editManager.keepTrackInRange();
  String name = userPiece.instruments.get(editManager.activeTrack).name;
  syncingInstrumentDropdown = true;
  InstrumentKey.setItems(instrumentNames, instrumentIndexForName(name));
  syncingInstrumentDropdown = false;
}

void makeBlankUserPiece(String title){
  if (userPiece != null){
    userPiece.stopPlayback();
  }

  composeInstrument = createPianoInstrument("Piano");
  userPiece = new MusicalPiece(title, new KeySignature(true, 0), new TimeSignature(4, 4), 120);
  userPiece.addInstrument(composeInstrument);
  userPiece.addMeasures(3);//adds 3 more measures
  applyMasterVolumeToUserPiece();

  if (editManager != null){
    editManager.resetEditor();
  }

  syncInstrumentDropdown();
}

void applyMasterVolumeToUserPiece(){
  if (userPiece == null){
    return;
  }

  for (Instrument inst : userPiece.instruments) {
    for (SoundFile s : inst.samples) {
      s.amp(masterVolume);
    }
  }
}
