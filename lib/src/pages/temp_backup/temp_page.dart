// import 'dart:async';
// import 'dart:developer';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:temperature/src/models/response_request_report_model.dart';
// import 'package:temperature/src/models/response_request_line_model.dart';
// import 'package:temperature/src/pages/temp/widget/average_temp_widget.dart';
// import 'package:temperature/src/services/network_service.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:temperature/src/pages/temp/widget/temp_widget.dart';
//
// class TempPage extends StatefulWidget {
//   const TempPage({Key? key}) : super(key: key);
//
//   @override
//   State<TempPage> createState() => _TempPageState();
// }
//
// class _TempPageState extends State<TempPage> with WidgetsBindingObserver {
//   AppLifecycleState? _lastLifecycleState;
//
//   late TooltipBehavior _tooltipBehaviorA;
//   late TooltipBehavior _tooltipBehaviorB;
//   late TooltipBehavior _tooltipBehaviorD;
//
//   List<dynamic> averageTempPreheatA = [];
//   List<dynamic> averageTempCuringA = [];
//
//   List<dynamic> averageTempPreheatB = [];
//   List<dynamic> averageTempCuringB = [];
//
//   List<dynamic> averageTempPreheatD = [];
//   List<dynamic> averageTempCuringD = [];
//
//   List<ChartData> chartPreheatA = [];
//   List<ChartData> chartCuringA = [];
//
//   List<ChartData> chartPreheatB = [];
//   List<ChartData> chartCuringB = [];
//
//   List<ChartData> chartPreheatD = [];
//   List<ChartData> chartCuringD = [];
//
//   ChartSeriesController? seriesController;
//
//   StreamSubscription? _subscriptionRealTimeTemp;
//   StreamSubscription? _subscriptionAverageTemp;
//   StreamSubscription? _subscriptionChartTemp;
//
//   bool loopRealTimeTemp = true;
//   bool loopAverageTemp = true;
//   bool loopChartTemp = true;
//
//   late String initDate = ymd(DateTime.now());
//
//   String selectedValue = "7-18";
//
//   int year = DateTime.now().year;
//   int month = DateTime.now().month;
//   int day = DateTime.now().day;
//
//   int startHour = 7;
//   int endHour = 18;
//
//   bool ignoring = false;
//
//   void setIgnoring(bool newValue) {
//     setState(() {
//       ignoring = newValue;
//     });
//   }
//
//   List<DropdownMenuItem<String>> get dropdownItems {
//     List<DropdownMenuItem<String>> menuItems = [
//       const DropdownMenuItem(child: Text("Day-Shift"), value: "7-18"),
//       const DropdownMenuItem(child: Text("Night-Shift"), value: "18-5"),
//     ];
//     return menuItems;
//   }
//
//   Stream<dynamic> realTimeTempStream() async* {
//     final result = await NetworkService.fetchRealtimeTemp();
//     yield result;
//     log("**************** Initial Real Time Temp ****************");
//     while (loopRealTimeTemp) {
//       _subscriptionRealTimeTemp = await Future.delayed(const Duration(milliseconds: 3000));
//
//       final result = await NetworkService.fetchRealtimeTemp();
//       yield result;
//     }
//   }
//
//   Stream<dynamic> averageTempStream(String date, String shift) async* {
//     averageTempPreheatA = [];
//     averageTempCuringA = [];
//
//     averageTempPreheatB = [];
//     averageTempCuringB = [];
//
//     averageTempPreheatD = [];
//     averageTempCuringD = [];
//
//     final result = await NetworkService.postAverageTemp(date, shift);
//     yield result;
//     log("**************** Initial Average Temp ****************");
//     while (loopAverageTemp) {
//       _subscriptionAverageTemp = await Future.delayed(const Duration(seconds: 60));
//
//       averageTempPreheatA = [];
//       averageTempCuringA = [];
//
//       averageTempPreheatB = [];
//       averageTempCuringB = [];
//
//       averageTempPreheatD = [];
//       averageTempCuringD = [];
//
//       final result = await NetworkService.postAverageTemp(date, shift);
//       yield result;
//     }
//   }
//
//   Stream<dynamic> chartTempStream() async* {
//     chartPreheatA = [];
//     chartCuringA = [];
//
//     chartPreheatB = [];
//     chartCuringB = [];
//
//     chartPreheatD = [];
//     chartCuringD = [];
//
//     final result = await NetworkService.fetchReport(initDate);
//     yield result;
//     log("**************** Initial Report Chart Temp ****************");
//     while (loopChartTemp) {
//       _subscriptionChartTemp = await Future.delayed(const Duration(seconds: 60));
//
//       chartPreheatA = [];
//       chartCuringA = [];
//
//       chartPreheatB = [];
//       chartCuringB = [];
//
//       chartPreheatD = [];
//       chartCuringD = [];
//
//       final result = await NetworkService.fetchReport(initDate);
//       yield result;
//     }
//   }
//
//   Future<void> getDateNow () async {
//     while (loopChartTemp) {
//     await Future.delayed(const Duration(minutes: 5));
//     initDate = ymd(DateTime.now());
//     selectedValue = "7-18";
//     setState(() {
//       log("<<<<<<<<<<<<<<<< Reset Date >>>>>>>>>>>>>>>>");
//     });
//     }
//   }
//
//   String ymd(value) {
//     String day = value.toString();
//     int idx = day.indexOf(" ");
//     List parts = [day.substring(0, idx).trim(), day.substring(idx + 1).trim()];
//     return parts[0];
//   }
//
//   void refreshAll () {
//     initDate = ymd(DateTime.now());
//     selectedValue = "7-18";
//     setState(() {
//       log("<<<<<<<<<<<<<<<< Reset Date >>>>>>>>>>>>>>>>");
//     });
//   }
//
//   @override
//   void initState() {
//     getDateNow ();
//     initDate = ymd(DateTime.now());
//     _tooltipBehaviorA = TooltipBehavior(
//       enable: true,
//       format: 'time: point.x,    temp: point.y °C',
//       shouldAlwaysShow: true,
//       // duration: 5000,
//     );
//
//     _tooltipBehaviorB = TooltipBehavior(
//       enable: true,
//       format: 'time: point.x,    temp: point.y °C',
//       shouldAlwaysShow: true,
//       // duration: 5000,
//     );
//
//     _tooltipBehaviorD = TooltipBehavior(
//       enable: true,
//       format: 'time: point.x,    temp: point.y °C',
//       shouldAlwaysShow: true,
//       // duration: 5000,
//     );
//
//     super.initState();
//     WidgetsBinding.instance?.addObserver(this);
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _subscriptionRealTimeTemp?.cancel();
//     _subscriptionAverageTemp?.cancel();
//     _subscriptionChartTemp?.cancel();
//     super.dispose();
//     WidgetsBinding.instance?.removeObserver(this);
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (AppLifecycleState.paused == state) {
//       loopRealTimeTemp = false;
//       loopAverageTemp = false;
//       loopChartTemp = false;
//
//       _subscriptionRealTimeTemp?.pause();
//       _subscriptionAverageTemp?.pause();
//       _subscriptionChartTemp?.pause();
//     }
//     if (AppLifecycleState.resumed == state) {
//       loopRealTimeTemp = true;
//       loopAverageTemp = true;
//       loopChartTemp = true;
//
//       _subscriptionRealTimeTemp?.resume();
//       _subscriptionAverageTemp?.resume();
//       _subscriptionChartTemp?.resume();
//     }
//     setState(() {
//       _lastLifecycleState = state;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String date = initDate;
//     String shift = selectedValue;
//
//     return Scaffold(
//       backgroundColor: Colors.black87,
//       appBar: _buildAppbar(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(
//             top: 20,
//             bottom: 20,
//             left: 20,
//             right: 20,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Flexible(
//                 flex: 11,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Realtime Temperature",
//                       style: TextStyle(
//                         fontSize: 25,
//                         color: Colors.amber.shade700,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     StreamBuilder(
//                       stream: realTimeTempStream(),
//                       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//                         if (snapshot.hasData) {
//                           List<RealTimeTempModel>? data = snapshot.data;
//                           if (data == null || data.isEmpty) {
//                             return const Center(
//                               child: Text(
//                                 'Not have data !',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 24,
//                                 ),
//                               ),
//                             );
//                           }
//                           return _buildStreamRealtimeTemp(data);
//                         }
//                         if (snapshot.hasError) {
//                           return const Center(
//                             child: Text(
//                               ' Error data !',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 24,
//                               ),
//                             ),
//                           );
//                         }
//                         return const Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Flexible(
//                 flex: 14,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 40, bottom: 20),
//                   child: Column(
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Report Data Temperature in Line",
//                             style: TextStyle(
//                               fontSize: 25,
//                               color: Colors.amber.shade700,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               const Text(
//                                 "Data",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               _buildShowDate(date),
//                               const SizedBox(width: 40),
//                               const Text(
//                                 "Shift",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               _buildShowShift(),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: 1250,
//                             height: 900,
//                             decoration: const BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [Color(0xff4e597e), Color(0xff6a7398), Color(0xff717793)],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                             ),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height: 60,
//                                   color: Colors.grey.shade800,
//                                   child: Center(
//                                     child: Text(
//                                       "View Recorded Data",
//                                       style: TextStyle(
//                                         fontSize: 25,
//                                         color: Colors.amber.shade700,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(40),
//                                   child: Container(
//                                     // height: 500,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                           color: Colors.white, // Set border color
//                                           width: 2.0), // Set border width
//                                       borderRadius: const BorderRadius.all(
//                                         Radius.circular(5.0),
//                                       ), // Set rounded corner radius
//                                       boxShadow: const [
//                                         BoxShadow(
//                                           blurRadius: 10,
//                                           color: Colors.black,
//                                           offset: Offset(1, 3),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Column(
//                                       children: [
//                                         Container(
//                                           height: 60,
//                                           color: Colors.grey.shade800,
//                                           child: Row(
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               SizedBox(
//                                                 width: 400,
//                                                 child: Center(
//                                                   child: Text(
//                                                     "Temperature  (Average)",
//                                                     style: TextStyle(
//                                                       fontSize: 20,
//                                                       color: Colors.amber.shade700,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 200,
//                                                 child: Center(
//                                                   child: Text(
//                                                     "Preheat °c",
//                                                     style: TextStyle(
//                                                       fontSize: 20,
//                                                       color: Colors.amber.shade700,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 200,
//                                                 child: Center(
//                                                   child: Text(
//                                                     "Curing °c",
//                                                     style: TextStyle(
//                                                       fontSize: 20,
//                                                       color: Colors.amber.shade700,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 200,
//                                                 child: Center(
//                                                   child: Text(
//                                                     "Time",
//                                                     style: TextStyle(
//                                                       fontSize: 20,
//                                                       color: Colors.amber.shade700,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         _buildStreamAverageTemp(date, shift),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             width: 1250,
//                             height: 900,
//                             decoration: const BoxDecoration(
//                               gradient: LinearGradient(
//                                   colors: [Color(0xff4e597e), Color(0xff6a7398), Color(0xff717793)],
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight),
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   height: 60,
//                                   color: Colors.grey.shade800,
//                                   child: Center(
//                                     child: Text(
//                                       "Compare Data",
//                                       style: TextStyle(
//                                         fontSize: 25,
//                                         color: Colors.amber.shade700,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 5),
//                                 _buildStreamChartTemp(date, shift),
//                                 const SizedBox(height: 5),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   _buildStreamRealtimeTemp(List<RealTimeTempModel> data) {
//     final tempList = data;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         for (var item in tempList)
//           TempWidget(
//             line: "Line ${item.lineId}",
//             tempP: item.preheat.tempValue,
//             minP: item.preheat.min,
//             maxP: item.preheat.max,
//             tempC: item.curing.tempValue,
//             minC: item.curing.min,
//             maxC: item.curing.max,
//           ),
//       ],
//     );
//   }
//
//   _buildStreamAverageTemp(String date, String shift) {
//     return StreamBuilder(
//       stream: averageTempStream(date, shift),
//       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//         if (snapshot.hasData) {
//           final data = snapshot.data;
//           if (data == null || data.isEmpty) {
//             return const Center(
//               child: Center(
//                 child: Text(
//                   'No data !',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//             );
//           }
//
//           List<dynamic> lineA = data["lineA"];
//           List<dynamic> lineB = data["lineB"];
//           List<dynamic> lineD = data["lineD"];
//
//           String time = "";
//
//           final paramsA = lineA.map((B) => ReportTempModel.fromJson(B)).toList();
//           final paramsB = lineB.map((B) => ReportTempModel.fromJson(B)).toList();
//           final paramsD = lineD.map((B) => ReportTempModel.fromJson(B)).toList();
//
//           ///////////// Line A /////////////
//           double preheatA = 0;
//           double curingA = 0;
//           for (var result in paramsA) {
//             var tempPreheatA = result.preheat;
//             var tempCuringA = result.curing;
//             averageTempPreheatA.add(tempPreheatA);
//             averageTempCuringA.add(tempCuringA);
//           }
//           if (averageTempPreheatA.isNotEmpty) {
//             preheatA = averageTempPreheatA.reduce((a, b) => a + b) / averageTempPreheatA.length;
//           }
//           if (averageTempCuringA.isNotEmpty) {
//             curingA = averageTempCuringA.reduce((a, b) => a + b) / averageTempCuringA.length;
//           }
//           //////////////////////////////////
//
//           ///////////// Line B /////////////
//           double preheatB = 0;
//           double curingB = 0;
//           for (var result in paramsB) {
//             var tempPreheatB = result.preheat;
//             var tempCuringB = result.curing;
//             averageTempPreheatB.add(tempPreheatB);
//             averageTempCuringB.add(tempCuringB);
//           }
//           if (averageTempPreheatB.isNotEmpty) {
//             preheatB = averageTempPreheatB.reduce((a, b) => a + b) / averageTempPreheatB.length;
//           }
//           if (averageTempCuringB.isNotEmpty) {
//             curingB = averageTempCuringB.reduce((a, b) => a + b) / averageTempCuringB.length;
//           }
//           //////////////////////////////////
//
//           ///////////// Line C /////////////
//           double preheatD = 0;
//           double curingD = 0;
//           for (var result in paramsD) {
//             var tempPreheatD = result.preheat;
//             var tempCuringD = result.curing;
//             averageTempPreheatD.add(tempPreheatD);
//             averageTempCuringD.add(tempCuringD);
//           }
//
//           if (averageTempPreheatD.isNotEmpty) {
//             preheatD = averageTempPreheatD.reduce((a, b) => a + b) / averageTempPreheatD.length;
//           }
//           if (averageTempCuringD.isNotEmpty) {
//             curingD = averageTempCuringD.reduce((a, b) => a + b) / averageTempCuringD.length;
//           }
//           //////////////////////////////////
//
//           if (shift == '7-18') {
//             time = '07:00 - 18:00';
//           } else {
//             time = '18:00 - 05:00';
//           }
//
//           log('List Temp Preheat => ${preheatD.toInt()}');
//           log('List Temp Curing  => ${curingD.toInt()}');
//
//           return Padding(
//             padding: const EdgeInsets.only(top: 40, bottom: 40),
//             child: Column(
//               children: [
//                 AverageTempWidget(line: "Line A-Recorded", preheat: preheatA, curing: curingA, shift: time),
//                 AverageTempWidget(line: "Line B-Recorded", preheat: preheatB, curing: curingB, shift: time),
//                 AverageTempWidget(line: "Line D-Recorded", preheat: preheatD, curing: curingD, shift: time),
//               ],
//             ),
//           );
//         }
//         if (snapshot.hasError) {
//           return const Center(
//             child: Text(
//               ' Error data !',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//               ),
//             ),
//           );
//         }
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//   }
//
//   _buildStreamChartTemp(String date, String shift) {
//     return StreamBuilder(
//       stream: chartTempStream(),
//       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//         if (snapshot.hasData) {
//           final data = snapshot.data;
//
//           if (data == null || data.isEmpty) {
//             return const Center(
//               child: SizedBox(
//                 height: 280,
//                 width: 1050,
//                 child: Center(
//                   child: Text(
//                     'No data !',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }
//
//           List<dynamic> lineA = data["lineA"];
//           List<dynamic> lineB = data["lineB"];
//           List<dynamic> lineD = data["lineD"];
//
//           final paramsA = lineA.map((B) => ReportTempModel.fromJson(B)).toList();
//           final paramsB = lineB.map((B) => ReportTempModel.fromJson(B)).toList();
//           final paramsD = lineD.map((B) => ReportTempModel.fromJson(B)).toList();
//
//           final dateList = date.split("-");
//           int year = int.parse(dateList[0]);
//           int month = int.parse(dateList[1]);
//           int dayStart = int.parse(dateList[2]);
//           int dayEnd = int.parse(dateList[2]);
//
//           final shiftList = shift.split("-");
//           int startHour = int.parse(shiftList[0]);
//           int endHour = int.parse(shiftList[1]);
//
//           if (shift == "18-5") {
//             dayEnd += 1;
//           }
//
//           ///////////// Line A /////////////
//           for (var result in paramsA) {
//             var tempPreheatA = result.preheat;
//             var tempCuringA = result.curing;
//
//             chartPreheatA.add(
//               ChartData(
//                 DateTime.fromMillisecondsSinceEpoch(result.createTimeStamp),
//                 tempPreheatA,
//               ),
//             );
//             chartCuringA.add(
//               ChartData(
//                 DateTime.fromMillisecondsSinceEpoch(result.createTimeStamp),
//                 tempCuringA,
//               ),
//             );
//           }
//
//           ///////////// Line B /////////////
//           for (var result in paramsB) {
//             var tempPreheatB = result.preheat;
//             var tempCuringB = result.curing;
//
//             chartPreheatB.add(
//               ChartData(
//                 DateTime.fromMillisecondsSinceEpoch(result.createTimeStamp),
//                 tempPreheatB,
//               ),
//             );
//             chartCuringB.add(
//               ChartData(
//                 DateTime.fromMillisecondsSinceEpoch(result.createTimeStamp),
//                 tempCuringB,
//               ),
//             );
//           }
//
//           ///////////// Line C /////////////
//           for (var result in paramsD) {
//             var tempPreheatD = result.preheat;
//             var tempCuringD = result.curing;
//
//             chartPreheatD.add(
//               ChartData(
//                 DateTime.fromMillisecondsSinceEpoch(result.createTimeStamp),
//                 tempPreheatD,
//               ),
//             );
//             chartCuringD.add(
//               ChartData(
//                 DateTime.fromMillisecondsSinceEpoch(result.createTimeStamp),
//                 tempCuringD,
//               ),
//             );
//           }
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildChartTemp(
//                 year,
//                 month,
//                 dayStart,
//                 startHour,
//                 dayEnd,
//                 endHour,
//                 "Temp-Line-A",
//                 chartPreheatA,
//                 chartCuringA,
//                 _tooltipBehaviorA,
//               ),
//               // const SizedBox(height: 3),
//               _buildChartTemp(
//                 year,
//                 month,
//                 dayStart,
//                 startHour,
//                 dayEnd,
//                 endHour,
//                 "Temp-Line-B",
//                 chartPreheatB,
//                 chartCuringB,
//                 _tooltipBehaviorB,
//               ),
//               // const SizedBox(height: 3),
//               _buildChartTemp(
//                 year,
//                 month,
//                 dayStart,
//                 startHour,
//                 dayEnd,
//                 endHour,
//                 "Temp-Line-D",
//                 chartPreheatD,
//                 chartCuringD,
//                 _tooltipBehaviorD,
//               ),
//             ],
//           );
//         }
//         if (snapshot.hasError) {
//           return const SizedBox(
//             height: 280,
//             width: 1050,
//             child: Center(
//               child: Text(
//                 'Error data !',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//           );
//         }
//         return const SizedBox(
//           height: 280,
//           width: 1050,
//           child: Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       },
//     );
//   }
//
//   _buildShowDate(String date) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(
//           width: 1.0,
//           color: Colors.white,
//         ),
//         borderRadius: const BorderRadius.all(
//           Radius.circular(
//             2,
//           ),
//         ),
//       ),
//       width: 200,
//       child: Padding(
//         padding: const EdgeInsets.only(
//           left: 8,
//           right: 8,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               date,
//               style: const TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             IgnorePointer(
//               ignoring: ignoring,
//               child: IconButton(
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         content: SizedBox(
//                           height: 500,
//                           width: 1000,
//                           child: _buildSelectDate(),
//                         ),
//                       );
//                     },
//                   );
//                 },
//                 icon: const Icon(
//                   Icons.calendar_month_rounded,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   _buildShowShift() {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(
//           width: 1.0,
//           color: Colors.white,
//         ),
//         borderRadius: const BorderRadius.all(
//           Radius.circular(
//             2,
//           ),
//         ),
//       ),
//       width: 200,
//       child: Padding(
//         padding: const EdgeInsets.only(
//           left: 10,
//           right: 10,
//         ),
//         child: DropdownButtonHideUnderline(
//           child: IgnorePointer(
//             ignoring: ignoring,
//             child: DropdownButton(
//               value: selectedValue,
//               dropdownColor: Colors.grey.shade600,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//               ),
//               icon: const Icon(
//                 Icons.arrow_drop_down_outlined,
//                 color: Colors.white,
//                 size: 40,
//               ),
//               onChanged: (String? newValue) {
//                 selectedValue = newValue!;
//                 setState(
//                   () {},
//                 );
//               },
//               items: dropdownItems,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   _buildChartTemp(
//     int year,
//     int month,
//     int dayStart,
//     int startHour,
//     int dayEnd,
//     int endHour,
//     String title,
//     List<ChartData> chartPreheat,
//     List<ChartData> chartCuring,
//     TooltipBehavior _tooltipBehavior,
//   ) {
//     return Row(
//       children: [
//         const SizedBox(width: 30),
//         RotatedBox(
//           quarterTurns: 3,
//           child: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 18,
//               color: Colors.white,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         const SizedBox(width: 20),
//         SizedBox(
//           height: 260,
//           width: 1100,
//           child: Center(
//             child: SfCartesianChart(
//               tooltipBehavior: _tooltipBehavior,
//               enableAxisAnimation: true,
//               primaryYAxis: NumericAxis(
//                 majorGridLines: const MajorGridLines(width: 0),
//                 crossesAt: 0,
//                 labelStyle: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 // interval: 20,
//                 isInversed: false,
//               ),
//               legend: Legend(
//                 isVisible: true,
//                 iconWidth: 0,
//                 iconHeight: 0,
//                 textStyle: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 toggleSeriesVisibility: true,
//               ),
//               primaryXAxis: DateTimeAxis(
//                 majorGridLines: const MajorGridLines(width: 0),
//                 minimum: DateTime(year, month, dayStart, startHour),
//                 maximum: DateTime(year, month, dayEnd, endHour),
//                 visibleMinimum: DateTime(year, month, dayStart, startHour),
//                 visibleMaximum: DateTime(year, month, dayEnd, endHour),
//                 intervalType: DateTimeIntervalType.hours,
//                 dateFormat: DateFormat.Hm(),
//                 labelStyle: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               series: <ChartSeries<ChartData, DateTime>>[
//                 SplineSeries<ChartData, DateTime>(
//                   splineType: SplineType.cardinal,
//                   name: 'Preheat',
//                   enableTooltip: true,
//                   color: const Color(0xff00337C),
//                   onRendererCreated: (ChartSeriesController controller) {
//                     seriesController = controller;
//                   },
//                   animationDuration: 0,
//                   dataSource: chartPreheat,
//                   xValueMapper: (ChartData sales, _) => sales.x,
//                   yValueMapper: (ChartData sales, _) => sales.y,
//                 ),
//                 SplineSeries<ChartData, DateTime>(
//                   splineType: SplineType.cardinal,
//                   name: 'Curing',
//                   enableTooltip: true,
//                   color: Colors.deepOrange,
//                   onRendererCreated: (ChartSeriesController controller) {
//                     seriesController = controller;
//                   },
//                   animationDuration: 0,
//                   dataSource: chartCuring,
//                   xValueMapper: (ChartData sales, _) => sales.x,
//                   yValueMapper: (ChartData sales, _) => sales.y,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Column(
//           children: const [
//             Icon(
//               Icons.thermostat,
//               color: Color(0xff00337C),
//             ),
//             SizedBox(height: 10),
//             Icon(
//               Icons.thermostat,
//               color: Colors.deepOrange,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   _buildAppbar() {
//     return PreferredSize(
//       preferredSize: const Size.fromHeight(90.0),
//       child: AppBar(
//         toolbarHeight: 90,
//         title: Padding(
//           padding: const EdgeInsets.only(left: 25),
//           child: Container(
//             color: Colors.white,
//             child: Padding(
//               padding: const EdgeInsets.all(40.0),
//               child: Image.asset(
//                 "assets/images/logo_jinpao2.png",
//                 fit: BoxFit.contain,
//                 height: 60,
//               ),
//             ),
//           ),
//         ),
//         actions: [
//           Center(
//             child: Row(
//               children: [
//                 Text(
//                   "Temperature Profile  ",
//                   style: TextStyle(
//                     fontSize: 40,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.amber.shade700,
//                   ),
//                 ),
//                 const Text(
//                   "Dashboard",
//                   style: TextStyle(
//                     fontSize: 40,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//                 GestureDetector(
//                   onTap: () {
//                     refreshAll();
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: const Icon(
//                       Icons.refresh_rounded,
//                       size: 40,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//               ],
//             ),
//           ),
//         ],
//         backgroundColor: Colors.grey.shade800,
//       ),
//     );
//   }
//
//   _buildSelectDate() {
//     return SizedBox(
//       height: 400,
//       child: SfDateRangePicker(
//         backgroundColor: Colors.white,
//         view: DateRangePickerView.month,
//         selectionMode: DateRangePickerSelectionMode.single,
//         minDate: DateTime(2023),
//         maxDate: DateTime.now(),
//         showActionButtons: true,
//         toggleDaySelection: true,
//         showNavigationArrow: true,
//         onSubmit: (value) {
//           if (value == null) {
//             log("Date status == null ?");
//           } else {
//             String selectDate = value.toString();
//             int idx = selectDate.indexOf(" ");
//             List parts = [selectDate.substring(0, idx).trim(), selectDate.substring(idx + 1).trim()];
//             initDate = parts[0];
//             print(initDate);
//             Get.back();
//             setState(() {});
//           }
//         },
//         onCancel: () {
//           Get.back();
//         },
//       ),
//     );
//   }
// }
//
// class ChartData {
//   ChartData(this.x, this.y);
//   final DateTime x;
//   final dynamic y;
// }
