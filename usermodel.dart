class KyayUserData {
  final String objId;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String password;

  KyayUserData(
      {this.objId,
      this.name,
      this.username,
      this.email,
      this.password,
      this.phone});

  factory KyayUserData.fromJson(Map<String, dynamic> json) {
    return new KyayUserData(
      objId: json['objectId'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
    );
  }
}
