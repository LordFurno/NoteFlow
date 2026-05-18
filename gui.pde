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
  NoteKey.setItems(loadStrings("noteDurations.txt"), 0); 
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

  // =========================
  // VOLUME SLIDER
  // =========================
  VolumeSlider = new GCustomSlider(this, xInitialValueButtons+760, yInitialValueButtons, 140, 40, "grey_blue");

  VolumeSlider.setLimits(80, 0, 100);
  VolumeSlider.setNumberFormat(G4P.INTEGER, 0);
  VolumeSlider.setOpaque(false);
  VolumeSlider.addEventHandler(this, "VolumeChanged");

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

  if (demoEqualizer.piece != null) {
    demoEqualizer.piece.tempo = newTempo;
  }
}

public void VolumeChanged(GCustomSlider source, GEvent event) {

  masterVolume = source.getValueF() / 100.0;

  for (Instrument inst : userPiece.instruments) {
    for (SoundFile s : inst.samples) {
      s.amp(masterVolume);
    }
  }
}

public void UndoClicked(GButton source, GEvent event) {
  editManager.undo();
}

public void RedoClicked(GButton source, GEvent event) {
  editManager.redo();
}

public void dropList1_click1(GDropList source, GEvent event) {
  int selected = source.getSelectedIndex();

  float[] durations = {4.0, 2.0, 1.0, 0.5, 0.25};

  println("Selected duration: " + durations[selected]);
}

public void PlayClicked(GButton source, GEvent event) {

  if (demoEqualizer.piece == null) return;

  if (demoEqualizer.piece.playing) {
    demoEqualizer.piece.stopPlayback();
    source.setText("Play");
  } else {
    demoEqualizer.piece.startPlayback();
    source.setText("Pause");
  }
}

public void button1_click1(GButton source, GEvent event) {
  println("Reset clicked");
}

public void button2_click1(GButton source, GEvent event) {

  showSavePopup = true;

  SaveNameBox.setVisible(true);
  SaveCheckbox.setVisible(true);
  ConfirmSaveButton.setVisible(true);
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

  // Close popup
  showSavePopup = false;

  SaveNameBox.setVisible(false);
  SaveCheckbox.setVisible(false);
  ConfirmSaveButton.setVisible(false);

  SaveNameBox.setText("");
  SaveCheckbox.setSelected(false);
}

/* ================= VARIABLES ================= */

GCustomSlider BPM;
GCustomSlider VolumeSlider;

GButton UndoButton;
GButton RedoButton;

GDropList NoteKey;

GLabel Notes;

GButton PlayButton;

GLabel label1;

GButton button1;
GButton button2;

GTextField SaveNameBox;
GCheckbox SaveCheckbox;
GButton ConfirmSaveButton;
