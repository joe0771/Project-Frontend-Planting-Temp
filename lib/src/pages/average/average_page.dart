import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:temperature/src/models/response_request_report_model.dart';
import 'package:temperature/src/services/network_service.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:temperature/src/pages/realtime/realtime_page.dart';
import 'package:temperature/src/pages/average/widget/average_temp_widget.dart';

class AveragePage extends StatefulWidget {
  const AveragePage({Key? key}) : super(key: key);

  @override
  State<AveragePage> createState() => _AveragePageState();
}

class _AveragePageState extends State<AveragePage> with WidgetsBindingObserver {
  AppLifecycleState? _lastLifecycleState;

  final DateRangePickerController _controller = DateRangePickerController();
  DateTime? selectedDate;

  List<dynamic> averageTempDryingA = [];
  List<dynamic> averageTempCuringA = [];

  List<dynamic> averageTempDryingB = [];
  List<dynamic> averageTempCuringB = [];

  List<dynamic> averageTempDryingD = [];
  List<dynamic> averageTempCuringD = [];

  StreamSubscription? _subscriptionAverageTemp;

  bool loopAverageTemp = true;

  late String initDate = ymd(DateTime.now());

  String selectedValue = "7-18.50";

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("Day-Shift"), value: "7-18.50"),
      const DropdownMenuItem(child: Text("Night-Shift"), value: "19-6.50"),
    ];
    return menuItems;
  }

  Stream<dynamic> averageTempStream(String date, String shift) async* {
    averageTempDryingA = [];
    averageTempCuringA = [];

    averageTempDryingB = [];
    averageTempCuringB = [];

    averageTempDryingD = [];
    averageTempCuringD = [];

    final result = await NetworkService.requestAverage(date, shift);
    yield result;
    log("**************** Initial Average Temp ****************");
    while (loopAverageTemp) {
      _subscriptionAverageTemp = await Future.delayed(const Duration(seconds: 60));

      averageTempDryingA = [];
      averageTempCuringA = [];

      averageTempDryingB = [];
      averageTempCuringB = [];

      averageTempDryingD = [];
      averageTempCuringD = [];

      final result = await NetworkService.requestAverage(date, shift);
      yield result;
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
    initDate = ymd(DateTime.now());
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    loopAverageTemp = false;
    _subscriptionAverageTemp?.cancel();
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppLifecycleState.paused == state) {
      loopAverageTemp = false;

      _subscriptionAverageTemp?.pause();
    }
    if (AppLifecycleState.resumed == state) {
      loopAverageTemp = true;

      _subscriptionAverageTemp?.resume();
    }
    setState(() {
      _lastLifecycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    String date = initDate;
    String shift = selectedValue;

    return Scaffold(
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
              child: Column(
                children: [
                  Container(
                    height: 60,
                    color: Colors.grey.shade800,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 450,
                          child: Center(
                            child: Text(
                              "Temperature  (Average)",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.amber.shade700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 250,
                          child: Center(
                            child: Text(
                              "Drying °C",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.amber.shade700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 250,
                          child: Center(
                            child: Text(
                              "Curing °C",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.amber.shade700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 250,
                          child: Center(
                            child: Text(
                              "Time",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.amber.shade700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStreamAverageTemp(date, shift),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildStreamAverageTemp(String date, String shift) {
    return StreamBuilder(
      stream: averageTempStream(date, shift),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data == null || data.isEmpty) {
            return const Center(
              child: Center(
                child: Text(
                  'No data !',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            );
          }

          List<dynamic> lineA = data["lineA"];
          List<dynamic> lineB = data["lineB"];
          List<dynamic> lineD = data["lineD"];

          String time = "";

          final paramsA = lineA.map((B) => ResponseRequestReportModel.fromJson(B)).toList();
          final paramsB = lineB.map((B) => ResponseRequestReportModel.fromJson(B)).toList();
          final paramsD = lineD.map((B) => ResponseRequestReportModel.fromJson(B)).toList();

          ///////////// Line A /////////////
          double dryingA = 0;
          double curingA = 0;
          for (var result in paramsA) {
            var tempDryingA = result.drying;
            var tempCuringA = result.curing;
            averageTempDryingA.add(tempDryingA);
            averageTempCuringA.add(tempCuringA);
          }
          if (averageTempDryingA.isNotEmpty) {
            dryingA = averageTempDryingA.reduce((a, b) => a + b) / averageTempDryingA.length;
          }
          if (averageTempCuringA.isNotEmpty) {
            curingA = averageTempCuringA.reduce((a, b) => a + b) / averageTempCuringA.length;
          }
          //////////////////////////////////

          ///////////// Line B /////////////
          double dryingB = 0;
          double curingB = 0;
          for (var result in paramsB) {
            var tempDryingB = result.drying;
            var tempCuringB = result.curing;
            averageTempDryingB.add(tempDryingB);
            averageTempCuringB.add(tempCuringB);
          }
          if (averageTempDryingB.isNotEmpty) {
            dryingB = averageTempDryingB.reduce((a, b) => a + b) / averageTempDryingB.length;
          }
          if (averageTempCuringB.isNotEmpty) {
            curingB = averageTempCuringB.reduce((a, b) => a + b) / averageTempCuringB.length;
          }
          //////////////////////////////////

          ///////////// Line C /////////////
          double dryingD = 0;
          double curingD = 0;
          for (var result in paramsD) {
            var tempDryingD = result.drying;
            var tempCuringD = result.curing;
            averageTempDryingD.add(tempDryingD);
            averageTempCuringD.add(tempCuringD);
          }

          if (averageTempDryingD.isNotEmpty) {
            dryingD = averageTempDryingD.reduce((a, b) => a + b) / averageTempDryingD.length;
          }
          if (averageTempCuringD.isNotEmpty) {
            curingD = averageTempCuringD.reduce((a, b) => a + b) / averageTempCuringD.length;
          }
          //////////////////////////////////

          if (shift == '7-18.50') {
            time = '07:00 - 18:50';
          } else {
            time = '19:00 - 06:50';
          }

          log('List Temp Drying => ${dryingD.toInt()}');
          log('List Temp Curing  => ${curingD.toInt()}');

          return Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 40),
            child: Column(
              children: [
                AverageTempWidget(line: "Line A-Recorded", drying: dryingA, curing: curingA, shift: time),
                AverageTempWidget(line: "Line B-Recorded", drying: dryingB, curing: curingB, shift: time),
                AverageTempWidget(line: "Line D-Recorded", drying: dryingD, curing: curingD, shift: time),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              ' Error data !',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
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
          "Average Temperature Data",
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
