import 'package:funle_fb2/funle_fb2.dart';

void main() async {
  FB2Parser parser = FB2Parser('example.fb2');
  await parser.parse();

  print(parser.description.title);
  print(parser.description.authors![0].firstName);
}
