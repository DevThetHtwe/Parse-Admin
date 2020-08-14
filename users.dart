import 'package:Bhawlone/view/Kyay/kyayForm.dart';
import 'package:Bhawlone/view/Kyay/userdatasource.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'usercontroller.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final UsersControl usersControl = UsersControl();
  @override
  void initState() {
    super.initState();
    setState(
      () {
        usersControl.initializeparse();
      },
    );
  }

  TextEditingController controller = TextEditingController();
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  var _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool isSearch = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final control = Provider.of<UsersControl>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KyayForm(false, '', '', '', '', '', ''),
                ),
              );
            },
          ),
        ],
        title: Text(
          'Manage Users',
          style: GoogleFonts.ubuntu(),
        ),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: PaginatedDataTable(
          header: Text(
            "Register List",
            style: GoogleFonts.b612(color: Colors.blue),
          ),
          actions: <Widget>[
            isSearch
                ? Container(
                    width: 100,
                    child: TextField(
                      controller: controller,
                      onChanged: control.search,
                    ),
                  )
                : Container(),
            isSearch
                ? IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        isSearch = !isSearch;
                        controller.clear();
                        // control.data();
                        control.search("");
                      });
                    })
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        isSearch = !isSearch;
                      });
                    })
          ],
          source: UserDataSource(context, control.list),
          rowsPerPage: _rowsPerPage,
          availableRowsPerPage: const [5, 10, 15, 20],
          sortAscending: _sortAscending,
          sortColumnIndex: _sortColumnIndex,
          headingRowHeight: 20.0,
          onRowsPerPageChanged: (int v) {
            setState(() {
              _rowsPerPage = v;
            });
          },
          columns: <DataColumn>[
            DataColumn(
                label: Container(
                  child: Text(
                    "Name",
                    style: GoogleFonts.b612(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                onSort: (index, sortAscending) {
                  setState(() {
                    _sortAscending = sortAscending;
                    if (sortAscending) {
                      control.list.sort((a, b) => a.name.compareTo(b.name));
                    } else {
                      control.list.sort((a, b) => b.name.compareTo(a.name));
                    }
                  });
                }),
            DataColumn(
                label: Container(
              child: Text(
                "Username",
                style: GoogleFonts.b612(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            )),
            DataColumn(
                label: Container(
              child: Text(
                "Email",
                style: GoogleFonts.b612(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            )),
            DataColumn(
                label: Container(
              child: Text(
                "Phone",
                style: GoogleFonts.b612(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            )),
            DataColumn(
              label: Container(
                alignment: Alignment.center,
                child: Text(
                  "Action",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.b612(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                // width: 20,
              ),
            ),
          ],
        ),
      ),
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
                  nameController.clear();
                  passwordController.clear();
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
                  UsersControl control = new UsersControl();
                  control.add(
                    nameController.text,
                    passwordController.text,
                  );
                  //
                  Navigator.of(context).pop();
                  nameController.clear();
                  passwordController.clear();
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
}
