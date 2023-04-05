// import 'package:flutter/material.dart';
//
// class AverageTempWidget extends StatelessWidget {
//   const AverageTempWidget({
//     Key? key,
//     required this.line,
//     required this.preheat,
//     required this.curing,
//     required this.shift,
//   }) : super(key: key);
//
//   final String line;
//   final double preheat;
//   final double curing;
//   final String shift;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         SizedBox(
//           height: 80,
//           width: 400,
//           child: Center(
//             child: Text(
//               line,
//               style: const TextStyle(
//                 fontSize: 20,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 80,
//           child: Center(
//             child: VerticalDivider(
//               width: 20,
//               thickness: 1,
//               // indent: 20,
//               // endIndent: 0,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 80,
//           width: 200,
//           child: Center(
//             child: Text(
//               preheat.toStringAsFixed(2),
//               style: const TextStyle(
//                 fontSize: 20,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 80,
//           child: Center(
//             child: VerticalDivider(
//               width: 20,
//               thickness: 1,
//               // indent: 20,
//               // endIndent: 0,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 80,
//           width: 200,
//           child: Center(
//             child: Text(
//               curing.toStringAsFixed(2),
//               style: const TextStyle(
//                 fontSize: 20,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 80,
//           child: Center(
//             child: VerticalDivider(
//               width: 20,
//               thickness: 1,
//               // indent: 20,
//               // endIndent: 0,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 80,
//           width: 200,
//           child: Center(
//             child: Text(
//               shift,
//               style: const TextStyle(
//                 fontSize: 20,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
