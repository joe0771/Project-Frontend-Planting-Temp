import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature/src/constants/color.dart';
import 'package:temperature/src/pages/realtime/realtime_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jinpao Automation',
      theme: ThemeData(
        // fontFamily: 'sans',
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: CustomColors.primaryColor,
            onSurface: Colors.grey.shade700,
          ),
        ),
      ),
      home: const RealtimePage(),
    );
  }
}
