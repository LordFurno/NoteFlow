//Page Constants 
int homePage = 0;
int demosPage = 1;
int libraryPage = 2;
int FAQPage = 3;
int demoVisualPage = 4;
int composePage = 5;
int currentScreen = homePage;

//NaviBar x,y vaues for labels(avoids hardcoding)
int headerX = 315;
int headerY = 35;

int toolbarH = 90;

//Music Editing Page
int marginX = 80;
int startY = 140;
int staffSpacing = 12;
int systemGap = 170;
int numberOfSystems = 3;
int measuresPerSystem = 4;

color bgColor = color(8, 6, 15);
color staffColor = color(190, 140, 255);
color accentPurple = color(140, 70, 255);
color textColor = color(230, 220, 255);


// Draw Page 
void drawScreen(){
  if (currentScreen == homePage){
  drawHome();
  } else if (currentScreen == demosPage){
  drawDemos();
  } else if(currentScreen == libraryPage){
  drawLibrary();
  } else if(currentScreen == demoVisualPage){
  drawDemoVisual();
  }else if(currentScreen == composePage){
  drawCompose();
  }//else if (currentScreen == FAQPage){
  //drawFAQ();
  //} 
}

//HOMEPAGE
void drawHome(){
  background(0);
  drawArt();
  textSize(100);
  fill(255);
  textAlign(LEFT);
  text("NoteFlow", 40,240);
  
  fill(119, 61, 255);
  rect(-10,-10,1010,80);
  
  fill(255);
  textSize(45);
  
  text("Compose without limits.", 500,350);
  
  noStroke();
  fill(255,25);
  stroke(255,120);
  strokeWeight(2);

  //rect(10,0,70,70,15);
  //rect(160,0,130,70,15);
  //rect(290,0,170,70,15);
  //rect(460,0,170,70,15);
  //rect(630,0,300,7,15);

  noStroke();
  fill(255);
  rect(20,40,30,20);
  triangle(10,40, 35,10, 60,40);

  stroke(5);
  fill(0);
  line(15,33, 35,10);
  line(15,43, 35,20);
  line(15,33, 15,55);
  line(35,10, 35,50);
  ellipse(30,50, 10,5);
  ellipse(10,55, 10,5);

  strokeWeight(2);
  textSize(25);
  fill(255);

  naviBarText();
}




/*
-starting page
-FAQ page
-Features page
-Library/saved progress page
-Demo's page

*/

//TAB 2

void drawDemos(){
  background(0);

  fill(119, 61, 255);
  rect(-10,-10,1010,80);

  noStroke();
  fill(255,25);
  stroke(255,120);
  strokeWeight(2);

  noStroke();
  fill(255);
  rect(20,40,30,20);
  triangle(10,40, 35,10, 60,40);

  stroke(5);
  fill(0);
  line(15,33, 35,10);
  line(15,43, 35,20);
  line(15,33, 15,55);
  line(35,10, 35,50);
  ellipse(30,50, 10,5);
  ellipse(10,55, 10,5);

  strokeWeight(2);
  textSize(25);
  fill(255);

  textAlign(LEFT);
  naviBarText();

  textAlign(CENTER);
  textSize(35);
  text("Try out our default demo's to get accustomed to our software!", width/2, 200);

  String[] demoNames = {"Demo 1", "Demo 2", "Chord Test"};
  for(int i = 0; i < 3; i++){
    fill(255);
    rect(120 + i*290, 320, 200, 150, 25);

    fill(0);
    textSize(30);
    text(demoNames[i], 220 + i*290, 405);
  }
}

//TAB 3

