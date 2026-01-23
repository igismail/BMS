import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/landing_page.dart';
import 'package:flutter_application_1/login_page.dart';

class BusManagementSystem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LandingPage(), debugShowCheckedModeBanner: false);
  }
}
