import 'package:eventi/Database.dart';
import 'package:eventi/Event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'PresentationDetails.dart';
import 'Slot.dart';
import 'TimeUtils.dart';

class RoomOverViewPage extends StatefulWidget {
  RoomOverViewPage({Key key, this.day}) : super(key: key);

  final String day;

  @override
  _RoomOverViewPageState createState() => _RoomOverViewPageState();
}

class _RoomOverViewPageState extends State<RoomOverViewPage> {
  int _index = 0;
  PageController controller;
  Database database = new Database();

//  final List<Question> questions;
  Event event;
  bool loading = true;

  @override
  initState() {
    super.initState();
    controller = new PageController(
      initialPage: _index,
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
    final response =
    await database.getEvent(id);
    return response;
  }

  Future<List<Room>> _getRooms() async {
    return Future<List<Room>>.delayed(
      Duration(seconds: 2),
          () => event.days.firstWhere((value)=> value.id == widget.day).getRooms(),
    );
  }

  @override
  dispose() {
    controller.dispose();
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
        // Here we take the value from the RoomOverViewPage object that was created by
        // the App.build method, and use it to set our appbar title.
        // title: Text(widget.title),
          title: Text(widget.day),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(child: content()),
      ),
    );
  }

  content() {
    if (loading) {
      return Center(child: new CircularProgressIndicator(),);
    } else {
      return Container(
        child: FutureBuilder<List<Room>>(
          future: _getRooms(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? pager(snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
      );
    }
  }

  pager(List<Room> rooms) {
    return PageView.builder(
        itemCount: rooms.length,
        controller: controller,
        onPageChanged: (int index) => setState(() => _index = index),
        itemBuilder: (context, index) => builder(index, rooms));
  }

  builder(int index, List<Room> rooms) {
    return new AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          double value = 1.0;
          if (controller.position.haveDimensions) {
            value = controller.page - index;
            value = (1 - (value.abs() * .2)).clamp(0.0, 1.0);
          }
          return new Center(
            child: SizedBox(
              height: Curves.easeOut.transform(value) *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.8,
              width: Curves.easeOut.transform(value) *
                  MediaQuery
                      .of(context)
                      .size
                      .width *
                  0.95,
              child: Card(
                color: Colors.green,
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: getSlotViews(rooms[index].getSlots()),
              ),
            ),

          );
        });
  }

  getSlotViews(List<Slot> slots) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: slots.length,
        itemBuilder: (BuildContext context, int index) {
          return
            new Card(
                child: InkWell(onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          PresentationDetailsPage(index: index)));
                },
                    child: new Padding(
                        padding: EdgeInsets.all(4.0),
                        child: new Container(
                            child: new Row(children: <Widget>[
                              new Padding(
                                padding: EdgeInsets.all(4.0),
                                child: new Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: <Widget>[
                                      new Text(
                                          formatTime(slots[index].getStart())),
                                      new Container(
                                        color: Colors.black38,
                                        width: 1,
                                        height: 15,
                                        margin: EdgeInsets.all(5.0),
                                      ),
                                      new Text(
                                          formatTime(slots[index].getEnd())),
                                    ]),
                              ),
                              new Container(
                                color: Colors.black38,
                                width: 1,
                                height: 60,
                                margin: EdgeInsets.all(5.0),
                              ),
                              new Padding(
                                padding: EdgeInsets.all(4.0),
                                child: new Align(
                                  alignment: Alignment.center,
                                  child: new Column(
                                    children: <Widget>[
                                      new Text(
                                        slots[index].getTitle(),
                                        style: new TextStyle(fontSize: 20),
                                        textAlign: TextAlign.start,
                                      ),
                                      new Text(slots[index].getDescription()),
                                      new Text("by " +
                                          database
                                              .getAttendeeById(
                                              slots[index].getSpeaker())
                                              .getFirstName())
                                    ],
                                  ),
                                ),
                              ),
                            ]
                            )
                        )
                    )
                )
            )
          ;
        }
    );
  }
}

