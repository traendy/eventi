import 'package:eventi/Attendee.dart';
import 'package:eventi/Slot.dart';

import 'Event.dart';

class Database{

  List<Attendee> getAttendees(){
    return [
      new Attendee.speaker(0,"Anna", "Amalia", true),
      new Attendee.speaker(1,"Brava", "Brandson", true),
      new Attendee.speaker(2,"Can", "Chamelion", true),
      new Attendee(3,"Donald", "Dorito"),
    ];
  }

  Attendee getAttendeeById(int id) {
    List <Attendee> attendees =  getAttendees();
    return attendees[id];
  }

  getSlots(){
    return [
      new Slot(0, new DateTime.now(), new DateTime.now(), "A Presentation", "A Description", 0),
      new Slot(1, new DateTime.now(), new DateTime.now(), "B Presentation", "B Description", 1),
      new Slot(2, new DateTime.now(), new DateTime.now(), "C Presentation", "C Description", 2),
      new Slot(3, new DateTime.now(), new DateTime.now(), "D Presentation", "D Description", 1),
      new Slot(4, new DateTime.now(), new DateTime.now(), "E Presentation", "E Description", 2),
    ];
  }


  Future<Event> eventFactory() {
    return Future.delayed(Duration(seconds: 4), () =>Event("event", "event d", [new Day(DateTime.now(), "iddd", [new Room("room", "room d", "ddas", getSlots())]),
      new Day(DateTime.now(), "afasf",
          [new Room("room", "room d", "ddas", getSlots())])]));
  }

  bool validAccount(String email, String password){
    return true;
  }

  Future<Event> getEvent(String eventId) async{
    return await eventFactory();
  }

  Future<bool> attemptLogin(String email, String password, String event) async {
    print('Awaiting user order...');
    return await login(email, password, event);;
  }

  Future<bool> login(String email, String password, String event) {
    // Imagine that this function is more complex and slow.
    return Future.delayed(Duration(seconds: 1), () => validAccount(email, password));
  }



}