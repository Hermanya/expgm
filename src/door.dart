library game;
import 'block.dart';
import 'actor.dart';
import 'dart:html';
class Door{
  num x,y;
  num width, height;
  bool isOpen;
  num progress;
  Door(this.x,this.y,this.isOpen){
    width = 2*Block.sideLength;
    height = 2*Block.sideLength;
    progress = 0;
  }
  Door.fromJSON(obj){
    x = obj["x"];
    y = obj["y"];
    isOpen = obj["isOpen"];
    width = 2*Block.sideLength;
    height = 2*Block.sideLength;
    progress = 0;
  }
  bool isLevelCompleted(Actor actor,startTime){
    if (isOpen){
        if (x - width/2 <= actor.x - actor.width/2 &&
            x + width/2 >= actor.x + actor.width/2 &&
            y - height/2 <= actor.y &&
            y + height/2 >= actor.y + actor.height
            ){
          print("cool-cool-cool, level completed");
          querySelector("#canvas").style.opacity="0";
          querySelector("#text-line").style.height="0";
          querySelector("#card").style.display="block";
          querySelector("#card").style.opacity="1";
          var time = new DateTime.now().millisecondsSinceEpoch - startTime;
          var date = new DateTime.fromMillisecondsSinceEpoch(time);
          var string = (date.minute>9?"":"0")+date.minute.toString()+
              ":"+(date.second>9?"":"0")+date.second.toString();
          querySelector("#taken-time").text=string;
          return true;
        }
    }
    if (progress != 0){
      progress++;
      if (progress == 10){
        isOpen = true;
        progress = 0;
      }
    }
    return false;
  }
  String toJson(){
    return ["{\"x\":",x,
            ",\"y\":",y,
            ",\"isOpen\":",isOpen,"}"].join("");
  }
}