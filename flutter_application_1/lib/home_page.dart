import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdfe4ea),
      appBar: AppBar(
        title: const Text(
          "Bus Company App",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 35, 8, 100),
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
              color: Color.fromARGB(255, 68, 63, 161),
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome to Bus Management System",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Manage buses, employees and trips easily",

              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppButton(
                  buttontext: 'Manage Buses',
                  ontap: () {},
                  backgroundColor: Colors.amberAccent,
                  height: 50,
                  width: 50,
                  buttontextclr: Colors.white,
                ),
                const SizedBox(width: 16),
                AppButton(
                  buttontext: 'Manage Employees',
                  ontap: () {},
                  backgroundColor: Colors.blueAccent,
                  height: 50,
                  width: 50,
                  buttontextclr: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                  buttontext: 'Manage Trips',
                  ontap: () {},
                  backgroundColor: Colors.greenAccent,
                  height: 50,
                  width: 50,
                  buttontextclr: Colors.white,
                ),
                const SizedBox(width: 16),
                AppButton(
                  buttontext: 'Manage Earnings and Costs',
                  ontap: () {},
                  backgroundColor: Colors.orangeAccent,
                  height: 150,
                  width: 150,
                  buttontextclr: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
