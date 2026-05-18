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
      pitches[j] = int(pitchStrings[j].trim()); //.trim() removes any weird errors by removint whitespace
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
          measure.events.add(new Note(duration, midiNote, piece.instruments.get(instrIdx)));
          
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

      String name = path.substring(
        path.lastIndexOf("/") + 1,
        path.length() - 5
      );

      savedProjects.add(name);
    }
  }
}


void saveCurrentProject(String projectName) {

  userPiece.title = projectName;

  SavedPiece save = new SavedPiece(
    "data/" + projectName + ".json",
    userPiece
  );

  save.createFile();

  loadSavedProjects();

  println("Saved project: " + projectName);
}
