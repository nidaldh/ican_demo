import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:demo_ican/data_layer/model/user.dart';
import 'package:demo_ican/ui_layer/chart/new_chart.dart';
import 'package:demo_ican/ui_layer/chart/temp_chart.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowIBM extends StatefulWidget {
  User user;

  ShowIBM({this.user});

  @override
  _ShowIBMState createState() => _ShowIBMState();
}

class _ShowIBMState extends State<ShowIBM> {
  final _formKey = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MM-dd");
  String date;
  double weight;
  double height;
  double bmi;
  Firestore firestore = Firestore.instance;

  @override
  void initState() {
    getDates();
    super.initState();
  }
  LineChart chart;
  Map<DateTime, double> createLine2() {
    Map<DateTime, double> data = {};
    data[DateTime.now().subtract(Duration(minutes: 40))] = 13.0;
    data[DateTime.now().subtract(Duration(minutes: 30))] = 24.0;
    data[DateTime.now().subtract(Duration(minutes: 22))] = 39.0;
    data[DateTime.now().subtract(Duration(minutes: 20))] = 29.0;
    data[DateTime.now().subtract(Duration(minutes: 15))] = 27.0;
    data[DateTime.now().subtract(Duration(minutes: 12))] = 9.0;
    data[DateTime.now().subtract(Duration(minutes: 5))] = 35.0;
    return data;
  }
  @override
  Widget build(BuildContext context) {
    Map<DateTime, double> line1 = createLine2();

    chart = LineChart.fromDateTimeMaps([line1], [Colors.green], ['C']);

    return Scaffold(
      appBar: AppBar(
        title: Text("Add IBM"),
        elevation: 0,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Card(
                color: Colors.white,
                child: DateTimeField(
                  validator: (value) {
                    if (value == null) {
                      return 'Please select date';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    date = val.toString().substring(0, 10);
                    print(date);
                  },
                  decoration: InputDecoration(
                    labelText: 'date',
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                  ),
                  format: format,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlineButton(
                    child: Text("save"),
//                    backgroundColor: Colors.deepPurpleAccent,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        setState(() {
                          bmi = calculateBMi();
                          _bmi.add(BMI(DateTime.parse(date), bmi));
                        });
                      }
                    },
                  ),
                  OutlineButton(
                    child: Text("show BMI"),
//                    backgroundColor: Colors.deepPurpleAccent,
                    onPressed: () {
                      setState(() {
                        getDates();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  borderOnForeground: true,
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    bmi.toString() ?? "BMI",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ChartTemp(_bmi),
//            NewChart(_bmi)
//              Padding(
//                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
//                child: AnimatedLineChart(
//                  chart,
//                  key: UniqueKey(),
//                ),
//              )
              ],
          ),
        ),
      ),
    );
  }



  double calculateBMi() {
    print("calculate");
    bmi = weight / ((widget.user.height * widget.user.height) / 10000);
    add();
    return bmi;
  }

  List<BMI> _bmi = [];

  Future getDates() async {
    if (_bmi.length > 0) return null;
    print("get data");
    QuerySnapshot querySnapshot = await firestore
        .collection("info")
        .document(widget.user.email)
        .collection("IBM")
        .getDocuments();
    querySnapshot.documents.forEach((f) {
      DateTime.parse(f.documentID);
      print(DateTime.parse(f.documentID));
      _bmi.add(BMI(DateTime.parse(f.documentID), f.data['BMI']));
      print(f.documentID.toString());
      print(f.data);
    });

    _bmi.sort((a, b) => a.date.compareTo(b.date));
  }

  add() async {
    print(widget.user.email);
    print("date: " + date.substring(0, 10));
    await firestore
        .collection("info")
        .document(widget.user.email)
        .collection("IBM")
        .document(date)
        .setData({"weight": weight, "BMI": bmi});
    if (DateTime.parse(date).compareTo(DateTime.now()) >= 1) {
      print("change weight");
      await firestore
          .collection("info")
          .document(widget.user.email)
          .updateData({"weight": weight});
    }
  }
}
