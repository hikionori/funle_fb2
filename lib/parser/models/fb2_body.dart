import 'package:funle_fb2/parser/models/fb2_section.dart';

class FB2Body {
  late final String? title;

  late final String? epigraph;

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
