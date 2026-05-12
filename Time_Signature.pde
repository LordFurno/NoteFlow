class TimeSignature {
  int upper;  //Beats per measure (how many beats)
  int lower;  //Note value that gets one beat (4 = quarter, 8 = eighth, etc.)
  int numBeats, maxBeats;

  TimeSignature(int upper, int lower) {
    this.upper = upper;
    this.lower = lower;
  }

  
  int beatsPerMeasure() {
    return upper;
  }

  //Duration of one beat in terms of quarter-note units
  // e.x. 4/4 → 1.0, 6/8 → 0.5, 2/2 → 2.0
  float beatDuration() {
    return 4.0 / lower;
  }

  float measureDuration() {
    return upper * beatDuration();
  }

  String toString() {
    return upper + "/" + lower;
  }
}
