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
int headerY = 50;

//Music Editing Page
int marginX = 80;
int startY = 120;
int staffSpacing = 12;
int staffGap = 90;
int systemGap = 170;

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
    
    fill(255);
    rect(150, 140 + i*90, 700, 60, 20);

    fill(0);
    textSize(30);
    text("Project " + (i+1), 500, 170 + i*90);
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
  text("Piano Music Sheet", width / 2, 55);

  textSize(16);
  fill(170, 130, 230);
  text("Blank composition layout", width / 2, 82);

  int numberOfSystems = 3;

  for (int i = 0; i < numberOfSystems; i++) {
    int y = startY + i * systemGap;

    //Upper set of lines
    drawStaffLines(y);

    //Lower set of lines
    drawStaffLines(y + staffGap);

    //Measure lines for both sets
    drawMeasureLines(y);
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

void drawStaffLines(int y) {
  stroke(staffColor);
  strokeWeight(2);

  for (int i = 0; i < 5; i++) {
    line(marginX,y + i * staffSpacing,width - marginX,y + i * staffSpacing);
  }
}

void drawMeasureLines(int y) {
  stroke(accentPurple);
  strokeWeight(2);

  int numberOfMeasures = 4;
  int sheetWidth = width - marginX * 2;
  int measureWidth = sheetWidth / numberOfMeasures;

  for (int i = 0; i <= numberOfMeasures; i++) {
    int x = marginX + i * measureWidth;

    //Measure lines for upper staff
    line(x, y, x, y + staffSpacing * 4);

    //Measure lines for lower staff
    line(x, y + staffGap, x, y + staffGap + staffSpacing * 4);
  }
}
