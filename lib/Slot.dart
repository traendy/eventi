import 'dart:ui';

import 'package:flutter/cupertino.dart' as prefix0;

class Slot{
  var id = 0;
  var start = new DateTime.now();
  var end = new DateTime.now();
  var title = "";
  var description = "";
  var speaker = -1;

  Slot(int id, DateTime start, DateTime end, String title, String description, int speaker){
    this.id = id;
    this.start = start;
    this.end = end;
    this.title = title;
    this.description = description;
    this.speaker = speaker;
  }

  getTitle(){
    return this.title;
  }

  getDescription(){
    return this.description;
  }

  getSpeaker(){
    return this.speaker;
  }

  getStart(){
    return this.start;
  }

  getEnd(){
    return this.end;
  }

  getId(){
    return this.id;
  }


}