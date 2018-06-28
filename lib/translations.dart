import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;
import 'package:intl/intl.dart';
import 'package:xml2json/xml2json.dart';
import 'application.dart';

class Translations {
  Translations(Locale locale) {
    this.locale = locale;
    _localizedValues = null;
  }

  Locale locale;

  static Map<dynamic, dynamic> _localizedValues;

  static Translations of(BuildContext context){
    return Localizations.of<Translations>(context, Translations);
  }

  String text(String key) {
    return _localizedValues[key] ?? '** $key not found';
  }

  static Future<Translations> load(Locale locale) async {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    Translations translations = new Translations(locale);

    String jsonContent = await rootBundle.loadString("assets/locales/values-$localeName/strings.xml");
    Xml2Json myTransformer = new Xml2Json();
    // Parse a simple XML string
    myTransformer.parse(jsonContent);
    // Transform to JSON using GData
    String jsont = myTransformer.toGData();
    _localizedValues = new Map<dynamic, dynamic>();
    Map<dynamic, dynamic> json_o = json.decode(jsont);
    List<dynamic> strings = json_o["resources"]["string"];
    strings.forEach((element) {
      _localizedValues[element["name"]] = element["\$t"];
    });

    return translations;
  }

  get currentLanguage => locale.languageCode;
}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) => applic.supportedLanguages.contains(locale.languageCode);

  @override
  Future<Translations> load(Locale locale) => Translations.load(locale);

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}

class SpecificLocalizationDelegate extends LocalizationsDelegate<Translations> {
  final Locale overriddenLocale;

  const SpecificLocalizationDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => overriddenLocale != null;

  @override
  Future<Translations> load(Locale locale) => Translations.load(overriddenLocale);

  @override
  bool shouldReload(LocalizationsDelegate<Translations> old) => true;
}