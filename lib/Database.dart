import 'package:eventi/Attendee.dart';
import 'package:eventi/Slot.dart';

import 'Event.dart';

class Database {
  List<Attendee> getAttendees() {
    return [
      new Attendee.speaker(0, "Anna", "Amalia", true),
      new Attendee.speaker(1, "Brava", "Brandson", true),
      new Attendee.speaker(2, "Can", "Chamelion", true),
      new Attendee(3, "Donald", "Dorito"),
    ];
  }

  Attendee getAttendeeById(int id) {
    List<Attendee> attendees = getAttendees();
    return attendees[id];
  }

  getSlots() {
    return [
      new Slot(0, new DateTime.now(), new DateTime.now(), "A Presentation",
          "A Description", 0),
      new Slot(1, new DateTime.now(), new DateTime.now(), "B Presentation",
          "B Description", 1),
      new Slot(2, new DateTime.now(), new DateTime.now(), "C Presentation",
          "C Description", 2),
      new Slot(3, new DateTime.now(), new DateTime.now(), "D Presentation",
          "D Description", 1),
      new Slot(4, new DateTime.now(), new DateTime.now(), "E Presentation",
          "E Description", 2),
    ];
  }

  Future<Event> eventFactory() {
    return Future.delayed(
        Duration(seconds: 1),
        () => Event("Special Event", "eventid5", [
              new Day(DateTime.now(), "Day1", [
                new Room(
                    "Room 1", "At the end of the hallway.", "r1", getSlots()),
                new Room("Room 2", "The big one.", "r2", getSlots())
              ]),
              new Day(DateTime.now(), "Day2",
                  [new Room("Room 3", "Up the tower.", "r3", getSlots())])
            ]));
  }

  bool validAccount(String email, String password) {
    return true;
  }

  Future<Event> getEvent(String eventId) async {
    return await eventFactory();
  }

  Future<bool> attemptLogin(String email, String password, String event) async {
    return await login(email, password, event);
  }

  Future<bool> login(String email, String password, String event) {
    // Imagine that this function is more complex and slow.
    return Future.delayed(
        Duration(seconds: 1), () => validAccount(email, password));
  }

  Future<List<Hotel>> getHotels() async {
    return Future.delayed(
        Duration(seconds: 1),
        () => [
              new Hotel("Trump", "Whitehouse, Washington", "www.whitehouse.ru", "983 53459308"),
              new Hotel("Hilton", "Hollywood hills", "www.hilton.com",
                  "983 53459308"),
              new Hotel("Radisson", "Dammtow Wall 123 Hamburg", "www.radission.de",
                  "983 53459308")
            ]);
  }
}
