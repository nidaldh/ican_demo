import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:demo_ican/data_layer/model/user.dart';
import 'package:demo_ican/ui_layer/chart/chart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ShowIBM extends StatefulWidget {
  User user;

  ShowIBM({this.user});

  @override
  _ShowIBMState createState() => _ShowIBMState();
}

class _ShowIBMState extends State<ShowIBM> {
  final f = new NumberFormat("###.00");
  final _formKey = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MM-dd");
  String date;
  double weight;
  double height;
  double bmi;
  Firestore firestore = Firestore.instance;
  List<BMI> _bmi = [];
  var reference;
  Stream<QuerySnapshot> query;

  @override
  void initState() {
    reference = Firestore.instance
        .collection("info")
        .document(widget.user.email)
        .collection("IBM");
    query = reference.snapshots();
//    startQuery();
    getDates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    print("Len" + _bmi.length.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).tr("add_BMI"),
            style: GoogleFonts.cairo(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
        elevation: 0,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Card(
                color: Colors.white,
                child: DateTimeField(
                  validator: (value) {
                    if(value.compareTo(DateTime.now())>0)
                      return AppLocalizations.of(context).tr("date_error_future");
                    if (value == null) {
                      return AppLocalizations.of(context).tr("date_error");
                    }
                    return null;
                  },
                  onSaved: (val) {
                    print(val.runtimeType);
                    date = val.toString().substring(0, 10);
//                    print(date);
                  },
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).tr("date"),
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
                    if (value.isEmpty || double.parse(value) < 30) {
                      return AppLocalizations.of(context).tr("weight_error");
                    }
                    return null;
                  },
                  onSaved: (val) {
                    weight = double.parse(val.trim());
//                    print(weight);
                  },
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).tr("weight"),
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
                    child: Text(AppLocalizations.of(context).tr("save")),
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
                  SizedBox(
                    width: 20,
                  ),
                  Tooltip(
                    message: (_bmi.length >= 2)
                        ? AppLocalizations.of(context).tr("show_ibm")
                        : AppLocalizations.of(context).tr("bmi_limit"),
                    child: OutlineButton(
                      child: Text(AppLocalizations.of(context).tr("show_ibm")),
//                    backgroundColor: Colors.deepPurpleAccent,
                      onPressed: (_bmi.length >= 2)
                          ? () {
//                      setState(() {
//                        getDates();
//                      });
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return Chart2(_bmi, title: "nidal");
//                        return PopImage();
                                }),
                              );
                            }
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  color: getColor(bmi ?? 10),
                  borderOnForeground: true,
                  elevation: 10,
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Center(
                    child: Text(
                        bmi.toString() == "null" ? "BMI" : f.format(bmi),
                        style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
//              ChartTemp(_bmi),
//              ChartTemp(),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: new FirestoreAnimatedList(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    query: query = reference.snapshots(),
                    itemBuilder: (
                      BuildContext context,
                      DocumentSnapshot snapshot,
                      Animation<double> animation,
                      int index,
                    ) =>
                        FadeTransition(
                      opacity: animation,
                      child: Card(
                          color: getColor(snapshot.data['BMI']),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  f.format(snapshot.data['BMI']),
                                  style: GoogleFonts.cairo(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  snapshot.documentID.toString(),
                                  style: GoogleFonts.cairo(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                              ],
                            )),
                          )),
//                        Text(
//                           snapshot.data['note'],
//                        ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateBMi() {
//    print("calculate");
    bmi = weight / ((widget.user.height * widget.user.height) / 10000);
    add();
    return bmi;
  }

  Future getDates() async {
    if (_bmi.length > 0) return null;
//    print("get data");
    QuerySnapshot querySnapshot = await firestore
        .collection("info")
        .document(widget.user.email)
        .collection("IBM")
        .getDocuments();
    querySnapshot.documents.forEach((f) {
      DateTime.parse(f.documentID);
//      print(DateTime.parse(f.documentID));
      _bmi.add(BMI(DateTime.parse(f.documentID), f.data['BMI']));
//      print(f.documentID.toString());
//      print(f.data);
    });
    setState(() {});
//    print("len2::" + _bmi.length.toString());

    _bmi.sort((a, b) => a.date.compareTo(b.date));
  }

  add() async {
//    print(widget.user.email);
//    print("date: " + date.substring(0, 10));
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

  Color getColor(double weight) {
//    print(weight.toString() + "color");
    if (weight < 18.5)
      return Colors.blue[300];
    else if (weight < 25)
      return Colors.green[600];
    else if (weight < 30)
      return Colors.orangeAccent[200];
    else if (weight < 35)
      return Colors.orangeAccent[700];
    else if (35 < weight) return Colors.red[400];
  }
}
