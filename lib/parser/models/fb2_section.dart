class FB2Section {
  late final String? title;
  late final String? content;

  FB2Section(final String section) {
    this.content = section;
    title = RegExp(r"<title>([\s\S]+?)<\/title>")
        .firstMatch(content ?? '')
        ?.group(1);
  }

  @override
  String toString() {
    return 'FB2Section{title: $title, content: $content}';
  }
}
