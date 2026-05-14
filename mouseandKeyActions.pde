// MOUSE AND KEY CONTROLS
//If mouse is in the navigation bar
int boundingBox[] = {315,50,310  ,  97,89,113  ,  53,207,196  ,  176,165,179  ,  52,38,50  ,  248,222,203};

void mousePressed() {
  handleNavClick();
}
void handleNavClick() {
  if (mouseY > 60) return; // ignore clicks outside navbar

  //Homepage
  if (mouseX > 10 && mouseX < 60) {
    currentScreen = homePage;
    //boundingbox[0] = true;
    //setVisible(true);
    //hoverBoudningBox.setVisible(true);
    //setVisible();
    //Create it so that if the user is hovering over the button there is a boudning box around it.
    //Do this for each button
  }
  //Features
  if (mouseX > 314 && mouseX < 400) {
    currentScreen = demosPage;
    //setVisible();
    
  }
  //Library
  if (mouseX > 465 && mouseX < 540) {
    currentScreen = libraryPage;
    //setVisible();
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