void drawLibrary(){
  background(0);

  fill(119, 61, 255);
  rect(-10,-10,1010,80);

  noStroke();
  fill(255,25);
  stroke(255,120);
  strokeWeight(2);

  noStroke();
  fill(255);
  rect(20,40,30,20);
  triangle(10,40, 35,10, 60,40);

  stroke(5);
  fill(0);
  line(15,33, 35,10);
  line(15,43, 35,20);
  line(15,33, 15,55);
  line(35,10, 35,50);
  ellipse(30,50, 10,5);
  ellipse(10,55, 10,5);

  strokeWeight(2);
  textSize(25);
  fill(255);

  textAlign(LEFT);
  naviBarText();

  textAlign(CENTER, CENTER);

  for(int i = 0; i < 6; i++){
    String projectName = "Empty Project " + (i+1);
    if (i < savedProjects.size()){
      projectName = savedProjects.get(i);
    }

    fill(255);
    rect(150, 140 + i*90, 700, 60, 20);

    fill(0);
    textSize(30);
    text(projectName, 500, 170 + i*90);
  }
}
void drawFAQ(){


}
void drawCompose(){
  background(bgColor);

  // Title
  fill(textColor);
  textAlign(CENTER);
  textSize(32);
  String title = "Piano Music Sheet";
  if (userPiece != null){
    title = userPiece.title;
  }
  text(title, width / 2, 55);
  
  textSize(16);
  fill(170, 130, 230);
  text(editorDisplayText(), width / 2, 82);
  noStroke();
  fill(108,59,170);
  rect(20,40,30,20);
  triangle(10,40, 35,10, 60,40);
  stroke(5);
  line(15,33, 35,10);
  line(15,43, 35,20);
  line(15,33, 15,55);
  line(35,10, 35,50);
  ellipse(30,50, 10,5);
  ellipse(10,55, 10,5);

  drawExistingMeasureStaves();

  drawUserPiece();

  if (showSavePopup) {
    drawSavePopup();
  }
}

void drawDemoVisual(){
  background(0);

  fill(119, 61, 255);
  rect(-10,-10,1010,80);

  noStroke();
  fill(255);
  rect(20,40,30,20);
  triangle(10,40, 35,10, 60,40);

  stroke(5);
  fill(0);
  line(15,33, 35,10);
  line(15,43, 35,20);
  line(15,33, 15,55);
  line(35,10, 35,50);
  ellipse(30,50, 10,5);
  ellipse(10,55, 10,5);

  strokeWeight(2);
  textSize(25);
  fill(255);
  textAlign(LEFT);
  naviBarText();

  textAlign(CENTER);
  textSize(38);
  text(demoEqualizer.displayTitle(), width/2, 145);

  if (demoEqualizer.draw()){
    currentScreen = demosPage;
  }
}

void naviBarText() {
  textSize(25);
  textAlign(LEFT);

  for (int i = 0; i < navLabels.length; i++) {
    if (isNavHovered(i)) {
      noFill();
      stroke(255);
      strokeWeight(2);
      rect(navX[i] - navPad, navY - 22, navW[i] + navPad*2, navBoxH, 6);
    }
    fill(255);
    noStroke();
    text(navLabels[i], navX[i], navY);
  }
}

void drawExistingMeasureStaves(){
  //Only draw the measures that actually exist in userPiece
  if (userPiece == null){
    return;
  }

  int totalMeasures = min(userPiece.measureCount(), numberOfSystems * measuresPerSystem);

  for (int system=0;system<numberOfSystems;system++){
    int firstMeasure = system * measuresPerSystem;
    int measuresThisSystem = min(measuresPerSystem, totalMeasures - firstMeasure);

    if (measuresThisSystem <= 0){
      continue;
    }

    int y = startY + system * systemGap;

    drawStaffLines(y, measuresThisSystem);

    drawMeasureLines(y, measuresThisSystem);
  }
}

void drawStaffLines(int y, int measureCount) {
  stroke(staffColor);
  strokeWeight(2);
  float endX = marginX + measureWidth() * measureCount;

  for (int i = 0; i < 5; i++) {
    line(marginX,y + i * staffSpacing,endX,y + i * staffSpacing);
  }
}

void drawMeasureLines(int y, int numberOfMeasures) {
  stroke(accentPurple);
  strokeWeight(2);

  for (int i = 0; i <= numberOfMeasures; i++) {
    float x = marginX + i * measureWidth();

    line(x, y, x, y + staffSpacing * 4);
  }
}


void drawSavePopup() {

  fill(0, 180);
  rect(0, 0, width, height);

  fill(40);
  stroke(255);
  strokeWeight(3);

  rect(width/2 - 220, height/2 - 140, 440, 240, 20);

  fill(255);

  textAlign(CENTER);
  textSize(28);

  text("Enter a name for your project:", width/2, height/2 - 80);
}

