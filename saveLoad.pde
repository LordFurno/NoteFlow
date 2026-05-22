ArrayList<String> undoStack = new ArrayList<String>();
ArrayList<String> redoStack = new ArrayList<String>();

String historyPath = "data/History_Storage.txt";
boolean historyLocked = false;

ArrayList<String> historyStates = new ArrayList<String>();

int historyIndex = -1;

boolean loadingHistoryState = false;

class SavedPiece{
  String saveLocation;
  MusicalPiece piece;

  SavedPiece(String s, MusicalPiece p){
    this.saveLocation = s;
    this.piece = p;
  }

  void createFile(){
    JSONObject root = new JSONObject();

    root.setString("title", this.piece.title);
    root.setInt("tempo", this.piece.tempo);

    JSONObject keySigJSON = new JSONObject();
    keySigJSON.setBoolean("sharp", this.piece.keySig.sharp);
    keySigJSON.setInt("accidentalCount", this.piece.keySig.accidentalCount);
    root.setJSONObject("keySig", keySigJSON);

    JSONObject timeSigJSON = new JSONObject();
    timeSigJSON.setInt("upper", this.piece.timeSig.upper);
    timeSigJSON.setInt("lower", this.piece.timeSig.lower);
    root.setJSONObject("timeSig", timeSigJSON);

    JSONArray instrumentData = new JSONArray(); //Contains information per instrument
    for (int i=0;i<this.piece.instruments.size();i++){ //For ecah instrument in the piece
    
       JSONObject instrument = new JSONObject(); //Per-instrument data
       Instrument cur = this.piece.instruments.get(i);
       int[] samplePitches = cur.samplePitches;
       float[] starts = cur.sampleStarts;

       String pitchData = "";
       for (int j=0;j<samplePitches.length;j++){
         if (j==samplePitches.length-1){
           pitchData += str(samplePitches[j]);
         }else{
           pitchData += str(samplePitches[j]) + ",";
         }
       }
       
       String startData = "";
       for (int j=0;j<starts.length;j++){
         if (j==starts.length-1){
           startData += str(starts[j]);
         }else{
           startData += str(starts[j]) + ",";
         }
       }

       String fileData = String.join(",", cur.filePaths);

       instrument.setString("name", cur.name);
       instrument.setString("pitches", pitchData);
       instrument.setString("starts", startData);
       instrument.setString("files", fileData);
       instrumentData.setJSONObject(i, instrument);
    }
    root.setJSONArray("instruments", instrumentData);

    JSONArray tracksJSON = new JSONArray(); //Data per-track
    
    for (int t=0;t<this.piece.tracks.size();t++){
      ArrayList<Measure> track = this.piece.tracks.get(t);
      JSONArray trackJSON = new JSONArray();
      
      for (int m=0;m<track.size();m++){
        Measure measure = track.get(m);
        JSONObject measureJSON = new JSONObject(); //Data per-measure

        String accData = ""; //Accidentaldata
        boolean firstAcc = true;
        for (int keyS : measure.withinMeasureAccidentals.keySet()){
          if (!firstAcc){
            accData += ",";
          }
          accData += keyS + ":" + measure.withinMeasureAccidentals.get(keyS);
          firstAcc = false;
        }
        measureJSON.setString("accidentals", accData);

        JSONArray eventsJSON = new JSONArray(); //Each event in each measure
        
        for (int e=0;e<measure.events.size();e++){
          
          MusicEvent event = measure.events.get(e);
          JSONObject eventJSON = new JSONObject();
          
          eventJSON.setFloat("duration", event.duration);
          if (event instanceof Note){
            Note n = (Note) event;
            eventJSON.setString("type", "note");
            eventJSON.setInt("midiNote", n.midiNote);
            eventJSON.setInt("instrumentIndex", this.piece.instruments.indexOf(n.family));
            if (n.hasAccidental){
              eventJSON.setBoolean("hasAccidental", true);
              eventJSON.setInt("accidentalModifier", n.accidentalModifier);
            }
            
          }else{
            eventJSON.setString("type", "rest");
          }
          
          eventsJSON.setJSONObject(e, eventJSON);
        }
        
        measureJSON.setJSONArray("events", eventsJSON);
        trackJSON.setJSONObject(m, measureJSON);
      }
      tracksJSON.setJSONArray(t, trackJSON);
    }
    root.setJSONArray("tracks", tracksJSON);

    saveJSONObject(root, this.saveLocation);
  }



}




