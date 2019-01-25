import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
// import 'package:vibrate/vibrate.dart';

import 'dart:io';
// import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

final mainReference = FirebaseDatabase.instance.reference().child('sas');

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
  String name;
  String value;

  Note(this.name, this.value);

  Note.map(dynamic obj) {
    this.name = obj["name"];
    this.value = obj["value"];
  }

  String get aname => name;
  String get avalue => value;

  Note.fromSnapshot(DataSnapshot snapshot) {
    name = snapshot.value["name"];
    value = snapshot.value["value"];
  }
}

class _ThirdScreenState extends State<ThirdScreen> {
  List<Note> items;
  StreamSubscription<Event> _onNoteAddedSubscription;
  StreamSubscription<Event> _onNoteChangedSubscription;

  @override
  Widget build(BuildContext context) {
    
  }

  @override
  void initState() {
    super.initState();

  }
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