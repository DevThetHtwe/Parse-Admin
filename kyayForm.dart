import 'dart:convert';

import 'package:Bhawlone/view/Kyay/usercontroller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'rolemodel.dart';

class KyayForm extends StatefulWidget {
  final bool isupdate;
  final String id, username, name, email, phone, password;
  KyayForm(this.isupdate, this.id, this.username, this.name, this.email,
      this.phone, this.password);
  //
  @override
  _KyayFormState createState() => _KyayFormState();
}

class _KyayFormState extends State<KyayForm> {
  //user control to update list .............

  final UsersControl usersControl = UsersControl();
  String firstrolevalue = '';

  @override
  void initState() {
    initializeparse();
    this.widget.isupdate ? filldata() : print('');
    super.initState();
  }

  void filldata() async {
    setState(() {
      username.text = this.widget.username;
      name.text = this.widget.name;
      email.text = this.widget.email;
      phone.text = this.widget.phone;
    });
  }

  void filterrole() async {
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('_User'))
          ..whereContains('objectId', this.widget.id);

    QueryBuilder<ParseObject> queryRole =
        QueryBuilder<ParseObject>(ParseObject('_Role'))
          ..whereMatchesQuery('users', query);

    var apiResponse = await queryRole.query();

    if (apiResponse.success) {
      setState(() {
        rolevalue = apiResponse.results[0]['name'];
        firstrolevalue = apiResponse.results[0]['name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: this.widget.isupdate ? updateform() : normalform(),
    );
  }

  Widget normalform() {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text('Add User')),
      body: SafeArea(
        child: Container(
          child: CustomScrollView(
            slivers: [
              addfield('Name', name, false),
              addfield('Username', username, false),
              addfield('Email', email, false),
              addfield('Phone', phone, false),
              roledropdown(),
              addfield('Password', password, true),
              addfield('Confirm Password', confirmpassword, true),
              savebtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget updateform() {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text('Update User')),
      body: SafeArea(
        child: Container(
          child: CustomScrollView(
            slivers: [
              addfield('Name', name, false),
              addfield('Username', username, false),
              addfield('Email', email, false),
              addfield('Phone', phone, false),
              roledropdown(),
              passwordbtn(),
              updatebtn(),
            ],
          ),
        ),
      ),
    );
  }

  List<RoleData> roledata = new List<RoleData>();
  String rolevalue;
  List<String> item = List<String>();

  TextEditingController name = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController opassword = new TextEditingController();
  TextEditingController confirmpassword = new TextEditingController();

  void fetchRole() async {
    roledata.clear();
    try {
      var apiResponse = await ParseObject('_Role').getAll();
      // print(apiResponse);
      if (apiResponse.success) {
        final List<dynamic> json =
            const JsonDecoder().convert(apiResponse.result.toString());
        roledata.clear();
        roledata = json.map((data) => new RoleData.fromJson(data)).toList();
        // print(roledata.length);
        addtoitem();
      }
    } catch (e) {
      print("No Data!");
    }
  }

  void initializeparse() async {
    await Parse()
        .initialize("myAppId", "http://192.168.8.100:1337/parse",
            masterKey: "myMasterKey", debug: false)
        .whenComplete(
      () {
        print('>>> Initializing parse server completed <<<');
        fetchRole();
        this.widget.isupdate ? filterrole() : print('');
      },
    );
  }

  void adduser(String name, String username, String email, String phone,
      String selectedrow, String password) async {
    String id = '';
    roledata.forEach((rolee) {
      if (rolee.name == selectedrow) {
        setState(() {
          id = rolee.objId;
        });
      }
    });
    var newuser = ParseObject('_User')
      ..set('name', name)
      ..set('username', username)
      ..set('email', email)
      ..set('phone', phone)
      // ..set('role', selectedrow)
      ..set('password', password);
    await newuser.save().then(
      (user) {
        ParseObject role = ParseObject('_Role')..objectId = id;
        var relation = role.getRelation('users');
        relation.add(newuser);
        role.save();
      },
    ).whenComplete(
      () {
        print('User Successfully Added!');
        clr();
        usersControl.fetchdata();
        Navigator.of(context).pop();
      },
    );
  }

  void updateuser(String userid, String name, String username, String email,
      String phone, String selectedrow) async {
    String roleid = '';
    roledata.forEach((rolee) {
      if (rolee.name == selectedrow) {
        setState(() {
          roleid = rolee.objId;
        });
      }
    });

    String firstroleid = '';
    roledata.forEach((frole) {
      if (frole.name == firstrolevalue) {
        setState(() {
          firstroleid = frole.objId;
        });
      }
    });

    var newuser = ParseObject('_User')
      ..objectId = userid
      ..set('name', name)
      ..set('username', username)
      ..set('email', email)
      ..set('phone', phone);
    await newuser.save().then(
      (user) {
        if (firstrolevalue != selectedrow) {
          ParseObject firstrole = ParseObject('_Role')..objectId = firstroleid;
          var firstrelation = firstrole.getRelation('users');
          firstrelation.remove(newuser);
          firstrole.save();

          print('first role id is : ' + firstroleid);

          // ParseObject firstrole = ParseObject('_Role')..objectId = firstroleid;
          // var aa = firstrole.removeRelation('users', [newuser]);

          // ParseObject role = ParseObject('_Role')..objectId = roleid;
          // var relation = role.getRelation('users');
          // relation.add(newuser);
          // role.save();

          // print(roleid);
        } else {
          //
        }
      },
    ).whenComplete(
      () {
        print('User Successfully Added!');
        clr();
        usersControl.fetchdata();
        Navigator.of(context).pop();
      },
    );
  }

  addtoitem() {
    roledata.forEach((element) {
      setState(() {
        item.add(element.name);
      });
    });
  }

  Widget roledropdown() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          style: GoogleFonts.ubuntu(color: Colors.black),
          decoration: InputDecoration(
            hintStyle: GoogleFonts.ubuntu(color: Colors.grey),
            labelStyle: GoogleFonts.ubuntu(color: Colors.black),
            hintText: 'Role',
            contentPadding:
                EdgeInsets.only(top: 0, bottom: 0, left: 5.0, right: 5.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          value: rolevalue,
          items: item
              .map((label) => DropdownMenuItem(
                    child: Text(label),
                    value: label,
                  ))
              .toList(),
          onChanged: (v) {
            setState(() {
              rolevalue = v;
            });
          },
        ),
      ),
    );
  }

  Widget addpwfield(String hint, TextEditingController controller, bool ispw) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Card(
        elevation: 0.2,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: TextField(
          controller: controller,
          style: GoogleFonts.ubuntu(),
          obscureText: ispw ? true : false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 5.0, right: 5.0),
          ),
        ),
      ),
    );
  }

  Widget addfield(String hint, TextEditingController controller, bool ispw) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Card(
          elevation: 0.2,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: TextField(
            controller: controller,
            style: GoogleFonts.ubuntu(),
            obscureText: ispw ? true : false,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 5.0, right: 5.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget savebtn() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: FlatButton(
          color: Colors.green,
          onPressed: () {
            adduser(name.text, username.text, email.text, phone.text, rolevalue,
                password.text);
          },
          child: Text('Save', style: GoogleFonts.ubuntu(color: Colors.white)),
        ),
      ),
    );
  }

  Widget updatebtn() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: FlatButton(
          color: Colors.green,
          onPressed: () {
            updateuser(this.widget.id, name.text, username.text, email.text,
                phone.text, rolevalue);
          },
          child: Text('Update', style: GoogleFonts.ubuntu(color: Colors.white)),
        ),
      ),
    );
  }

  Widget passwordbtn() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20.0),
        child: FlatButton(
          color: Colors.blue,
          onPressed: () {
            showPasswordDialog(context);
          },
          child: Text('Change Password',
              style: GoogleFonts.ubuntu(color: Colors.white)),
        ),
      ),
    );
  }

  showPasswordDialog(BuildContext context) {
    // setControls();
    AlertDialog alert = AlertDialog(
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          addpwfield('New Password', password, true),
          addpwfield('Retype New Password', confirmpassword, true),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlatButton(
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              FlatButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                onPressed: () async {
                  if (password.text != confirmpassword.text) {
                    print('Passsword not match');
                  } else {
                    var newuser = ParseObject('_User')
                      ..objectId = this.widget.id
                      ..set('password', confirmpassword.text);
                    await newuser
                        .save()
                        .then((value) => Navigator.of(context).pop())
                        .whenComplete(() => Navigator.of(context).pop());
                  }
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  clr() {
    name.clear();
    username.clear();
    email.clear();
    phone.clear();
    password.clear();
    confirmpassword.clear();
  }
}
