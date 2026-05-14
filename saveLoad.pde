class SavedPiece{
  String saveLocation;
  MusicalPiece piece;
  
  SavedPiece(String s, MusicalPiece p){
    this.saveLocation = s;
    this.piece = p;
  }
  /*
  JSONObject createFile(){
    JSONArray instrumentData = new JSONArray(); //Contains information per instrument
    for (int i=0;i<this.piece.instruments.size();i++){
       JSONObject instrument = new JSONObject(); //Per-instrument data
       
       
       
    }
    
    
    
   
  }
  
  
  */
}
