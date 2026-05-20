class Demo{
  
  //Fields
  MusicalPiece piece; 
  
  float xPoint, yPoint;
  float space;
  
  //Constructor
  Demo(MusicalPiece piece){
    
    this.piece = piece;

    xPoint = 70;
    yPoint = 140;
    space = 70;
  }
  
  
  
  void playDemo(){
    
    this.piece.play();
  }
  
  
  void DemoAnalyze(){
    

    println("Demo Name: " + this.piece.title);
    println("Instruments: " );
    for (Instrument i: this.piece.instruments){
       println(i.name);
    }
    
    println("Time Signature: " + this.piece.timeSig.toString());
    println("Key Signature: " + this.piece.keySig.getKeyName());
  }
}

//MusicalPiece createDemo1(PApplet app){
//  KeySignature keySig = new KeySignature(true, 1);
//  TimeSignature timeSig = new TimeSignature(4,4);
//  int tempo = 60;
  
//  int[] saxPitches = {60, 55, 74};

//  String[] saxFiles = {"altoSax/C4.aif", "altoSax/G3.aif", "altoSax/D5.aif"};
//  float [] saxStarts = {0.21, 0.4, 0.2};
//  Instrument sax = new Instrument("Alto sax", saxPitches, saxFiles, saxStarts, app);
  
  
//  MusicalPiece demo1 = new MusicalPiece("Demo 1", keySig, timeSig, tempo);
//  demo1.addInstrument(sax);
  
//  //Do 3 measures
//  demo1.addMeasure(); //One empty measure so audio doesn't get messed up weirdly
//  demo1.addMeasure();
//  demo1.addMeasure();
//  demo1.addMeasure();
//  demo1.addMeasure();
  
//  //Measure 1
//  demo1.placeEvent(0,1,0, new Note(1.0, 55, sax));
//  demo1.placeEvent(0,1,1, new Note(1.0, 67, sax));
//  demo1.placeEvent(0,1,2, new Note(0.5, 69, sax));
//  demo1.placeEvent(0,1,3, new Note(0.5, 71, sax));
//  demo1.placeEvent(0,1,4, new Note(0.5, 73, sax));
//  demo1.placeEvent(0,1,5, new Note(0.5, 75, sax));
  
//  //Measure 2
//  demo1.placeEvent(0,2,0, new Note(1.0, 67, sax));
  
//  demo1.placeEvent(0,2,3, new Note(0.25, 67, sax));
//  demo1.placeEvent(0,2,4, new Note(0.25, 67, sax));
//  demo1.placeEvent(0,2,5, new Note(0.25, 67, sax));
//  demo1.placeEvent(0,2,6, new Note(0.25, 67, sax));
 
//  //Measure 3
//  demo1.placeEvent(0,3,0, new Note(1.0, 55, sax));
//  demo1.placeEvent(0,3,1, new Note(1.0, 56, sax));
//  demo1.placeEvent(0,3,2, new Note(1.0, 57, sax));
//  demo1.placeEvent(0,3,3, new Note(1.0, 58, sax));
  
//  //Measure 4
//  demo1.placeEvent(0,4,0, new Note(1.0, 74, sax));
//  demo1.placeEvent(0,4,1, new Note(1.0, 75, sax));
//  demo1.placeEvent(0,4,2, new Note(1.0, 76, sax));
//  demo1.placeEvent(0,4,3, new Note(1.0, 77, sax));

//  return demo1;
//}

