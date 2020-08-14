import 'dart:convert';
import 'package:Bhawlone/view/Kyay/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class UsersControl extends ChangeNotifier {
  factory UsersControl() {
    if (_this == null) _this = UsersControl._();
    return _this;
  }
  static UsersControl _this;
  UsersControl._() : super();
  List<KyayUserData> get list => show;
  List<KyayUserData> lists = List<KyayUserData>();
  List<KyayUserData> show = List<KyayUserData>();

  void fetchdata() async {
    try {
      var apiResponse = await ParseObject('_User').getAll();
      if (apiResponse.success) {
        final List<dynamic> json =
            const JsonDecoder().convert(apiResponse.result.toString());
        lists.clear();
        lists = json.map((data) => new KyayUserData.fromJson(data)).toList();
        show = lists;
        notifyListeners();
        print(show.length);
      }
    } catch (e) {
      print("No Data!");
    }
    notifyListeners();
  }

  void add(String name, String password) async {
    var add = ParseObject('_User')
      ..set('username', name)
      ..set('password', password);
    await add.save();

    lists.add(
      KyayUserData(name: name, password: password, objId: add.objectId),
    );
    notifyListeners();
  }

  void initializeparse() async {
    await Parse()
        .initialize("myAppId", "http://192.168.8.100:1337/parse",
            masterKey: "myMasterKey", debug: true)
        .whenComplete(
      () {
        print('>>> Initializing parse server completed <<<');
        fetchdata();
      },
    );
  }

  void edit(
      String id, String name, String phone, String password, int index) async {
    var edit = ParseObject('_User')
      ..objectId = id
      ..set('username', name)
      ..set('phone', phone)
      ..set('password', password);

    await edit.save();

    lists.replaceRange(
      index,
      index + 1,
      [KyayUserData(phone: phone, name: name, objId: id, password: password)],
    );

    notifyListeners();
  }

  void search(String value) {
    if (value.isNotEmpty || value.length != 0) {
      show = lists.where((data) {
        return data.name.toLowerCase().contains(value.toLowerCase()) ||
            data.email.toLowerCase().contains(value.toLowerCase()) ||
            data.phone.toLowerCase().contains(value.toLowerCase()) ||
            data.username.toLowerCase().contains(value.toLowerCase());
      }).toList();

      notifyListeners();
    } else {
      show = lists;
      notifyListeners();
    }
  }
}
