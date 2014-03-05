import 'dart:math';

import 'stage.dart';
import 'actor.dart';
import 'block.dart';
import 'portal.dart';
import 'door.dart';
import 'vertical-button.dart';

class Render{
  var canvas, ctx, img;
  Render(this.canvas,this.ctx,this.img);
  show(Stage stage,Actor actor,Actor clone,Actor previousActor,{currentEditingElement,isGoodSpot}){
    ctx.fillStyle = "#dfdfdf";
    ctx.strokeStyle = "#fefefe";
    ctx.lineWidth=0.3;
    ctx.fillRect(0,0,canvas.width,canvas.height);
    //background grid
    ctx..beginPath();
    for(int i = 0; i<canvas.width; i+=32){
      ctx..moveTo(i,0)
         ..lineTo(i,canvas.height);
    }
    for(int i = 0; i<canvas.height; i+=32){
      ctx..moveTo(0,i)
         ..lineTo(canvas.width,i);
    }
    ctx..stroke();
    
    //stage
    int i,j;
    num l = Block.sideLength;
    ctx.lineWidth=2;
    ctx.strokeStyle="#000";
    for (i = stage.blocks.length - 1; i >= 0; i--){
      for (j = 0; j < stage.blocks[i].length; j++){
          switch (stage.blocks[i][j].type){
            case "regular":
              ctx.fillStyle = "#ffffff";
              ctx.strokeStyle = "rgba(200,200,200,0.2)";
              break;
            case "non-portalable":
              ctx.fillStyle = "#777";
              ctx.strokeStyle = "rgba(75,75,75,0.2)";
              break;
            case "nothing":
              ctx.fillStyle = "rgba(0,0,0,0)";
              ctx.strokeStyle = "rgba(0,0,0,0)";
              break;
            default:ctx.strokeStyle = "#fff";
              ctx.fillStyle = "#eee";
              
          }
          ctx..beginPath()
             ..moveTo(stage.blocks[i][j].x-l/2,
              canvas.height-stage.blocks[i][j].y-l/2)
             ..lineTo(stage.blocks[i][j].x+l/2,
              canvas.height-stage.blocks[i][j].y-l/2)
             ..lineTo(stage.blocks[i][j].x+l/2,
                canvas.height-stage.blocks[i][j].y+l/2)
             ..lineTo(stage.blocks[i][j].x-l/2,
                canvas.height-stage.blocks[i][j].y+l/2);
         
          
          if ((j*j+i) % 4 == 0){
          ctx..moveTo(stage.blocks[i][j].x,
              canvas.height-stage.blocks[i][j].y-l/2)
             ..lineTo(stage.blocks[i][j].x,
                canvas.height-stage.blocks[i][j].y+l/2);
          }
          if ((j+i*i) % 8 == 2){
            ctx..moveTo(stage.blocks[i][j].x,
                canvas.height-stage.blocks[i][j].y-l/2)
                  ..lineTo(stage.blocks[i][j].x,
                      canvas.height-stage.blocks[i][j].y+l/2)
                ..moveTo(stage.blocks[i][j].x - l/2,
                canvas.height-stage.blocks[i][j].y)
                  ..lineTo(stage.blocks[i][j].x + l/2,
                      canvas.height-stage.blocks[i][j].y);
          }
          
         
          ctx..fill()
             ..stroke()
             ..closePath();
      }
    }
//verticalButton
  if (stage.verticalButton!=null){
    drawVerticalButton(stage.verticalButton);
  }
  //door 
  drawDoor(stage.entryDoor,512);
  drawDoor(stage.exitDoor,(stage.exitDoor.isOpen?384:
                                    stage.exitDoor.progress==0?0:
                                      stage.exitDoor.progress<5?128:256));
    if (actor!=null){ 
    //portals
      for (Portal portal in actor.portals){
        if (portal!=null){
          drawPortal(portal);
        }
      }
      
  
  //player
      drawActors(actor, clone, previousActor);
    }
  }
  drawActors(Actor actor,Actor clone, Actor previousActor){
    num animationOffset;
    if (previousActor.y != actor.y ||
        previousActor.deltaY != actor.deltaY)
      animationOffset = 9;
    else{
      if (previousActor.x == actor.x)
        animationOffset = 0;
      else{
        animationOffset = (actor.isTurned?(7- actor.x%200~/25):actor.x%200~/25)+ 1;//96~/24;//128/32
      }
    }
    drawActor(actor,animationOffset);
    //ctx.fillRect(actor.x-actor.width/2,canvas.height-actor.y-actor.height,actor.width,actor.height);
    if (clone.isActiveClone){
      //ctx.fillRect(clone.x-clone.width/2,canvas.height-clone.y-clone.height,clone.width,clone.height);
     drawActor(clone,animationOffset);
    }
  }
  drawActor(Actor actor, num animationOffset){
    num yShift = 0,xShift;
    
    if (animationOffset>0){
      yShift = animationOffset%2==0?-1:0;
      xShift = 5;
    }else{
      xShift = 2;
    }
    ctx..save()
       ..translate(actor.x,canvas.height-actor.y-actor.height/2)
       ..rotate(actor.rotation)
       ..scale(actor.isTurned?-1:1,1)
       ..drawImageScaledFromSource(img,
           animationOffset*64,0,64,128,//actor.width,actor.height,
            -actor.width/2,-actor.height/2,actor.width,actor.height)
            
       ..translate(xShift-5,-30+yShift)
       ..rotate(actor.aimDegree)
       ..drawImageScaledFromSource(img,
           0,270,64,32,
            -actor.width/2+xShift,-actor.height/2+65+yShift,actor.width,actor.height/4)
       ..restore();
  //  ctx.fillRect(actor.x-actor.width/2,canvas.height-actor.y-actor.height/2-actor.height/2,actor.width,actor.height);
  }
  drawDoor(Door door,num offset){
    ctx.drawImageScaledFromSource(img,
        offset,130,128,128,
        door.x - door.width/2,
        canvas.height - door.y - door.height/2,
        door.width,
        door.height);
  }
  drawVerticalButton( VerticalButton button){
    drawPath(button.door, button);
    ctx.drawImageScaledFromSource(img,
        0,320,12,64,
        button.x - button.width/2,
        canvas.height - button.y - button.height/2,
        button.width,
        button.height);
  }
  drawPath(object,anotherObject){
      ctx.fillStyle="#aff";
      num sign = object.x>anotherObject.x?1:-1;
      ctx.beginPath();
      for (num i =0; i<= (object.x - anotherObject.x)*sign;i+=16){
        ctx.moveTo(object.x-i*sign,canvas.height -object.y);
        ctx.arc(object.x-i*sign,canvas.height -object.y,4,0,PI*2);
        
      }
      sign = object.y>anotherObject.y?1:-1;
      for (num i =0; i<= (object.y - anotherObject.y)*sign;i+=16){
        ctx.moveTo(anotherObject.x,canvas.height - anotherObject.y-i*sign);
        ctx.arc(anotherObject.x,canvas.height - anotherObject.y-i*sign,4,0,PI*2);
      }
      ctx.fill();
    }
  drawPortal(Portal portal){
    ctx..lineWidth=4+(new Random().nextBool()?1:0)
       ..strokeStyle = portal.color
       ..beginPath()
       ..moveTo(portal.x,canvas.height-portal.y)
       ..lineTo(portal.x1,canvas.height-portal.y1)
       ..stroke();
  }
}