MusicalPiece loadPiece(String path, PApplet app){
  JSONObject root = loadJSONObject(path);

  String title = root.getString("title");
  int tempo = root.getInt("tempo");

  JSONObject keySigJSON = root.getJSONObject("keySig");
  KeySignature keySig = new KeySignature(keySigJSON.getBoolean("sharp"), keySigJSON.getInt("accidentalCount"));

  JSONObject timeSigJSON = root.getJSONObject("timeSig");
  TimeSignature timeSig = new TimeSignature(timeSigJSON.getInt("upper"), timeSigJSON.getInt("lower"));

  MusicalPiece piece = new MusicalPiece(title, keySig, timeSig, tempo);

  JSONArray instrumentsJSON = root.getJSONArray("instruments");
  for (int i=0;i<instrumentsJSON.size();i++){
    JSONObject instrJSON = instrumentsJSON.getJSONObject(i);
    String name = instrJSON.getString("name");

    String[] pitchStrings = instrJSON.getString("pitches").split(",");
    
    int[] pitches = new int[pitchStrings.length];
    
    for (int j=0;j<pitchStrings.length;j++){
      pitches[j] = int(pitchStrings[j].trim()); //Trim first so extra spaces don't break parsing
    }

    String[] startStrings = instrJSON.getString("starts").split(",");
    float[] starts = new float[startStrings.length];
    for (int j=0;j<startStrings.length;j++){
      starts[j] = float(startStrings[j].trim());
    }

    String[] files = instrJSON.getString("files").split(",");
    for (int j=0;j<files.length;j++){
      files[j] = files[j].trim();
    }

    piece.addInstrument(new Instrument(name, pitches, files, starts, app));
  }

  //Replace auto-created placeholder measures with the saved ones
  JSONArray tracksJSON = root.getJSONArray("tracks");
  for (int t=0;t<tracksJSON.size();t++){
    piece.tracks.get(t).clear();
    
    JSONArray trackJSON = tracksJSON.getJSONArray(t);
    
    for (int m=0;m<trackJSON.size();m++){
      JSONObject measureJSON = trackJSON.getJSONObject(m);
      Measure measure = new Measure(t, m, timeSig);
      measure.events.clear();

      String accData = measureJSON.getString("accidentals");
      if (accData.length() > 0){
        for (String pair : accData.split(",")){
          String[] parts = pair.split(":");
          measure.withinMeasureAccidentals.put(int(parts[0].trim()), int(parts[1].trim()));
        }
      }

      JSONArray eventsJSON = measureJSON.getJSONArray("events");
      for (int e=0;e<eventsJSON.size();e++){
        
        JSONObject eventJSON = eventsJSON.getJSONObject(e);
        float duration = eventJSON.getFloat("duration");
        
        if (eventJSON.getString("type").equals("note")){
          int midiNote = eventJSON.getInt("midiNote");
          int instrIdx = eventJSON.getInt("instrumentIndex");
          Note note = new Note(duration, midiNote, piece.instruments.get(instrIdx));

          if (eventJSON.hasKey("hasAccidental") && eventJSON.getBoolean("hasAccidental")){
            note.hasAccidental = true;
            note.accidentalModifier = eventJSON.getInt("accidentalModifier");
          }

          measure.events.add(note);
          
        }else{
          measure.events.add(new Rest(duration));
        }
      }

      piece.tracks.get(t).add(measure);
    }
  }

  return piece;
}

