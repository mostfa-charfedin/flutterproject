class User {
  int id;
  String name;
  String lastName;
  String email;
  String password;
  String role;

  User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
    required this.role,
  });


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
    );
  }
}
