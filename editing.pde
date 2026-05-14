class EditManager {

  ArrayList<String> undoList;
  ArrayList<String> redoList;

  boolean drag;

  String DraggedItem;

  float dragX;
  float dragY;

  float snapSpace;
  float snapX;
  float snapY;

  float trashX;
  float trashY;
  float trashW;
  float trashH;

  ArrayList<String> placedNames;
  ArrayList<Float> placedX;
  ArrayList<Float> placedY;

  EditManager() {

    undoList = new ArrayList<String>();
    redoList = new ArrayList<String>();

    drag = false;

    DraggedItem = "";

    dragX = 0;
    dragY = 0;

    snapSpace = 30;

    snapX = 200;
    snapY = 200;

    trashX = 500;
    trashY = 600;
    trashW = 100;
    trashH = 50;

    placedNames = new ArrayList<String>();
    placedX = new ArrayList<Float>();
    placedY = new ArrayList<Float>();
  }


  void ActionAdd(String action) {

    undoList.add(action);

    redoList.clear();
  }


  String undo() {

    if (undoList.size() > 0) {

      String action = undoList.get(undoList.size() - 1);

      undoList.remove(undoList.size() - 1);

      redoList.add(action);

      return action;
    }
    return "";
  }


  String redo() {

    if (redoList.size() > 0) {

      String action = redoList.get(redoList.size() - 1);

      redoList.remove(redoList.size() - 1);

      undoList.add(action);

      return action;
    }
    return "";
  }


  void HistorySave() {

    String[] history = new String[undoList.size()];

    for (int i = 0; i < undoList.size(); i++) {
      history[i] = undoList.get(i);
    }
    saveStrings("history.txt", history);
  }


  void MoveAction(String itemName) {
    drag = true;
    DraggedItem = itemName;
    dragX = mouseX;
    dragY = mouseY;
  }


  void dragUpdate() {

    if (drag) {
      dragX = mouseX;
      dragY = mouseY;
    }
  }


  void placeAction() {

    if (!drag) {
      return;
    }

    float snappedX = round((dragX - snapX) / snapSpace) * snapSpace + snapX;

    float snappedY = round((dragY - snapY) / snapSpace) * snapSpace + snapY;

    if (dragX > snapX && dragX < width - 150 && dragY > snapY && dragY < height - 120) {

      placedNames.add(DraggedItem);
      placedX.add(snappedX);
      placedY.add(snappedY);

      ActionAdd(DraggedItem + " placed");
    }

    drag = false;
    DraggedItem = "";
  }


  void deleteAction() {

    for (int i = placedNames.size() - 1; i >= 0; i--) {

      float x = placedX.get(i);
      float y = placedY.get(i);

      if (x > trashX && x < trashX + trashW && y > trashY && y < trashY + trashH) {

        ActionAdd(placedNames.get(i) + " deleted");

        placedNames.remove(i);
        placedX.remove(i);
        placedY.remove(i);
      }
    }
  }


  void drawPlacedItems() {

    fill(255);

    for (int i = 0; i < placedNames.size(); i++) {

      float x = placedX.get(i);
      float y = placedY.get(i);

      ellipse(x, y, 20, 15);
      line(x + 8, y, x + 8, y - 35);
    }
  }


  void drawDraggedItem() {

    if (drag) {
      
      fill(255);
      ellipse(dragX, dragY, 20, 15);
      line(dragX + 8, dragY, dragX + 8, dragY - 35);
    }
  }


  void drawTrash() {

    if (drag) {
      stroke(255, 255, 0);
      strokeWeight(4);
    } 
    else {
      stroke(255);
      strokeWeight(2);
    }

    fill(40);
    rect(trashX, trashY, trashW, trashH, 10);

    rect(trashX - 10, trashY - 12, trashW + 20, 12, 5);
    fill(255);

    textAlign(CENTER, CENTER);
    textSize(22);
    text("TRASH", trashX + trashW/2, trashY + trashH/2);
  }


  void display() {
    drawPlacedItems();
    drawDraggedItem();
    drawTrash();
  }
  
  
  
}
  
