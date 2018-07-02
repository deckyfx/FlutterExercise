
import 'package:exercise/LatestUpdate.dart';
import 'package:flutter/material.dart';
import 'translations.dart';
import 'language-selector.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _dimension;

  @override
  void initState() {
    super.initState();

    _dimension = 580.0;
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        drawer: new Drawer(
          child: new LanguageSelector(),
          elevation: 2.0,
        ),

        appBar: new AppBar(
          title: new Text(Translations.of(context).text('main_title')),

          bottom: TabBar(
            tabs: [
              Tab(text: Translations.of(context).text('latest_updates')),
              Tab(text: Translations.of(context).text('populars')),
              Tab(text: Translations.of(context).text('follows')),
            ],
          ),

        ),

        body: TabBarView(
          children: [
            new LatestUpdate(),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}