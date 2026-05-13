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

MusicalPiece createDemo1(PApplet app){
  KeySignature keySig = new KeySignature(true, 1);
  TimeSignature timeSig = new TimeSignature(4,4);
  int tempo = 60;
  
  int[] saxPitches = {60};

  String[] saxFiles = {"altoSax/C4.aif"};
  float [] saxStarts = {0.21};
  Instrument sax = new Instrument("Alto sax", saxPitches, saxFiles, saxStarts, app);
  
  
  MusicalPiece demo1 = new MusicalPiece("Demo 1", keySig, timeSig, tempo);
  demo1.addInstrument(sax);
  
  //Do 3 measures
  demo1.addMeasure();
  demo1.addMeasure();
  demo1.addMeasure();
  
  //Measure 1
  demo1.placeEvent(0,0,0, new Note(1.0, 67, sax));
  demo1.placeEvent(0,0,1, new Note(1.0, 67, sax));
  demo1.placeEvent(0,0,2, new Note(0.5, 67, sax));
  demo1.placeEvent(0,0,3, new Note(0.5, 67, sax));
  demo1.placeEvent(0,0,4, new Note(0.5, 67, sax));
  demo1.placeEvent(0,0,5, new Note(0.5, 67, sax));
  
  //Measure 2
  demo1.placeEvent(0,1,0, new Note(1.0, 67, sax));
  
  demo1.placeEvent(0,1,3, new Note(0.25, 67, sax));
  demo1.placeEvent(0,1,4, new Note(0.25, 67, sax));
  demo1.placeEvent(0,1,5, new Note(0.25, 67, sax));
  demo1.placeEvent(0,1,6, new Note(0.25, 67, sax));
  
  //Measure 3
  demo1.placeEvent(0,2,0, new Note(1.0, 68, sax));
  demo1.placeEvent(0,2,1, new Note(1.0, 69, sax));
  demo1.placeEvent(0,2,2, new Note(1.0, 70, sax));
  demo1.placeEvent(0,2,3, new Note(1.0, 71, sax));
  
  return demo1;
}

/*all i really think that's left is to sort of assign values and stuff for each demo
I think the foundation is pretty good, it's just setting values and stuff
*/


  //this is just the foundation/structure for the demos
  /*
  //fields
  
  int or float for the time and key signature, instrument is prob string
  int/float KeySig;
  int/float TimeSig;
  String InstrumentType;
  more will come, but this is kinda the starting point
  unsure if notes should be int or string, ill figure it out
  
  constructor
  Demo(time signature, key signature, all that stuff){
    this.keySig = keysignature information (pull from other tabs)
    this.TimeSig = timesignature information
    this.InstrumentType = instrument info
  }
  
  Methods
  
  
  //drawing/visualizing it using 
  >draw the time and key signatures and notes and stuff if they dont already exist/dont have a command or call function
  
  //in the gui, it should be called/commanded like in the spinning whiteboard thing
  so that it can be used instead of just sitting there
  
  //have a method that works as an array (only array cuz 3 demos only)
  //might need to make 3 constructors in the main tab, each with their own stuff/info
  
  //method to analyze what each of the demo's has, and calling that information
  */
