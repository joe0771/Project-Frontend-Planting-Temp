import 'package:flutter/material.dart';
import 'package:get/get.dart';

alertCustomDialog(
  IconData icon,
  Color color,
  String title,
  String subtitle,
  bool dismissible,
) {
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