MusicalPiece createDemo1(PApplet app){
  KeySignature keySig = new KeySignature(true, 1);
  TimeSignature timeSig = new TimeSignature(4,4);
  int tempo = 60;

  int[] saxPitches = {60, 55, 74};
  String[] saxFiles = {"altoSax/C4.aif", "altoSax/G3.aif", "altoSax/D5.aif"};
  float [] saxStarts = {0.21, 0.4, 0.2};
  Instrument sax = new Instrument("Alto sax", saxPitches, saxFiles, saxStarts, app);

  MusicalPiece demo1 = new MusicalPiece("Demo 1", keySig, timeSig, tempo);
  demo1.addInstrument(sax);

  //Do 5 more measures
  demo1.addMeasure();
  demo1.addMeasure();
  demo1.addMeasure();
  demo1.addMeasure();
  demo1.addMeasure();

  //Measure 1
  demo1.placeEvent(0,1,0, new Note(1.0, 55, sax));
  demo1.placeEvent(0,1,1, new Note(1.0, 67, sax));
  demo1.placeEvent(0,1,2, new Note(0.5, 69, sax));
  demo1.placeEvent(0,1,3, new Note(0.5, 71, sax));
  demo1.placeEvent(0,1,4, new Note(0.5, 73, sax));
  demo1.placeEvent(0,1,5, new Note(0.5, 75, sax));

  //Measure 2
  demo1.placeEvent(0,2,0, new Note(1.0, 67, sax));
  demo1.placeEvent(0,2,3, new Note(0.25, 67, sax));
  demo1.placeEvent(0,2,4, new Note(0.25, 67, sax));
  demo1.placeEvent(0,2,5, new Note(0.25, 67, sax));
  demo1.placeEvent(0,2,6, new Note(0.25, 67, sax));

  //Measure 3
  demo1.placeEvent(0,3,0, new Note(1.0, 55, sax));
  demo1.placeEvent(0,3,1, new Note(1.0, 56, sax));
  demo1.placeEvent(0,3,2, new Note(1.0, 57, sax));
  demo1.placeEvent(0,3,3, new Note(1.0, 58, sax));

  //Measure 4
  demo1.placeEvent(0,4,0, new Note(1.0, 74, sax));
  demo1.placeEvent(0,4,1, new Note(1.0, 75, sax));
  demo1.placeEvent(0,4,2, new Note(1.0, 76, sax));
  demo1.placeEvent(0,4,3, new Note(1.0, 77, sax));

  return demo1;
}

