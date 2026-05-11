class KeySignature {

  // Fields
  String keyName;
  boolean major;
  int accidentalCount;

  // Constructor
  KeySignature(String keyName, boolean major, int accidentalCount) {
    this.keyName = keyName;
    this.major = major;
    this.accidentalCount = accidentalCount;
  }

  //Methods
  void display(float x, float y) {
    textSize(24);

    if (major) {
      text(keyName + " Major", x, y);
    } else {
      text(keyName + " Minor", x, y);
    }

    text("Accidentals: " + accidentalCount, x, y + 30);
  }

  String getFullName() {
    if (major) {
      return keyName + " Major";
    } else {
      return keyName + " Minor";
    }
  }

  void changeKey(String newKey, boolean isMajor, int newCount) {
    keyName = newKey;
    major = isMajor;
    accidentalCount = newCount;
  }
}
