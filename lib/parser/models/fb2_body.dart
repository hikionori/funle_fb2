import 'package:funle_fb2/parser/models/fb2_section.dart';

/// Represents the body of an FB2 document.
class FB2Body {
  /// The title of the document.
  late final String? title;

  /// The epigraph of the document.
  late final String? epigraph;

  /// The sections of the document.
  late final List<FB2Section>? sections;

  FB2Body(final String body) {
    title = RegExp(r'<title>(.+?)<\/title>').firstMatch(body)?.group(1);

    epigraph =
        RegExp(r'<epigraph>([\s\S]+?)<\/epigraph>').firstMatch(body)?.group(1);

    final Iterable<RegExpMatch> sectionsRegExp =
        RegExp(r'<section>([\s\S]+?)<\/section>').allMatches(body);
    if (sectionsRegExp.isNotEmpty) {
      sections = sectionsRegExp.map((e) => FB2Section(e.group(0)!)).toList();
    }
  }
}
