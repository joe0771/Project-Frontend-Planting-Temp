import 'dart:developer';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:temperature/src/models/return_status_model.dart';
import 'package:temperature/src/services/network_service.dart';
import 'package:temperature/src/widgets/dialog/alert_custom_dialog.dart';

settingCustomDialogWidget(
  String line,
  String statusD,
  double tempD,
  int minD,
  int maxD,
  String statusC,
  double tempC,
  int minC,
  int maxC,
  Function() state,
) {
  TextEditingController? _textControllerMinP = TextEditingController(text: minD.toString());
  TextEditingController? _textControllerMaxP = TextEditingController(text: maxD.toString());
  TextEditingController? _textControllerMinC = TextEditingController(text: minC.toString());
  TextEditingController? _textControllerMaxC = TextEditingController(text: maxC.toString());

  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.transparent,
      titlePadding: const EdgeInsets.all(50),
      title: Builder(
        builder: (context) {
          var width = MediaQuery.of(context).size.width;
          return Column(
            children: [
              Container(
                width: width - 1000,
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
                          width: 600,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              SizedBox(
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
                              SizedBox(
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
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
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
                            width: 600,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildTextField(_textControllerMinP),
                                _buildTextField(_textControllerMaxP),
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
                            width: 600,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildTextField(_textControllerMinC),
                                _buildTextField(_textControllerMaxC),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
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
                            color: Colors.white,
                          ),
                        ),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(
                                color: Colors.white,
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

                        try {
                          minD = int.parse(_textControllerMinP.text);
                          maxD = int.parse(_textControllerMaxP.text);
                          minC = int.parse(_textControllerMinC.text);
                          maxC = int.parse(_textControllerMaxC.text);

                          final ReturnStatusModel? result = await NetworkService.settingTemp(line, minD, maxD, minC, maxC);
                          state();

                          if (result!.success == true) {

                            alertCustomDialog(Icons.check_circle_outline_outlined, Colors.green, "Update Success", "Update setting temperature in line $line success", true);

                          } else {
                            alertCustomDialog(Icons.error_outline_rounded, Colors.red, "Update Fail",  "Update setting temperature in line $line fail", true);
                          }
                        } catch (error) {
                          alertCustomDialog(Icons.error_outline_rounded, Colors.red, "Update Error",  "Update setting temperature in line $line error", true);
                        }
                      },
                    ),
                  )
                ],
              ),
            ],
          );
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
    ),
    barrierDismissible: true,
    barrierColor: Colors.black87,
  );
}

_buildTextField(TextEditingController _textControllerMinP) {
  return SizedBox(
    width: 200,
    child: Center(
      child: TextField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(3),
        ],
        textAlign: TextAlign.center,
        controller: _textControllerMinP,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          labelStyle: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
        ),
        style: const TextStyle(
          fontSize: 30,
          color: Colors.white,
        ),
      ),
    ),
  );
}
