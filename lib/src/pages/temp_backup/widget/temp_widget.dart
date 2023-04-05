// import 'package:flutter/material.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
//
// class TempWidget extends StatelessWidget {
//   const TempWidget({
//     Key? key,
//     required this.line,
//     required this.tempP,
//     required this.minP,
//     required this.maxP,
//     required this.tempC,
//     required this.minC,
//     required this.maxC,
//   }) : super(key: key);
//
//   final String line;
//   final double tempP;
//   final int minP;
//   final int maxP;
//   final double tempC;
//   final int minC;
//   final int maxC;
//
//   @override
//   Widget build(BuildContext context) {
//     double tempPreheat = tempP;
//     double tempCuring = tempC;
//
//     if (tempPreheat >= 200) {
//       tempPreheat = 200;
//     }
//     if (tempPreheat <= 0) {
//       tempPreheat = 0;
//     }
//
//     if (tempCuring >= 200) {
//       tempCuring = 200;
//     }
//     if (tempCuring <= 0) {
//       tempCuring = 0;
//     }
//
//     return Column(
//       children: [
//         Container(
//           width: 825,
//           height: 60,
//           color: Colors.grey.shade800,
//           child: Center(
//             child: Text(
//               line,
//               style: TextStyle(
//                 fontSize: 25,
//                 color: Colors.amber.shade700,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//         Container(
//           width: 825,
//           height: 180,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(colors: [
//               Color(0xff4e597e),
//               Color(0xff6a7398),
//               Color(0xff717793)
//             ], begin: Alignment.topLeft, end: Alignment.bottomRight),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.only(top: 20, bottom: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircularPercentIndicator(
//                   startAngle: 180,
//                   radius: 60.0,
//                   lineWidth: 20.0,
//                   // animation: true,
//                   percent: tempPreheat / 200.toDouble(),
//                   center: Text(
//                     "${tempPreheat.toInt()}°",
//                     style: const TextStyle(
//                       fontSize: 25,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   circularStrokeCap: CircularStrokeCap.square,
//                   progressColor: const Color(0xff00337C),
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Preheat",
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 160,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "$minP°",
//                             style: const TextStyle(
//                               fontSize: 20,
//                               height: 1.5,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           Text(
//                             "$maxP°",
//                             style: const TextStyle(
//                               fontSize: 20,
//                               height: 1.5,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: 160,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Min",
//                             style: TextStyle(
//                               fontSize: 20,
//                               // height: 0.8,
//                               color: Colors.lightBlueAccent.shade200,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           Text(
//                             "Max",
//                             style: TextStyle(
//                               fontSize: 20,
//                               // height: 0.8,
//                               color: Colors.amber.shade700,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.only(left: 20, right: 20),
//                   child: SizedBox(
//                     height: 160,
//                     child: VerticalDivider(
//                       width: 20,
//                       thickness: 1,
//                       indent: 20,
//                       endIndent: 0,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 CircularPercentIndicator(
//                   startAngle: 180,
//                   radius: 60.0,
//                   lineWidth: 20.0,
//                   // animation: true,
//                   percent: tempCuring / 200.toDouble(),
//                   center: Text(
//                     "${tempCuring.toInt()}°",
//                     style: const TextStyle(
//                       fontSize: 25,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   circularStrokeCap: CircularStrokeCap.square,
//                   progressColor: Colors.deepOrange,
//                 ),
//                 const SizedBox(width: 20),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Curing",
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 160,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "$minC°",
//                             style: const TextStyle(
//                               fontSize: 20,
//                               height: 1.5,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           Text(
//                             "$maxC°",
//                             style: const TextStyle(
//                               fontSize: 20,
//                               height: 1.5,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: 160,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Min",
//                             style: TextStyle(
//                               fontSize: 20,
//                               // height: 0.8,
//                               color: Colors.lightBlueAccent.shade200,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           Text(
//                             "Max",
//                             style: TextStyle(
//                               fontSize: 20,
//                               // height: 0.8,
//                               color: Colors.amber.shade700,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
