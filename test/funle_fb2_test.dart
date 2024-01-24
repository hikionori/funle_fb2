
import 'package:flutter_test/flutter_test.dart';
import 'package:funle_fb2/funle_fb2.dart';

void main() {
  const String pathToFixtures = './test/fixtures/';
  late FB2Parser parser;

  test("Parse fb2 file: test_file.fb2", () async {
    parser = FB2Parser("$pathToFixtures/test_file.fb2");
    await parser.parse();
    expect(parser.description.title, "Исполнитель");
    expect(parser.images.length, 3);
    expect(parser.body.sections?.length, 15);
    expect(
      parser.description.coverPage?.bytes,
      parser.images
          .where((element) => element.id == parser.description.coverPage?.id)
          .first
          .bytes,
    );
  });

  test("Parse fb2 file: test_file2.fb2", () async {
    parser = FB2Parser("$pathToFixtures/test_file2.fb2");
    await parser.parse();

    expect(parser.description.title, "Четвертое крыло");
    expect(parser.images.length, 80);
    expect(parser.body.sections?.length, 42);
    expect(
      parser.description.coverPage?.bytes,
      parser.images
          .where((element) => element.id == parser.description.coverPage?.id)
          .first
          .bytes,
    );
  });
}