String editorDisplayText(){
  if (editManager == null){
    return "";
  }

  String mode = editManager.placeMode ? "Place" : "Select";
  String item = editManager.placingRest ? "Rest" : "Note";
  String instrumentName = "";

  if (userPiece != null && userPiece.instruments.size() > editManager.activeTrack){
    instrumentName = " | " + userPiece.instruments.get(editManager.activeTrack).name;
  }

  return mode + " " + item + " | Track " + (editManager.activeTrack+1) + instrumentName + " | Duration " + selectedDuration + " | " + editManager.statusText;
}

void drawUserPiece(){
  //Draw the active track from the actual MusicalPiece data
  if (userPiece == null || userPiece.tracks.size() == 0){
    return;
  }

  editManager.keepTrackInRange();

  ArrayList<Measure> track = userPiece.tracks.get(editManager.activeTrack);
  int visibleMeasures = min(track.size(), numberOfSystems * measuresPerSystem);

  for (int m=0;m<visibleMeasures;m++){
    Measure measure = track.get(m);
    float currentBeat = 0;

    for (int e=0;e<measure.events.size();e++){
      MusicEvent event = measure.events.get(e);
      float x = eventX(m, currentBeat);
      boolean selected = editManager.selectedMeasure == m && editManager.selectedEvent == e;

      if (event instanceof Note){
        drawSavedNote((Note) event, x, measureSystemY(m), selected);
      }else{
        drawSavedRest(event.duration, x, measureSystemY(m), selected);
      }

      currentBeat += event.duration;
    }
  }
}

void drawSavedNote(Note note, float x, int systemY, boolean selected){
  int drawMidi = constrain(note.midiNote, minEditorMidi, maxEditorMidi);
  int staffTop = systemY;
  int anchorMidi = 64; //E4, bottom line

  float y = noteY(drawMidi, staffTop, anchorMidi);

  drawLedgerLines(drawMidi, x, staffTop, anchorMidi);

  stroke(255);
  strokeWeight(2);

  if (note.duration <= 1.0 + MUSIC_EPSILON){
    fill(255);
  }else{
    noFill();
  }

  ellipse(x, y, 18, 12);

  if (note.duration < 4.0 - MUSIC_EPSILON){
    drawStemAndFlags(note, x, y);
  }

  if (selected){
    drawEventHighlight(x, y);
  }
}

void drawStemAndFlags(Note note, float x, float y){
  boolean stemUp = note.midiNote < 71; //B4, middle line

  float stemX = x - 8;
  float stemEnd = y + 38;

  if (stemUp){
    stemX = x + 8;
    stemEnd = y - 38;
  }

  line(stemX, y, stemX, stemEnd);

  int flags = 0;
  if (note.duration <= 0.25 + MUSIC_EPSILON){
    flags = 2;
  }else if (note.duration <= 0.5 + MUSIC_EPSILON){
    flags = 1;
  }

  for (int i=0;i<flags;i++){
    float flagY = stemEnd + i * 8;

    if (stemUp){
      line(stemX, flagY, stemX + 16, flagY + 9);
    }else{
      flagY = stemEnd - i * 8;
      line(stemX, flagY, stemX - 16, flagY - 9);
    }
  }
}

//Need to fix this, spacing is really weird
void drawSavedRest(float duration, float x, int systemY, boolean selected){
  float y = systemY + staffSpacing * 2;

  stroke(255, 190);
  strokeWeight(2);
  fill(255, 190);

  if (duration >= 4.0 - MUSIC_EPSILON){
    rect(x - 8, y - staffSpacing, 16, 5);
  }else if (duration >= 2.0 - MUSIC_EPSILON){
    rect(x - 8, y, 16, 5);
  }else{
    noFill();
    line(x, y - 14, x + 8, y - 5);
    line(x + 8, y - 5, x - 3, y + 6);
    line(x - 3, y + 6, x + 8, y + 16);

    if (duration <= 0.5 + MUSIC_EPSILON){
      line(x + 7, y - 10, x + 17, y - 3);
    }
    if (duration <= 0.25 + MUSIC_EPSILON){
      line(x + 4, y - 3, x + 14, y + 4);
    }
  }

  if (selected){
    drawEventHighlight(x, y);
  }
}

