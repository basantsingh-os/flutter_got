import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'episodes_page.dart';
import 'got.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: CupertinoColors.destructiveRed),
        debugShowCheckedModeBanner: false,
        home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GOT got;
  String url =
      "http://api.tvmaze.com/singlesearch/shows?q=game-of-thrones&embed=episodes";

  Widget myCard() {
    return SingleChildScrollView(
      child: Card(
        elevation: 0,
        color: CupertinoColors.systemGrey6,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              
                               Hero( tag:"g1",
                                                            child:CircleAvatar(
                  backgroundImage: NetworkImage(got.image.original),
                  radius: 100,
                
              ),
                               ),
              SizedBox(height: 20),
              Text(
                got.name,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.activeGreen),
              ),
              Text("Runtime ${got.runtime.toString()} minutes",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.activeBlue)),
              Text(got.summary,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EpisodesPage(
                        got: got, episodes:got.eEmbedded.episodes
                      )));
                },
                color: Theme.of(context).primaryColor,
                elevation: 0,
                child: Text(
                  "All episodes",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget myBody() {
    return got == null ? Center(child: CircularProgressIndicator()) : myCard();
  }

  @override
  void initState() {
    super.initState();
    fetchEpisodes();
  }

  fetchEpisodes() async {
    var res = await http.get(url);
    var decodedRes = jsonDecode(res.body);
    got = GOT.fromJson(decodedRes);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          "Game of Thrones",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: myBody(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.refresh)),
    );
  }
}
