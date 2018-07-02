import 'package:exercise/ReadManga.dart';
import 'package:exercise/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'translations.dart';
import 'application.dart';
import 'MyHomePage.dart';

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

      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/MyHomePage': (BuildContext context) => new MyHomePage(),
      },
    );
  }
}