MusicalPiece test(PApplet app){
  KeySignature keySig = new KeySignature(true, 1);
  TimeSignature timeSig = new TimeSignature(4,4);
  int tempo = 116;



  Instrument sax = createPianoInstrument("Piano");

  MusicalPiece demo2 = new MusicalPiece("Demo 2", keySig, timeSig, tempo);
  demo2.addInstrument(sax);

  //10 bars in total
  demo2.addMeasure(); //Empty measure
  demo2.addMeasure();
  demo2.addMeasure();
  demo2.addMeasure();
  demo2.addMeasure();
  demo2.addMeasure();
  demo2.addMeasure();
  demo2.addMeasure();
  demo2.addMeasure();
  demo2.addMeasure();

  //Pickup into the solo
  demo2.placeEventAtBeat(0,1,2.5, new Note(0.5, 83, sax));
  demo2.placeEventAtBeat(0,1,3.0, new Note(0.5, 81, sax));
  demo2.placeEventAtBeat(0,1,3.5, new Note(0.5, 79, sax));

  //Measure 5
  demo2.placeEventAtBeat(0,2,0.0, new Note(0.5, 83, sax));
  demo2.placeEventAtBeat(0,2,0.5, new Note(1.5, 79, sax));
  demo2.placeEventAtBeat(0,2,2.5, new Note(0.5, 76, sax));

  demo2.placeEventAtBeat(0,2,3.0, new Note(1.0, 79, sax));

  //Measure 6
  demo2.placeEventAtBeat(0,3,0.0, new Note(2.0, 76, sax));
  demo2.placeEventAtBeat(0,3,2.5, new Note(0.5, 79, sax));
  demo2.placeEventAtBeat(0,3,3.0, new Note(0.5, 79, sax));
  demo2.placeEventAtBeat(0,3,3.5, new Note(0.5, 81, sax));

  //Measure 7
  demo2.placeEventAtBeat(0,4,0.0, new Note(0.5, 83, sax));
  demo2.placeEventAtBeat(0,4,0.5, new Note(0.5, 81, sax));
  demo2.placeEventAtBeat(0,4,1.0, new Note(0.5, 79, sax));
  demo2.placeEventAtBeat(0,4,1.5, new Note(0.5, 81, sax));
  demo2.placeEventAtBeat(0,4,2.0, new Note(0.5, 83, sax));
  demo2.placeEventAtBeat(0,4,2.5, new Note(0.5, 81, sax));
  demo2.placeEventAtBeat(0,4,3.0, new Note(0.5, 79, sax));
  demo2.placeEventAtBeat(0,4,3.5, new Note(0.5, 79, sax));

  //Measure 8
  demo2.placeEventAtBeat(0,5,0.0, new Note(2.0, 76, sax));
  demo2.placeEventAtBeat(0,5,2.5, new Note(0.5, 83, sax));
  demo2.placeEventAtBeat(0,5,3.0, new Note(0.5, 81, sax));
  demo2.placeEventAtBeat(0,5,3.5, new Note(0.5, 79, sax));

  //Measure 9
  demo2.placeEventAtBeat(0,6,0.0, new Note(0.5, 83, sax));
  demo2.placeEventAtBeat(0,6,0.5, new Note(0.5, 86, sax));

  demo2.placeEventAtBeat(0,6,2.5, new Note(0.5, 76, sax));
  demo2.placeEventAtBeat(0,6,3.0, new Note(0.5, 79, sax));
  demo2.placeEventAtBeat(0,6,3.5, new Note(0.5, 79, sax));

  //Measure 10
  //Natural doesn't matter because no grace note
  demo2.placeEventAtBeat(0,7,0.0, new Note(0.25, 81, sax));
  demo2.placeEventAtBeat(0,7,0.25, new Note(0.25, 79, sax));
  demo2.placeEventAtBeat(0,7,0.5, new Note(1.5, 76, sax)); //Does dotted half work?

  demo2.placeEventAtBeat(0,7,2.5, new Note(0.5, 76, sax));
  demo2.placeEventAtBeat(0,7,3.0, new Note(0.5, 79, sax));
  demo2.placeEventAtBeat(0,7,3.5, new Note(0.5, 81, sax));

  //Measure 11
  demo2.placeEventAtBeat(0,8,0.0, new Note(0.5, 83, sax));
  demo2.placeEventAtBeat(0,8,0.5, new Note(0.5, 81, sax));
  demo2.placeEventAtBeat(0,8,1.0, new Note(0.5, 79, sax));
  demo2.placeEventAtBeat(0,8,1.5, new Note(0.5, 81, sax));
  demo2.placeEventAtBeat(0,8,2.0, new Note(0.5, 83, sax));
  demo2.placeEventAtBeat(0,8,2.5, new Note(0.5, 81, sax));
  demo2.placeEventAtBeat(0,8,3.0, new Note(0.5, 79, sax));
  demo2.placeEventAtBeat(0,8,3.5, new Note(0.5, 79, sax));

  //Measure 12
  demo2.placeEventAtBeat(0,9,0.0, new Note(1.5, 76, sax));

  return demo2;
}

