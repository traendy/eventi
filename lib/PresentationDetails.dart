import 'package:flutter/material.dart';
import 'Database.dart';
import 'TimeUtils.dart';

class PresentationDetailsPage extends StatefulWidget {
  final int index;

  PresentationDetailsPage({Key key, this.index}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _PresentationDetailsPageState createState() =>
      _PresentationDetailsPageState(index);
}

class _PresentationDetailsPageState extends State<PresentationDetailsPage> {
  Database database = new Database();
  int id;

  _PresentationDetailsPageState(int index) {
    this.id = index;
  }

  @override
  Widget build(BuildContext context) {
    var slots = database.getSlots();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the PresentationDetailsPage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Presentation"),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(children: <Widget>[
            Image(image: AssetImage('assets/images/android-programming.jpg')),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        slots[id].getTitle(),
                        style: new TextStyle(fontSize: 20),
                        textAlign: TextAlign.start,
                      )),
                  Container(
                    color: Colors.black38,
                    height: 1.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text("by " +
                            database
                                .getAttendeeById(slots[id].getSpeaker())
                                .getFirstName()),
                        Text(slots[this.id].getDescription()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }

  getSlotViews(Database database) {
    var slots = database.getSlots();
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: slots.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
              child: new Padding(
                  padding: EdgeInsets.all(4.0),
                  child: new Container(
                      child: new Row(children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.all(4.0),
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Text(formatTime(slots[index].getStart())),
                            new Container(
                              color: Colors.black38,
                              width: 1,
                              height: 15,
                              margin: EdgeInsets.all(5.0),
                            ),
                            new Text(formatTime(slots[index].getEnd())),
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
                                    .getAttendeeById(slots[index].getSpeaker())
                                    .getFirstName())
                          ],
                        ),
                      ),
                    ),
                  ]))));
        });
  }
}
