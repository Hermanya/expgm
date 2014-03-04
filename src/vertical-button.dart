library item;
import 'door.dart';
import 'block.dart';
import 'dart:html';
import 'keyboard.dart';
import 'actor.dart';

class VerticalButton{
  num x,y;
  num width, height;
  Door door;
  bool locked;
  VerticalButton(this.x,this.y,this.door){
    width = Block.sideLength/16*3;
    height = Block.sideLength;
    locked = false;
  }
  VerticalButton.fromJSON(Door door,Map obj){
    x = obj["x"];
    y = obj["y"];
    this.door = door;
    width = Block.sideLength/16*3;
    height = Block.sideLength;
    locked = false;
  }
  tryOpen(Actor actor, Keyboard keyboard){
    if (! locked){
      if (x - width/2 >= actor.x - actor.width/2 &&
          x + width/2 <= actor.x + actor.width/2 &&
          y - height/2 >= actor.y - actor.height/2 &&
          y + height/2 <= actor.y + actor.height/2
          ){
        if (keyboard.isPressed(KeyCode.E)){
          door.progress = 1;
          locked = true;
        }
      }
    }
  }
  String toJson(){
    return ["{\"x\":",x,
            ",\"y\":",y,
            "}"].join("");
  }
}