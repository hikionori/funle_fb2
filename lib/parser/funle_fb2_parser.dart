import 'dart:io';

import 'package:funle_fb2/parser/models/fb2_body.dart';
import 'package:funle_fb2/parser/models/fb2_description.dart';
import 'package:funle_fb2/parser/models/fb2_image.dart';

class FB2Parser {
  late final String path;

  late final File file;

  late final FB2Description description;

  late final FB2Body body;

  final List<FB2Image> images = [];

  FB2Parser(this.path) {
    // match the file extension
    RegExpMatch? match = RegExp(r'\.fb2$').firstMatch(path);
    if (match == null) {
      throw Exception('The file extension is not .fb2');
    }
    file = File(path);
  }

  Future<void> parse() async {
    String fileContent = await file.readAsString();

    /// initially parse images
    final Iterable<RegExpMatch> imagesRegExp =
        RegExp(r'<binary[\s\S]+?>([\s\S]+?)<\/binary>').allMatches(fileContent);
    for (final RegExpMatch image in imagesRegExp) {
      images.add(FB2Image(image.group(0)!));
    }

    fileContent =
        fileContent.replaceAllMapped(RegExp(r'<image([\s\S]+?)\/>'), (match) {
      String id = RegExp(r'="#([\s\S]+?)"')
          .firstMatch(match.group(1)!)
          ?.group(1) as String;
      FB2Image? currentImage;
      for (var image in images) {
        if (image.id == id) currentImage = image;
      }
      if (currentImage == null) return match.group(0)!;
      return '<img src="data:image/png;base64, ${currentImage.bytes}"/>';
    });

    fileContent =
        fileContent.replaceAllMapped(RegExp(r'<empty-line\/>'), (match) {
      return '<br/>';
    });

    /// for correct work with hyperlinks we need to replace all <a l:href="..."> to <a href="...">
    fileContent =
        fileContent.replaceAllMapped(RegExp(r'<a l:href="(.+?)">'), (match) {
      return '<a href="${match.group(1)}">';
    });

    /// parse description
    // final RegExpMatch? descriptionRegExp =
    //     RegExp(r'<description>([\s\S]+?)<\/description>')
    //         .firstMatch(fileContent);
    // if (descriptionRegExp == null) {
    //   throw Exception('The file does not contain description');
    // }
    // description = FB2Description(descriptionRegExp.group(1)!);
    description = FB2Description(fileContent,
        images.firstWhere((element) => element.id == 'cover.jpg'));

    /// parse body
    final RegExpMatch? bodyRegExp =
        RegExp(r'<body>([\s\S]+?)<\/body>').firstMatch(fileContent);
    if (bodyRegExp == null) {
      throw Exception('The file does not contain body');
    }
    body = FB2Body(bodyRegExp.group(1)!);
  }
}
