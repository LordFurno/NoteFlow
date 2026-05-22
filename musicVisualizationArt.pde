//This will be the viual art that is displyed on the home page.
float unit;
PVector center;
int sphereRadius;


void drawArt() {
  smooth(8); //Makes lines look smoother
  unit = height/100.0; //Create a scale value based on the screens height
  strokeWeight(unit/10.0); //Sets the line thickness based on the scale
  center = new PVector(width/2,height/2); 
  sphereRadius = 17 * round(unit); //Sets the radius of the inner circle
  fill(0);
  
  noStroke();
  rect(0, 0, width, height); //Covers background in black
  noFill();

  float extendingLinesMin = sphereRadius * 1.1; //Sets the shortest possible line length
  float extendingLinesMax = sphereRadius * 4.0; //Sets the longest posible line length
  
  //Draws lines around a circle to create a pulsing sphere effect
  for (int angle = 0; angle <= 360; angle += 3) {
    float pulse = noise(angle * 0.3, frameCount * 0.02); //Creates smooth animated randomness
    
    //Squish the pulse to exaggerate short vs long — makes it more dramatic
    pulse = pow(pulse, 2);
    
    float lineRadius = map(pulse, 0, 1, extendingLinesMin, extendingLinesMax);

    float x1 = cos(radians(angle)) * sphereRadius + center.x; //Calculates inner line start x-pos
    float y1 = sin(radians(angle)) * sphereRadius + center.y; //Calculates inner line start y-pos
    float x2 = cos(radians(angle)) * lineRadius + center.x;   //Calculates outer line end x-pos
    float y2 = sin(radians(angle)) * lineRadius + center.y;   //Calculates outer line end y-pos

    stroke(255);
    line(x1, y1, x2, y2);
  }
}
