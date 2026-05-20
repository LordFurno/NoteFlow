class EditManager {

  int activeTrack; //Which track is being edited
  int selectedMeasure; //Which measure has the selected event
  int selectedEvent; //Index inside the measure event list
  boolean placeMode; //Place if true, select if false
  boolean placingRest; //Place rests instead of notes
  String statusText;

  EditManager() {
    resetEditor();
  }

  void resetEditor(){
    activeTrack = 0;
    placeMode = true;
    placingRest = false;
    clearSelection();
    statusText = "Place mode";
  }

  void clearSelection(){
    selectedMeasure = -1;
    selectedEvent = -1;
  }

  boolean hasSelection(){
    //Makes sure the saved selection still points to a real event
    if (userPiece == null){
      return false;
    }
    if (activeTrack < 0 || activeTrack >= userPiece.tracks.size()){
      return false;
    }
    if (selectedMeasure < 0 || selectedMeasure >= userPiece.tracks.get(activeTrack).size()){
      return false;
    }

    Measure measure = userPiece.getMeasure(activeTrack, selectedMeasure);
    return selectedEvent >= 0 && selectedEvent < measure.events.size();
  }

  MusicEvent selectedMusicEvent(){
    if (!hasSelection()){
      return null;
    }

    return userPiece.getMeasure(activeTrack, selectedMeasure).events.get(selectedEvent);
  }

  void selectEvent(int measureID, int eventID){
    //Selection is stored as measure index + event index
    if (userPiece == null || activeTrack < 0 || activeTrack >= userPiece.tracks.size()){
      clearSelection();
      return;
    }
    if (measureID < 0 || measureID >= userPiece.tracks.get(activeTrack).size()){
      clearSelection();
      return;
    }

    Measure measure = userPiece.getMeasure(activeTrack, measureID);

    if (eventID < 0 || eventID >= measure.events.size()){
      clearSelection();
      return;
    }

    selectedMeasure = measureID;
    selectedEvent = eventID;
    setStatus("Selected measure " + (measureID+1) + ", event " + (eventID+1));
  }

  void selectNextEvent(int direction){
    //Used by left/right arrows to move through the event list
    if (userPiece == null || userPiece.tracks.size() == 0){
      return;
    }

    keepTrackInRange();

    if (!hasSelection()){
      selectEvent(0, 0);
      return;
    }

    int measureID = selectedMeasure;
    int eventID = selectedEvent + direction;

    while (measureID >= 0 && measureID < userPiece.tracks.get(activeTrack).size()){
      Measure measure = userPiece.getMeasure(activeTrack, measureID);

      if (eventID >= 0 && eventID < measure.events.size()){
        selectEvent(measureID, eventID);
        return;
      }

      measureID += direction;

      if (direction > 0){
        eventID = 0;
      }else if (measureID >= 0){
        eventID = userPiece.getMeasure(activeTrack, measureID).events.size() - 1;
      }
    }

    setStatus("No more events");
  }

  void changeSelectedPitch(int amount){
    //Pitch only makes sense for notes, not rests
    MusicEvent event = selectedMusicEvent();

    if (!(event instanceof Note)){
      setStatus("Select a note first");
      return;
    }

    Note note = (Note) event;
    note.midiNote = constrain(note.midiNote + amount, minEditorMidi, maxEditorMidi);
    setStatus("Pitch: " + note.midiNote);
  }

  void changeSelectedDuration(float duration){
    //Use the MusicalPiece edit method so Measure.changeEvent handles the subdivision
    selectedDuration = duration;

    MusicEvent event = selectedMusicEvent();

    if (event == null){
      setStatus("Duration: " + duration);
      return;
    }

    MusicEvent newEvent;

    if (event instanceof Note){
      Note note = (Note) event;
      newEvent = new Note(duration, note.midiNote, note.family);
      ((Note)newEvent).hasAccidental = note.hasAccidental;
      ((Note)newEvent).accidentalModifier = note.accidentalModifier;
    }else{
      newEvent = new Rest(duration);
    }

    if (userPiece.editEvent(activeTrack, selectedMeasure, selectedEvent, newEvent)){
      setStatus("Duration changed to " + duration);
    }else{
      setStatus("Duration blocked by another note");
    }
  }

  void deleteSelected(){
    //Deleting means replacing the event with an equal-length rest
    MusicEvent event = selectedMusicEvent();

    if (event == null){
      return;
    }

    if (userPiece.editEvent(activeTrack, selectedMeasure, selectedEvent, new Rest(event.duration))){
      setStatus("Changed to rest");
    }
  }

  void togglePlaceMode(){
    placeMode = !placeMode;

    if (placeMode){
      setStatus("Place mode");
    }else{
      setStatus("Select mode");
    }
  }

  void toggleRestMode(){
    placingRest = !placingRest;

    if (placingRest){
      setStatus("Placing rests");
    }else{
      setStatus("Placing notes");
    }
  }

  void addMeasureToPiece(){
    if (userPiece == null){
      return;
    }

    if (userPiece.measureCount() >= numberOfSystems * measuresPerSystem){
      setStatus("Maximum measures reached");
      return;
    }

    userPiece.addMeasure();
    saveHistoryState();
    setStatus("Added measure " + userPiece.measureCount());
  }

  void deleteLastMeasure(){
    //Remove the last measure from every track
    if (userPiece == null || userPiece.measureCount() <= 1){
      setStatus("Cannot delete the last measure");
      return;
    }

    userPiece.stopPlayback();

    int removeID = userPiece.measureCount() - 1;
    for (int t=0;t<userPiece.tracks.size();t++){
      userPiece.tracks.get(t).remove(removeID);
    }

    if (selectedMeasure >= userPiece.measureCount()){
      clearSelection();
    }

    saveHistoryState();
    setStatus("Deleted measure " + (removeID+1));
  }

  void addTrackToPiece(Instrument instrument){
    //MusicalPiece.addInstrument creates the matching measures too
    if (userPiece == null){
      return;
    }

    userPiece.addInstrument(instrument);
    activeTrack = userPiece.tracks.size() - 1;
    clearSelection();
    syncInstrumentDropdown();
    setStatus("Added track " + (activeTrack+1));
  }

  void deleteActiveTrack(){
    //After deleting a track, fix the track number stored inside each measure
    if (userPiece == null || userPiece.tracks.size() <= 1){
      setStatus("Cannot delete the last track");
      return;
    }

    userPiece.stopPlayback();
    userPiece.tracks.remove(activeTrack);
    userPiece.instruments.remove(activeTrack);

    for (int t=0;t<userPiece.tracks.size();t++){
      for (Measure measure: userPiece.tracks.get(t)){
        measure.track = t;
      }
    }

    keepTrackInRange();
    clearSelection();
    composeInstrument = userPiece.instruments.get(activeTrack);
    syncInstrumentDropdown();
    setStatus("Deleted track. Active track " + (activeTrack+1));
  }

  void setActiveTrackInstrument(String instrumentName){
    //Existing notes need the new instrument too
    if (userPiece == null || userPiece.tracks.size() == 0){
      return;
    }

    keepTrackInRange();

    Instrument newInstrument = createInstrumentByName(instrumentName);
    userPiece.instruments.set(activeTrack, newInstrument);
    composeInstrument = newInstrument;

    for (Measure measure: userPiece.tracks.get(activeTrack)){
      for (MusicEvent event: measure.events){
        if (event instanceof Note){
          Note note = (Note) event;
          note.family = newInstrument;
        }
      }
    }

    applyMasterVolumeToUserPiece();
    syncInstrumentDropdown();
    setStatus("Track " + (activeTrack+1) + " instrument: " + newInstrument.name);
  }

  void changeTrack(int direction){
    //direction is -1 for previous track, 1 for next track
    if (userPiece == null || userPiece.tracks.size() == 0){
      return;
    }

    activeTrack += direction;
    keepTrackInRange();
    clearSelection();
    syncInstrumentDropdown();
    setStatus("Track " + (activeTrack+1));
  }

  void keepTrackInRange(){
    //Prevents activeTrack from pointing past the end after deleting/loading
    if (userPiece == null || userPiece.tracks.size() == 0){
      activeTrack = 0;
    }else{
      activeTrack = constrain(activeTrack, 0, userPiece.tracks.size() - 1);
    }
  }
  void updateKeySig(KeySignature k){
    if (userPiece == null){
      return;
    }

    userPiece.keySig = k;
    saveHistoryState();
    setStatus("Key signature: " + k.getKeyName());
  }

  boolean pieceIsEmpty(){
    //Changing meter is only safe before notes are placed
    if (userPiece == null){
      return true;
    }

    for (ArrayList<Measure> track: userPiece.tracks){
      for (Measure measure: track){
        for (MusicEvent event: measure.events){
          if (event instanceof Note){
            return false;
          }
        }
      }
    }

    return true;
  }

  void rebuildMeasureRests(Measure measure){
    //Rebuilds an empty measure for the current time signature
    measure.timeSig = userPiece.timeSig;
    measure.events.clear();
    measure.clearAccidentals();

    for (int i=0;i<measure.timeSig.beatsPerMeasure();i++){
      measure.events.add(new Rest(measure.timeSig.beatDuration()));
    }
  }

  void updateTimeSig(TimeSignature t){
    if (userPiece == null){
      return;
    }

    if (!pieceIsEmpty()){
      setStatus("Time signature can only change while empty");
      return;
    }

    userPiece.stopPlayback();
    userPiece.timeSig = t;

    for (ArrayList<Measure> track: userPiece.tracks){
      for (Measure measure: track){
        rebuildMeasureRests(measure);
      }
    }

    clearSelection();
    saveHistoryState();
    setStatus("Time signature: " + t.toString());
  }

  void setSelectedAccidental(int modifier){
    MusicEvent event = selectedMusicEvent();

    if (!(event instanceof Note)){
      setStatus("Select a note first");
      return;
    }

    Note note = (Note) event;
    note.hasAccidental = true;
    note.accidentalModifier = modifier;

    saveHistoryState();

    if (modifier > 0){
      setStatus("Sharp accidental");
    }else if (modifier < 0){
      setStatus("Flat accidental");
    }else{
      setStatus("Natural accidental");
    }
  }

  void clearSelectedAccidental(){
    MusicEvent event = selectedMusicEvent();

    if (!(event instanceof Note)){
      setStatus("Select a note first");
      return;
    }

    Note note = (Note) event;
    note.hasAccidental = false;
    note.accidentalModifier = 0;
    saveHistoryState();
    setStatus("Cleared accidental");
  }

  void setStatus(String message){
    statusText = message;
    println(message);
  }
}
