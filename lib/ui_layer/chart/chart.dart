
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:flutter/material.dart';

import 'package:demo_ican/ui_layer/chart/temp_chart.dart';






class Chart2 extends StatefulWidget {
  List<BMI> _bmi = [];
  Chart2(this._bmi,{Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Chart2> {
  int chartIndex = 0;

  @override
  Widget build(BuildContext context) {


    LineChart chart;
    Map<DateTime, double> createFromBMI(List<BMI> _bmi) {
      _bmi.sort((a, b) => a.date.compareTo(b.date));
      Map<DateTime, double> data = {};
      for(int i=0;i<_bmi.length;i++)
        data[_bmi[i].date] = _bmi[i].bmi;
      return data;
    }
    List<Color> getColors(List<BMI> _bmi){
      List<Color> color=[];
      for(int i=0;i<_bmi.length;i++)
        color.add(Colors.amber) ;
      return color;
    }

      chart = LineChart.fromDateTimeMaps(
          [createFromBMI(widget._bmi)], [Colors.green], ['']);


    return Scaffold(
      appBar: AppBar(
        title: Text("BMI"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedLineChart(
                      chart,
                      key: UniqueKey(),


                    ), //Unique key to force animations
                  )),
            ]),
      ),
    );
  }
}
class BMI {
  BMI(this.date, this.bmi);
  final DateTime date;
  final double bmi;
}