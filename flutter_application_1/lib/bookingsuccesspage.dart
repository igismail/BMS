import 'package:flutter/material.dart';
import 'package:flutter_application_1/busticket.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BookingSuccessPage extends StatelessWidget {
  final List<int> selectedSeats;
  final double totalAmount;
  final String name;
  final String phone;

  const BookingSuccessPage({
    super.key,
    required this.selectedSeats,
    required this.totalAmount,
    required this.name,
    required this.phone,
  });

  Future<void> _printTicket() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80, // Optimized for receipt printers
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text("BUS TICKET",
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),
              pw.SizedBox(height: 10),
              pw.Text("Customer: $name"),
              pw.Text("Phone: $phone"),
              pw.Text("Seats: ${selectedSeats.join(", ")}"),
              pw.SizedBox(height: 10),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text("Total: BDT ${totalAmount.toStringAsFixed(0)}",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Booking Confirmed"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.green, size: 100),
            Gap(12.h),
            Text(
              "Thank You!",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              "Your booking has been successful.",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            Gap(30.h),

            // Ticket Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        _buildInfoRow("Passenger", name),
                        Gap(12.h),
                        _buildInfoRow("Phone", phone),
                        Gap(12.h),
                        _buildInfoRow("Seats", selectedSeats.join(", ")),
                      ],
                    ),
                  ),

                  // Dashed Line
                  Row(
                    children: List.generate(
                      20,
                      (index) => Expanded(
                        child: Container(
                          color: index % 2 == 0
                              ? Colors.transparent
                              : Colors.grey[300],
                          height: 1,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          "৳ ${totalAmount.toStringAsFixed(0)}",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gap(40.h),

            // Actions
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _printTicket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: const Icon(Icons.print_rounded),
                label: Text("Download/Print Ticket",
                    style: TextStyle(fontSize: 16.sp)),
              ),
            ),
            Gap(12.h),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Busticket()),
                );
              },
              child: const Text("Return to Home"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14.sp)),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: Colors.black87)),
      ],
    );
  }
}
