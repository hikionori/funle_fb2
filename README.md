## FunLe FB2 - is a package for work with FB2 files.

> This package is in development now. So it can be unstable and not work correctly.
> This package based on [fb2_parse](https://pub.dev/packages/fb2_parse)

#### Now it can:
* Parse FB2 file for get information about book. And this can be used for display book in WebView.

#### In future it will:
* Parse FB2 file for get information about book. And this can be used for display book in WebView.
* Provide widgets for display book in Flutter app.
* Provide library for editing of creating new FB2 files.

## Usage
1. Add dependency to your pubspec.yaml file:
```toml
dependencies:
  funle_fb2: ^0.0.1
```

2. Import package in your dart file:
```dart
import 'package:funle_fb2/funle_fb2.dart';
```

3. Use it:
```dart
// Create instance of FB2Parser
FB2Parser parser = FB2Parser("path/to/file.fb2");
// parse file
await parser.parse();
// get book info
String title = parser.description.title;
```