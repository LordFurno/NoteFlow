import processing.sound.*;
import g4p_controls.*;

/*
TODO
Add the ability to chang key signature + time signature
Add the ability to add accidentals to the note
Draw the key signature plus clef (default to treble)
Limit the number of measures (so it doesn't go off screen)
Fix saving/loading
Fix piano sample (sounds bad)
Add a button for equalizer visualization of musical piece
Move demos to compose page
Indexout of bounds error when placing whole note in last measure (happens when you place whole note that is longer than measure)
Happens with all overflows

Fix rest drwaings, doesn't space well or look good, the half and whole rest are the same which is wrong
Add visual for back button on composer screen
*/

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
MusicalPiece userPiece; //What the user edits
Instrument composeInstrument;
float selectedDuration = 1.0;
int minEditorMidi = 48;
int maxEditorMidi = 84;
String[] instrumentNames = {"Piano", "Alto sax", "Strings"};
boolean syncingInstrumentDropdown = true;

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
  undoStack.clear();
  redoStack.clear();
  
  saveHistoryState();
  loadSavedProjects();
  

 
}

void draw() {
  drawScreen();
}

Instrument createPianoInstrument(String name){
  int[] pianoPitches = {49, 57, 65, 73, 81, 85};
  String[] pianoFiles = {
    "vscoPiano/Player_dyn2_rr1_014.wav",
    "vscoPiano/Player_dyn2_rr1_018.wav",
    "vscoPiano/Player_dyn2_rr1_022.wav",
    "vscoPiano/Player_dyn2_rr1_026.wav",
    "vscoPiano/Player_dyn2_rr1_030.wav",
    "vscoPiano/Player_dyn2_rr1_032.wav"
  };
  float[] pianoStarts = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
  return new Instrument(name, pianoPitches, pianoFiles, pianoStarts, this);
}

Instrument createAltoSaxInstrument(String name){
  int[] saxPitches = {60, 55, 74};
  String[] saxFiles = {"altoSax/C4.aif", "altoSax/G3.aif", "altoSax/D5.aif"};
  float[] saxStarts = {0.21, 0.4, 0.2};
  return new Instrument(name, saxPitches, saxFiles, saxStarts, this);
}

Instrument createStringsInstrument(String name){
  int[] stringPitches = {57, 62, 69, 72, 76, 83};
  String[] stringFiles = {
    "strings/VlnEns_susVib_A2_v2.wav",
    "strings/VlnEns_susVib_D3_v2.wav",
    "strings/VlnEns_susVib_A3_v2.wav",
    "strings/VlnEns_susVib_C4_v2.wav",
    "strings/VlnEns_susVib_E4_v2.wav",
    "strings/VlnEns_susVib_B4_v2.wav"
  };
  float[] stringStarts = {0.05, 0.05, 0.05, 0.05, 0.05, 0.05};
  return new Instrument(name, stringPitches, stringFiles, stringStarts, this);
}

Instrument createInstrumentByName(String name){
  if (name.equals("Alto sax")){
    return createAltoSaxInstrument(name);
  }
  if (name.equals("Strings")){
    return createStringsInstrument(name);
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
  userPiece.addMeasure(3);//adds 3 more measures
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
      s.amp(masterVolume * inst.volumeScale);
    }
  }
}
