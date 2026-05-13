class Demo{
  
  //Fields
  String demoName;
  TimeSignature timeSig;
  KeySignature keySig;
  Instrument instrumentType;
  
  ArrayList <MusicEvent> demoEvents;
  
  float xPoint, yPoint;
  float space;
  
  //Constructor
  Demo(String numDem, TimeSignature t, KeySignature k, Instrument i ){
    
    this.demoName = numDem;

    this.timeSig = t;
    this.keySig = k;
    this.instrumentType = i;

    demoEvents = new ArrayList<MusicEvent>();

    xPoint = 70;
    yPoint = 140;
    space = 70;
  }
  
  void addNote(float duration, int midiPitch){
    
    Note n = new Note(duration, midiPitch, instrumentType);
    demoEvents.add(n);
  }
  
  void addRest(float duration) {

    Rest r = new Rest(duration);
    demoEvents.add(r);
  }
  
  void playDemo(){
    
    for(MusicEvent e : demoEvents){
      
      if(e instanceof Note){
        
        Note n = (Note)e;
        n.play();
        
        delay(int((60000.0 / bpm) * n.duration));
      }
      else{
        
        delay(int((60000.0 / bpm) * e.duration));
      }
    }
  }
  
  void DemoAnalyze(){
    
    int noteCount = 0;
    int restCount = 0;

    for (MusicEvent e : demoEvents) {

      if (e instanceof Note) {
        noteCount++;
      }
      else {
        restCount++;
      }
    }
    
    println("Demo Name: " + demoName);
    println("Instrument: " + instrumentType.name);
    println("Time Signature: " + timeSig.toString());
    println("Key Signature: " + keySig.getKeyName());
    println("Notes: " + noteCount);
    println("Rests: " + restCount);
  }
}
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
