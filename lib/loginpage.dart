import 'dart:ffi';

import 'package:eventi/Database.dart';
import 'package:eventi/EventOverViewPage.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Initially password is obscure
  bool _obscureText = true;
  Database database = new Database();
  String _password;
  String _email;
  String _eventId;
  bool loading = false;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void tryLogin() {
    setState(() {
      loading = true;
    });
    database.attemptLogin(_email, _password, _eventId).then((value) => loggedIn(value));
  }

  void loggedIn(bool success){
    setState(() {
      loading = false;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventOverViewPage(title: "Event")));
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sample"),
      ),
      body: new Center(
        child: new Padding(
          padding: EdgeInsets.all(4.0),
          child: new Card(
            child: new Padding(
              padding: EdgeInsets.all(8.0),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'event id',
                        icon: const Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: const Icon(Icons.event_available))),
                    onSaved: (val) => _eventId = val,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'eMail',
                        icon: const Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: const Icon(Icons.alternate_email))),
                    onSaved: (val) => _email = val,
                  ),
                  new Row(children: <Widget>[
                    new Flexible(
                        child: new TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              icon: const Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: const Icon(Icons.lock))),
                          validator: (val) =>
                          val.length < 6 ? 'Password too short.' : null,
                          onSaved: (val) => _password = val,
                          obscureText: _obscureText,
                        )),
                    new IconButton(
                        onPressed: _toggle,
                        icon: _obscureText
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility))
                  ]),
                  new MaterialButton(
                    child: loading ? new CircularProgressIndicator() : Text(
                        "login"),
                    onPressed: () => tryLogin(),
                    color: Colors.green,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
