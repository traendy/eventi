import 'package:eventi/Database.dart';
import 'package:eventi/Event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class EventOverViewPage extends StatefulWidget {
  EventOverViewPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EventOverViewPageState createState() => _EventOverViewPageState();
}

class _EventOverViewPageState extends State<EventOverViewPage> {
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

  setEvent(Event value){
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

  Future<List<Day>> _getDays() async {
    return Future<List<Day>>.delayed(
      Duration(seconds: 2),
          () => event.days,
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
        // Here we take the value from the EventOverViewPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(child: content()),
      ),
    );
  }

  content() {
    if(loading){
      return Center(child: new CircularProgressIndicator(),);
    }else{
      return Container(
        child: FutureBuilder<List<Day>>(
          future: _getDays(),
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

  pager(List<Day> days) {
    return PageView.builder(
        itemCount: days.length,
        controller: controller,
        onPageChanged: (int index) => setState(() => _index = index),
        itemBuilder: (context, index) => builder(index, days));
  }

  builder(int index, List<Day> days) {
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
                child: Column(children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        days[index].getId(),
                        style: TextStyle(fontSize: 26),
                      ),
                    ),
                  ),
                  MaterialButton(
                    child: Text("answer"),
                    color: Colors.deepOrangeAccent,
                    onPressed: () =>
                        setState(() =>
                            controller.animateToPage(
                                index + 1,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeOut)),
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
            ),

          );
        });
  }
}

