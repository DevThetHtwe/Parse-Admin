class RoleData {
  final String objId;
  final String name;
  final String password;
  final String phone;

  bool selected = false;
  RoleData({this.name, this.password, this.objId, this.phone});

  factory RoleData.fromJson(Map<String, dynamic> json) {
    return new RoleData(
      objId: json['objectId'],
      name: json['name'],
      password: json['password'],
      phone: json['phone'],
    );
  }
}
