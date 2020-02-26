import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/data_layer/model/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).tr("add_info"),style: GoogleFonts.cairo(
            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Form(
          key: _formKey,
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              TextFormField(
                initialValue: widget.user.name??null,
                validator: (value) {
                  if (value.isEmpty) {
                    return AppLocalizations.of(context).tr("empty_input");
                  }
                  return null;
                },
                onSaved: (val) {
                  name = val.trim();
                  print(name);
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
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
                      .length != 10) {
                    return AppLocalizations.of(context).tr("phone_number_error");

                  }
                  return null;
                },
                onSaved: (val) {
                  phone = val;
                  print(phone);
                },
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: Icon(MdiIcons.phone),
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
                    return AppLocalizations.of(context).tr("age_error");

                  }
                  return null;
                },
                onSaved: (val) {
                  age = int.parse(val.trim());
                  print(age);
                },
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: Icon(MdiIcons.humanFemaleGirl),
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
                    return AppLocalizations.of(context).tr("empty_input");
                  }
                  return null;
                },
                onSaved: (val) {
                  location = val.trim();
                  print(location);
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.location_on),
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
                  if (value.isEmpty ) {
                    return AppLocalizations.of(context).tr("empty_input");
                  }
                  if (double.parse(value) <= 30){
                    return AppLocalizations.of(context).tr("weight_input");
                  }
                  return null;
                },
                onSaved: (val) {
                  weight = double.parse(val.trim());
                  print(weight);
                },
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: Icon(MdiIcons.weightKilogram),
//                  helperText: AppLocalizations.of(context).tr("kg"),
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
                  if (value.isEmpty ) {
                    return AppLocalizations.of(context).tr("empty_input");
                  }
                  if( double.parse(value) <= 130){
                    return AppLocalizations.of(context).tr("height_error");
                  }
                  return null;
                },
                onSaved: (val) {
                  height = double.parse(val.trim());
                  print(height);
                },
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: Icon(MdiIcons.humanMaleHeight),
                  semanticCounterText: "cm",

//prefixIcon: Icon(Icons.chat),
//                  helperText: AppLocalizations.of(context).tr("cm"),
                  alignLabelWithHint: true,
                  labelText: AppLocalizations.of(context).tr("height"),
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.amberAccent)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                child: Text("save"),
//                backgroundColor: Colors.amberAccent,
              color: Colors.amberAccent,
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
   var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'updatng',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    print(widget.user.email);
    pr.show();
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
    pr.hide();
    Navigator.pop(context,{
      'user':widget.user
    });

  }
}