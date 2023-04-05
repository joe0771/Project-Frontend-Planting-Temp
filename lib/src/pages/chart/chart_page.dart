import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:temperature/src/models/response_request_report_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:temperature/src/services/network_service.dart';
import 'package:temperature/src/pages/realtime/realtime_page.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> with WidgetsBindingObserver {
  AppLifecycleState? _lastLifecycleState;

  final DateRangePickerController _controller = DateRangePickerController();
  DateTime? selectedDate;

  late ZoomPanBehavior _zoomPanBehavior;

  late TooltipBehavior _tooltipBehaviorA;
  late TooltipBehavior _tooltipBehaviorB;
  late TooltipBehavior _tooltipBehaviorD;

  List<ChartData> chartDryingA = [];
  List<ChartData> chartCuringA = [];

  List<ChartData> chartDryingB = [];
  List<ChartData> chartCuringB = [];

  List<ChartData> chartDryingD = [];
  List<ChartData> chartCuringD = [];

  ChartSeriesController? seriesController;

  StreamSubscription? _subscriptionChartTemp;

  bool loopChartTemp = true;

  late String initDate;

  String selectedValue = "7-18.50";

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("Day-Shift"), value: "7-18.50"),
      const DropdownMenuItem(child: Text("Night-Shift"), value: "19-6.50"),
    ];
    return menuItems;
  }

  Stream<dynamic> chartTempStream() async* {
    chartDryingA = [];
    chartCuringA = [];

    chartDryingB = [];
    chartCuringB = [];

    chartDryingD = [];
    chartCuringD = [];

    final result = await NetworkService.requestReport(initDate);
    yield result;
    log("**************** Initial Report Chart Temp ****************");
    while (loopChartTemp) {
      _subscriptionChartTemp = await Future.delayed(const Duration(seconds: 20));

      chartDryingA = [];
      chartCuringA = [];

      chartDryingB = [];
      chartCuringB = [];

      chartDryingD = [];
      chartCuringD = [];

      final result = await NetworkService.requestReport(initDate);
      yield result;
    }
  }

  Future<void> getDateNow() async {
    while (loopChartTemp) {
      await Future.delayed(const Duration(minutes: 1));
      initDate = ymd(DateTime.now());
      selectedValue = "7-18.50";
      if (mounted) {
        setState(() {
          log("<<<<<<<<<<<<<<<< Reset Date >>>>>>>>>>>>>>>>");
        });
      }
    }
  }

  String ymd(value) {
    String day = value.toString();
    int idx = day.indexOf(" ");
    List parts = [day.substring(0, idx).trim(), day.substring(idx + 1).trim()];
    return parts[0];
  }

  void refreshAll() {
    initDate = ymd(DateTime.now());
    selectedValue = "7-18.50";
    setState(() {
      log("<<<<<<<<<<<<<<<< Reset Date >>>>>>>>>>>>>>>>");
    });
  }

  @override
  void initState() {
    getDateNow();
    initDate = ymd(DateTime.now());
    _zoomPanBehavior = ZoomPanBehavior(
      enableMouseWheelZooming: true,
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.xy,
    );
    _tooltipBehaviorA = TooltipBehavior(
      enable: true,
      format: 'time: point.x,    temp: point.y °C',
      shouldAlwaysShow: true,
      textStyle: const TextStyle(
        fontSize: 22,
      ),
      // duration: 5000,
    );

    _tooltipBehaviorB = TooltipBehavior(
      enable: true,
      format: 'time: point.x,    temp: point.y °C',
      shouldAlwaysShow: true,
      textStyle: const TextStyle(
        fontSize: 22,
      ),
      // duration: 5000,
    );

    _tooltipBehaviorD = TooltipBehavior(
      enable: true,
      format: 'time: point.x,    temp: point.y °C',
      shouldAlwaysShow: true,
      textStyle: const TextStyle(
        fontSize: 22,
      ),
      // duration: 5000,
    );

    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _subscriptionChartTemp?.cancel();
    loopChartTemp = false;
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppLifecycleState.paused == state) {
      loopChartTemp = false;

      _subscriptionChartTemp?.pause();
    }
    if (AppLifecycleState.resumed == state) {
      loopChartTemp = true;

      _subscriptionChartTemp?.resume();
    }
    setState(() {
      _lastLifecycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    String date = initDate;
    String shift = selectedValue;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: _buildAppbar(date),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff2c2947), Color(0xff414161), Color(0xff707094)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _buildStreamChartTemp(date, shift),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildAppbar(String date) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: AppBar(
        leadingWidth: 100,
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 60,
          ),
          onPressed: () {
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const RealtimePage(),
              ),
            );
          },
        ),
        toolbarHeight: 100,
        title: Text(
          "Temperature Chart Data",
          style: TextStyle(
            fontSize: 35,
            color: Colors.amber.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Center(
            child: Row(
              children: [
                const Text(
                  "Date",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 20),
                _buildShowDate(date),
                const SizedBox(width: 40),
                const Text(
                  "Shift",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 20),
                _buildShowShift(),
                const SizedBox(width: 205),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 60,
                  ),
                  onPressed: () => refreshAll(),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
        ],
        backgroundColor: Colors.grey.shade800,
      ),
    );
  }

  _buildStreamChartTemp(String date, String shift) {
    return StreamBuilder(
      stream: chartTempStream(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;

          if (data == null || data.isEmpty) {
            return const Center(
              child: SizedBox(
                height: 280,
                width: 1050,
                child: Center(
                  child: Text(
                    'No data !',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            );
          }

          List<dynamic> lineA = data["lineA"];
          List<dynamic> lineB = data["lineB"];
          List<dynamic> lineD = data["lineD"];

          final paramsA = lineA.map((B) => ResponseRequestReportModel.fromJson(B)).toList();
          final paramsB = lineB.map((B) => ResponseRequestReportModel.fromJson(B)).toList();
          final paramsD = lineD.map((B) => ResponseRequestReportModel.fromJson(B)).toList();

          final dateList = date.split("-");
          int year = int.parse(dateList[0]);
          int month = int.parse(dateList[1]);
          int dayStart = int.parse(dateList[2]);
          int dayEnd = int.parse(dateList[2]);

          final shiftList = shift.split("-");
          int startHour = int.parse(shiftList[0]);

          final endHourList = shiftList[1].split(".");
          int endHour = int.parse(endHourList[0]);
          int endMinute = int.parse(endHourList[1]);

          if (shift == "19-6.50") {
            dayEnd += 1;
          }

          ///////////// Line A /////////////
          for (var result in paramsA) {
            var tempDryingA = result.drying;
            var tempCuringA = result.curing;

            chartDryingA.add(
              ChartData(
                DateTime.fromMillisecondsSinceEpoch(result.timeStamp),
                tempDryingA,
              ),
            );
            chartCuringA.add(
              ChartData(
                DateTime.fromMillisecondsSinceEpoch(result.timeStamp),
                tempCuringA,
              ),
            );
          }

          ///////////// Line B /////////////
          for (var result in paramsB) {
            var tempDryingB = result.drying;
            var tempCuringB = result.curing;

            chartDryingB.add(
              ChartData(
                DateTime.fromMillisecondsSinceEpoch(result.timeStamp),
                tempDryingB,
              ),
            );
            chartCuringB.add(
              ChartData(
                DateTime.fromMillisecondsSinceEpoch(result.timeStamp),
                tempCuringB,
              ),
            );
          }

          ///////////// Line C /////////////
          for (var result in paramsD) {
            var tempDryingD = result.drying;
            var tempCuringD = result.curing;

            chartDryingD.add(
              ChartData(
                DateTime.fromMillisecondsSinceEpoch(result.timeStamp),
                tempDryingD,
              ),
            );
            chartCuringD.add(
              ChartData(
                DateTime.fromMillisecondsSinceEpoch(result.timeStamp),
                tempCuringD,
              ),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),
              _buildChartTemp(
                year,
                month,
                dayStart,
                startHour,
                dayEnd,
                endHour,
                endMinute,
                "Temp-Line-A",
                chartDryingA,
                chartCuringA,
                _tooltipBehaviorA,
              ),
              // const SizedBox(height: 3),
              _buildChartTemp(
                year,
                month,
                dayStart,
                startHour,
                dayEnd,
                endHour,
                endMinute,
                "Temp-Line-B",
                chartDryingB,
                chartCuringB,
                _tooltipBehaviorB,
              ),
              // const SizedBox(height: 3),
              _buildChartTemp(
                year,
                month,
                dayStart,
                startHour,
                dayEnd,
                endHour,
                endMinute,
                "Temp-Line-D",
                chartDryingD,
                chartCuringD,
                _tooltipBehaviorD,
              ),
            ],
          );
        }
        if (snapshot.hasError) {
          return const SizedBox(
            height: 280,
            width: 1050,
            child: Center(
              child: Text(
                'Error data !',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          );
        }
        return const SizedBox(
          height: 280,
          width: 1050,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  _buildChartTemp(
    int year,
    int month,
    int dayStart,
    int startHour,
    int dayEnd,
    int endHour,
    int endMinute,
    String title,
    List<ChartData> chartPreheat,
    List<ChartData> chartCuring,
    TooltipBehavior _tooltipBehavior,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          const SizedBox(width: 40),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 40),
          SizedBox(
            height: 355,
            width: 2250,
            child: Center(
              child: SfCartesianChart(
                plotAreaBorderWidth: 3,
                zoomPanBehavior: _zoomPanBehavior,
                tooltipBehavior: _tooltipBehavior,
                enableAxisAnimation: true,
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  crossesAt: 0,
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                  interval: 50,
                  minimum: 0,
                  maximum: 200,
                  visibleMinimum: 0,
                  visibleMaximum: 200,
                  isInversed: false,
                  decimalPlaces: 0,
                ),
                legend: Legend(
                  isVisible: true,
                  iconWidth: 0,
                  iconHeight: 0,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  toggleSeriesVisibility: true,
                ),
                primaryXAxis: DateTimeAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  minimum: DateTime(year, month, dayStart, startHour),
                  maximum: DateTime(year, month, dayEnd, endHour, endMinute),
                  visibleMinimum: DateTime(year, month, dayStart, startHour),
                  visibleMaximum: DateTime(year, month, dayEnd, endHour, endMinute),
                  intervalType: DateTimeIntervalType.hours,
                  dateFormat: DateFormat.Hm(),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                series: <ChartSeries<ChartData, DateTime>>[
                  SplineSeries<ChartData, DateTime>(
                    width: 3,
                    splineType: SplineType.cardinal,
                    name: 'Drying',
                    enableTooltip: true,
                    color: Colors.blue,
                    onRendererCreated: (ChartSeriesController controller) {
                      seriesController = controller;
                    },
                    animationDuration: 0,
                    dataSource: chartPreheat,
                    xValueMapper: (ChartData sales, _) => sales.x,
                    yValueMapper: (ChartData sales, _) => sales.y,
                  ),
                  SplineSeries<ChartData, DateTime>(
                    width: 3,
                    splineType: SplineType.cardinal,
                    name: 'Curing',
                    enableTooltip: true,
                    color: Colors.deepOrange,
                    onRendererCreated: (ChartSeriesController controller) {
                      seriesController = controller;
                    },
                    animationDuration: 0,
                    dataSource: chartCuring,
                    xValueMapper: (ChartData sales, _) => sales.x,
                    yValueMapper: (ChartData sales, _) => sales.y,
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: const [
              Icon(
                Icons.thermostat,
                color: Colors.blue,
                size: 45,
              ),
              SizedBox(height: 10),
              Icon(
                Icons.thermostat,
                color: Colors.deepOrange,
                size: 45,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildShowDate(String date) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color: Colors.white,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            2,
          ),
        ),
      ),
      height: 60,
      width: 300,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      // backgroundColor: Colors.grey.shade800,
                      content: SizedBox(
                        height: 1000,
                        width: 1400,
                        child: _buildSelectDate(),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.calendar_month_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildShowShift() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color: Colors.white,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            2,
          ),
        ),
      ),
      width: 250,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            value: selectedValue,
            dropdownColor: Colors.grey.shade600,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
            icon: const Icon(
              Icons.arrow_drop_down_outlined,
              color: Colors.white,
              size: 50,
            ),
            onChanged: (String? newValue) {
              selectedValue = newValue!;
              setState(
                () {},
              );
            },
            items: dropdownItems,
          ),
        ),
      ),
    );
  }

  _buildSelectDate() {
    return Column(
      children: [
        SizedBox(
          height: 800,
          child: SfDateRangePicker(
            // backgroundColor: Colors.grey.shade800,
            controller: _controller,
            headerHeight: 100,
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.single,
            minDate: DateTime(2023),
            maxDate: DateTime.now(),
            toggleDaySelection: true,
            showNavigationArrow: false,
            selectionTextStyle: const TextStyle(color: Colors.white, fontSize: 30),
            rangeTextStyle: const TextStyle(color: Colors.white, fontSize: 30),
            headerStyle: DateRangePickerHeaderStyle(
              backgroundColor: Colors.grey.shade800,
              textStyle: const TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
            ),
            yearCellStyle: DateRangePickerYearCellStyle(
              textStyle: TextStyle(color: Colors.grey.shade800, fontSize: 30),
              todayTextStyle: TextStyle(color: Colors.grey.shade800, fontSize: 30),
              disabledDatesTextStyle: TextStyle(color: Colors.grey.shade400, fontSize: 30),
            ),
            monthViewSettings: const DateRangePickerMonthViewSettings(
              viewHeaderHeight: 100,
              dayFormat: 'EEE',
              viewHeaderStyle: DateRangePickerViewHeaderStyle(
                textStyle: TextStyle(
                  color: Colors.blue,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            monthCellStyle: DateRangePickerMonthCellStyle(
              textStyle: TextStyle(color: Colors.grey.shade800, fontSize: 30),
              todayTextStyle: TextStyle(color: Colors.grey.shade800, fontSize: 30),
              disabledDatesTextStyle: TextStyle(color: Colors.grey.shade400, fontSize: 30),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 200,
              height: 60,
              child: TextButton(
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.blue,
                    ),
                  ),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  }),
            ),
            const SizedBox(width: 50),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                child: const Text(
                  "Confirm",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                onPressed: () async {
                  Get.back();
                  selectedDate = _controller.selectedDate;
                  if (selectedDate == null) {
                    log("Date status == null ?");
                  } else {
                    String selectDate = selectedDate.toString();
                    int idx = selectDate.indexOf(" ");
                    List parts = [selectDate.substring(0, idx).trim(), selectDate.substring(idx + 1).trim()];
                    initDate = parts[0];
                    setState(() {
                      //todo
                    });
                  }
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final dynamic y;
}
