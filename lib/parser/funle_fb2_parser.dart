import 'dart:io';

import 'package:funle_fb2/parser/models/fb2_body.dart';
import 'package:funle_fb2/parser/models/fb2_description.dart';
import 'package:funle_fb2/parser/models/fb2_image.dart';

class FB2Parser {
  /// The path of the FB2 file.
  late final String path;

  /// The file object of the FB2 file.
  late final File file;

  /// The description of the FB2 file.
  late final FB2Description description;

  /// The body of the FB2 file.
  late final FB2Body body;

  /// The list of images in the FB2 file.
  final List<FB2Image> images = [];

  FB2Parser(this.path) {
    // match the file extension
    RegExpMatch? match = RegExp(r'\.fb2$').firstMatch(path);
    if (match == null) {
      throw Exception('The file extension is not .fb2');
    }
    file = File(path);
    if (!file.existsSync()) {
      throw Exception('The file does not exist');
    }
  }

  /// Parses the file content and performs various transformations and parsing operations.
  ///
  /// This method reads the content of the file, performs image parsing, replaces empty-line tags with <br/> tags,
  /// replaces hyperlink tags with correct href attribute, and then parses the description and body of the file.
  ///
  /// Throws an exception if there is an error while reading the file or during the parsing process.
  Future<void> parse() async {
    String fileContent = await file.readAsString();

    parseImages(fileContent);

    fileContent = changeImageTagToImg(fileContent);

    fileContent =
        fileContent.replaceAllMapped(RegExp(r'<empty-line\/>'), (match) {
      return '<br/>';
    });

    /// for correct work with hyperlinks we need to replace all <a l:href="..."> to <a href="...">
    fileContent =
        fileContent.replaceAllMapped(RegExp(r'<a l:href="(.+?)">'), (match) {
      return '<a href="${match.group(1)}">';
    });

    parseDescription(fileContent);

    parseBody(fileContent);
  }

  /// Parses the body of the FB2 file from the given [fileContent].
  /// Throws an exception if the file does not contain a body.
  void parseBody(String fileContent) {
    final RegExpMatch? bodyRegExp =
        RegExp(r'<body>([\s\S]+?)<\/body>').firstMatch(fileContent);
    if (bodyRegExp == null) {
      throw Exception('The file does not contain body');
    }
    body = FB2Body(bodyRegExp.group(1)!);
  }

  /// Parses the description from the given [fileContent].
  ///
  /// The [fileContent] should be a string containing the content of a file.
  /// This method uses a regular expression to extract the description from the file content.
  /// If the description is not found, an exception is thrown.
  /// The extracted description is then assigned to the [description] property.
  /// Additionally, it retrieves the image with the ID 'cover.jpg' from the [images] list
  /// and assigns it to the [description] object.
  void parseDescription(String fileContent) {
    final RegExpMatch? descriptionRegExp =
        RegExp(r'<description>([\s\S]+?)<\/description>')
            .firstMatch(fileContent);
    if (descriptionRegExp == null) {
      throw Exception('The file does not contain description');
    }
    description = FB2Description(descriptionRegExp.group(1)!,
        images.firstWhere((element) => element.id == 'cover.jpg'));
  }

  /// Replaces all image tags in the given [fileContent] with corresponding img tags.
  /// The [fileContent] is expected to be a string containing HTML-like content.
  /// The image tags are expected to have the format <image ... />.
  /// The replacement is done by matching the id attribute of each image tag with the id of an FB2Image object in the [images] list.
  /// If a matching FB2Image object is found, the image tag is replaced with an img tag containing the base64-encoded image bytes.
  /// If no matching FB2Image object is found, the image tag is left unchanged.
  /// Returns the modified [fileContent] string.
  String changeImageTagToImg(String fileContent) {
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
    return fileContent;
  }

  /// Parses the images from the given [fileContent].
  ///
  /// The [fileContent] is a string containing the content of a file.
  /// This method uses a regular expression to find and extract binary image data
  /// enclosed within `<binary>` and `</binary>` tags in the [fileContent].
  /// Each extracted image is then added to the `images` list.
  void parseImages(String fileContent) {
    final Iterable<RegExpMatch> imagesRegExp =
        RegExp(r'<binary[\s\S]+?>([\s\S]+?)<\/binary>').allMatches(fileContent);
    for (final RegExpMatch image in imagesRegExp) {
      images.add(FB2Image(image.group(0)!));
    }
  }
}
