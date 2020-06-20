import 'package:flutter/material.dart';
import 'dart:async';
import 'Kamus.dart';
import 'Services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: UserFilterDemo(),
    );
  }
}

class UserFilterDemo extends StatefulWidget {
  UserFilterDemo() : super();

  final String title = "Kamus Bahasa Indonesia";

  @override
  UserFilterDemoState createState() => UserFilterDemoState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class UserFilterDemoState extends State<UserFilterDemo> {
  //
  final _debouncer = Debouncer(milliseconds: 500);
  
  List<Kamus> users = List();
  List<Kamus> filteredUsers = List();
   

  @override
  void initState() {
    super.initState();

    
  
    Services.getUsers().then((usersFromServer1) {
      setState(() {

        users = usersFromServer1;
        filteredUsers = users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
            child: Text(
          "KAMUS BESAR BAHASA INDONESIA (KBBI)",
          style: TextStyle(
              fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.white),
        )),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
            child: Center(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: new BorderRadius.all(Radius.circular(25)),
                ),
                child: TextField(
                  onChanged: (string) {
                    _debouncer.run(() {
                      setState(() {
                        filteredUsers = users
                            .where((u) => (u.kosakata
                                    .toLowerCase()
                                    .contains(string.toLowerCase()) ||
                                u.artinya
                                    .toLowerCase()
                                    .contains(string.toLowerCase())))
                            .toList();
                      });
                    });
                  },
                  style: new TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.black38),
                      hintText: "Search ",
                      hintStyle: new TextStyle(color: Colors.black38)),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: filteredUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          filteredUsers[index].kosakata,
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          filteredUsers[index].artinya.toLowerCase(),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
