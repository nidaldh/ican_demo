import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ican/ui_layer/admin/bottom_sheet.dart';
import 'package:demo_ican/ui_layer/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _firebase = Firestore.instance.collection("info");

  int index;
  String x;
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("search"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: x,
                      decoration: InputDecoration(
                        icon: Icon(Icons.search),
                        labelText: "search",
                        border: new OutlineInputBorder(
                            borderSide:
                                new BorderSide(color: Colors.amberAccent)),
                      ),
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return AppLocalizations.of(context).tr("empty_input");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        print(value);
                        x = value.trim();
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Row(
                          children: <Widget>[
                            Text("search by name"),
                            Icon(Icons.person)
                          ],
                        ),
                        color: Colors.amberAccent,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            index=0;
                            setState(() {});
                          }
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RaisedButton(
                        child: Row(
                          children: <Widget>[
                            Text("search by location"),
                            Icon(Icons.location_on)
                          ],
                        ),
                        color: Colors.amberAccent,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            index=1;
                            setState(() {});
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  FutureBuilder(
                    future: search(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            child: Card(
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                        );
                      if (snapshot.connectionState ==
                          ConnectionState.done) if (snapshot.data.length > 0)
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    settingModalBottomSheet(
                                        context, snapshot.data[index]);
                                  },
                                  child: Card(
                                      color: Colors.amber,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Center(
                                            child: Text(
                                          snapshot.data[index].data['name'],
                                          style: GoogleFonts.cairo(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 1.2 *
                                                  SizeConfig.textMultiplier),
                                        )),
                                      )),
                                ),
                              );
                            });
                      else
                        return Card(
                            color: Colors.amber,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                  child: Text(
                                "no data",
                                style: GoogleFonts.cairo(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 1.2 * SizeConfig.textMultiplier),
                              )),
                            ));
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future search(){
    if(index ==0)
      return getByName();
    return getByLocation();
  }

  Future getByLocation() async {
    QuerySnapshot qn =
        await _firebase.where('location', isEqualTo: x).getDocuments();
    return qn.documents;
  }

  Future getByName() async {
    QuerySnapshot qn = await _firebase
        .where(
          'name',
          isEqualTo: x,
        )
        .getDocuments();
    return qn.documents;
  }
}
