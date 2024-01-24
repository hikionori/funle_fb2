class FB2Image {
  late final String? id;
  late final String bytes;
  late final String? contentType;

  FB2Image(final String binary) {
    id = RegExp(r'id="(.+?)"').firstMatch(binary)?.group(1);
    contentType = RegExp(r'content-type="(.+?)"').firstMatch(binary)?.group(1);
    bytes = RegExp(r'<binary[\s\S]+?>([\s\S]+?)<\/binary>')
            .firstMatch(binary)
            ?.group(1) ??
        '';
  }

  @override
  String toString() {
    return 'FB2Image{id: $id, bytes: $bytes, contentType: $contentType}';
  }
}
