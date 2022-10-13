import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
      body: SfCartesianChart(
        title: ChartTitle(
            text: 'Monthly expenses of a family \n (in U.S. Dollars)'),
        legend: Legend(isVisible: true),
        tooltipBehavior: _tooltipBehavior,
        series: <ChartSeries>[
          StackedBarSeries<StrengthData, String>(
              dataSource: _chartData,
              xValueMapper: (StrengthData exp, _) => exp.bodyPart,
              yValueMapper: (StrengthData exp, _) => exp.val,
              name: 'Arms',
              markerSettings: MarkerSettings(
                isVisible: true,
              )),
        ],
        primaryXAxis: CategoryAxis(),
      ),
    ));
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
