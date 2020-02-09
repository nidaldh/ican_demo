import 'package:demo_ican/data_layer/model/user.dart';
import 'package:demo_ican/ui_layer/add_user/add_user_form.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  User user;
  UserProfile(this.user);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("profile"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () async {
              dynamic date = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return AddUser(
                        user: this.widget.user,
                      ) ??
                      "nothing";
                }),
              );
              print(date);
              setState(() {
//              print(date['nidal']);
                print(date['user']);

//              this.widget.user=date['user'];
              });
              print("weight " + widget.user.height.toString());
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: ListView(
            children: <Widget>[
              Center(child: Text(widget.user.name)),
              Divider(
                thickness: 3,
                color: Colors.deepPurple,
              ),
              Text(widget.user.phoneNumber),
              Divider(
                thickness: 3,
                color: Colors.deepPurple,
              ),
              Text(widget.user.email),
              Divider(
                thickness: 3,
                color: Colors.deepPurple,
              ),
              Text(widget.user.location),
              Divider(
                thickness: 3,
                color: Colors.deepPurple,
              ),
              Text(widget.user.weight.toString()),
              Divider(
                thickness: 3,
                color: Colors.deepPurple,
              ),
              Text(widget.user.height.toString()),
              Divider(
                thickness: 3,
                color: Colors.deepPurple,
              ),
              Text(widget.user.age.toString()),
              Divider(
                thickness: 3,
                color: Colors.deepPurple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
