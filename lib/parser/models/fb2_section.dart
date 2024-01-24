class FB2Section {
  /// The title of the section.
  late final String? title;

  /// The content of the section.
  late final String? content;

  FB2Section(final String section) {
    content = section;
    title = RegExp(r"<title>([\s\S]+?)<\/title>")
        .firstMatch(content ?? '')
        ?.group(1);
  }

  @override
  String toString() {
    return 'FB2Section{title: $title, content: $content}';
  }
}
