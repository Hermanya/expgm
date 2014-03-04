import 'dart:html';
import 'dart:collection';

import '../src/moment.dart';
import '../src/stage.dart';
import '../src/actor.dart';
import '../src/render.dart';
import '../src/keyboard.dart';

final canvas = querySelector("#canvas");
final textLine = querySelector("#text-line");
final CanvasRenderingContext2D ctx =
( canvas as CanvasElement).context2D;
num sideLength;
Stage stage;
Actor actor;
var animationFrame,render,keyboard,moments,clone,img,previousActor,startTime,currentElement;
void main() {
  canvas.width = 64*18;//window.innerWidth;
    canvas.height= 640;//window.innerHeight;
    sideLength = canvas.width/18;
  img = new ImageElement(src: "../resources/actor.png");
  img.onLoad.listen((e){editorInit();});
  
}
void editorInit(){
  stage = new Stage(2, sideLength, canvas.height, textLine);
  window.onMouseDown.listen(mouseDownHandler);
  querySelector("#current-item").onChange.listen(selectChangeHandler);
}
game(num delta) {
  if (keyboard.isPressed(KeyCode.Q) && moments.length != 0){
    moments.last.actor.restore(actor);
    moments.last.clone.restore(clone);
    moments.removeLast();
  }else{
    if (moments.length != 0){
      previousActor = moments.last.actor;
      actor.updatePosition(stage, keyboard,previousActor,clone);
    if (stage.verticalButton != null)
      stage.verticalButton.tryOpen(actor,keyboard);
    }
    moments.add(new Moment(actor,clone));
    if (moments.length>1024){
      moments.removeFirst();
    }
  }
  if (keyboard.isPressed(KeyCode.ENTER)){
    textLine.style.height="0";
  }
  render.show(stage, actor,clone,previousActor);
  if (! stage.exitDoor.isLevelCompleted(actor,startTime))
  animationFrame = window.animationFrame.then(game);
}
gameInit(){
  
  moments = new Queue<Moment>();
  actor = new Actor(stage.entryDoor.x, stage.entryDoor.y, sideLength);
  clone = new Actor(0, 0, sideLength);
  moments.add(new Moment(actor,clone));
  
  render = new Render(canvas, ctx, img);
  keyboard = new Keyboard();
  canvas.onClick.listen((Event e){actor.generatePortal1(e,stage,canvas,ctx);});
  canvas.onContextMenu.listen((Event e){e.preventDefault();actor.generatePortal2(e,stage,canvas,ctx);return false;});
  canvas.onMouseMove.listen((Event e){actor.moveAim(e,canvas,clone);});
  animationFrame = window.animationFrame.then(game);
  startTime = new DateTime.now().millisecondsSinceEpoch;
}
void selectChangeHandler(Event e){
  var select = querySelector("#stage");
  var value = select.options[select.selectedIndex].value;
  
  switch (value){
  case "luna":
    break;
  case "mars":
    break;
  case "random":
    break;
  }
} 
void mouseDownHandler(Event e){
  
}