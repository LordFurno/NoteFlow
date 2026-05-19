/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!

 */
//Global Settings
int xInitialValueButtons = 100;
int yInitialValueButtons = 640;

public void createGUI() {
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);

  // BPM Slider
  BPM = new GCustomSlider(this, xInitialValueButtons, yInitialValueButtons, 120, 40, "grey_blue"); 
  BPM.setLimits(120, 20, 240);
  BPM.setNumberFormat(G4P.INTEGER, 0);
  BPM.setOpaque(false);
  BPM.addEventHandler(this, "BPMSlider");

  // Undo
  UndoButton = new GButton(this, xInitialValueButtons+154, yInitialValueButtons+5, 70, 30);
  UndoButton.setText("Undo");
  UndoButton.addEventHandler(this, "UndoClicked");

  // Redo
  RedoButton = new GButton(this, xInitialValueButtons+234, yInitialValueButtons+5, 70, 30);
  RedoButton.setText("Redo");
  RedoButton.addEventHandler(this, "RedoClicked");

  // Note durations
  NoteKey = new GDropList(this, xInitialValueButtons+324, yInitialValueButtons+5, 100, 80, 3, 10);
  NoteKey.setItems(loadStrings("noteDurations.txt"), 2);
  NoteKey.addEventHandler(this, "dropList1_click1");

  // Play
  PlayButton = new GButton(this, xInitialValueButtons+444, yInitialValueButtons+5, 100, 30);
  PlayButton.setText("Play/Pause");
  PlayButton.addEventHandler(this, "PlayClicked");

  // Reset
  button1 = new GButton(this, xInitialValueButtons+564, yInitialValueButtons+5, 80, 30);
  button1.setText("Reset");
  button1.setLocalColorScheme(GCScheme.RED_SCHEME);
  button1.addEventHandler(this, "button1_click1");

  // Save
  button2 = new GButton(this, xInitialValueButtons+654, yInitialValueButtons+5, 80, 30);
  button2.setText("Save");
  button2.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  button2.addEventHandler(this, "button2_click1");

  // Instruments
  InstrumentKey = new GDropList(this, xInitialValueButtons+754, yInitialValueButtons+5, 120, 80, 3, 10);
  InstrumentKey.setItems(instrumentNames, 0);
  InstrumentKey.addEventHandler(this, "InstrumentChanged");

  // =========================
  // VOLUME SLIDER
  // =========================
  VolumeSlider = new GCustomSlider(this, xInitialValueButtons, yInitialValueButtons+45, 140, 40, "grey_blue");

  VolumeSlider.setLimits(80, 0, 100);
  VolumeSlider.setNumberFormat(G4P.INTEGER, 0);
  VolumeSlider.setOpaque(false);
  VolumeSlider.addEventHandler(this, "VolumeChanged");

  // Track controls
  PrevTrackButton = new GButton(this, xInitialValueButtons+160, yInitialValueButtons+50, 80, 30);
  PrevTrackButton.setText("< Track");
  PrevTrackButton.addEventHandler(this, "PrevTrackClicked");

  NextTrackButton = new GButton(this, xInitialValueButtons+250, yInitialValueButtons+50, 80, 30);
  NextTrackButton.setText("Track >");
  NextTrackButton.addEventHandler(this, "NextTrackClicked");

  AddTrackButton = new GButton(this, xInitialValueButtons+340, yInitialValueButtons+50, 90, 30);
  AddTrackButton.setText("Add Track");
  AddTrackButton.addEventHandler(this, "AddTrackClicked");

  DeleteTrackButton = new GButton(this, xInitialValueButtons+440, yInitialValueButtons+50, 95, 30);
  DeleteTrackButton.setText("Del Track");
  DeleteTrackButton.setLocalColorScheme(GCScheme.RED_SCHEME);
  DeleteTrackButton.addEventHandler(this, "DeleteTrackClicked");

  AddMeasureButton = new GButton(this, xInitialValueButtons+545, yInitialValueButtons+50, 110, 30);
  AddMeasureButton.setText("Add Measure");
  AddMeasureButton.addEventHandler(this, "AddMeasureClicked");

  // =========================
  // SAVE POPUP CONTROLS
  // =========================

  SaveNameBox = new GTextField(this, 350, 300, 300, 40);
  SaveNameBox.setPromptText("Project Name");
  SaveNameBox.setVisible(false);

  SaveCheckbox = new GCheckbox(this, 350, 360, 280, 30);
  SaveCheckbox.setText("Confirm Save");
  SaveCheckbox.setVisible(false);

  ConfirmSaveButton = new GButton(this, 420, 420, 150, 40);
  ConfirmSaveButton.setText("Save Project");
  ConfirmSaveButton.setVisible(false);
  ConfirmSaveButton.addEventHandler(this, "ConfirmSaveClicked");

  updateGUIVisibility();
}

