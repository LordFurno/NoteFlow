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

public void createGUI() {
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);

  BPM = new GCustomSlider(this, 26, 10, 120, 40, "grey_blue");
  BPM.setLimits(120, 20, 240);
  BPM.setNumberFormat(G4P.INTEGER, 0);
  BPM.setOpaque(false);
  BPM.addEventHandler(this, "BPMSlider");

  UndoButton = new GButton(this, 180, 15, 70, 30);
  UndoButton.setText("Undo");
  UndoButton.addEventHandler(this, "UndoClicked");

  RedoButton = new GButton(this, 260, 15, 70, 30);
  RedoButton.setText("Redo");
  RedoButton.addEventHandler(this, "RedoClicked");

  NoteKey = new GDropList(this, 350, 15, 100, 80, 3, 10);
  NoteKey.setItems(loadStrings("noteDurations.txt"), 0);
  NoteKey.addEventHandler(this, "dropList1_click1");

  PlayButton = new GButton(this, 470, 15, 100, 30);
  PlayButton.setText("Play/Pause");
  PlayButton.addEventHandler(this, "PlayClicked");

  button1 = new GButton(this, 590, 15, 80, 30);
  button1.setText("Reset");
  button1.setLocalColorScheme(GCScheme.RED_SCHEME);
  button1.addEventHandler(this, "button1_click1");

  button2 = new GButton(this, 680, 15, 80, 30);
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
