class User {
  String? name;
  int? age;
  String? gender;

  User({
    required this.name,
    required this.age,
    required this.gender,
  });

  User.fromJson(Map<String, Object?> json)
   : this (
        name: json['name']! as String,
        age: json['age']! as int,
        gender: json['gender']! as String,
      );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
    };
  }
}
