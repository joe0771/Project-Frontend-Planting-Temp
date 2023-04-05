import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:temperature/src/widgets/blink/blink_widgets.dart';

class TempWidget extends StatelessWidget {
  const TempWidget({
    Key? key,
    required this.line,
    required this.statusD,
    required this.pvD,
    required this.svD,
    required this.minD,
    required this.maxD,
    required this.updateD,
    required this.statusC,
    required this.pvC,
    required this.minC,
    required this.maxC,
    required this.updateC,
    required this.svC,
  }) : super(key: key);

  final String line;
  final String statusD;
  final double pvD;
  final double svD;
  final int minD;
  final int maxD;
  final String updateD;
  final String statusC;
  final double pvC;
  final double svC;
  final int minC;
  final int maxC;
  final String updateC;

  @override
  Widget build(BuildContext context) {
    double tempDrying = pvD;
    double tempCuring = pvC;

    Color colorP1 = const Color(0xff5fd626);
    Color colorP2 = const Color(0xff459d1c);
    Color colorP3 = const Color(0xff236e00);

    Color colorC1 = const Color(0xff5fd626);
    Color colorC2 = const Color(0xff459d1c);
    Color colorC3 = const Color(0xff236e00);

    if (tempDrying >= 200) {
      tempDrying = 200;
    }

    if (tempDrying <= 0) {
      tempDrying = 0;
    }

    if (tempCuring >= 200) {
      tempCuring = 200;
    }
    if (tempCuring <= 0) {
      tempCuring = 0;
    }

    if (tempDrying <= minD) {
      colorP1 = const Color(0xFF3880e8);
      colorP2 = const Color(0xff1755ad);
      colorP3 = const Color(0xff00337C);
    } else if (tempDrying >= maxD) {
      colorP1 = const Color(0xffdf6d26);
      colorP2 = const Color(0xffba4f0c);
      colorP3 = const Color(0xff9e3e02);
    }

    if (tempCuring <= minC) {
      colorC1 = const Color(0xFF3880e8);
      colorC2 = const Color(0xff1755ad);
      colorC3 = const Color(0xff00337C);
    } else if (tempCuring >= maxC) {
      colorC1 = const Color(0xffdf6d26);
      colorC2 = const Color(0xffba4f0c);
      colorC3 = const Color(0xff9e3e02);
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff2c2947), Color(0xff414161), Color(0xff707094)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      width: 820,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 60,
                color: Colors.grey.shade800,
                child: Center(
                  child: Text(
                    line,
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.amber.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (statusD == "on") ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 20, right: 20),
                      child: Icon(
                        Icons.wifi,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ] else ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 20, right: 20),
                      child: Icon(
                        Icons.wifi_off_sharp,
                        color: Colors.white30,
                        size: 40,
                      ),
                    ),
                  ],
                  if (pvD >= maxD && statusD == "on" || pvD <= minD && statusD == "on") ...[
                    const BlinkWidget(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20, right: 40),
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, right: 40),
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 20, right: 40),
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.white30,
                        size: 40,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: CircularPercentIndicator(
                        startAngle: 180,
                        radius: 150.0,
                        lineWidth: 40.0,
                        linearGradient: LinearGradient(
                          colors: <Color>[
                            colorP1,
                            colorP2,
                            colorP3,
                          ],
                        ),
                        // animation: true,
                        rotateLinearGradient: true,
                        percent: tempDrying / 200.toDouble(),
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${tempDrying.toInt()}°",
                              style: const TextStyle(
                                fontSize: 65,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "PV",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        circularStrokeCap: CircularStrokeCap.butt,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Drying",
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 350,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$minD°",
                                style: const TextStyle(
                                  fontSize: 40,
                                  height: 1.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "$maxD°",
                                style: const TextStyle(
                                  fontSize: 40,
                                  height: 1.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Min",
                                style: TextStyle(
                                  fontSize: 30,
                                  // height: 0.8,
                                  color: Color(0xFF3880e8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Max",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color(0xffdf6d26),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: SizedBox(
                            width: 350,
                            child: Divider(
                              thickness: 2,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "SV : ",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              " $svD°",
                              style: const TextStyle(
                                fontSize: 40,
                                height: 1.5,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 100,
                      left: 40,
                      right: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Last update: $updateD",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        const Divider(
                          thickness: 4,
                          color: Colors.white,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (statusC == "on") ...[
                              const Padding(
                                padding: EdgeInsets.only(top: 20, right: 20),
                                child: Icon(
                                  Icons.wifi,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ] else ...[
                              const Padding(
                                padding: EdgeInsets.only(top: 20, right: 20),
                                child: Icon(
                                  Icons.wifi_off_sharp,
                                  color: Colors.white30,
                                  size: 40,
                                ),
                              ),
                            ],
                            if (pvC >= maxC && statusC == "on" || pvC <= minC && statusC == "on") ...[
                              const BlinkWidget(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ] else ...[
                              const Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.white30,
                                  size: 40,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: CircularPercentIndicator(
                        startAngle: 180,
                        radius: 150.0,
                        lineWidth: 40.0,
                        linearGradient: LinearGradient(
                          colors: <Color>[
                            colorC1,
                            colorC2,
                            colorC3,
                          ],
                        ),
                        // animation: true,
                        rotateLinearGradient: true,

                        percent: tempCuring / 200.toDouble(),
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${tempCuring.toInt()}°",
                              style: const TextStyle(
                                fontSize: 65,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "PV",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        circularStrokeCap: CircularStrokeCap.butt,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Curing",
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 350,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$minC°",
                                style: const TextStyle(
                                  fontSize: 40,
                                  height: 1.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "$maxC°",
                                style: const TextStyle(
                                  fontSize: 40,
                                  height: 1.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Min",
                                style: TextStyle(
                                  fontSize: 30,
                                  // height: 0.8,
                                  color: Color(0xFF3880e8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Max",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color(0xffdf6d26),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: SizedBox(
                            width: 350,
                            child: Divider(
                              thickness: 2,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "SV : ",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              " $svC°",
                              style: const TextStyle(
                                fontSize: 40,
                                height: 1.5,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 100,
              left: 40,
              right: 40,
              bottom: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Last update: $updateC",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 40),
        ],
      ),
    );
  }
}
