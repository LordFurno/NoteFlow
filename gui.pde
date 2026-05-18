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

  BPM = new GCustomSlider(this, xInitialValueButtons, yInitialValueButtons, 120, 40, "grey_blue"); 
  BPM.setLimits(120, 20, 240);
  BPM.setNumberFormat(G4P.INTEGER, 0);
  BPM.setOpaque(false);
  BPM.addEventHandler(this, "BPMSlider");

  UndoButton = new GButton(this, xInitialValueButtons+154, yInitialValueButtons+5, 70, 30); //Diff = 154
  UndoButton.setText("Undo");
  UndoButton.addEventHandler(this, "UndoClicked");

  RedoButton = new GButton(this, xInitialValueButtons+234, yInitialValueButtons+5, 70, 30); //Diff = 80
  RedoButton.setText("Redo");
  RedoButton.addEventHandler(this, "RedoClicked");

  NoteKey = new GDropList(this, xInitialValueButtons+324, yInitialValueButtons+5, 100, 80, 3, 10); //Diff = 90
  NoteKey.setItems(loadStrings("noteDurations.txt"), 0); 
  NoteKey.addEventHandler(this, "dropList1_click1");

  PlayButton = new GButton(this, xInitialValueButtons+444, yInitialValueButtons+5, 100, 30); //Diff = 120
  PlayButton.setText("Play/Pause");
  PlayButton.addEventHandler(this, "PlayClicked");

  button1 = new GButton(this, xInitialValueButtons+564, yInitialValueButtons+5, 80, 30); //Diff = 120
  button1.setText("Reset");
  button1.setLocalColorScheme(GCScheme.RED_SCHEME);
  button1.addEventHandler(this, "button1_click1");

  button2 = new GButton(this, xInitialValueButtons+654, yInitialValueButtons+5, 80, 30); //Diff = 90
  button2.setText("Save");
  button2.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  button2.addEventHandler(this, "button2_click1");

  updateGUIVisibility();
}
/* ================= EVENT HANDLERS ================= */

public void BPMSlider(GCustomSlider source, GEvent event) {
  int newTempo = int(source.getValueF());
  if (demoEqualizer.piece != null) {
    demoEqualizer.piece.tempo = newTempo;
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
  println("Save clicked");
}

/* ================= VARIABLES ================= */

GCustomSlider BPM;
GButton UndoButton;
GButton RedoButton;
GDropList NoteKey;
GLabel Notes;
GButton PlayButton;
GLabel label1;
GButton button1;
GButton button2;
