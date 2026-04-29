import 'package:flutter/material.dart';
import 'package:flutter_application_1/bookingsuccesspage.dart'; // Ensure this matches your file name
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class BookingConfirmationPage extends StatefulWidget {
  const BookingConfirmationPage({
    super.key,
    required this.selectedSeats,
    required this.totalAmount,
    required String name,
    required String phone,
  });

  final List<int> selectedSeats;
  final double totalAmount;

  @override
  State<BookingConfirmationPage> createState() =>
      _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  final Color primaryColor = const Color(0xFF1A237E); // Professional Navy Blue

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    // Simulating a database/API call
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() => _loading = false);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingSuccessPage(
          name: _nameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          selectedSeats: widget.selectedSeats,
          totalAmount: widget.totalAmount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text("Checkout",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                children: [
                  _buildProgressIndicator(),
                  Gap(20.h),

                  // Trip Card
                  _sectionHeader("Trip Summary"),
                  Gap(10.h),
                  _buildTripCard(),

                  Gap(25.h),

                  // Passenger Form Card
                  _sectionHeader("Passenger Information"),
                  Gap(10.h),
                  _buildPassengerCard(),
                ],
              ),
            ),
            _buildBottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _stepCircle("1", "Seats", true),
        _stepLine(true),
        _stepCircle("2", "Confirm", true),
        _stepLine(false),
        _stepCircle("3", "Success", false),
      ],
    );
  }

  Widget _buildTripCard() {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _tripLocation("CTG", "Chattogram"),
              Icon(Icons.directions_bus, color: Colors.white.withOpacity(0.5)),
              _tripLocation("DHA", "Dhaka"),
            ],
          ),
          const Divider(color: Colors.white24, height: 30),
          _rowItem(
              "Selected Seats", widget.selectedSeats.join(", "), Colors.white),
          Gap(10.h),
          _rowItem("Total Payable",
              "৳ ${widget.totalAmount.toStringAsFixed(0)}", Colors.white,
              isBold: true),
        ],
      ),
    );
  }

  Widget _buildPassengerCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _field(_nameCtrl, "Full Name", Icons.person_outline,
              validator: (v) => v!.isEmpty ? "Enter your name" : null),
          Gap(16.h),
          _field(_phoneCtrl, "Phone Number", Icons.phone_android_outlined,
              keyboard: TextInputType.phone,
              validator: (v) => RegExp(r'^01\d{9}$').hasMatch(v ?? '')
                  ? null
                  : "Invalid phone number"),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5))
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _loading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: Size(double.infinity, 56.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r)),
            elevation: 0,
          ),
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text("Confirm & Pay ৳ ${widget.totalAmount.toStringAsFixed(0)}",
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _sectionHeader(String title) => Text(title,
      style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700]));

  Widget _tripLocation(String code, String city) => Column(
        crossAxisAlignment:
            code == "DHA" ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(code,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold)),
          Text(city, style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
        ],
      );

  Widget _rowItem(String label, String value, Color color,
          {bool isBold = false}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: color.withOpacity(0.8), fontSize: 13.sp)),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 14.sp,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      );

  Widget _field(TextEditingController c, String hint, IconData icon,
          {TextInputType? keyboard, String? Function(String?)? validator}) =>
      TextFormField(
        controller: c,
        keyboardType: keyboard,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: primaryColor, size: 20),
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFFF4F6FB),
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none),
        ),
      );

  Widget _stepCircle(String step, String label, bool isActive) => Column(
        children: [
          CircleAvatar(
            radius: 12.r,
            backgroundColor: isActive ? primaryColor : Colors.grey[300],
            child: Text(step,
                style: TextStyle(color: Colors.white, fontSize: 10.sp)),
          ),
          Gap(4.h),
          Text(label,
              style: TextStyle(
                  fontSize: 10.sp,
                  color: isActive ? primaryColor : Colors.grey)),
        ],
      );

  Widget _stepLine(bool isActive) => Expanded(
      child: Container(
          height: 2,
          color: isActive ? primaryColor : Colors.grey[300],
          margin: EdgeInsets.only(bottom: 15.h)));
}
