import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
// import 'package:vibrate/vibrate.dart';

import 'dart:io';
// import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

final mainReference = FirebaseDatabase.instance.reference();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'CS8803 MAS';

    List<Post> st = new List();
    st.add(new Post("大头", "test"));
    st.add(new Post("呵呵", "程言哲"));
    st.add(new Post("title", "subtitle"));
    st.add(new Post("Random", "random"));
    st.add(new Post("Map", "Show Map"));
    st.add(new Post("Really?", "yanzhe"));
    st.add(new Post("Okay", "another"));

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            var post = st[index];
            var ic = post.ti != "Map" ? Icon(Icons.phone) : Icon(Icons.map);

            return ListTile(
              leading: ic,
              title: Text(post.ti),
              subtitle: Text(post.content),
              onTap: () => onTapped(post, context),
            );
          },
          itemCount: st.length,
        ),
        // body: ListView(
        //   children: <Widget>[
        //     ListTile(
        //       leading: Icon(Icons.map),
        //       title: Text('中文'),
        //     ),
        //     ListTile(
        //       leading: Icon(Icons.photo_album),
        //       title: Text('程言哲'),
        //     ),
        //     ListTile(
        //       leading: Icon(Icons.phone),
        //       title: Text('Phone'),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  void onTapped(Post post, BuildContext context) {
    if (post.content == "程言哲") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondScreen(content: "test"),
        ),
      );
    } else if (post.ti == "Map") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapScreen(),
        ),
      );
    } else if (post.content == "another") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ThirdScreen(),
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Platform.isIOS
              ? _createCupertinoAlertDialog(context)
              : _createMaterialAlertDialog(context);
        }
      );
    }
  }

  AlertDialog _createMaterialAlertDialog(BuildContext context) => new AlertDialog(
    title: new Text('Nooooo!'),
    content: new Text('您必须选择程言哲'),
    actions: <Widget>[
      new MaterialButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: new Text('Cancel'),
      ),
      new MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text('OK')),
    ],
  );

  CupertinoAlertDialog _createCupertinoAlertDialog(BuildContext context) => new CupertinoAlertDialog(
    title: new Text('Nooooo!'),
    content: new Text('您必须选择程言哲'),
    actions: <Widget>[
      new CupertinoButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: new Text('Cancel'),
      ),
      new CupertinoButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text('OK')),
    ],
  );
}

class Post {
  final String ti;
  final String content;

  Post(this.ti, this.content);
}

class Note {
  String _name;
  String _value;

  Note(this._name, this._value);

  Note.map(dynamic obj) {
    this._name = obj["name"];
    this._value = obj["value"];
  }

  String get name => _name;
  String get value => _value;

  Note.fromSnapshot(DataSnapshot snapshot) {
    print(snapshot.key);
    print(snapshot.value);
    // print(snapshot.value[snapshot.key]);
    _name = snapshot.key;
    _value = snapshot.value.toString();
    // _name = snapshot.value["name"];
    // _value = snapshot.value["value"];
  }
}

class _ThirdScreenState extends State<ThirdScreen> {
  List<Note> items;
  StreamSubscription<Event> _onNoteAddedSubscription;
  // StreamSubscription<Event> _onNoteChangedSubscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Third Screen"),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            var node = items[index];
            var ic = Icon(Icons.assignment);
            // var ic = post.ti != "Map" ? Icon(Icons.phone) : Icon(Icons.map);

            return ListTile(
              leading: ic,
              title: Text(node.name),
              subtitle: Text(node.value),
              // onTap: () => onTapped(post, context),
            );
          },
          itemCount: items.length,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    items = new List();
 
    _onNoteAddedSubscription = mainReference.onChildAdded.listen(_onNoteAdded);
    // _onNoteChangedSubscription = mainReference.onChildChanged.listen(_onNoteUpdated);
  }

  @override
  void dispose() {
    _onNoteAddedSubscription.cancel();
    // _onNoteChangedSubscription.cancel();
    super.dispose();
  }

  void _onNoteAdded(Event event) {
    setState(() {
      // print(event.snapshot);
      var t = new Note.fromSnapshot(event.snapshot);
      // print(t.name);
      items.add(new Note.fromSnapshot(event.snapshot));
    });
  }
 
  // void _onNoteUpdated(Event event) {
  //   var oldNoteValue = items.singleWhere((note) => note.id == event.snapshot.key);
  //   setState(() {
  //     items[items.indexOf(oldNoteValue)] = new Note.fromSnapshot(event.snapshot);
  //   });
  // }
}

class ThirdScreen extends StatefulWidget {
  // ThirdScreen(): super();
  @override
  _ThirdScreenState createState() => _ThirdScreenState();

}

class SecondScreen extends StatelessWidget {

  final String content;

  SecondScreen({Key key, @required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Text("揍他哈！",
              style: new TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0), // the standard way fo doing this should be wrapping it around Padding widget
            RaisedButton(
              onPressed: () {
                // Vibrate.vibrate();
                Navigator.pop(context);
              },
              child: Text("来啦老弟？",
                style: new TextStyle(fontSize: 20),
              ),
            ),
          ],
          
        ),
      ),
      // ),
      // body: Center(
      //   child: RaisedButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     child: Text('Go back!'),
      //   ),
      // ),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MapScreen> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(33.7773, -84.3962);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Where to find 程言哲'),
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              options: GoogleMapOptions(
                cameraPosition: CameraPosition(
                  target: _center,
                  zoom: 18.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton(
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ]
        ),
        // body: GoogleMap(
        //   onMapCreated: _onMapCreated,
        //   options: GoogleMapOptions(
        //     cameraPosition: CameraPosition(
        //       target: _center,
        //       zoom: 15.0,
        //     ),
        //   ),
        // ),
      ),
    );
  }
}