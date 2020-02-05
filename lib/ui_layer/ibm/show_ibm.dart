import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/data_layer/user.dart';
import 'package:flutter/material.dart';

class ShowIBM extends StatefulWidget {
  User user;

  ShowIBM({this.user});

  @override
  _ShowIBMState createState() => _ShowIBMState();
}

class _ShowIBMState extends State<ShowIBM> {
  final _formKey = GlobalKey<FormState>();
  String date;
  double weight;
  double height;
  double bmi;
  Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add IBM"),
        elevation: 0,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Form(
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
                  date = val.trim();
                  print(date);
                },
                decoration: InputDecoration(
//                    icon: Icon(Icons.person),
                  labelText: 'date',
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
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (val) {
                  weight = double.parse(val.trim());
                  print(weight);
                },
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
//                    icon: Icon(Icons.person),
                  labelText: 'weight',
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)),
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

//                  Navigator.of(context).pop();
                }
                add();
//                calculateBMi();
              },
            ),
            SizedBox(
              height: 10,
            ),
            Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    borderOnForeground: true,
                    margin:  EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
              bmi.toString(),
            ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }

  void calculateBMi() async {
    print("calculate");
    print(widget.user.email);
//    await firestore
//        .collection("info")
//        .document(widget.user.email)
//        .get()
//        .then((DocumentSnapshot ds) {
//      // use ds as a snapshot
////     ds.data[''];
//      print(ds.data['height']);
//      height = ds.data['height'];
//    });
    weight=widget.user.weight;

    bmi = weight / ((height * height) / 10000);
//    print();
  }

  add() async {
    print(widget.user.email);
    await calculateBMi();

    await firestore
        .collection("info")
        .document(widget.user.email)
        .collection("IBM")
        .document(date)
        .setData({"weight": weight, "BMI": bmi});
//    await firestore
//        .collection("info")
//        .document("nidal@gmail.com")
//        .collection("IBM")
//        .getDocuments()
//        .then((QuerySnapshot snapshot) {
//      print("nidal");
//      print(snapshot.documents.length);
//      snapshot.documents.forEach((f) => print('${f.data}'));
//    });
  }
}
