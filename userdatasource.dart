import 'package:Bhawlone/controller/control.dart';
import 'package:Bhawlone/view/Kyay/kyayForm.dart';
import 'package:Bhawlone/view/Kyay/usermodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class UserDataSource extends DataTableSource {
  final List<KyayUserData> list;
  final BuildContext context;
  UserDataSource(this.context, this.list);

  int _selectedCount = 0;
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => list.length;

  @override
  int get selectedRowCount => _selectedCount;

  @override
  DataRow getRow(int index) {
    final KyayUserData item = list[index];
    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(
        Container(
          // width: 55,
          child: item.name != null
              ? Text(item.name, style: GoogleFonts.b612(fontSize: 13))
              : Text(''),
        ),
      ),
      DataCell(
        Container(
          // width: 55,
          child: item.username != null
              ? Text(item.username, style: GoogleFonts.b612(fontSize: 13))
              : Text(''),
        ),
      ),
      DataCell(
        Container(
          // width: 55,
          child: item.email != null
              ? Text(item.email, style: GoogleFonts.b612(fontSize: 13))
              : Text(''),
        ),
      ),
      DataCell(
        Container(
          // width: 55,
          child: item.phone != null
              ? Text(
                  item.phone,
                  style: GoogleFonts.b612(fontSize: 13),
                )
              : Text(''),
        ),
      ),
      DataCell(
        Row(
          children: [
            Container(
              child: IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KyayForm(
                        true,
                        item.objId,
                        item.username,
                        item.name,
                        item.email,
                        item.phone,
                        item.password,
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  askUser(item.objId, index, item.name);
                },
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  showEdit(
      String id, String name, String phone, int index, String password) async {
    //
    // ParseUser currentUser = await ParseUser.currentUser();
    //

    //
    // var aa = await currentUser.getObject(id).then(
    //   (value) {
    //     if (value.success) {
    //       print('Your password is ' + value.result['password']);
    //     }
    //   },
    // );
    //
    AlertDialog alert = AlertDialog(
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone',
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Update Password',
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlatButton(
                color: Colors.red,
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'CANCEL',
                  style: GoogleFonts.b612(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              FlatButton(
                color: Colors.blue,
                onPressed: () async {
                  Control control = new Control();
                  control.edit(
                    id,
                    nameController.text,
                    phoneController.text,
                    passwordController.text,
                    index,
                  );
                  //
                  Navigator.of(context).pop();
                },
                child: Text(
                  'UPDATE',
                  style: GoogleFonts.b612(color: Colors.white),
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

  addUser(String name, String password) async {
    AlertDialog alert = AlertDialog(
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add New User',
            textAlign: TextAlign.center,
            style: GoogleFonts.b612(color: Colors.blue),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'New Name',
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'New Password',
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlatButton(
                color: Colors.red,
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'CANCEL',
                  style: GoogleFonts.b612(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              FlatButton(
                color: Colors.blue,
                onPressed: () async {
                  Control control = new Control();
                  control.add(
                    nameController.text,
                    passwordController.text,
                  );
                  //
                  Navigator.of(context).pop();
                },
                child: Text(
                  'ADD',
                  style: GoogleFonts.b612(color: Colors.white),
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

  askUser(String oid, int index, String name) async {
    AlertDialog alert = AlertDialog(
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.help_outline, color: Colors.red),
          SizedBox(
            height: 15,
          ),
          Text(
            'Delete $name?',
            textAlign: TextAlign.center,
            style: GoogleFonts.b612(color: Colors.blue),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlatButton(
                color: Colors.blue,
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'CANCEL',
                  style: GoogleFonts.b612(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              FlatButton(
                color: Colors.red,
                onPressed: () async {
                  //
                  list.removeAt(index);

                  ParseObject('_User')..delete(id: oid);
                  notifyListeners();
                  //
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.b612(color: Colors.white),
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

  void sort(getField(lists), bool ascending) {
    list.sort((a, b) {
      if (!ascending) {
        final c = a;
        a = b;
        b = c;
      }
      final aValue = getField(a);
      final bValue = getField(b);

      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }
}