MusicalPiece createDemo2(PApplet app){
  KeySignature keySig = new KeySignature(true, 1);
  TimeSignature timeSig = new TimeSignature(4,4);
  int tempo = 116;
  
  int[] saxPitches = {60, 55, 74};

  String[] saxFiles = {"altoSax/C4.aif", "altoSax/G3.aif", "altoSax/D5.aif"};
  float [] saxStarts = {0.21, 0.4, 0.2};
  Instrument sax = new Instrument("Alto sax", saxPitches, saxFiles, saxStarts, app);
  
  
  MusicalPiece demo2 = new MusicalPiece("Demo 2", keySig, timeSig, tempo);
  demo2.addInstrument(sax);
  
  //10 bars in total
  demo2.addMeasure(); //Empty measure
  demo2.addMeasure();
  demo2.addMeasure();
  demo2.addMeasure();
  demo2.addMeasure();
  demo2.addMeasure();
  demo2.addMeasure();
  demo2.addMeasure();
  demo2.addMeasure();
  demo2.addMeasure();
 
  
  //Pickup into the solo
  demo2.placeEventAtBeat(0,1,2.5, new Note(0.5, 83, sax));
  demo2.placeEventAtBeat(0,1,3.0, new Note(0.5, 81, sax));
  demo2.placeEventAtBeat(0,1,3.5, new Note(0.5, 79, sax));
  
  //Measure 5
  demo2.placeEventAtBeat(0,2,0.0, new Note(0.5, 83, sax));
  demo2.placeEventAtBeat(0,2,0.5, new Note(1.5, 79, sax));
  demo2.placeEventAtBeat(0,2,2.5, new Note(0.5, 76, sax));
  
  demo2.placeEventAtBeat(0,2,3.0, new Note(1.0, 79, sax));
  

  
  //Measure 6
  demo2.placeEventAtBeat(0,3,0.0, new Note(2.0, 76, sax));
  demo2.placeEventAtBeat(0,3,2.5, new Note(0.5, 79, sax));
  demo2.placeEventAtBeat(0,3,3.0, new Note(0.5, 79, sax));
  demo2.placeEventAtBeat(0,3,3.5, new Note(0.5, 81, sax));
 
  //Measure 7
  demo2.placeEventAtBeat(0,4,0.0, new Note(0.5, 83, sax));
  demo2.placeEventAtBeat(0,4,0.5, new Note(0.5, 81, sax));
  demo2.placeEventAtBeat(0,4,1.0, new Note(0.5, 79, sax));
  demo2.placeEventAtBeat(0,4,1.5, new Note(0.5, 81, sax));
  demo2.placeEventAtBeat(0,4,2.0, new Note(0.5, 83, sax));
  demo2.placeEventAtBeat(0,4,2.5, new Note(0.5, 81, sax));
  demo2.placeEventAtBeat(0,4,3.0, new Note(0.5, 79, sax));
  demo2.placeEventAtBeat(0,4,3.5, new Note(0.5, 79, sax));
  
  //Measure 8
  demo2.placeEventAtBeat(0,5,0.0, new Note(2.0, 76, sax));
  demo2.placeEventAtBeat(0,5,2.5, new Note(0.5, 83, sax));
  demo2.placeEventAtBeat(0,5,3.0, new Note(0.5, 81, sax));
  demo2.placeEventAtBeat(0,5,3.5, new Note(0.5, 79, sax));
  
  //Measure 9
  demo2.placeEventAtBeat(0,6,0.0, new Note(0.5, 83, sax));
  demo2.placeEventAtBeat(0,6,0.5, new Note(0.5, 86, sax));
 
  demo2.placeEventAtBeat(0,6,2.5, new Note(0.5, 76, sax));
  demo2.placeEventAtBeat(0,6,3.0, new Note(0.5, 79, sax));
  demo2.placeEventAtBeat(0,6,3.5, new Note(0.5, 79, sax));

  
  //Measure 10
  //Natural doesn't matter because no grace note
  demo2.placeEventAtBeat(0,7,0.0, new Note(0.25, 81, sax));
  demo2.placeEventAtBeat(0,7,0.25, new Note(0.25, 79, sax));
  demo2.placeEventAtBeat(0,7,0.5, new Note(1.5, 76, sax)); //Does dotted half work?
  
  demo2.placeEventAtBeat(0,7,2.5, new Note(0.5, 76, sax));
  demo2.placeEventAtBeat(0,7,3.0, new Note(0.5, 79, sax));
  demo2.placeEventAtBeat(0,7,3.5, new Note(0.5, 81, sax));

  
  //Measure 11
  demo2.placeEventAtBeat(0,8,0.0, new Note(0.5, 83, sax));
  demo2.placeEventAtBeat(0,8,0.5, new Note(0.5, 81, sax));
  demo2.placeEventAtBeat(0,8,1.0, new Note(0.5, 79, sax));
  demo2.placeEventAtBeat(0,8,1.5, new Note(0.5, 81, sax));
  demo2.placeEventAtBeat(0,8,2.0, new Note(0.5, 83, sax));
  demo2.placeEventAtBeat(0,8,2.5, new Note(0.5, 81, sax));
  demo2.placeEventAtBeat(0,8,3.0, new Note(0.5, 79, sax));
  demo2.placeEventAtBeat(0,8,3.5, new Note(0.5, 79, sax));
  
  
  //Measure 12
  demo2.placeEventAtBeat(0,9,0.0, new Note(1.5, 76, sax));
  
  
  return demo2;
}

