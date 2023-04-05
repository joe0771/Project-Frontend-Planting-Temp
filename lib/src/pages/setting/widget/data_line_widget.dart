import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:temperature/src/widgets/dialog/setting_custom_dialog_widet.dart';

class DataLineWidget extends StatelessWidget {
  const DataLineWidget({
    Key? key,
    required this.line,
    required this.statusP,
    required this.tempP,
    required this.minP,
    required this.maxP,
    required this.tempC,
    required this.statusC,
    required this.minC,
    required this.maxC,
    required this.state,
  }) : super(key: key);

  final String line;
  final String statusP;
  final double tempP;
  final int minP;
  final int maxP;
  final String statusC;
  final double tempC;
  final int minC;
  final int maxC;
  final Function() state;

  @override
  Widget build(BuildContext context) {
    String tempPStatus = "";
    String tempCStatus = "";

    Color colorP = Colors.transparent;
    Color colorC = Colors.transparent;

    if (statusP == "on") {
      tempPStatus = "Online";
      colorP = Colors.green;
    } else {
      tempPStatus = "Offline";
      colorP = Colors.grey.shade500;
    }

    if (statusC == "on") {
      tempCStatus = "Online";
      colorC = Colors.green;
    } else {
      tempCStatus = "Offline";
      colorC = Colors.grey.shade500;
    }

    return InkWell(
      onTap: () {
        settingCustomDialogWidget(line, statusP, tempP, minP, maxP, statusC, tempC, minC, maxC, state);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Card(
          color: Colors.grey.shade800,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Text(
                    "Temperature Setting Line $line",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.amber.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: SizedBox(
                    width: 800,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(
                          width: 200,
                          child: Center(
                            child: Text(
                              "Min",
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xFF3880e8),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 200,
                          child: Center(
                            child: Text(
                              "Max",
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xffdf6d26),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: Center(
                            child: Text(
                              "Status",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.amber.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 40),
                  child: ListTile(
                    title: const Text(
                      "Drying",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: SizedBox(
                      width: 800,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Center(
                              child: Text(
                                "$minP",
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Center(
                              child: Text(
                                "$maxP",
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Center(
                              child: Text(
                                tempPStatus,
                                style: TextStyle(
                                  fontSize: 30,
                                  color: colorP,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 40),
                  child: ListTile(
                    title: const Text(
                      "Curing",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: SizedBox(
                      width: 800,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Center(
                              child: Text(
                                "$minC",
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Center(
                              child: Text(
                                "$maxC",
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Center(
                              child: Text(
                                tempCStatus,
                                style: TextStyle(
                                  fontSize: 30,
                                  color: colorC,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
