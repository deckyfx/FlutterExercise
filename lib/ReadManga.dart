import 'dart:async';
import 'dart:convert';
import 'package:exercise/models/Chapter.dart';
import 'package:exercise/models/Manga.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' as vector64;

class ReadManga extends StatefulWidget {
  final Manga manga;

  ReadManga({@required this.manga});

  @override
  _ReadMangaState createState() => new _ReadMangaState(manga: this.manga);
}

class _ReadMangaState extends State<ReadManga> {
  final Manga manga;

  final PageController controller = new PageController();

  double _scale = 1.0;
  double _previousScale = null;

  _ReadMangaState({@required this.manga});

  @override
  void initState() {
    super.initState();
  }

  Future<Chapter> parseHTML(String body) async {
    var document = parse(body);

    String json_text = document.documentElement.querySelector('script[data-type]').text;
    Map<dynamic, dynamic> jsonData = json.decode(json_text);
    Chapter _chapter = manga.chapters[0];
    _chapter.dataurl = jsonData["dataurl"];
    List<dynamic> pages = jsonData["page_array"];
    _chapter.pages = new List<String>();
    pages.forEach( (f) => _chapter.pages.add(f) );
    _chapter.next_chapter_id = jsonData["next_chapter_id"];
    _chapter.next_chapter_id = jsonData["prev_chapter_id"];
    return _chapter;
  }

  Future<Chapter> getChapterPages() async {
    final response = await http.get(Manga.BASE_URL + manga.chapters[0].href);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON]
      return await parseHTML(response.body);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: new EdgeInsets.only(top: 16.0,),
        decoration: new BoxDecoration(
          color: Colors.black
        ),
        child: new FutureBuilder<Chapter>(
          future: getChapterPages(),
          builder: (context, AsyncSnapshot<Chapter> snapshots) {
            if (snapshots.hasError)
              return Text("Error Occurred");
            switch (snapshots.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done: {
                return new Stack(
                  alignment: FractionalOffset.bottomCenter,
                  children: <Widget>[
                    new PageView.builder(
                      controller: controller,
                      itemCount: snapshots.data.pages?.length,
                      itemBuilder: (_, int page) {
                        return new Container(
                          alignment: Alignment.center,
                          child: new GestureDetector(
                            onScaleStart: (ScaleStartDetails details) {
                              print(details);
                              // Does this need to go into setState, too?
                              // We are only saving the scale from before the zooming started
                              // for later - this does not affect the rendering...
                              _previousScale = _scale;
                            },
                            onScaleUpdate: (ScaleUpdateDetails details) {
                              print(details);
                              setState(() => _scale = _previousScale * details.scale);
                            },
                            onScaleEnd: (ScaleEndDetails details) {
                              print(details);
                              // See comment above
                              _previousScale = null;
                            },
                            child: new Transform(
                              transform: new Matrix4.diagonal3(new vector64.Vector3(_scale, _scale, _scale)),
                              alignment: FractionalOffset.center,
                              child: CachedNetworkImage(
                                placeholder: CircularProgressIndicator(),
                                imageUrl: Manga.BASE_URL + snapshots.data.buildImageURL(page),
                                fit: BoxFit.fill,
                                errorWidget: new Icon(Icons.error),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    new Container(
                      margin: new EdgeInsets.only(
                        top: 16.0,
                        bottom: 16.0,
                      ),
                    ),
                  ],
                );
              } break;
              default:
            }
          }
        )
      )
    );
  }
}