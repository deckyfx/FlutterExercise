import 'package:exercise/models/Chapter.dart';
import 'package:exercise/models/MangaRating.dart';
import 'package:exercise/models/MangaStatus.dart';
import 'package:exercise/models/Tag.dart';
import 'package:html/dom.dart';

class Manga {
  static final String BASE_URL = 'https://mangadex.org';

  final int id;
  final String thumb;
  final String href;
  final String title;

  List<String> alt_names;
  List<String> authors;
  List<String> artists;
  List<DemographicTag> demographics;
  List<GenreTag> genres;
  MangaRating rating;
  MangaStatus status;
  String description;
  List<String> links;
  List<String> actions;

  List<Chapter> chapters;
  List<Comment> comments;

  Manga({this.id, this.title, this.thumb, this.href});
}