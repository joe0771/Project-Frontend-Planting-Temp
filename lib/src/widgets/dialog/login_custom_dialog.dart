import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:temperature/src/pages/setting/setting_page.dart';
import 'package:temperature/src/widgets/dialog/alert_custom_dialog.dart';

loginCustomDialog(
  IconData icon,
  Color color,
  String title,
  String subtitle,
  bool dismissible,
) {
  TextEditingController? _textController = TextEditingController();
  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.grey.shade800,
      titlePadding: const EdgeInsets.all(50),
      title: Builder(
        builder: (context) {
          var width = MediaQuery.of(context).size.width;
          return Column(
            children: [
              Container(
                width: width - 1500,
                color: Colors.grey.shade800,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: 100,
                        color: color,
                      ),
                      const SizedBox(height: 40),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(_textController)
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
                        "Close",
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
                      },
                    ),
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
                        if (_textController.text == "automation519") {
                          Navigator.pushReplacement<void, void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => const SettingPage(),
                            ),
                          );
                        } else {
                          alertCustomDialog(Icons.error_outline_rounded, Colors.red, "Login Fail", "Invalid password", true);
                        }
                      },
                    ),
                  ),
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
    barrierDismissible: dismissible,
    barrierColor: Colors.black87,
  );
}

_buildTextField(TextEditingController _textController) {
  return SizedBox(
    width: 500,
    height: 100,
    child: Center(
      child: TextField(
        // inputFormatters: [
        //   LengthLimitingTextInputFormatter(3),
        // ],
        textAlign: TextAlign.center,
        controller: _textController,
        autofocus: true,
        keyboardType: TextInputType.text,
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
