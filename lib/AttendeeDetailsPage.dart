import 'package:flutter/material.dart';
import 'Database.dart';
import 'TimeUtils.dart';

class AttendeeDetailsPage extends StatefulWidget {

  static const routeName = '/attendeeDetails';
  AttendeeDetailsPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _AttendeeDetailsPageState createState() =>
      _AttendeeDetailsPageState();
}

class AttendeeDetailsArguments {
  final int id;

  AttendeeDetailsArguments(this.id);
}

class _AttendeeDetailsPageState extends State<AttendeeDetailsPage> {
  Database database = new Database();
  int id;

  @override
  Widget build(BuildContext context) {
    var attendees = database.getAttendees();
    final AttendeeDetailsArguments args = ModalRoute
        .of(context)
        .settings
        .arguments;
    id = args.id;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the AttendeeDetailsPage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Attendee"),
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
                        attendees[id].getFirstName(),
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
                        Text(attendees[id].getLastName()),
                        Text(attendees[id].getId().toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
