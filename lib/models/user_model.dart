class UserModel{
  String id;
  String name;
  String email;

  UserModel({required this.id, required this.name, required this.email,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}