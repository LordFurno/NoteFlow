class KeySignature {

  // Fields
  boolean sharp; //Whether the key is with sharps
  int accidentalCount; //0-7

  // Constructor
  KeySignature(boolean sharp, int accidentalCount) {
    this.sharp = sharp;
    this.accidentalCount = accidentalCount;
  }
  
  String getKeyName() {
    if (sharp) {
      return sharpMajorKeys[accidentalCount] + " Major";
    }else{
      return flatMajorKeys[accidentalCount] + " Major";
    }
  }
  
  //Returns which midi pitch classes (0–11) are sharpened/flattened in this key
  int[] getAccidentalPitchClasses(){
    int res[] = new int[this.accidentalCount];
    for (int i=0;i<this.accidentalCount;i++){
      res[i] = sharp ? sharpMidi[i]: flatMidi[i]; 
    }
    return res;
  }
  
  //Given a raw midi note, apply this key signature and return the adjusted note
  int modifyPitch(int midiNote){
     int pitchClass = midiNote%12;
     for (int i=0;i<this.accidentalCount;i++){
       if (sharp){
         if (pitchClass==sharpMidi[i]){
           return midiNote+1;
         }
       }else{
         if (pitchClass==flatMidi[i]){
           return midiNote-1;
         }
       }
     }
     return midiNote; //Not affected
  }

  //Methods
  void display(float x, float y) {
    textSize(24);
    text(getKeyName(), x, y);

    text("Accidentals: " + accidentalCount, x, y + 30);
  }


  void changeKey(boolean newSharp, int newCount) {
    this.sharp = newSharp;
    this.accidentalCount = newCount;
  }
}
