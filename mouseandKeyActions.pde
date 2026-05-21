//Global Settings
int scrollbarW = 16;
int scrollbarH;
int scrollbarX;
int scrollbarY = 0;

int scrollbarMarginRight = 10;
float imageMoveAmount = 1.5;

VScrollbar featureScrollbar;
PImage featuresImg, FAQImg;

boolean isNavHovered(int i) {
  return mouseX >= navX[i] - navPad && mouseX <= navX[i] + navW[i] + navPad && mouseY >= navY - 45 && mouseY <= navY + 45;
}

void mousePressed() {
  if (showSavePopup){
    return;
  }

  if (handleDemoCardClick()) {
    return;
  }

  if (handleLibraryProjectClick()) {
    return;
  }

  if (currentScreen == composePage && handleComposeClick()){
    return;
  }

  if (currentScreen == featuresPage || currentScreen == FAQPage){
    featureScrollbar.startDrag();

    if (featureScrollbar.dragging){
      return;
    }
  }

  handleNavClick();
}
void mouseReleased() {
  if (currentScreen == featuresPage || currentScreen == FAQPage){
    featureScrollbar.stopDrag();
  }
}
void keyPressed(){
  if (currentScreen != composePage || showSavePopup){
    return;
  }

  if (key == CODED){
    if (keyCode == UP){
      editManager.changeSelectedPitch(1);
    }else if (keyCode == DOWN){
      editManager.changeSelectedPitch(-1);
    }else if (keyCode == LEFT){
      editManager.selectNextEvent(-1);
    }else if (keyCode == RIGHT){
      editManager.selectNextEvent(1);
    }
    return;
  }

  if (key == DELETE || key == BACKSPACE){
    editManager.deleteSelected();
  }else if (key == 'p' || key == 'P'){
    editManager.togglePlaceMode();
  }else if (key == 'r' || key == 'R'){
    editManager.toggleRestMode();
  }else if (key == 's' || key == 'S'){
    editManager.setSelectedAccidental(1);
  }else if (key == 'f' || key == 'F'){
    editManager.setSelectedAccidental(-1);
  }else if (key == 'n' || key == 'N'){
    editManager.setSelectedAccidental(0);
  }else if (key == 'c' || key == 'C'){
    editManager.clearSelectedAccidental();
  }
}

void handleNavClick() {
  if (mouseX > 8 && mouseX < 72 && mouseY > 16 && mouseY < 68) {
    stopActiveDemo();
    currentScreen = homePage;
    updateGUIVisibility();
    return;
  }
    
  if (currentScreen != composePage){
    if (mouseY > 80) return;

    for (int i = 0; i < navLabels.length; i++) {
      if (isNavHovered(i)) {
        stopActiveDemo();
        currentScreen = navScreens[i];
        updateGUIVisibility();
        return;
      }
    }
  }
}

boolean handleDemoCardClick() {
  if (currentScreen != demosPage){
    return false;
  }

  for (int i = 0; i < 3; i++) {
    float x = 120 + i * 290;
    float y = 320;
    float w = 200;
    float h = 150;

    if (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) {
      loadDemoIntoComposer(i);
      return true;
    }
  }

  return false;
}

boolean handleLibraryProjectClick() {
  float x1 = 150;
  float x2 = 850;
  float startY = 135;
  float buttonH = 65;
  float gap = 90;

  if (currentScreen != libraryPage){
    return false;
  }

  for (int i = 0; i < 6; i++){
    float y1 = startY + i*gap;
    float y2 = y1 + buttonH;
    
    if (mouseX >= x1 && mouseX <= x2 && mouseY >= y1 && mouseY <= y2) {
      stopActiveDemo();
      if (i < savedProjects.size()){
        loadProject(savedProjects.get(i));
      }else{
        makeBlankUserPiece("My Piece");
      }
      currentScreen = composePage;
      updateGUIVisibility();
      return true;
    }
  }

  return false;
}

