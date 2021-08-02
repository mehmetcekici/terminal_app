import 'package:flutter/material.dart';
import 'package:terminal_app/entities/user.dart';
import 'package:terminal_app/pages/user_profile.dart';
import 'package:terminal_app/services/web/user_service.dart';
import 'package:terminal_app/widgets/app_bar.dart';
import 'package:terminal_app/utils/extensions.dart';
import 'package:terminal_app/widgets/text_field.dart';

class UserList extends StatefulWidget {
  UserList({Key key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> users;
  Widget body;
  bool searchVisible = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Kullanıcılar",
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: context.width / 30),
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                searchVisible = !searchVisible;
                if (!searchVisible) {
                  searchController.clear();
                  getUsers();
                }
              });
            },
          ),
        ],
      ).build(context),
      body: Column(
        children: [
          searchVisible ? serachBar() : SizedBox(),
          searchVisible ? Divider(color: Colors.black) : SizedBox(),
          Expanded(child: body),
        ],
      ),
    );
  }

  serachBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width / 20),
            child: CustomTextField(
              controller: searchController,
              textStyle: context.theme.headline6,
              hintText: "ara",
              suffixIcon: IconButton(
                icon: Icon(Icons.cancel_outlined),
                onPressed: () {
                  searchController.clear();
                  getUsers();
                },
              ),
              onChanged: (text) {
                getUsers(filter: text);
              },
            ),
          ),
        ),
      ],
    );
  }

  get empty {
    return Center(
      child: Text("Kullanıcı bulunamadı"),
    );
  }

  get _users {
    return Container(
      child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                listItem(index),
                Divider(color: Colors.black),
              ],
            );
          }),
    );
  }

  listItem(index) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 15),
      leading: Icon(
        Icons.person_rounded,
        color: Colors.green,
      ),
      title: Text(
        users[index].kisi,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      ),
      subtitle: Text((users[index].admin == 0 ? "admin" : "standart")),
      trailing: Icon(Icons.arrow_forward_ios_rounded),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserProfile(id: users[index].id)));
      },
    );
  }

  getUsers({String filter}) {
    filter = filter ?? "";
    UserService.getAll(
      where: "KISI LIKE ?",
      whereArgs: ["%$filter%"],
    ).then((value) {
      this.setState(() {
        if (value != null && value.isNotEmpty) {
          users = value;
          body = _users;
        } else {
          body = empty;
        }
      });
    });
  }
}
