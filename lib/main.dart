import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'MyHomePage.dart';

import 'translations.dart';
import 'application.dart';
import 'language-selector.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SpecificLocalizationDelegate _localeOverrideDelegate;

  @override
  void initState(){
    super.initState();
    _localeOverrideDelegate = new SpecificLocalizationDelegate(null);
    ///
    /// Let's save a pointer to this method, should the user wants to change its language
    /// We would then call: applic.onLocaleChanged(new Locale('en',''));
    ///
    applic.onLocaleChanged = onLocaleChange;
  }

  onLocaleChange(Locale locale){
    setState((){
      _localeOverrideDelegate = new SpecificLocalizationDelegate(locale);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // Lock device orientation to potrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return new MaterialApp(
      title: 'Flutter Demo',

      // Hide debug banner
      debugShowCheckedModeBanner: false,

      theme: new ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),

      // Localization support
      localizationsDelegates: [
        _localeOverrideDelegate,
        const TranslationsDelegate(),

        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: applic.supportedLocales(),

      home: new Scaffold(
        drawer: new Drawer(
          child: new LanguageSelector(),
          elevation: 2.0,
        ),

        appBar: new AppBar(
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(null),
            ),
          ],
          leading: new Container(),

          title: new Text("Test"),
        ),

        body: new Container(

        ),

      ),
    );
  }
}
