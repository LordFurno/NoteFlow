boolean isNavHovered(int i) {
  return mouseX >= navX[i] - navPad
      && mouseX <= navX[i] + navW[i] + navPad
      && mouseY >= navY - 22
      && mouseY <= navY - 22 + navBoxH;
}

void mousePressed() {
  handleNavClick();
}

void handleNavClick() {
  if (mouseY > 60) return;

  //Logo icon click — go home
  if (mouseX > 10 && mouseX < 60) {
    currentScreen = homePage;
    return;
  }

  //Nav labels
  for (int i = 0; i < navLabels.length; i++) {
    if (isNavHovered(i)) {
      currentScreen = navScreens[i];
      return;
    }
  }
}
