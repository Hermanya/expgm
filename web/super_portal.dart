import 'dart:html';
import 'dart:collection';
import 'dart:web_audio';
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
var animationFrame,stage,actor,render,keyboard,moments,clone,img,previousActor,startTime;

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
init(){
  
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
  querySelector("#canvas").style.opacity="1";
  querySelector("#text-line").style.height="64px";
}
void main() {
  img = new ImageElement(src: "../resources/actor.png");
  img.onLoad.listen((e){tryToInit();});

  Map<String, String> params = new HashMap<String, String>();
    window.location.search.replaceFirst("?", "").split("&").forEach((e) {
      if (e.contains("=")) {
        List<String> split = e.split("=");
        params[split[0]] = split[1];
      }
    });
  int level;
  try{
    level = int.parse(params["chamber"]);
  }catch(e){
    level = 1;
  }
 
  querySelector("#restart-chamber").setAttribute("href", "game.html?chamber="+(level).toString());
  querySelector("#next-chamber").setAttribute("href", "game.html?chamber="+(level+1).toString());
  var url = ["../levels/",level,".json"].join("");
  var request = HttpRequest.getString(url).then(onDataLoaded, onError: onDataLoadError);
  canvas.width = 64*18;//window.innerWidth;
  canvas.height= 640;//window.innerHeight;  
  var audio = new AudioElement("../resources/Portal2-02-Halls_of_Science_4_ringtone.mp3");
  //http://media.steampowered.com/apps/portal2/soundtrack/02/ringtones/mp3/Portal2-02-Halls_of_Science_4_ringtone.mp3
  audio.play();
  audio.onEnded.listen((Event e){
    print("ended");
    audio.currentTime = 0;
    audio.play();
  });
}
onDataLoaded(string){
 sideLength = canvas.width/18;
 
 stage = new Stage.fromJson(string,sideLength,textLine);
 //stage = new Stage.test(2,sideLength,canvas.height,textLine);
 print(stage.toJSON());
 tryToInit();
}
onDataLoadError(var a){
  querySelector("#canvas").style.display="none";
  querySelector("#text-line").style.display="none";
  querySelector("#card").style.display="block";
  querySelector("#card").style.opacity="1";
  querySelector("#restart-chamber").style.display="none";
  querySelector("#next-chamber").style.display="none";
  querySelector("#taken-time").text="404";
}
num loadedContent = 0;
tryToInit(){
  loadedContent++;
  if (loadedContent == 2)
    init();
}