void drawEventHighlight(float x, float y){
  noFill();
  stroke(255, 230, 80);
  strokeWeight(2);
  rect(x - 18, y - 18, 36, 36, 6);
}

void drawLedgerLines(int midiNote, float x, int staffTop, int anchorMidi){
  //Notes outside the staff need small extra staff lines
  int bottomStep = diatonicIndexFromMidi(anchorMidi);
  int noteStep = diatonicIndexFromMidi(midiNote);
  int diff = noteStep - bottomStep;
  float bottomY = staffTop + staffSpacing * 4;
  float stepY = staffSpacing / 2.0;

  stroke(255, 190);
  strokeWeight(2);

  if (diff < 0){
    for (int s=-2;s>=diff;s-=2){
      float y = bottomY - s * stepY;
      line(x - 14, y, x + 14, y);
    }
  }else if (diff > 8){
    for (int s=10;s<=diff;s+=2){
      float y = bottomY - s * stepY;
      line(x - 14, y, x + 14, y);
    }
  }
}

float noteY(int midiNote, int staffTop, int anchorMidi){
  int bottomStep = diatonicIndexFromMidi(anchorMidi);
  int noteStep = diatonicIndexFromMidi(midiNote);
  int diff = noteStep - bottomStep;

  return staffTop + staffSpacing * 4 - diff * (staffSpacing / 2.0);
}

int diatonicIndexFromMidi(int midiNote){
  int[] pitchClassSteps = {0, 0, 1, 1, 2, 3, 3, 4, 4, 5, 5, 6};
  int pitchClass = midiNote % 12;

  if (pitchClass < 0){
    pitchClass += 12;
  }

  int octave = midiNote / 12 - 1;
  return octave * 7 + pitchClassSteps[pitchClass];
}

int midiFromDiatonicIndex(int index){
  int[] naturalPitches = {0, 2, 4, 5, 7, 9, 11};
  int octave = int(floor(index / 7.0));
  int degree = index - octave * 7;

  return (octave + 1) * 12 + naturalPitches[degree];
}

float measureWidth(){
  return (width - marginX * 2) / float(measuresPerSystem);
}

float measureStartX(int measureID){
  int slot = measureID % measuresPerSystem;
  return marginX + slot * measureWidth();
}

int measureSystemY(int measureID){
  int system = measureID / measuresPerSystem;
  return startY + system * systemGap;
}

float eventX(int measureID, float beat){
  float usableWidth = measureWidth() - 36;
  return measureStartX(measureID) + 18 + (beat / userPiece.timeSig.measureDuration()) * usableWidth;
}

int measureFromMouse(){
  if (mouseX < marginX || mouseX > width - marginX){
    return -1;
  }

  for (int system=0;system<numberOfSystems;system++){
    int y = startY + system * systemGap;
    int top = y - staffSpacing * 3;
    int bottom = y + staffSpacing * 10;

    if (mouseY >= top && mouseY <= bottom){
      int slot = int((mouseX - marginX) / measureWidth());
      slot = constrain(slot, 0, measuresPerSystem - 1);
      return system * measuresPerSystem + slot;
    }
  }

  return -1;
}

int eventIDAtBeat(Measure measure, float beat){
  float currentBeat = 0;

  for (int i=0;i<measure.events.size();i++){
    MusicEvent event = measure.events.get(i);
    float nextBeat = currentBeat + event.duration;

    if (beat >= currentBeat - MUSIC_EPSILON && beat < nextBeat - MUSIC_EPSILON){
      return i;
    }

    currentBeat = nextBeat;
  }

  if (measure.events.size() > 0 && beat >= currentBeat - MUSIC_EPSILON){
    return measure.events.size() - 1;
  }

  return -1;
}

int midiFromMouseY(int measureID){
  //Turn the mouse y position into a midi note on this staff
  int systemY = measureSystemY(measureID);
  int staffTop = systemY;
  int anchorMidi = 64; //E4

  float bottomY = staffTop + staffSpacing * 4;
  float stepY = staffSpacing / 2.0;
  int steps = round((bottomY - mouseY) / stepY);
  int noteStep = diatonicIndexFromMidi(anchorMidi) + steps;

  return constrain(midiFromDiatonicIndex(noteStep), minEditorMidi, maxEditorMidi);
}
