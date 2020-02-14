////import 'package:bezier_chart/bezier_chart.dart';
//import 'package:demo_ican/ui_layer/chart/temp_chart.dart';
//import 'package:fl_animated_linechart/chart/area_line_chart.dart';
//import 'package:fl_animated_linechart/chart/line_chart.dart';
//import 'package:fl_animated_linechart/common/pair.dart';
//import 'package:fl_animated_linechart/fl_animated_linechart.dart';
//import 'package:flutter/material.dart';
//
//import 'fake_chart_series..dart';
//
////// Copyright 2018 the Charts project authors. Please see the AUTHORS file
////// for details.
//////
////// Licensed under the Apache License, Version 2.0 (the "License");
////// you may not use this file except in compliance with the License.
////// You may obtain a copy of the License at
//////
////// http://www.apache.org/licenses/LICENSE-2.0
//////
////// Unless required by applicable law or agreed to in writing, software
////// distributed under the License is distributed on an "AS IS" BASIS,
////// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
////// See the License for the specific language governing permissions and
////// limitations under the License.
////
/////// Example of a time series chart with a confidence interval.
///////
/////// Confidence interval is defined by specifying the upper and lower measure
/////// bounds in the series.
////// EXCLUDE_FROM_GALLERY_DOCS_START
////import 'dart:math';
////// EXCLUDE_FROM_GALLERY_DOCS_END
////import 'package:charts_flutter/flutter.dart' as charts;
////import 'package:flutter/material.dart';
////
////class TimeSeriesConfidenceInterval extends StatelessWidget {
////  final List<charts.Series> seriesList;
////  final bool animate;
////
////  TimeSeriesConfidenceInterval(this.seriesList, {this.animate});
////
////  /// Creates a [TimeSeriesChart] with sample data and no transition.
////  factory TimeSeriesConfidenceInterval.withSampleData() {
////    return new TimeSeriesConfidenceInterval(
////      _createSampleData(),
////      // Disable animations for image tests.
////      animate: false,
////    );
////  }
////
////  // EXCLUDE_FROM_GALLERY_DOCS_START
////  // This section is excluded from being copied to the gallery.
////  // It is used for creating random series data to demonstrate animation in
////  // the example app only.
////  factory TimeSeriesConfidenceInterval.withRandomData() {
////    return new TimeSeriesConfidenceInterval(_createRandomData());
////  }
////
////  /// Create random data.
////  static List<charts.Series<TimeSeriesSales, DateTime>> _createRandomData() {
////    final random = new Random();
////
////    final data = [
////      new TimeSeriesSales(new DateTime(2017, 9, 19), random.nextInt(100)),
////      new TimeSeriesSales(new DateTime(2017, 9, 26), random.nextInt(100)),
////      new TimeSeriesSales(new DateTime(2017, 10, 3), random.nextInt(100)),
////      new TimeSeriesSales(new DateTime(2017, 10, 10), random.nextInt(100)),
////    ];
////
////    return [
////      new charts.Series<TimeSeriesSales, DateTime>(
////        id: 'Sales',
////        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
////        domainFn: (TimeSeriesSales sales, _) => sales.time,
////        measureFn: (TimeSeriesSales sales, _) => sales.sales,
////        // When the measureLowerBoundFn and measureUpperBoundFn is defined,
////        // the line renderer will render the area around the bounds.
////        measureLowerBoundFn: (TimeSeriesSales sales, _) => sales.sales - 5,
////        measureUpperBoundFn: (TimeSeriesSales sales, _) => sales.sales + 5,
////        data: data,
////      )
////    ];
////  }
////  // EXCLUDE_FROM_GALLERY_DOCS_END
////
////  @override
////  Widget build(BuildContext context) {
////    return new charts.TimeSeriesChart(
////      seriesList,
////      animate: animate,
////      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
////      // should create the same type of [DateTime] as the data provided. If none
////      // specified, the default creates local date time.
////      dateTimeFactory: const charts.LocalDateTimeFactory(),
////    );
////  }
////
////  /// Create one series with sample hard coded data.
////  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
////    final data = [
////      new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
////      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
////      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
////      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
////    ];
////
////    return [
////      new charts.Series<TimeSeriesSales, DateTime>(
////        id: 'Sales',
////        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
////        domainFn: (TimeSeriesSales sales, _) => sales.time,
////        measureFn: (TimeSeriesSales sales, _) => sales.sales,
////        // When the measureLowerBoundFn and measureUpperBoundFn is defined,
////        // the line renderer will render the area around the bounds.
////        measureLowerBoundFn: (TimeSeriesSales sales, _) => sales.sales - 5,
////        measureUpperBoundFn: (TimeSeriesSales sales, _) => sales.sales + 5,
////        data: data,
////      )
////    ];
////  }
////}
////
/////// Sample time series data type.
////class TimeSeriesSales {
////  final DateTime time;
////  final int sales;
////
////  TimeSeriesSales(this.time, this.sales);
////}
//
///// Example of a combo time series chart with two series rendered as lines, and
///// a third rendered as points along the top line with a different color.
/////
///// This example demonstrates a method for drawing points along a line using a
///// different color from the main series color. The line renderer supports
///// drawing points with the "includePoints" option, but those points will share
///// the same color as the line.
//import 'package:charts_flutter/flutter.dart' as charts;
//
//class DateTimeComboLinePointChart extends StatelessWidget {
//  final List<charts.Series> seriesList;
//  final bool animate;
//
//  DateTimeComboLinePointChart(this.seriesList, {this.animate});
//
//  /// Creates a [TimeSeriesChart] with sample data and no transition.
//  factory DateTimeComboLinePointChart.withSampleData() {
//    return new DateTimeComboLinePointChart(
//      _createSampleData(),
//      // Disable animations for image tests.
//      animate: true,
//    );
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return new charts.TimeSeriesChart(
//      seriesList,
//      animate: animate,
//      defaultRenderer: new charts.LineRendererConfig(),
//      customSeriesRenderers: [
//        new charts.PointRendererConfig(
//            customRendererId: 'customPoint')
//      ],
//      dateTimeFactory: const charts.LocalDateTimeFactory(),
//    );
//  }
//
//  /// Create one series with sample hard coded data.
//  static List<charts.Series<BMI, DateTime>> _createSampleData() {
//    final desktopSalesData = [
//      new BMI(new DateTime(2017, 9, 19), 5),
//      new BMI(new DateTime(2017, 9, 26), 25),
//      new BMI(new DateTime(2017, 10, 3), 80),
//      new BMI(new DateTime(2017, 10, 10), 75),
//    ];
//    return [
//      new charts.Series<BMI, DateTime>(
//        id: 'Desktop',
//        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//        domainFn: (BMI sales, _) => sales.date,
//        measureFn: (BMI sales, _) => sales.bmi,
//        data: desktopSalesData,
//      ),
//    ];
//  }
//}
//
///// Sample time series data type.
//class TimeSeriesSales {
//  final DateTime time;
//  final int sales;
//
//  TimeSeriesSales(this.time, this.sales);
//}
//
//
//
////class NewChart extends StatefulWidget {
////
////  List<BMI> _bmi;
////  final String title;
////  NewChart(this._bmi,{Key key, this.title}) : super(key: key);
////  @override
////  _MyHomePageState createState() => _MyHomePageState();
////}
////
////class _MyHomePageState extends State<NewChart> with FakeChartSeries {
////  int chartIndex = 0;
////
////  @override
////  Widget build(BuildContext context) {
////    Map<DateTime, double> line1 = createLine2();
////    Map<DateTime, double> line2 = createLine2_2();
////
////    LineChart chart;
////
////      chart = LineChart.fromDateTimeMaps(
////          [line1], [Colors.green], ['C']);
////
////
////    return
////      Container(
////        child: Column(
////            mainAxisSize: MainAxisSize.max,
////            mainAxisAlignment: MainAxisAlignment.spaceBetween,
////            crossAxisAlignment: CrossAxisAlignment.stretch,
////            children: [
////              Expanded(
////                  child: Padding(
////                padding: const EdgeInsets.all(8.0),
////                child: AnimatedLineChart(
////                  chart,
////                  key: UniqueKey(),
////                ), //Unique key to force animations
////              )),
////              SizedBox(width: 200, height: 50, child: Text('')),
////            ]),
////    );
////  }
////  Map<DateTime, double> createLine2() {
////    Map<DateTime, double> data = {};
////    data[DateTime.now().subtract(Duration(minutes: 40))] = 13.0;
////    data[DateTime.now().subtract(Duration(minutes: 30))] = 24.0;
////    data[DateTime.now().subtract(Duration(minutes: 22))] = 39.0;
////    data[widget._bmi[1].date]=10;
//////    data[DateTime.now().subtract(Duration(minutes: 20))] = 29.0;
//////    data[DateTime.now().subtract(Duration(minutes: 15))] = 27.0;
//////    data[DateTime.now().subtract(Duration(minutes: 12))] = 9.0;
//////    data[DateTime.now().subtract(Duration(minutes: 5))] = 35.0;
////    return data;
////  }
////
////
////}
