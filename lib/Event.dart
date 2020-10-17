import 'Slot.dart';

class Event{
  Event(String title, String id, List<Day> days){
    this.title = title;
    this.id = id;
    this.days = days;
  }
  var title = "";
  var id = "";
  var days;

  List<Day> getDays(){
    return days;
  }
}

class Day{
  Day(DateTime date, String id, List<Room> rooms){
    this.date = date;
    this.id = id;
    this.rooms = rooms;
  }
  var date;
  var id = "";
  var rooms;

  getDate(){return date;}
  getId(){return id;}
  List<Room>getRooms() {return rooms;}
}

class Room{
  Room(String title, String description, String id, List<Slot> slots){
    this.title = title;
    this.description = description;
    this.id = id;
    this.slots = slots;
  }
  var title  ="";
  var description = "";
  var id = "";
  var slots;

  getId(){return id;}
  String getTitle(){return title;}
  String getDescription(){return description;}

  List<Slot> getSlots(){return slots;}
}

class Hotel{
  var name;
  var address;
  var website;
  var phone;

  Hotel(String name, String address, String website, String phone){
    this.name = name;
    this.address = address;
    this.website = website;
    this.phone = phone;
  }
}

