class DebugFormModel {
  const DebugFormModel({
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
    this.prefecture,
    this.birthday,
  });

  final String name;
  final String email;
  final String password;
  final DebugModelGender gender;
  final String? prefecture;
  final DateTime? birthday;

  @override
  String toString() {
    return 'DebugFormModel(name: $name, email: $email, password: $password, gender: $gender, prefecture: $prefecture, birthday: $birthday)';
  }
}

enum DebugModelGender {
  male,
  female,
  other,
}