boolean handleComposeClick(){
  if (userPiece == null || userPiece.tracks.size() == 0){
    return false;
  }

  if (mouseY >= yInitialValueButtons - 10){
    return false;
  }

  if (mouseX >= xInitialValueButtons + 530 && mouseX <= xInitialValueButtons + 890 && mouseY >= yInitialValueButtons - 55 && mouseY <= yInitialValueButtons - 5){
    return false;
  }

  editManager.keepTrackInRange();

  int measureID = measureFromMouse();
  if (measureID < 0){
    return false;
  }

  if (measureID >= userPiece.measureCount()){
    editManager.setStatus("Add more measures");
    return true;
  }

  Measure measure = userPiece.getMeasure(editManager.activeTrack, measureID);
  float rawBeat = ((mouseX - measureStartX(measureID)) / measureWidth()) * userPiece.timeSig.measureDuration();
  rawBeat = constrain(rawBeat, 0, userPiece.timeSig.measureDuration() - MUSIC_EPSILON);
  int eventID = eventIDAtBeat(measure, rawBeat);

  if (!editManager.placeMode){
    editManager.selectEvent(measureID, eventID);
    return true;
  }

  if (eventID < 0){
    return true;
  }

  if (measure.events.get(eventID) instanceof Note){
    editManager.selectEvent(measureID, eventID);
    return true;
  }

  MusicEvent event;
  if (editManager.placingRest){
    event = new Rest(selectedDuration);
  }else{
    int midiNote = midiFromMouseY(measureID);
    Instrument instrument = userPiece.instruments.get(editManager.activeTrack);
    event = new Note(selectedDuration, midiNote, instrument);
  }

  boolean placed = userPiece.placeEvent(editManager.activeTrack, measureID, eventID,event);
  
  if (placed){
    editManager.selectEvent(measureID, eventID);
    editManager.setStatus("Placed event");
  }
  else{
    editManager.setStatus("Could not place event");
  }
  return true;
}

MusicalPiece createDemoPiece(int demoID){
  boolean oldLoading = loadingHistoryState;
  loadingHistoryState = true;

  MusicalPiece piece;
  if (demoID == 0){
    piece = createDemo1(this);
  }else if (demoID == 1){
    piece = createDemo2(this);
  }else{
    piece = createDemo3(this);
  }

  loadingHistoryState = oldLoading;
  return piece;
}

void loadDemoIntoComposer(int demoID){
  stopActiveDemo();
  if (userPiece != null){
    userPiece.stopPlayback();
  }

  userPiece = createDemoPiece(demoID);
  if (userPiece.instruments.size() > 0){
    composeInstrument = userPiece.instruments.get(0);
  }

  editManager.resetEditor();
  applyMasterVolumeToUserPiece();
  syncInstrumentDropdown();
  saveHistoryState();
  currentScreen = composePage;
  updateGUIVisibility();
  editManager.setStatus("Loaded " + userPiece.title);
}

void startUserPieceVisual(){
  if (userPiece == null){
    return;
  }

  userPiece.stopPlayback();
  startDemoVisual(userPiece);
}

void startDemoVisual(MusicalPiece piece) {
  stopActiveDemo();
  visualReturnScreen = currentScreen;
  demoEqualizer.start(piece);
  currentScreen = demoVisualPage;
  updateGUIVisibility();
}

void stopActiveDemo() {
  if (demoEqualizer != null) {
    demoEqualizer.stop();
  }
}

