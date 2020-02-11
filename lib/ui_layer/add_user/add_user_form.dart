import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/data_layer/model/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  final User user;

  AddUser({Key key, @required this.user}) : super(key: key);
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  String name = '';
  String phone = "";
  int age;
  String location;
  double height;
  double weight;
  Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
//      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).tr("add_info")),
        elevation: 0,
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: widget.user.name??null,
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
                  labelText: AppLocalizations.of(context).tr("name"),
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: widget.user.phoneNumber??null,
                validator: (value) {
                  if (value.isEmpty || value
                      .trim()
                      .length == 9) {
                    return 'the number must be 10 digit';
                  }
                  return null;
                },
                onSaved: (val) {
                  phone = val;
                  print(phone);
                },
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).tr("phone_number"),
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.amberAccent)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: widget.user.age.toString()??null,
                validator: (value) {
                  if (value
                      .trim()
                      .isEmpty || int.parse(value) < 10) {
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
                  labelText: AppLocalizations.of(context).tr("age"),
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.amberAccent)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: widget.user.location ??null,
                validator: (value) {
                  if (value
                      .trim()
                      .isEmpty) {
                    return 'please enter your location';
                  }
                  return null;
                },
                onSaved: (val) {
                  location = val.trim();
                  print(location);
                },

                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).tr("location"),
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.amberAccent)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: widget.user.weight.toString()??null,
                validator: (value) {
                  if (value.isEmpty || double.parse(value) <= 20) {
                    return 'please enter your weight';
                  }
                  return null;
                },
                onSaved: (val) {
                  weight = double.parse(val.trim());
                  print(weight);
                },
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  helperText: "Kg",
                  labelText: AppLocalizations.of(context).tr("weight"),
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.amberAccent)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: widget.user.height.toString()??null,
                validator: (value) {
                  if (value.isEmpty || double.parse(value) <= 150) {
                    return 'please enter your height';
                  }
                  return null;
                },
                onSaved: (val) {
                  height = double.parse(val.trim());
                  print(height);
                },
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  helperText: "cm",
                  alignLabelWithHint: true,
                  labelText: AppLocalizations.of(context).tr("height"),
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.amberAccent)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                child: Text("save"),
                backgroundColor: Colors.amberAccent,
                onPressed: () async{
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                   await add();
                  }
                },

              )
            ],
          ),
        ),
      ),
    );
  }

  add()async {
    print(widget.user.email);
    await firestore.collection("info").document(widget.user.email).setData({
      'name': name,
      'phone_number':phone,
      'age':age,
      'location':location,
      'height':height,
      'weight':weight,
    });

    widget.user.name=name;
    widget.user.phoneNumber=phone;
    widget.user.age=age;
    widget.user.location=location;
    widget.user.height=height;
    widget.user.weight=weight;
    Navigator.pop(context,{
      'user':widget.user
    });

  }
}