MusicalPiece createDemo3(PApplet app){
  KeySignature keySig = new KeySignature(true, 0);
  TimeSignature timeSig = new TimeSignature(4,4);
  int tempo = 108;

  Instrument rootPiano = createPianoInstrument("Piano Root");
  Instrument thirdPiano = createPianoInstrument("Piano Third");
  Instrument fifthPiano = createPianoInstrument("Piano Fifth");

  MusicalPiece demo3 = new MusicalPiece("Chord Progression Test", keySig, timeSig, tempo);
  demo3.addInstrument(rootPiano);  //Track 0
  demo3.addInstrument(thirdPiano); //Track 1
  demo3.addInstrument(fifthPiano); //Track 2

  //4 measures total
  demo3.addMeasure();
  demo3.addMeasure();
  demo3.addMeasure();

  //Measure 1: C major to G major
  demo3.placeEventAtBeat(0,0,0.0, new Note(2.0, 60, rootPiano));
  demo3.placeEventAtBeat(1,0,0.0, new Note(2.0, 64, thirdPiano));
  demo3.placeEventAtBeat(2,0,0.0, new Note(2.0, 67, fifthPiano));

  demo3.placeEventAtBeat(0,0,2.0, new Note(2.0, 55, rootPiano));
  demo3.placeEventAtBeat(1,0,2.0, new Note(2.0, 62, thirdPiano));
  demo3.placeEventAtBeat(2,0,2.0, new Note(2.0, 67, fifthPiano));

  //Measure 2: A minor to F major
  demo3.placeEventAtBeat(0,1,0.0, new Note(2.0, 57, rootPiano));
  demo3.placeEventAtBeat(1,1,0.0, new Note(2.0, 60, thirdPiano));
  demo3.placeEventAtBeat(2,1,0.0, new Note(2.0, 64, fifthPiano));

  demo3.placeEventAtBeat(0,1,2.0, new Note(2.0, 53, rootPiano));
  demo3.placeEventAtBeat(1,1,2.0, new Note(2.0, 60, thirdPiano));
  demo3.placeEventAtBeat(2,1,2.0, new Note(2.0, 65, fifthPiano));

  //Measure 3: D minor to G major
  demo3.placeEventAtBeat(0,2,0.0, new Note(2.0, 50, rootPiano));
  demo3.placeEventAtBeat(1,2,0.0, new Note(2.0, 57, thirdPiano));
  demo3.placeEventAtBeat(2,2,0.0, new Note(2.0, 65, fifthPiano));

  demo3.placeEventAtBeat(0,2,2.0, new Note(2.0, 55, rootPiano));
  demo3.placeEventAtBeat(1,2,2.0, new Note(2.0, 62, thirdPiano));
  demo3.placeEventAtBeat(2,2,2.0, new Note(2.0, 67, fifthPiano));

  //Measure 4: E minor to C major
  demo3.placeEventAtBeat(0,3,0.0, new Note(2.0, 52, rootPiano));
  demo3.placeEventAtBeat(1,3,0.0, new Note(2.0, 59, thirdPiano));
  demo3.placeEventAtBeat(2,3,0.0, new Note(2.0, 67, fifthPiano));

  demo3.placeEventAtBeat(0,3,2.0, new Note(2.0, 48, rootPiano));
  demo3.placeEventAtBeat(1,3,2.0, new Note(2.0, 60, thirdPiano));
  demo3.placeEventAtBeat(2,3,2.0, new Note(2.0, 64, fifthPiano));

  return demo3;
}
