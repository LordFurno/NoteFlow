// MOUSE AND KEY CONTROLS
//If mouse is in the navigation bar
void mousePressed() {
  handleNavClick();
}
void handleNavClick() {
  if (mouseY > 60) return; // ignore clicks outside navbar

  //Homepage
  if (mouseX > 10 && mouseX < 60) {
    currentScreen = homePage;
  }
  //Features
  if (mouseX > 314 && mouseX < 400) {
    currentScreen = demosPage;
  }
  //Library
  if (mouseX > 465 && mouseX < 540) {
    currentScreen = libraryPage;
  }
  //Explore Demo's
  if (mouseX > 595 && mouseX < 755) {
    currentScreen = demosPage;
  }
  //FAQ
  if (mouseX > 790 && mouseX < 840){
    currentScreen = homePage;
  }
}
