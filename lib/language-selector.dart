import 'dart:math';
import 'package:flutter/material.dart';
import 'application.dart';
import 'translations.dart';

class LanguageSelector extends StatefulWidget {
  @override
  _LanguageSelectorState createState() => new _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  int _key;

  @override
  void initState() {
    super.initState();
    _collapse();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(context);
  }

  List<Widget> _languageItems() {
    List<Widget> list = [];
    final _transl = Translations.of(context);

    applic.supportedLanguages.forEach((lang) {
      list.add(new ListTile(
        title: new Text(_transl.text('language_$lang')),
        trailing: _transl.currentLanguage == lang
            ? new Icon(Icons.check, color: Colors.green)
            : null,
        selected: _transl.currentLanguage == lang,
        onTap: () {
          applic.onLocaleChanged(new Locale(lang, ''));
          setState(() {
            _collapse();
          });
        },
      ));
    });

    return list;
  }

  Widget _buildTiles(BuildContext context) {
    return new ExpansionTile(
      key: new Key(_key.toString()),
      initiallyExpanded: false,
      title: new Row(
        children: [new Text(Translations.of(context).text('language'))],
      ),
      children: _languageItems(),
    );
  }

  _collapse() {
    int newKey;
    do {
      _key = new Random().nextInt(10000);
    } while (newKey == _key);
  }
}