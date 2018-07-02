import 'package:exercise/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/avd.dart';
import 'package:flutter_svg/svg.dart';

class LatestUpdate extends StatefulWidget {
  @override
  _LatestUpdateState createState() => new _LatestUpdateState();
}

class _LatestUpdateState extends State<LatestUpdate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Expanded(
            child: new GridView.extent(
                maxCrossAxisExtent: 150.0,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                padding: const EdgeInsets.all(5.5),
                children: <Widget>[
                  new Text(Translations.of(context).text("main_title")),

                  new AvdPicture.asset(
                    'assets/drawables/battery_charging.xml',
                  ),

                  new SvgPicture.asset(
                    'assets/drawables/text.svg',
                    width: 100.0,
                    height: 100.0,
                  ),
                ]
            ),
          )
        ]
    );
  }
}