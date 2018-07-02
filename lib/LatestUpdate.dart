import 'dart:async';
import 'package:exercise/ReadManga.dart';
import 'package:exercise/models/Chapter.dart';
import 'package:exercise/models/Manga.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class LatestUpdate extends StatefulWidget {
  @override
  _LatestUpdateState createState() => new _LatestUpdateState();
}

class _LatestUpdateState extends State<LatestUpdate> {
  List<Manga> items = new List<Manga>();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    refreshList();
  }

  Future<List<Manga>> parseHTML(String body) async {
    var document = parse(body);
    List<dom.Element> trs = document.documentElement.querySelectorAll("div.table-responsive > table.table-striped.table-condensed > tbody > tr");
    int manga_id = 0;
    int chapter_id = 0;
    List<Manga> _items = new List<Manga>();
    trs.forEach((element) {
      List<dom.Element> rowtype = element.querySelectorAll('td[rowspan]');
      if (rowtype.length > 0) {
        // if td in tr has attribute rowspan, it is a Manga row
        String href = element.querySelector('td[rowspan] > div > a').attributes['href'];
        String thumb = element.querySelector('td[rowspan] > div > a > img').attributes['src'];
        String title = element.querySelector('td[colspan] > a').text;
        Manga manga = new Manga(id: manga_id, title: title, thumb: thumb, href: href);
        _items.add(manga);
        manga_id++;
        chapter_id = 0;
      } else {
        // if td in tr has not attribute rowspan, it is a Chapter row
        Manga manga = _items[_items.length - 1];
        if (manga.chapters == null) {
          manga.chapters = new List<Chapter>();
        }
        String href = element.querySelector('td:nth-child(3) > a').attributes['href'];
        String title = element.querySelector('td:nth-child(3) > a').text;
        String language = element.querySelector('td:nth-child(5) > img').attributes['alt'];
        String language_flag = element.querySelector('td:nth-child(5) > img').attributes['src'];
        String group_href = element.querySelector('td:nth-child(7) > a').attributes['href'];
        String group_name = element.querySelector('td:nth-child(7) > a').text;
        String datetime_str = element.querySelector('td:nth-child(9) > time').attributes['datetime'];
        DateTime datetime = DateTime.parse(datetime_str.replaceFirst(" UTC", "Z"));
        Chapter chapter = new Chapter(id: chapter_id,
            title: title, href: href,
            language: language,
            language_flag: language_flag,
            group_name: group_name, group_href: group_href,
            datetime: datetime);
        manga.chapters.add(chapter);
        _items[_items.length - 1] = manga;
        chapter_id++;
      }
    });
    return _items;
  }

  Future<Null> refreshList() async {
    _refreshIndicatorKey.currentState.show(atTop: true);
    final response = await http.get(Manga.BASE_URL);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<Manga> _items = new List<Manga>();
      _items = await parseHTML(response.body);
      setState(() => items = _items);
      return null;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  _onTileClicked(int index) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => new ReadManga(manga: items[index])
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      child: new GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3.0,
        ),
        itemCount: items?.length,
        itemBuilder: (context, index) {
          return new Card(key: null,
            child: new InkResponse(
              enableFeedback: true,
              onTap: () => _onTileClicked(index),
              child: new Container(
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        child: CachedNetworkImage(
                          placeholder: CircularProgressIndicator(),
                          imageUrl: items[index].thumb,
                          fit: BoxFit.fill,
                          errorWidget: new Icon(Icons.error),
                        ),
                        padding: const EdgeInsets.all(0.0),
                        alignment: Alignment.center,
                        width: 75.0,
                        height: 100.0,
                      ),

                      new Expanded(
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                '${items[index].title}',
                                style: new TextStyle(
                                    fontSize:15.0,
                                    color: const Color(0xFF000000),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto"
                                ),
                              ),

                              new Container(
                                child: new Row(
                                    children: <Widget>[
                                      new Container(
                                        child: CachedNetworkImage(
                                          placeholder: CircularProgressIndicator(),
                                          imageUrl: items[index].chapters[0].language_flag,
                                          fit: BoxFit.fill,
                                          errorWidget: new Icon(Icons.error),
                                        ),
                                        width: 25.0,
                                        height: 20.0,
                                      ),

                                      new Expanded(
                                        child: new Text(
                                          '${items[index].chapters[0].title}',
                                          style: new TextStyle(
                                              fontSize:13.0,
                                              color: const Color(0xFF000000),
                                              fontWeight: FontWeight.w200,
                                              fontFamily: "Roboto"
                                          ),
                                        ),
                                      ),
                                    ]
                                ),
                              ),

                              new Text(
                                new DateFormat.yMMMd().format(items[index].chapters[0].datetime),
                                style: new TextStyle(
                                    fontSize:12.0,
                                    color: const Color(0xFF242424),
                                    fontWeight: FontWeight.w100,
                                    fontFamily: "Roboto"
                                ),
                              ),

                            ]
                        ),
                      )
                    ]
                ),
                padding: const EdgeInsets.all(0.0),
                alignment: Alignment.center,
              ),
            )


          );
        },
      ),

      key: _refreshIndicatorKey,

      onRefresh: refreshList,
    );
  }
}