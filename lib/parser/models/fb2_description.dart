import 'package:funle_fb2/parser/models/fb2_author.dart';
import 'package:funle_fb2/parser/models/fb2_image.dart';

class FB2Description {
  /// The genres of the document.
  late final List<String>? genres = <String>[];

  /// The title of the document.
  late final String? title;

  /// The annotation of the document.
  late final String? annotation;

  /// The keywords of the document.
  late final List<String>? keywords;

  /// The authors of the document
  late final List<FB2Author>? authors;

  /// The translators of the document.
  late final String? date;

  /// The language of the document.
  late final String? lang;

  /// The source language of the document.
  late final String? srcLang;

  /// The history of the document.
  final FB2Image? coverPage;

  late final String? sequence;

  FB2Description(final String description, this.coverPage) {
    final Iterable<RegExpMatch> genresRegExp =
        RegExp(r'<genre>(.+?)<\/genre>').allMatches(description);
    for (final RegExpMatch genre in genresRegExp) {
      genres?.add(genre.group(1) ?? '');
    }

    final Iterable<RegExpMatch> keywordsRegExp =
        RegExp(r'<keywords>(.+?)<\/keywords>').allMatches(description);
    // for (final RegExpMatch keyword in keywordsRegExp) {
    //   keywords?.add(keyword.group(1) ?? '');
    // }
    keywords = keywordsRegExp.map((e) => e.group(1) ?? '').toList();

    final Iterable<RegExpMatch> authorsRegExp =
        RegExp(r'<author>([\s\S]+?)<\/author>').allMatches(description);
    // for (final RegExpMatch author in authorsRegExp) {
    //   authors?.add(FB2Author(author.group(1) ?? ''));
    // }
    authors = authorsRegExp.map((e) => FB2Author(e.group(1) ?? '')).toList();

    title = RegExp(r'<book-title>(.+?)<\/book-title>')
        .firstMatch(description)
        ?.group(1);

    annotation = RegExp(r'<annotation>([\s\S]+?)<\/annotation>')
        .firstMatch(description)
        ?.group(1);

    date = RegExp(r'<date>(.+?)<\/date>').firstMatch(description)?.group(1);

    lang = RegExp(r'<lang>(.+?)<\/lang>').firstMatch(description)?.group(1);

    srcLang = RegExp(r'<src-lang>(.+?)<\/src-lang>')
        .firstMatch(description)
        ?.group(1);

    sequence = RegExp(r'<sequence name="([\s\S]+?)"\/\>')
        .firstMatch(description)
        ?.group(1);
  }

  @override
  String toString() {
    return 'FB2Description{genres: $genres, title: $title, annotation: $annotation, keywords: $keywords, authors: $authors, date: $date, lang: $lang, srcLang: $srcLang, coverPage: $coverPage, sequence: $sequence}';
  }
}
