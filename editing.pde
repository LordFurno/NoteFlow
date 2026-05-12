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
//should also store all the actions into a textfile so that it can be reached for undo/redo

/*when moving/dragging the notes and stuff, it will work as a drag and drop sorta, 
like if its near the line things or area and mouse dragged equals false, it clicks into place
when its dragged away from the legend, the item is still there, but youre dragging too
essentially its unlimited

void moveAction(){
  if mouseclicked on item is true, then mousedragged on it is also true
}

void placeAction(){
  set mousedragged equal to false, 
  it will check if its in the vicinity of the area
  if it is, it will click into place (probably using for/while loop for spacing)
  if its not in vicinity, then it just goes back to the legend/loading area
}

void deleteAction(){
  user will just click the note or item (if mouseclicked on item is true), 
  and there will be a garbage can icon that glows (either use transparency fill, or turn outline yellow)
  you can click the garbage can, and if you do, it just deletes it
}

*/
