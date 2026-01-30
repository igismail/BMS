import 'package:flutter/material.dart';
import 'package:flutter_application_1/landing_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusManagementSystem extends StatelessWidget {
  const BusManagementSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',

          // You can use the library anywhere in the app even in theme
          home: child,
        );
      },
      child: const LandingPage(),
    );
  }
}
