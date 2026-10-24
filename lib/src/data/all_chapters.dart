// @trace spec:curriculum-and-comics
import '../models/comic_models.dart';
import 'chapters_book1_dubai.dart';
import 'chapters_book2_levant.dart';
import 'chapters_book3_cairo.dart';

final List<ComicChapterData> kAllArabiyaChapters = [
  ...kBook1DubaiChapters,
  ...kBook2LevantChapters,
  ...kBook3CairoChapters,
];
