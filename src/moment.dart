library moment;

import 'actor.dart';

class Moment{
  Actor actor;
  Actor clone;
  Moment(givenActor,givenClone){
    actor = givenActor.clone();

    clone = givenClone.clone();
  }
  
}