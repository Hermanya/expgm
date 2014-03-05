library actor;

import 'dart:html';
import 'portal.dart';
import 'dart:math';
import 'stage.dart';
class Actor{
  num x,y;
  num width,height;
  num rotation,aimDegree,deltaX,deltaY;
  List<Portal> portals;
  bool isCloneToRemove;
  bool isActiveClone;
  bool isTurned;
  
  Actor(this.x,this.y,this.width){
    rotation = 0;
    height = 2*width;
    deltaY = 0;
    deltaX = 0;
    isCloneToRemove = false;
    isActiveClone = false;
    portals = [null,null];
    isTurned = false;
    aimDegree = 0;
  }
  Actor.custom(this.x,this.y,this.width,this.height,this.rotation,this.deltaX,
      this.deltaY,this.portals,this.isCloneToRemove,this.isActiveClone,this.isTurned,
      this.aimDegree){
  }
  Actor clone(){
    List<Portal> newPortals = [null,null];
    if (portals[0]!=null)
       newPortals[0] = new Portal(portals[0].color,portals[0].isPositive,portals[0].isActive,
           portals[0].x,portals[0].y,portals[0].x1,portals[0].y1);
    if (portals[1]!=null)
      newPortals[1] = new Portal(portals[1].color,portals[1].isPositive,portals[1].isActive,
          portals[1].x,portals[1].y,portals[1].x1,portals[1].y1);
    return new Actor.custom(
        this.x,this.y,this.width,this.height,this.rotation,this.deltaX,this.deltaY, 
        newPortals,this.isCloneToRemove,this.isActiveClone,this.isTurned,this.aimDegree
    );
  }
  void restore(Actor currentActor){
    currentActor.x = x;
    currentActor.y = y;
    currentActor.rotation = rotation;
    currentActor.deltaX = deltaX;
    currentActor.deltaY = deltaY;
    currentActor.width = width;
    currentActor.height = height;
    currentActor.portals = portals;
    currentActor.isCloneToRemove = isCloneToRemove;
    currentActor.isActiveClone = isActiveClone;
  }
  int getColumn(_x,row,stage){
    if (row<0 || row>=stage.blocks[0].length)
      return 0;
    int column = (_x-width/2)~/64;
    int nextColumn = (_x+width/2-1)~/64;
    if (stage.blocks.length<=nextColumn || column < 0){
      return 0;
    }
    if ((_x-width/2)%64!=0){
      column = ! stage.blocks[column][row].isWalkable ? column : 
        ! stage.blocks[column][row+1].isWalkable?column:nextColumn;
    }
    return column;
  }
  void updatePosition(stage,keyboard,previousActor,clone){
    var _x = x;
    var _y = y;
    //horizontal movement
    if (keyboard.isPressed(KeyCode.A)){
      _x-=4;
    }
    if (keyboard.isPressed(KeyCode.D)){
      _x+=4;
    } 
    
    if(deltaX<4&&deltaX>-4)
      deltaX = 0;
    
    _x+=deltaX;
    _x=_x~/4*4;
    
    if ( deltaX>0)
      deltaX-=1;
    if (deltaX<0)
      deltaX+=1;
    
    int row =  (_y)~/64;
    if(row<0)
      row = 0;
    int column = getColumn(_x, row, stage);
 
     if (stage.blocks[column][row].isWalkable &&
         stage.blocks[column][row+1].isWalkable){
       if ((_y)%64!=0){
         row+=2;
         int column = getColumn(_x, row, stage);
         if (stage.blocks[column][row].isWalkable)
           x = _x;
         else{
            deltaX = 0;
           _x = x;
         }
       }else
          x = _x;
     }else{
       _x = x;
       deltaX = 0;
     }
     if(previousActor.deltaY>deltaY)
       var a;
      //vertical movement
     deltaY = deltaY-2;//0.5;//stage.gravity;
     if (deltaY<-32)
       deltaY = -32;
     row =  (_y+deltaY)~/64;
     if (row<0)
       row=0;
     if (row >=stage.blocks.length){
       row = stage.blocks.length-1;
     }
     column = getColumn(_x, row, stage);
     
    if (! stage.blocks[column][row].isWalkable){
      if (! checkForPortals(row,column,stage)) {
        deltaY = 0;
      
        column = (_x-width/2)~/64;   
        int nextColumn = (_x+width/2)~/64;
        if (stage.blocks[column].length>row+3){
          if ((_x-width/2)%64!=0)
            column = ! stage.blocks[column][row+2].isWalkable ? column:
                ! stage.blocks[column][row+3].isWalkable ? column: nextColumn;
          if (stage.blocks[column].length > row + 3){
            if (keyboard.isPressed(KeyCode.SPACE) &&
               stage.blocks[column][row+2].isWalkable &&
               stage.blocks[column][row+3].isWalkable)
              deltaY=16;
          }
        }
      }
    }
      _y+=deltaY; 

    y = _y;
    this.portalling(previousActor,clone,keyboard,stage);
    
   
  }
  bool checkForPortals(row,column,Stage stage){
    if (portals[0]!=null&&portals[1]!=null){
      for (Portal portal in portals){
        if (portal.x <= x - width/2 && 
            portal.x1 >= x + width/2 &&
            (portal.y == (row+1)*64 || 
                (portal.y == (row+3)*64 && ! stage.blocks[column][row+1].isWalkable)  ||
            (portal.y == (row+2)*64 && ! stage.blocks[column][row+1].isWalkable)))
          return true;
      } 
    }
    return false;
  }
  bool generatePortal1(e,stage,canvas,ctx){
    Portal portal  = Portal.generatePortal(e,stage,canvas,this,"#ffa000",portals,ctx);
    if (portal != null)
      portals[0] = portal;
    return false;
  }
  bool generatePortal2(e,stage,canvas,ctx){
    Portal portal  =  Portal.generatePortal(e,stage,canvas,this,"#00a0ff",portals,ctx);
    if (portal != null)
      portals[1] = portal;
    return false;
  }
  bool portalling(Actor previousActor,clone,keyboard,stage){
    
    if (portals[0]!=null&&portals[1]!=null){
      for (int i = 0; i < portals.length; i++){
        num alphaX = x - previousActor.x,
            alphaY = y - previousActor.y,
              sign = (portals[0].isPositive != portals[1].isPositive ? 1 : -1),
             other = (i+1)%portals.length;

        
        bool isOtherVertical = (portals[other].x == portals[other].x1);
        if (portals[i].x != portals[i].x1){
          //horizontal portal in
          if ( x-width/2 >= portals[i].x && x+width/2 <= portals[i].x1 &&
              y + height>= portals[i].y1 && y <= portals[i].y1){
            if (! clone.isActiveClone && ! portals[i].isActive){
              portals[i].isActive = true;
              this.restore(clone);
              clone.isActiveClone = true;
              clone.x = portals[other].x + 
                  (isOtherVertical?
                      (portals[other].isPositive?-clone.width/2:clone.width/2):
                        //clone.height/2);
                         x - portals[i].x);
              clone.y = (portals[other].y+portals[other].y1)~/2 - 
                  clone.height/2*(isOtherVertical?1:(portals[other].isPositive?2:0));
              if (isOtherVertical)
                clone.rotation += PI/2*(portals[other].isPositive?-1:1);
              else
                clone.rotation += portals[0].isPositive == portals[1].isPositive ? PI*(clone.rotation>0?-1:1): 0;
            
            }else{
              clone.x+=(isOtherVertical?alphaY:alphaX)*sign;
              
              num yValue = clone.y+(isOtherVertical?alphaX:alphaY)*sign;
              if (isOtherVertical){
                if (yValue > portals[other].y && yValue < portals[other].y1)
                  clone.y = yValue;
              }else{
                clone.y = yValue;
              }
            }
            
            
            
            if (isOtherVertical){
              clone.deltaX = deltaY*sign;
            }else{
              clone.deltaY = deltaY*sign;
            }
            
            if (keyboard.isPressed(KeyCode.A)){
              if ( x-width/2 -4 >= portals[i].x && x+width/2 -4 <= portals[i].x1){
                x-=4;
              }
            }
            if (keyboard.isPressed(KeyCode.D)){
              if ( x-width/2 +4 >= portals[i].x && x+width/2 +4 <= portals[i].x1){
                x+=4;
              }
            }
            if (isOtherVertical){
              clone.isTurned = ! portals[other].isPositive;
            }
            return true;
          }else{
            endTeleportation(i, clone, stage);
          }
        }else{
         //vertical portal in
          if ( x-width/2 <= portals[i].x && x+width/2 >= portals[i].x &&
              y + height <= portals[i].y1 && y >= portals[i].y){
            
            if (! clone.isActiveClone && ! portals[i].isActive){
              portals[i].isActive = true;
              this.restore(clone);
              clone.isActiveClone = true;
              clone.x = portals[other].x +
                  (isOtherVertical?(portals[other].isPositive?-clone.width/2:clone.width/2):
                    clone.height/2);
              clone.y = (portals[other].y+portals[other].y1)~/2 - 
                  (isOtherVertical?
                      clone.height/2:
                    (portals[other].isPositive?clone.width:clone.width/2));
              if (! isOtherVertical)
                clone.rotation += -PI/2*sign;//(portals[other].isPositive?-1:1);
            }else{
            clone.x+=(isOtherVertical?alphaX:alphaY)*sign;
            clone.y+=(isOtherVertical?alphaY:alphaX)*sign;
            }

            if (keyboard.isPressed(KeyCode.A)){
              x-=4;
              if (isOtherVertical)
                clone.x-=4*sign;
              else
                clone.y-=4*sign;
            }
            if (keyboard.isPressed(KeyCode.D)){
              x+=4;
              if (isOtherVertical)
                clone.x+=4*sign;
              else
                clone.y+=4*sign; 
            }
            if(! isOtherVertical){
              clone.y-=4;
              x-=4*(portals[i].isPositive?1:-1)*(portals[other].isPositive?-1:1);
            }
            clone.isTurned = isOtherVertical ? sign == 1 ? isTurned : ! isTurned : isTurned;
            return true;
          }else{
            endTeleportation(i, clone, stage);
          }
        }
      }
    }
    return false;
  }
  void endTeleportation(i,clone,stage){
    if (clone.isActiveClone && portals[i].isActive){
      clone.isActiveClone = false;
      portals[i].isActive = false;
      num row =  (clone.y)~/64;
      row++;
      if (row<0 || row>= stage.blocks[0].length)
        row=0;
      if (row>=stage.blocks.length){
        row = stage.blocks.length-1;
      }
      num column = getColumn(clone.x, row, stage);

      if (stage.blocks[column][row].isWalkable )
        clone.restore(this);
    }else{
      if (rotation > 0){
        rotation-=PI/45;
      }else{
        rotation+=PI/45;
      }
      if (rotation <= PI/45 && rotation >= -PI/45){
        rotation = 0;
      }
    }
    return;
  }
  void moveAim(event,canvas,clone){
    num offsetY = canvas.height-event.offset.y;
    num offsetX = event.offset.x;
    num slope = (offsetY-y-32)/(x-offsetX);
    if (slope > 64)
      slope = 64;
    if (slope == double.NAN)
      slope = 1/64;
    if (x-offsetX > 0){
      isTurned = true;
      slope = slope*-1;
    }else{
      isTurned = false;
    }
    aimDegree = atan(slope);
    if (clone.isActiveClone){
      clone.aimDegree = atan(slope);
    }
  }
}