void loadSavedProjects() {

  savedProjects.clear();

  String[] files = listPaths(dataPath(""));

  if (files == null) return;

  for (String path : files) {

    if (path.endsWith(".json")) {

      String name = projectNameFromPath(path);

      savedProjects.add(name);
    }
  }
}

String projectNameFromPath(String path){
  int slash = Math.max(path.lastIndexOf("/"), path.lastIndexOf("\\"));
  return path.substring(slash + 1, path.length() - 5);
}

String cleanProjectName(String projectName){
  String cleaned = projectName.trim();
  String badChars = "\\/:*?\"<>|";

  for (int i=0;i<badChars.length();i++){
    cleaned = cleaned.replace(badChars.charAt(i), '_');
  }

  return cleaned;
}


void saveCurrentProject(String projectName) {

  projectName = cleanProjectName(projectName);
  if (projectName.equals("")){
    println("Project name is empty.");
    return;
  }

  userPiece.title = projectName;

  SavedPiece save = new SavedPiece("data/" + projectName + ".json", userPiece);
  save.createFile();

  loadSavedProjects();

  println("Saved project: " + projectName);
}

boolean deleteSavedProject(String projectName){
  projectName = cleanProjectName(projectName);
  if (projectName.equals("")){
    return false;
  }

  java.io.File file = new java.io.File(dataPath(projectName + ".json"));
  if (!file.exists()){
    println("Could not find project: " + projectName);
    loadSavedProjects();
    return false;
  }

  boolean deleted = file.delete();
  loadSavedProjects();

  if (deleted){
    println("Deleted project: " + projectName);
  }else{
    println("Could not delete project: " + projectName);
  }

  return deleted;
}

void saveHistoryState(){

  if (loadingHistoryState){
    return;
  }

  while (historyStates.size() > historyIndex + 1){
    historyStates.remove(historyStates.size()-1);
  }

  String path = "data/History_Storage/history_" + historyStates.size() + ".json";

  SavedPiece save = new SavedPiece(path, userPiece);
  save.createFile();

  historyStates.add(path);
  historyIndex = historyStates.size()-1;
}

boolean loadProject(String projectName){
  String path = "data/" + projectName + ".json";
  java.io.File file = new java.io.File(dataPath(projectName + ".json"));

  if (!file.exists()){
    println("Could not find project: " + projectName);
    return false;
  }

  if (userPiece != null){
    userPiece.stopPlayback();
  }

  userPiece = loadPiece(path, this);

  if (userPiece.instruments.size() > 0){
    composeInstrument = userPiece.instruments.get(0);
  }

  editManager.resetEditor();
  applyMasterVolumeToUserPiece();

  undoStack.clear();
  redoStack.clear();
  
  saveHistoryState();
  
  println("Loaded project: " + projectName);
  
  return true;
}

void undoAction(){

  if (historyIndex <= 0){
    return;
  }

  historyIndex--;
  loadHistoryState(historyStates.get(historyIndex));
}

void redoAction(){

  if (historyIndex >= historyStates.size()-1){
    return;
  }

  historyIndex++;
  loadHistoryState(historyStates.get(historyIndex));
}
//Loads an undo/redo snapshopt and ressets anything connected to old piece
void loadHistoryState(String path){
  if (userPiece != null){
    userPiece.stopPlayback(); //Stops old piece first so playback doesn't keep going after undo/redo
  }

  loadingHistoryState = true;

  userPiece = loadPiece(path, this);

  loadingHistoryState = false;

  if (userPiece.instruments.size() > 0){
    composeInstrument = userPiece.instruments.get(0);
  }

  applyMasterVolumeToUserPiece();

  if (PlayButton != null){
    PlayButton.setText("Play/Pause");
  }

  syncInstrumentDropdown();
}
