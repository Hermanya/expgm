library stage;

import 'block.dart';
import 'door.dart';
import 'vertical-button.dart';
import 'dart:convert';

class Stage{
  List<List<Block>> blocks;
  num gravity;
  Door entryDoor, exitDoor;
  VerticalButton verticalButton;
  String textLine;
  Stage(this.gravity,sideLength,canvasHeight,textLineElement){
    Block.sideLength = sideLength;
    exitDoor = new Door(15*sideLength,128,false);
    entryDoor = new Door(3*sideLength,128,false);
    blocks = new List();
        Block.sideLength = sideLength;
        var newList;
        for(int i = 0; i < 18; i++){
          newList = new List();
          newList.add(new Block(sideLength*i+sideLength/2, sideLength/2,"regular",false,true));
          blocks.add(newList);
          for (int i = 0; i < 8; i++){
            newList.add(new Block(sideLength/2, sideLength*i+sideLength/2,"nothing",true,true));
          }
          newList.add(new Block(i*sideLength+sideLength/2, sideLength*9+sideLength/2,"regular",false,true));
          
        }
        for (int i = 0; i < 10; i++){
          blocks.first[i] = (new Block(sideLength/2, sideLength*i+sideLength/2,"regular",false,true));
          blocks.last[i] = (new Block((blocks.length-1)*sideLength+sideLength/2, sideLength*i+sideLength/2,"regular",false,true));
        }
  }
  Stage.test(this.gravity,sideLength,canvasHeight,textLineElement){

    blocks = new List();
    Block.sideLength = sideLength;
    var newList;
    for(int i = 0; i < 18; i++){
      newList = new List();
      newList.add(new Block(sideLength*i+sideLength/2, sideLength/2,"regular",false,true));
      blocks.add(newList);
      for (int i = 0; i < 8; i++){
        newList.add(new Block(sideLength/2, sideLength*i+sideLength/2,"nothing",true,true));
      }
      newList.add(new Block(i*sideLength+sideLength/2, sideLength*9+sideLength/2,"non-portalable",false,false));
      
    }
    
    for (int i = 0; i < 10; i++){
      blocks.first[i] = (new Block(sideLength/2, sideLength*i+sideLength/2,"non-portalable",false,false));
      blocks.last[i] = (new Block((blocks.length-1)*sideLength+sideLength/2, sideLength*i+sideLength/2,"regular",false,true));
    }
    
    
    for (int i = 5; i < 9; i++){
      for (int j = 0; j < 1; j++){
          blocks[j][i] = (new Block(j*sideLength+sideLength/2, sideLength*i+sideLength/2,"regular",false,true));
    
      }
    }
    for (int i = 5; i < 9; i++){
          for (int j = 16; j < 18; j++){
              blocks[j][i] = (new Block(j*sideLength+sideLength/2, sideLength*i+sideLength/2,"regular",false,true));
      
          }
        }
    for (int i = 0; i < 5; i++){
              for (int j = 16; j < 18; j++){
                  blocks[j][i] = (new Block(j*sideLength+sideLength/2, sideLength*i+sideLength/2,"non-portalable",false,false));
          
              }
            }
    
    
    
    for (int i = 4; i < 5; i++){
          for (int j = 14; j < 16; j++){
              blocks[j][i] = (new Block(j*sideLength+sideLength/2, sideLength*i+sideLength/2,"non-portalable",false,false));
        
          }
     }
    
    for (int i = 9; i < 10; i++){
              for (int j = 14; j < 17; j++){
                  blocks[j][i] = (new Block(j*sideLength+sideLength/2, sideLength*i+sideLength/2,"regular",false,true));
          
              }
            }
    
    for (int i = 0; i < 4; i++){
              for (int j = 1; j < 2; j++){
                  blocks[j][i] = (new Block(j*sideLength+sideLength/2, sideLength*i+sideLength/2,"non-portalable",false,false));
            
              }
         }
    blocks[1][4] = (new Block(1*sideLength+sideLength/2, sideLength*4+sideLength/2,"non-portalable",false,false));
    blocks[3][1] = (new Block(3*sideLength+sideLength/2, sideLength*1+sideLength/2,"non-portalable",false,false));
    blocks[4][1] = (new Block(4*sideLength+sideLength/2, sideLength*1+sideLength/2,"non-portalable",false,false));
   // blocks[14][9] = (new Block(14*sideLength+sideLength/2, sideLength*9+sideLength/2,"regular",false,true));
    
    
   // blocks[6][4] = (new Block(6*sideLength+sideLength/2, sideLength*4+sideLength/2,"nothing",true,true));
   
    exitDoor = new Door(15*sideLength,sideLength*6,false);
    entryDoor = new Door(15*sideLength,sideLength*2,false);
    verticalButton = new VerticalButton(1*sideLength+sideLength/2,5*sideLength+sideLength/2, exitDoor); 
    textLine = "Definitely something broke";
    textLineElement.text = textLine;
  }
  String toJSON(){
    String strBlck = JSON.encode(blocks);
    return ["{\"entryDoor\":",entryDoor.toJson(),
            ",\"exitDoor\":",exitDoor.toJson(),
            ",\"verticalButton\":",verticalButton.toJson(),
            ",\"gravity\":",gravity,
            ",\"textLine\":\"",textLine,"\""
            ",\"blocks\":",strBlck,
            "}"].join("");
  }
  Stage.fromJson(string,sideLength,textLineElement){
    Block.sideLength = sideLength;
    Map obj = JSON.decode(string);
    entryDoor = new Door.fromJSON(obj["entryDoor"]);
    exitDoor = new Door.fromJSON(obj["exitDoor"]);
    verticalButton = new VerticalButton.fromJSON(exitDoor,obj["verticalButton"]);
    gravity = obj["gravity"];
    textLine = obj["textLine"];
    textLineElement.text = textLine;
    blocks = new List();
    for (List sublist in obj["blocks"]){
      List list = new List();
      blocks.add(list);
      for (Map string in sublist){
        list.add(new Block.fromJSON(string));
      }
    }
  }
}