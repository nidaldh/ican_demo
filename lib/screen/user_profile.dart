import 'package:demo_ican/data_layer/user.dart';
import 'package:demo_ican/ui_layer/add_user/add_user_form.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  User user;
  UserProfile(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("profile"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return AddUser(
                    user: this.user,
                  );
                }),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: ListView(
            children: <Widget>[
                Center(child: Text(user.name)),Divider(thickness: 3,color: Colors.deepPurple,),
                Text(user.phoneNumber),Divider(thickness: 3,color: Colors.deepPurple,),
                Text(user.email),Divider(thickness: 3,color: Colors.deepPurple,),
                Text(user.location),Divider(thickness: 3,color: Colors.deepPurple,),
                Text(user.weight.toString()),Divider(thickness: 3,color: Colors.deepPurple,),
                Text(user.height.toString()),Divider(thickness: 3,color: Colors.deepPurple,),
                Text(user.age.toString()),Divider(thickness: 3,color: Colors.deepPurple,),
            ],
          ),
        ),
      ),
    );
  }
}
