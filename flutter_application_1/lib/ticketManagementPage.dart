import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Assuming you have a TicketStatus enum defined somewhere.
// If not, here is a placeholder:
enum TicketStatus { all, active, cancelled }

class TicketManagementPage extends StatefulWidget {
  const TicketManagementPage({super.key, this.initialAction});

  final String? initialAction;

  @override
  State<TicketManagementPage> createState() => _TicketManagementPageState();
}

class _TicketManagementPageState extends State<TicketManagementPage> {
  // 1. Define the missing state variable
  TicketStatus _filterStatus = TicketStatus.all;

  @override
  void initState() {
    super.initState();

    // Apply initial filter if coming from quick actions
    if (widget.initialAction == 'cancelled') {
      _filterStatus = TicketStatus.cancelled;
    }

    // Trigger dialogs after first frame so context is ready
    if (widget.initialAction == 'add' || widget.initialAction == 'scan') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.initialAction == 'add') _showAddTicketSheet();
        if (widget.initialAction == 'scan') _showScanDialog();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Management'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Gap(20.h),
            Text("Filtering by: ${_filterStatus.name}"),
            // Your ticket list and UI components go here
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTicketSheet,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Placeholder methods for your existing logic
  void _showAddTicketSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          const SizedBox(height: 300, child: Center(child: Text("Add Ticket"))),
    );
  }

  void _showScanDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(title: Text("Scan QR Code")),
    );
  }
}
