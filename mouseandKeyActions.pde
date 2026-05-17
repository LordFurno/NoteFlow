boolean isNavHovered(int i) {
  return mouseX >= navX[i] - navPad
      && mouseX <= navX[i] + navW[i] + navPad
      && mouseY >= navY - 22
      && mouseY <= navY - 22 + navBoxH;
}

void mousePressed() {
  if (currentScreen == demosPage && handleDemoCardClick()){
    return;
  } if (currentScreen == libraryPage && handleLibraryProjectClick()){
    return;
  }

  handleNavClick();
}

void handleNavClick() {
  if (mouseY > 60) return;

  //Logo icon click — go home
  if (mouseX > 10 && mouseX < 60) {
    stopActiveDemo();
    currentScreen = homePage;
    return;
  }

  //Nav labels
  for (int i = 0; i < navLabels.length; i++) {
    if (isNavHovered(i)) {
      stopActiveDemo();
      currentScreen = navScreens[i];
      return;
    }
  }
}

boolean handleDemoCardClick(){
  for (int i=0;i<3;i++){
    float x = 120 + i*290;
    float y = 320;
    float w = 200;
    float h = 150;

    if (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h){
      if (i == 1){
        startDemo2Visual();
      }else if (i == 2){
        startDemo3Visual();
      }
      return true;
    }
  }

  return false;
}
boolean handleLibraryProjectClick() {
  float x1 = 150;
  float y1 = 135;
  float x2 = 850;
  float y2 = 200;

  if (mouseX >= x1 && mouseX <= x2 && mouseY >= y1 && mouseY <= y2) {
    stopActiveDemo();

    // Change this to whatever page you want the project to open
    currentScreen = composePage;

    return true;
  }

  return false;
}

void startDemo2Visual(){
  startDemoVisual(createDemo2(this));
}

void startDemo3Visual(){
  startDemoVisual(createDemo3(this));
}

void startDemoVisual(MusicalPiece piece){
  stopActiveDemo();
  demoEqualizer.start(piece);
  currentScreen = demoVisualPage;
}

void stopActiveDemo(){
  if (demoEqualizer != null){
    demoEqualizer.stop();
  }
}
