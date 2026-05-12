//This is something I made that I thought would be pretty cool that could be on our homepage, 
// however it's not necessary just made it to add a bit more of a pop out factor(Lmk what you guys think)
float unit;
PVector center;
int sphereRadius;


void drawArt() {
  smooth(8);
  unit = height/100.0;
  strokeWeight(unit/10.0);
  center = new PVector(width/2,height/2);
  sphereRadius = 15 * round(unit);
  fill(0);
  
  noStroke();
  rect(0, 0, width, height);
  noFill();

  float extendingLinesMin = sphereRadius * 1.1;
  float extendingLinesMax = sphereRadius * 4.0;

  for (int angle = 0; angle <= 360; angle += 3) {
    //High noise scale --> neighbor lines don't match as much(but still related as a result of noise()), looks jumpy and independent
    float pulse = noise(angle * 0.3, frameCount * 0.02);
    
    //Squish the pulse to exaggerate short vs long — makes it more dramatic
    pulse = pow(pulse, 2);
    
    float lineRadius = map(pulse, 0, 1, extendingLinesMin, extendingLinesMax);

    float x1 = cos(radians(angle)) * sphereRadius + center.x;
    float y1 = sin(radians(angle)) * sphereRadius + center.y;
    float x2 = cos(radians(angle)) * lineRadius + center.x;
    float y2 = sin(radians(angle)) * lineRadius + center.y;

    stroke(255);
    line(x1, y1, x2, y2);
  }
}
