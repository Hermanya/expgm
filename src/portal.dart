library portal;

import 'block.dart';
import 'actor.dart';

class Portal{
  static num length = 64;
  num x,y,x1,y1;
  String color;
  bool isPositive,isActive;
  Portal(this.color,this.isPositive,this.isActive,this.x,this.y,this.x1,this.y1);
  static Portal generatePortal(event,stage,canvas,Actor actor,color,portals,ctx){
    for (Portal portal in portals){
      if (portal!=null){
        if (portal.isActive)
          return null;
      }
    }
    num offsetY = canvas.height - event.offsetY;
    num offsetX = event.offsetX;
    num slope = (offsetY-actor.y-actor.height*0.75)/(offsetX-actor.x);
    if (slope == double.INFINITY)
      slope = 1000;
    if (slope == -double.INFINITY)
      slope = -1000;
    if (slope == double.NAN)
      slope = 0;
    if (slope < 1/64 && slope > 0)
      slope = 1/64;
    if (slope > -1/64 && slope < 0)
      slope = -1/64;
    num    row,column,
    k = actor.y + actor.height*0.75 - slope * actor.x,
         sign = offsetX > actor.x ? 1 : -1,
         step = 1*sign;
            
         ctx.fillStyle = "#f00";
        ctx.beginPath;
         
    for (num i = actor.x; i > 0 && i < canvas.width; i+= step){
      ctx.fillRect(i,canvas.height - i*slope-k,4,4);
      row =  (i*slope+k)~/64;
      if (row<0)
        row = 0;
      if (row >= stage.blocks[1].length){
        row = stage.blocks[1].length-1;
      }
      column = (i)~/64;
      if (column<0)
        column = 0;
      if (column > stage.blocks.length)
        column = stage.blocks.length-1;
      if (stage.blocks.length<=column)
        return null;
      if (stage.blocks[column].length<=row)
        return null;
   
      if (! stage.blocks[column][row].isWalkable){
        if (! stage.blocks[column][row].isPortalable){
          return null;
        }
        num deltaX = actor.x - stage.blocks[column][row].x;
    
       String position;
       num xEntry,yEntry;
       bool isDown,isLeft;
        if(deltaX>0){
          yEntry =  ((stage.blocks[column][row].x+Block.sideLength/2)*slope+k);
          if (yEntry > stage.blocks[column][row].y+Block.sideLength/2){
            position = "top"; 
          }else{
            if (yEntry < stage.blocks[column][row].y-Block.sideLength/2){
              position="bottom";
            }else{
              position = "right";
            }
          }     
        }else{
          yEntry =  ((stage.blocks[column][row].x-Block.sideLength/2)*slope+k);
          if (yEntry > stage.blocks[column][row].y+Block.sideLength/2){
            position = "top"; 
          }else{
            if (yEntry < stage.blocks[column][row].y-Block.sideLength/2){
              position="bottom";
            }else{
              position = "left";
            }
          }
        }
        Portal portal =  new Portal(color,position == "top" || position == "right",false,
            stage.blocks[column][row].x+(Block.sideLength/2)*
            (position == "top" || position == "right"?1:-1),
            stage.blocks[column][row].y+(Block.sideLength/2)*
            (position == "top" || position == "right"?1:-1),
            stage.blocks[column][row].x+(Block.sideLength/2)*
            (position == "right" || position == "bottom"?1:-1),
            stage.blocks[column][row].y+(Block.sideLength/2)*
            (position == "top" || position == "left"?1:-1)
            );
        if (portal.x>portal.x1){
          num tmp = portal.x;
          portal.x = portal.x1;
          portal.x1 = tmp;
        }
   
        
        if (portal.y>portal.y1){
          num tmp = portal.y;
          portal.y = portal.y1;
          portal.y1 = tmp;
        }
        
        bool isNegative = position == "left" || position == "bottom";
        if (row == 0 || row >= stage.blocks[1].length)
          isNegative = false;
        bool isVertical = position == "right" || position == "left";
        if (isVertical){ 
          if (row <= 0 || row >= stage.blocks[column].length)
            return null;
          isDown = yEntry < stage.blocks[column][row].y;
          if (! stage.blocks[column][row+(isDown?-1:1)].isWalkable &&
              stage.blocks[column][row+(isDown?-1:1)].isPortalable &&
              stage.blocks[column+(isNegative?-1:1)][row+(isDown?-1:1)].isWalkable){
            if (isDown){
              portal.y -= Block.sideLength;
            }else{
              portal.y1 += Block.sideLength;
            }
          }else{
            if (! stage.blocks[column][row+(isDown?1:-1)].isWalkable &&
                stage.blocks[column][row+(isDown?1:-1)].isPortalable &&
                stage.blocks[column+(isNegative?-1:1)][row+(isDown?1:-1)].isWalkable){
              if (isDown){
                portal.y1 += Block.sideLength;
              }else{
                portal.y -= Block.sideLength;
              }
            }else{
              return null;
            }
          }
        }else{
          //horizontal
          yEntry = stage.blocks[column][row].y+(Block.sideLength/2)*(isNegative?-1:1);
          xEntry = (yEntry - k)/slope;
          isLeft = xEntry < stage.blocks[column][row].x;
          if (! stage.blocks[column+(isLeft?-1:1)][row].isWalkable &&
              stage.blocks[column+(isLeft?-1:1)][row].isPortalable &&
              stage.blocks[column+(isLeft?-1:1)][row+(isNegative?-1:1)].isWalkable){
            if (isLeft){
              portal.x -= Block.sideLength;
            }else{
              portal.x1 += Block.sideLength;
            }
          }else{
            if (! stage.blocks[column+(isLeft?1:-1)][row].isWalkable &&
                stage.blocks[column+(isLeft?1:-1)][row].isPortalable &&
                stage.blocks[column+(isLeft?1:-1)][row+(isNegative?-1:1)].isWalkable){
              if (isLeft){
                portal.x1 += Block.sideLength;
              }else{
                portal.x -= Block.sideLength;
              }
            }else{
              return null;
            }
          }
        }
      return portal;
      }
    }
    return null;
  }
}