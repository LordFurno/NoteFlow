//Page Constants 
int homePage = 0;
int demosPage = 1;
int libraryPage = 2;
int FAQPage = 3;
int currentScreen = homePage;

//NaviBar x,y vaues for labels(avoids hardcoding)
int headerX = 315;
int headerY = 50;


// Draw Page 
void drawScreen(){
  if (currentScreen == homePage){
  drawHome();
  } else if (currentScreen == demosPage){
  drawDemos();
  } else if(currentScreen == libraryPage){
  drawLibrary();
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

  for(int i = 0; i < 3; i++){
    fill(255);
    rect(120 + i*290, 320, 200, 150, 25);

    fill(0);
    textSize(30);
    text("Demo " + (i+1), 220 + i*290, 405);
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
