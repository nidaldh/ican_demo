import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  final String email;

  AddUser({Key key, @required this.email}) : super(key: key);
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  String name = '';
  int phone = 0;
  int age;
  String location;
  double height;
  double weight;
  Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text("Add user info"),
        elevation: 0,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Card(
                color: Colors.white,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    name = val.trim();
                    print(name);
                  },
                  decoration: InputDecoration(
//                    icon: Icon(Icons.person),
                    labelText: 'name',
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                color: Colors.white,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty || value.trim().length == 9) {
                      return 'the number must be 10 digit';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    phone = int.parse(val.trim());
                    print(phone);
                  },
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    labelText: 'Phone number',
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.amberAccent)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                color: Colors.white,
                child: TextFormField(
                  validator: (value) {
                    if (value.trim().isEmpty || int.parse(value)<10) {
                      return 'the age must be 10 and above ';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    age = int.parse(val.trim());
                    print(age);
                  },
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    labelText: 'age',
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.amberAccent)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                color: Colors.white,
                child: TextFormField(

                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'please enter your location';
                    }
                    return null;
                  },
                  onSaved: (val){
                    location=val.trim();
                    print(location);
                  },

                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.amberAccent)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                color: Colors.white,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty || double.parse(value)<=20) {
                      return 'please enter your weight';
                    }
                    return null;
                  },
                  onSaved: (val){
                    weight=double.parse(val.trim());
                    print(weight);
                  },
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    labelText: 'weight',
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.amberAccent)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                color: Colors.white,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty || double.parse(value)<=150) {
                      return 'please enter your height';
                    }
                    return null;
                  },
                  onSaved: (val){
                    height=double.parse(val.trim());
                    print(height);
                  },
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    labelText: 'Height',
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.amberAccent)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                child: Text("save"),
                backgroundColor: Colors.deepPurpleAccent,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    add();
                    Navigator.of(context).pop();

                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  add() {
    print(widget.email);
    firestore.collection("info").document(widget.email).setData({
      'name': name,
      'phone_number':phone,
      'age':age,
      'location':location,
      'height':height,
      'weight':weight,
    });
  }
}
