import 'package:flutter/material.dart';
import 'package:terminal_app/entities/user.dart';
import 'package:terminal_app/pages/user_profile.dart';
import 'package:terminal_app/services/user_service.dart';

class UserList extends StatefulWidget {
  UserList({Key key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> users;
  Widget body;

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("Kullanıcılar"),
          ),
          actions: [
            // IconButton(
            //   padding: EdgeInsets.only(right: 15),
            //   icon: Icon(Icons.person_add_alt_1, color: Colors.white),
            //   onPressed: () {
            //     Navigator.pushReplacementNamed(context, "/user_card");
            //   },
            // ),
          ],
        ),
        body: body);
  }

  get empty {
    return Center(
      child: Text("Liste Boş"),
    );
  }

  get _users {
    return Container(
      child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.only(left: 20),
                  leading: Icon(
                    Icons.person_rounded,
                    color: Colors.green,
                  ),
                  title: Text(
                    users[index].kisi,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),

                  subtitle:
                      Text((users[index].admin == 0 ? "admin" : "standart")),
                  // trailing: Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: actions(index),
                  // ),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward_ios_rounded),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UserProfile(id: users[index].id)));
                    },
                  ),
                ),
                Divider(color: Colors.black)
              ],
            );
          }),
    );
  }

  reload() {
    UserService.getAll().then((value) => (this.setState(() {
          if (value != null && value.isNotEmpty) {
            users = value;
            body = _users;
          } else {
            body = empty;
          }
        })));
  }

  actions(int index) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.edit_rounded, color: Colors.blue),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(Icons.delete_forever_rounded, color: Colors.red),
        onPressed: () {
          UserService.delete(users[index].id).then((value) {
            reload();
          });
        },
      )
    ];
  }
}
