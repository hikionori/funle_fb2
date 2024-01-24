class FB2Author {
  late final String? id;
  late final String? firstName;
  late final String? middleName;
  late final String? lastName;
  late final String? nickname;
  late final String? email;

  FB2Author(String author) {
    id = RegExp(r'id="(.+?)"').firstMatch(author)?.group(1) ?? '';
    firstName =
        RegExp(r'<first-name>(.+?)<\/first-name>').firstMatch(author)?.group(1);
    middleName = RegExp(r'<middle-name>(.+?)<\/middle-name>')
            .firstMatch(author)
            ?.group(1) ??
        '';
    lastName =
        RegExp(r'<last-name>(.+?)<\/last-name>').firstMatch(author)?.group(1) ??
            '';
    nickname =
        RegExp(r'<nickname>(.+?)<\/nickname>').firstMatch(author)?.group(1) ??
            '';
    email = RegExp(r'<email>(.+?)<\/email>').firstMatch(author)?.group(1) ?? '';
  }

  @override
  String toString() {
    return 'FB2Author{id: $id, firstName: $firstName, middleName: $middleName, lastName: $lastName, nickname: $nickname, email: $email}';
  }
}
