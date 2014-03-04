library block;


class Block{
  num x,y;
  static num sideLength;
  String type;
  bool isWalkable,isPortalable;
  Block(this.x,this.y,this.type,this.isWalkable,this.isPortalable);
  Block.fromJSON(obj){
    x = obj["x"];
    y = obj["y"];
    type = obj["type"];
    isWalkable = obj["isWalkable"];
    isPortalable = obj["isPortalable"];
  }
  Map toJson(){
    return {'x':x,
            'y':y,
            'type':type,
            'isWalkable':isWalkable,
            'isPortalable':isPortalable};
  }
}