/* ================= EVENT HANDLERS ================= */

public void BPMSlider(GCustomSlider source, GEvent event) {
  int newTempo = int(source.getValueF());

  if (currentScreen == composePage && userPiece != null) {
    userPiece.tempo = newTempo;
  }else if (demoEqualizer.piece != null) {
    demoEqualizer.piece.tempo = newTempo;
  }
}

public void VolumeChanged(GCustomSlider source, GEvent event) {

  masterVolume = source.getValueF() / 100.0;
  applyMasterVolumeToUserPiece();
}

public void InstrumentChanged(GDropList source, GEvent event) {
  if (syncingInstrumentDropdown){
    return;
  }

  int selected = source.getSelectedIndex();

  if (selected >= 0 && selected < instrumentNames.length){
    editManager.setActiveTrackInstrument(instrumentNames[selected]);
  }
}

public void PrevTrackClicked(GButton source, GEvent event) {
  editManager.changeTrack(-1);
}

public void NextTrackClicked(GButton source, GEvent event) {
  editManager.changeTrack(1);
}

public void AddTrackClicked(GButton source, GEvent event) {
  editManager.addTrackToPiece(createInstrumentByName(selectedInstrumentName()));
  applyMasterVolumeToUserPiece();
}

public void DeleteTrackClicked(GButton source, GEvent event) {
  editManager.deleteActiveTrack();
}

public void AddMeasureClicked(GButton source, GEvent event) {
  editManager.addMeasureToPiece();
}

public void UndoClicked(GButton source, GEvent event) {
  undoAction();
  editManager.setStatus("Undo");
}

public void RedoClicked(GButton source, GEvent event) {
  redoAction();
  editManager.setStatus("Redo");
}

public void dropList1_click1(GDropList source, GEvent event) {
  int selected = source.getSelectedIndex();

  float[] durations = {4.0, 2.0, 1.0, 0.5, 0.25};

  if (selected >= 0 && selected < durations.length){
    editManager.changeSelectedDuration(durations[selected]);
  }
}

public void PlayClicked(GButton source, GEvent event) {

  MusicalPiece piece = demoEqualizer.piece;

  if (currentScreen == composePage){
    piece = userPiece;
  }

  if (piece == null) return;

  if (piece.playing) {
    piece.stopPlayback();
    source.setText("Play");
  } else {
    piece.startPlayback();
    source.setText("Pause");
  }
}

public void button1_click1(GButton source, GEvent event) {
  makeBlankUserPiece("My Piece");
  source.setText("Reset");
  PlayButton.setText("Play/Pause");
}

public void button2_click1(GButton source, GEvent event) {

  showSavePopup = true;
  updateGUIVisibility();
}

public void ConfirmSaveClicked(GButton source, GEvent event) {

  String projectName = SaveNameBox.getText().trim();

  if (projectName.equals("")) {
    println("Please enter a project name.");
    return;
  }

  if (!SaveCheckbox.isSelected()) {
    println("Please confirm save.");
    return;
  }

  saveCurrentProject(projectName);
  editManager.setStatus("Saved " + projectName);

  showSavePopup = false;
  SaveNameBox.setText("");
  SaveCheckbox.setSelected(false);
  updateGUIVisibility();
}

/* ================= VARIABLES ================= */

GCustomSlider BPM;
GCustomSlider VolumeSlider;

GButton UndoButton;
GButton RedoButton;

GDropList NoteKey;
GDropList InstrumentKey;

GLabel Notes;

GButton PlayButton;

GLabel label1;

GButton button1;
GButton button2;
GButton PrevTrackButton;
GButton NextTrackButton;
GButton AddTrackButton;
GButton DeleteTrackButton;
GButton AddMeasureButton;

GTextField SaveNameBox;
GCheckbox SaveCheckbox;
GButton ConfirmSaveButton;
