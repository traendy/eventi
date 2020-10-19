import 'package:eventi/AttendeeDetailsPage.dart';
import 'package:eventi/Database.dart';
import 'package:eventi/Event.dart';
import 'package:eventi/RoomOverViewPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import 'Attendee.dart';

class EventOverViewPage extends StatefulWidget {
  EventOverViewPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EventOverViewPageState createState() => _EventOverViewPageState();
}

class _EventOverViewPageState extends State<EventOverViewPage> {
  int _dayIndex = 0;
  int _hotelIndex = 0;
  PageController dayController;
  PageController hotelController;
  Database database = new Database();

//  final List<Question> questions;
  Event event;
  bool loading = true;

  @override
  initState() {
    super.initState();
    dayController = new PageController(
      initialPage: _dayIndex,
      keepPage: false,
      viewportFraction: 0.95,
    );
    hotelController = new PageController(
      initialPage: _hotelIndex,
      keepPage: false,
      viewportFraction: 0.95,
    );
    _getEvent("").then((value) => setEvent(value));
  }

  setEvent(Event value) {
    setState(() {
      this.event = value;
      this.loading = false;
    });
  }

  String responseText = "";

  Future<Event> _getEvent(String id) async {
    final response = await database.getEvent(id);
    return response;
  }

  Future<List<Day>> _getDays() async {
    return Future<List<Day>>.delayed(
      Duration(seconds: 1),
          () => event.days,
    );
  }

  Future<List<Attendee>> _getSpeakers() async {
    return Future<List<Attendee>>.delayed(
      Duration(seconds: 1),
          () => database.getAttendees(),
    );
  }

  Future<List<Hotel>> _getHotels() async {
    return database.getHotels();
  }

  @override
  dispose() {
    dayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the EventOverViewPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: content(),
    );
  }

  navigateToDay(Day day) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RoomOverViewPage(day: day.getId())));
  }

  goToAttendeeDetails(Attendee attendee) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(
          context,
          AttendeeDetailsPage.routeName,
          arguments: AttendeeDetailsArguments(attendee.id));
    });
  }

  content() {
    if (loading) {
      return Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(padding: EdgeInsets.fromLTRB(16, 20, 16, 24), child:
          Text(event.title, style: TextStyle(fontSize: 26),textAlign: TextAlign.center,),
              ),
          FutureBuilder<List<Day>>(
            future: _getDays(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? pagerDays(snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),
          FutureBuilder<List<Attendee>>(
            future: _getSpeakers(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? buildSpeakerShowCase(snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),
          Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 0), child: Text("Hotels", style: TextStyle(fontSize: 26), textAlign: TextAlign.center,)),
          FutureBuilder<List<Hotel>>(
            future: _getHotels(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? pagerHotels(snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ],
      );
    }
  }

  pagerHotels(List<Hotel> hotels) {
    return Container(height: 250, child: PageView.builder(
        itemCount: hotels.length,
        controller: hotelController,
        onPageChanged: (int index) => setState(() => _hotelIndex = index),
        itemBuilder: (context, index) => hotelPagerBuilder(index, hotels)),);
  }

  pagerDays(List<Day> days) {
    return Container(height: 300, child: PageView.builder(
        itemCount: days.length,
        controller: dayController,
        onPageChanged: (int index) => setState(() => _dayIndex = index),
        itemBuilder: (context, index) => dayPagerBuilder(index, days)),);
  }

  dayPagerBuilder(int index, List<Day> days) {
    return new AnimatedBuilder(
        animation: dayController,
        builder: (context, child) {
          double value = 1.0;
          if (dayController.position.haveDimensions) {
            value = dayController.page - index;
            value = (1 - (value.abs() * .2)).clamp(0.0, 1.0);
          }
          return new Center(
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Column(children: <Widget>[
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: <Widget>[
                            Text(
                              days[index].getId(),
                              style: TextStyle(fontSize: 26),
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd – kk:mm')
                                  .format(days[index].getDate()),
                              style: TextStyle(fontSize: 26),
                            ),
                            Text("Upcomming:"),
                            Text("Room 1 next Slot"),
                            Text("Room n next Slot:"),
                          ],
                        )),
                  ),
                  MaterialButton(
                    child: Text("Check out Day"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.green)),
                    onPressed: () => navigateToDay(days[index]),
                  ),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("(" +
                          (index + 1).toString() +
                          "/" +
                          days.length.toString() +
                          ")"),
                    ),
                  ),
                ]),
              ),
          );
        });
  }

  hotelPagerBuilder(int index, List<Hotel> hotels) {
    return new AnimatedBuilder(
        animation: hotelController,
        builder: (context, child) {
          double value = 1.0;
          if (hotelController.position.haveDimensions) {
            value = hotelController.page - index;
            value = (1 - (value.abs() * .2)).clamp(0.0, 1.0);
          }
          return new Center(
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Column(children: <Widget>[
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: <Widget>[
                            Text(
                              hotels[index].name,
                              style: TextStyle(fontSize: 26),
                            ),
                            Text(
                              hotels[index].address,
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        )),
                  ),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("(" +
                          (index + 1).toString() +
                          "/" +
                          hotels.length.toString() +
                          ")"),
                    ),
                  ),
                ]),
              ),
          );
        });
  }

  buildSpeakerShowCase(List<Attendee> attendees){
    return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)),
    child: Column(children: <Widget>[
      Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 0), child:
      Text("Speaker Showcase", style: TextStyle(fontSize: 26, ), textAlign: TextAlign.center,),
          ),
        Container(height: 400, child:
      GridView.count( scrollDirection: Axis.horizontal,
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: getAttendeesContainers(attendees)
    )
    )
    ]));
  }

  getAttendeesContainers(List<Attendee> attendee){
    return attendee.map<Widget>((it) => getContainerForAttendee(it)).toList();
  }

  getContainerForAttendee(Attendee attendee){
    return  Container(color: Colors.teal[400],
      padding: const EdgeInsets.all(8),
      child: MaterialButton(onPressed: () => goToAttendeeDetails(attendee), child:Column(children: <Widget>[
        Text(attendee.getFirstName()),
        Text(attendee.getLastName()),
      ],),

    ));
  }
}
