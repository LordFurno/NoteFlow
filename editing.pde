class EditManager {

  ArrayList<String> undoList;
  ArrayList<String> redoList;

  EditManager() {

    undoList = new ArrayList<String>();
    redoList = new ArrayList<String>();
  }
  
  void ActionAdd(String action){
    undoList.add(action);
    redoList.clear();
  }
  
  String undo(){
   if(undoList.size() > 0){
     String action = undoList.get(undoList.size() - 1);
     undoList.remove(undoList.size() - 1);
     
     redoList.add(action);
     return action;
   }
   
   return "";
  }
  
  String redo() {

    if (redoList.size() > 0) {

      String action =
        redoList.get(redoList.size() - 1);

      redoList.remove(redoList.size() - 1);

      undoList.add(action);

      return action;
    }

    return "";
  }
}
  
