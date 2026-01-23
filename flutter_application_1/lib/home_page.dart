import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Bus Company App",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 112, 19, 17),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.directions_bus,
              size: 80,
              color: Color.fromARGB(255, 193, 190, 190),
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome to Bus Management System",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Manage buses, employees and trips easily",

              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),

            SizedBox(height: 50),

            AppButton(
              buttontext: 'Manage Buses',
              ontap: () {},

              height: 30,
              width: 400,
              backgroundColor: const Color.fromARGB(255, 112, 19, 17),
              buttontextclr: Colors.white,
            ),
            SizedBox(height: 10),

            AppButton(
              buttontext: 'Manage Employees',
              ontap: () {},
              backgroundColor: const Color.fromARGB(255, 112, 19, 17),
              height: 50,
              width: 50,
              buttontextclr: Colors.white,
            ),
            SizedBox(height: 10),

            AppButton(
              buttontext: 'Manage Trips',
              ontap: () {},
              backgroundColor: const Color.fromARGB(255, 112, 19, 17),
              height: 50,
              width: 50,
              buttontextclr: Colors.white,
            ),
            SizedBox(height: 10),

            AppButton(
              buttontext: 'Manage Earnings and Costs',
              ontap: () {},
              backgroundColor: const Color.fromARGB(255, 112, 19, 17),
              height: 150,
              width: 150,
              buttontextclr: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
