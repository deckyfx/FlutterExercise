import 'package:html/dom.dart';

class Chapter {
  final int id;
  final String href;
  final String title;
  final String language;
  final String language_flag;
  final String group_name;
  final String group_href;
  final DateTime datetime;

  List<Comment> comments;
  List<String> pages = new List<String>();
  String dataurl;
  int next_chapter_id;
  int prev_chapter_id;

  Chapter({this.id, this.title, this.href, this.language, this.language_flag, this.group_name, this.group_href, this.datetime});

  String buildImageURL(int page) {
    return "/data/" + dataurl + "/" + pages[page];
  }
}