void updateGUIVisibility() {
  boolean show = (currentScreen == composePage);

  BPM.setVisible(show);
  VolumeSlider.setVisible(show);

  UndoButton.setVisible(show);
  RedoButton.setVisible(show);
  NoteKey.setVisible(show);
  InstrumentKey.setVisible(show);
  PlayButton.setVisible(show);
  button1.setVisible(show);
  button2.setVisible(show);
  PrevTrackButton.setVisible(show);
  NextTrackButton.setVisible(show);
  AddTrackButton.setVisible(show);
  DeleteTrackButton.setVisible(show);
  AddMeasureButton.setVisible(show);
  DeleteMeasureButton.setVisible(show);
  VisualizeButton.setVisible(show);
  KeySignatureButton.setVisible(show);
  TimeSignatureButton.setVisible(show);

  if (!show){
    showSavePopup = false;
  }

  SaveNameBox.setVisible(show && showSavePopup);
  SaveCheckbox.setVisible(show && showSavePopup);
  ConfirmSaveButton.setVisible(show && showSavePopup);
  CloseSaveButton.setVisible(show && showSavePopup);
}
void setupFeatureScrollImage() {
  scrollbarY = toolbarH;
  scrollbarH = height - toolbarH;

  scrollbarX = width - scrollbarW - scrollbarMarginRight;

  featureScrollbar = new VScrollbar(scrollbarX, scrollbarY, scrollbarW, scrollbarH);
  featuresImg = loadImage("features.png");
  FAQImg = loadImage("FAQPage.png");
}
void drawNavbarOnTop() {
  fill(119, 61, 255);
  noStroke();
  rect(-10, -10, 1010, 80);

  fill(255);
  rect(20, 40, 30, 20);
  triangle(10, 40, 35, 10, 60, 40);

  stroke(5);
  fill(0);
  line(15, 33, 35, 10);
  line(15, 43, 35, 20);
  line(15, 33, 15, 55);
  line(35, 10, 35, 50);
  ellipse(30, 50, 10, 5);
  ellipse(10, 55, 10, 5);

  strokeWeight(2);
  textSize(25);
  fill(255);
  textAlign(LEFT);
  naviBarText();
}
void drawFeatureScrollImage() {
  background(0);

  // Pick which image to show
  PImage currentImg;

  if (currentScreen == FAQPage) {
    currentImg = FAQImg;
  } else {
    currentImg = featuresImg;
  }

  // Calculate scroll amount based on the current image
  float maxScroll = max(0, currentImg.height - (height - toolbarH));
  float scrollAmount = featureScrollbar.getScrollAmount(maxScroll);

  // Center the current image
  float imgX = width/2 - currentImg.width/2;

  image(currentImg, imgX, toolbarH - scrollAmount);

  //To cover annoying white line
  fill(0);
  noStroke();
  rect(imgX + currentImg.width - 2, toolbarH, 4, height - toolbarH);

  featureScrollbar.update();
  featureScrollbar.display();

  drawNavbarOnTop();
}

void mousePressedFeatureScrollImage() {
  featureScrollbar.startDrag();
}


void mouseReleasedFeatureScrollImage() {
  featureScrollbar.stopDrag();
}


//Scrollbar Class 
class VScrollbar {
  //Methods
  float x, y;
  int w, h;
  float sliderY;
  int sliderH = 30;

  boolean dragging = false;
  //Constructor
  VScrollbar(float tempX, float tempY, int tempW, int tempH) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;

    sliderY = y + h/2 - sliderH/2;
  }
  //Fields
  void update() {
    if (dragging) {
      sliderY = mouseY - sliderH/2;
      sliderY = constrain(sliderY, y, y + h - sliderH);
    }
  }

  void display() {
    noStroke();

    fill(204);
    rect(x, y, w, h);

    fill(122);
    rect(x, sliderY, w, sliderH);
  }

  void startDrag() {
    if (mouseOverSlider()) {
      dragging = true;
    }
  }

  void stopDrag() {
    dragging = false;
  }

  boolean mouseOverSlider() {
    return mouseX > x && mouseX < x + w && mouseY > sliderY && mouseY < sliderY + sliderH;
  }

  float getPos() {
    return map(sliderY, y, y + h - sliderH, 0, height);
  }
  float getScrollAmount(float maxScroll) {
  return map(sliderY, y, y + h - sliderH, 0, maxScroll);
}
}
