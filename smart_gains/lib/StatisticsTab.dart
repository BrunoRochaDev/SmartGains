import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'FitnessGoalsPage.dart';

class StatisticsTab extends StatefulWidget {
  StatisticsTab({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _StatisticsTab createState() => _StatisticsTab();
}

class _StatisticsTab extends State<StatisticsTab> {
  late List<StrengthData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, top: 64),
            child: Row(children: [
              Expanded(
                  child: Title(
                color: Colors.black,
                child: Text(
                  "Persons Name",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )),
              Container(
                height: 130.0,
                width: 130.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/womanImage.jpg'),
                    fit: BoxFit.fitWidth,
                  ),
                  shape: BoxShape.rectangle,
                ),
              )
            ]),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 64),
              child: Row(
                children: [
                  Container(
                    height: 260.0,
                    width: 130.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 200, 219, 212),
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Column(children: [
                        Icon(
                          Icons.local_fire_department,
                          size: 80,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text('2079'),
                          height: 60,
                        ),
                        Container(
                          child: Text("TDEE, Calaries"),
                          height: 60,
                        ),
                      ]),
                    ),
                  ),
                  Expanded(child: Container()),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          height: 120.0,
                          width: 130.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.amber,
                            shape: BoxShape.rectangle,
                          ),
                          child: Center(
                              child: Text(
                            "Current Weight: 200kg",
                            textAlign: TextAlign.center,
                          )),
                        ),
                      ),
                      Container(
                        height: 120.0,
                        width: 130.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.amber,
                          shape: BoxShape.rectangle,
                        ),
                        child: Center(
                            child: Text(
                          "Height: 1.80 m",
                          textAlign: TextAlign.center,
                        )),
                      )
                    ],
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 32),
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Statistics",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 32),
              child: Container(
                  height: 200,
                  child: SfCartesianChart(
                    title: ChartTitle(text: 'Data i dont know what to call it'),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: _tooltipBehavior,
                    series: <ChartSeries>[
                      StackedBarSeries<StrengthData, String>(
                          dataSource: _chartData,
                          xValueMapper: (StrengthData exp, _) => exp.bodyPart,
                          yValueMapper: (StrengthData exp, _) => exp.val,
                          name: "Values",
                          markerSettings: const MarkerSettings(
                            isVisible: true,
                          )),
                    ],
                    primaryXAxis: CategoryAxis(),
                  ))),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 32),
            child: Row(
              children: [
                Container(
                  height: 120.0,
                  width: 130.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber,
                    shape: BoxShape.rectangle,
                  ),
                  child: Center(
                      child: Text(
                    "Hours Trained this week 3/5 60%",
                    textAlign: TextAlign.center,
                  )),
                ),
                Expanded(child: Container()),
                Container(
                  height: 120.0,
                  width: 130.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber,
                    shape: BoxShape.rectangle,
                  ),
                  child: Center(
                      child: Text(
                    "Hours Trained this month 10/59 16%",
                    textAlign: TextAlign.center,
                  )),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 32),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    "Daily Tasks",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Expanded(child: Container()),
                  TextButton(
                    onPressed: () {},
                    child: Icon(Icons.edit),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black)),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 32),
            child: Container(
              alignment: Alignment.center,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: MyStatefulWidget(title: "20 min Exercise today"),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: MyStatefulWidget(title: "Drink 2 liters of water"),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: MyStatefulWidget(title: "Streching for 5 minutes"),
                ),
              ]),
            ),
          ),
        ],
      ),
    )));
  }

  List<StrengthData> getChartData() {
    final List<StrengthData> chartData = [
      StrengthData('Chest', 55),
      StrengthData('Legs', 33),
      StrengthData('Arms', -43),
    ];
    return chartData;
  }
}

class StrengthData {
  StrengthData(this.bodyPart, this.val);
  final String bodyPart;
  final num val;
}


/*Container(
        height: 200,
        child: SfCartesianChart(
          title: ChartTitle(text: 'Data i dont know what to call it'),
          legend: Legend(isVisible: true),
          tooltipBehavior: _tooltipBehavior,
          series: <ChartSeries>[
            StackedBarSeries<StrengthData, String>(
                dataSource: _chartData,
                xValueMapper: (StrengthData exp, _) => exp.bodyPart,
                yValueMapper: (StrengthData exp, _) => exp.val,
                name: "Values",
                markerSettings: const MarkerSettings(
                  isVisible: true,
                )),
          ],
          primaryXAxis: CategoryAxis(),
        ),
      )*/