import 'package:flutter/material.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

enum EmployeeRole { driver, conductor, mechanic, admin }

enum EmployeeStatus { active, onLeave, terminated }

class Employee {
  final String id;
  final String name;
  final String phone;
  final EmployeeRole role;
  EmployeeStatus status;
  final String joinDate;
  final String assignedBus;
  double salary; // Added Salary field

  Employee({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.status = EmployeeStatus.active,
    required this.joinDate,
    required this.assignedBus,
    required this.salary, // Required in constructor
  });
}

// ── Page ──────────────────────────────────────────────────────────────────────

class ManageEmployee extends StatefulWidget {
  const ManageEmployee({super.key});

  @override
  State<ManageEmployee> createState() => _ManageEmployeeState();
}

class _ManageEmployeeState extends State<ManageEmployee> {
  static const _brand = Color(0xFF630F10);

  final List<Employee> _employees = [
    Employee(
      id: 'E-001',
      name: 'Jalal Uddin',
      phone: '01711-111001',
      role: EmployeeRole.driver,
      assignedBus: 'Bus #05',
      joinDate: '1 Jan 2022',
      salary: 25000,
    ),
    Employee(
      id: 'E-002',
      name: 'Rina Begum',
      phone: '01822-222002',
      role: EmployeeRole.conductor,
      assignedBus: 'Bus #05',
      joinDate: '15 Mar 2023',
      salary: 18000,
    ),
    Employee(
      id: 'E-003',
      name: 'Faruk Hossain',
      phone: '01933-333003',
      role: EmployeeRole.driver,
      status: EmployeeStatus.onLeave,
      assignedBus: 'Bus #09',
      joinDate: '10 Jun 2021',
      salary: 26000,
    ),
  ];

  EmployeeStatus? _filterStatus;
  final _searchCtrl = TextEditingController();

  List<Employee> get _filtered {
    final q = _searchCtrl.text.toLowerCase();
    return _employees.where((e) {
      final matchSearch = q.isEmpty ||
          e.id.toLowerCase().contains(q) ||
          e.name.toLowerCase().contains(q) ||
          e.phone.contains(q) ||
          e.assignedBus.toLowerCase().contains(q);
      final matchFilter = _filterStatus == null || e.status == _filterStatus;
      return matchSearch && matchFilter;
    }).toList();
  }

  // Stats Logic
  int get _activeCount =>
      _employees.where((e) => e.status == EmployeeStatus.active).length;
  double get _totalPayroll => _employees
      .where((e) => e.status != EmployeeStatus.terminated)
      .fold(0, (sum, e) => sum + e.salary);

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: _brand,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Manage Employees',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _brand,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: const Text('Add Employee',
            style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: _showAddSheet,
      ),
      body: Column(
        children: [
          // Summary strip (Updated to show Payroll)
          Container(
            color: const Color(0xFF1A1A1A),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Row(
              children: [
                _statItem('Total', '${_employees.length}', Colors.white),
                _statItem('Active', '$_activeCount', const Color(0xFF2E9E5E)),
                _statItem(
                    'Monthly Payroll',
                    '৳${_totalPayroll.toStringAsFixed(0)}',
                    const Color(0xFF378ADD)),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search by name, ID, phone…',
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                prefixIcon:
                    const Icon(Icons.search, color: Colors.white38, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            color: Colors.white38, size: 18),
                        onPressed: () => setState(() => _searchCtrl.clear()),
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: {
                'All': null,
                'Active': EmployeeStatus.active,
                'On Leave': EmployeeStatus.onLeave,
                'Terminated': EmployeeStatus.terminated,
              }.entries.map((e) {
                final selected = _filterStatus == e.value;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(e.key),
                    selected: selected,
                    onSelected: (_) => setState(() => _filterStatus = e.value),
                    backgroundColor: const Color(0xFF1E1E1E),
                    selectedColor: _brand,
                    labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.white54,
                        fontSize: 12),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 4),
          // Employee list
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text('No employees found',
                        style: TextStyle(color: Colors.white38, fontSize: 15)))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _EmployeeCard(
                      employee: _filtered[i],
                      onToggleLeave: () => _toggleLeave(_filtered[i]),
                      onTerminate: () => _terminate(_filtered[i]),
                      onUpdateSalary: () =>
                          _showSalaryDialog(_filtered[i]), // Manage Salary
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(color: Colors.white38, fontSize: 10)),
        ],
      ),
    );
  }

  void _showSalaryDialog(Employee emp) {
    final salaryCtrl =
        TextEditingController(text: emp.salary.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text('Update Salary: ${emp.name}',
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: TextField(
          controller: salaryCtrl,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Monthly Salary (BDT)',
            labelStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24)),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _brand),
            onPressed: () {
              setState(() {
                emp.salary = double.tryParse(salaryCtrl.text) ?? emp.salary;
              });
              Navigator.pop(ctx);
              _snack('Salary updated for ${emp.name}');
            },
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _toggleLeave(Employee emp) {
    setState(() {
      emp.status = emp.status == EmployeeStatus.onLeave
          ? EmployeeStatus.active
          : EmployeeStatus.onLeave;
    });
    _snack(emp.status == EmployeeStatus.onLeave
        ? '${emp.name} marked on leave'
        : '${emp.name} marked active');
  }

  void _terminate(Employee emp) {
    setState(() => emp.status = EmployeeStatus.terminated);
    _snack('${emp.name} terminated');
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2A2A2A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddSheet() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final busCtrl = TextEditingController();
    final salaryCtrl = TextEditingController();
    EmployeeRole selectedRole = EmployeeRole.driver;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => Padding(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2))),
                ),
                const Text('Add New Employee',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                _sheetField(nameCtrl, 'Full Name', Icons.person),
                const SizedBox(height: 10),
                _sheetField(phoneCtrl, 'Phone Number', Icons.phone,
                    isPhone: true),
                const SizedBox(height: 10),
                _sheetField(salaryCtrl, 'Monthly Salary', Icons.payments,
                    isPhone: true), // Added Salary Input
                const SizedBox(height: 10),
                _sheetField(
                    busCtrl, 'Assigned Bus (optional)', Icons.directions_bus),
                const SizedBox(height: 14),
                const Text('Role',
                    style: TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: EmployeeRole.values.map((r) {
                    final label = r.name[0].toUpperCase() + r.name.substring(1);
                    final sel = selectedRole == r;
                    return ChoiceChip(
                      label: Text(label),
                      selected: sel,
                      onSelected: (_) => setLocal(() => selectedRole = r),
                      backgroundColor: const Color(0xFF2A2A2A),
                      selectedColor: _brand,
                      labelStyle: TextStyle(
                          color: sel ? Colors.white : Colors.white54,
                          fontSize: 12),
                      side: BorderSide.none,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.person_add, size: 18),
                    label: const Text('Add Employee',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _brand,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      final name = nameCtrl.text.trim();
                      final phone = phoneCtrl.text.trim();
                      final salary =
                          double.tryParse(salaryCtrl.text.trim()) ?? 0.0;
                      if (name.isEmpty || phone.isEmpty) {
                        _snack('Name and phone are required');
                        return;
                      }
                      final newId =
                          'E-${(_employees.length + 1).toString().padLeft(3, '0')}';
                      setState(() {
                        _employees.add(Employee(
                          id: newId,
                          name: name,
                          phone: phone,
                          role: selectedRole,
                          salary: salary,
                          assignedBus: busCtrl.text.trim().isEmpty
                              ? '—'
                              : busCtrl.text.trim(),
                          joinDate:
                              '${DateTime.now().day} ${_monthName(DateTime.now().month)} ${DateTime.now().year}',
                        ));
                      });
                      Navigator.pop(ctx);
                      _snack('$newId added successfully');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _monthName(int m) => [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][m - 1];

  Widget _sheetField(TextEditingController ctrl, String hint, IconData icon,
      {bool isPhone = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.white38, size: 18),
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        contentPadding: const EdgeInsets.symmetric(vertical: 13),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
      ),
    );
  }
}

// ── Employee Card ─────────────────────────────────────────────────────────────

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard({
    required this.employee,
    required this.onToggleLeave,
    required this.onTerminate,
    required this.onUpdateSalary,
  });

  final Employee employee;
  final VoidCallback onToggleLeave;
  final VoidCallback onTerminate;
  final VoidCallback onUpdateSalary;

  Color get _statusColor => switch (employee.status) {
        EmployeeStatus.active => const Color(0xFF2E9E5E),
        EmployeeStatus.onLeave => const Color(0xFFE8A020),
        EmployeeStatus.terminated => const Color(0xFF888888),
      };

  String get _statusLabel =>
      employee.status.name[0].toUpperCase() + employee.status.name.substring(1);

  Color get _roleColor => switch (employee.role) {
        EmployeeRole.driver => const Color(0xFF2563EB),
        EmployeeRole.conductor => const Color(0xFF2E9E5E),
        EmployeeRole.mechanic => const Color(0xFFE8A020),
        EmployeeRole.admin => const Color(0xFF9B59B6),
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: _statusColor, width: 3)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(employee.id,
                  style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
              Row(
                children: [
                  _badge(employee.role.name.toUpperCase(), _roleColor),
                  const SizedBox(width: 6),
                  _badge(_statusLabel, _statusColor),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(employee.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          Text(employee.phone,
              style: const TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _infoChip(Icons.directions_bus, employee.assignedBus),
              _infoChip(Icons.payments,
                  '৳${employee.salary.toStringAsFixed(0)}'), // Salary Display
              _infoChip(Icons.calendar_today, employee.joinDate),
            ],
          ),
          const SizedBox(height: 10),
          if (employee.status != EmployeeStatus.terminated)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _btn('Salary', Colors.blueGrey,
                    onUpdateSalary), // Manage Salary Button
                const SizedBox(width: 6),
                _btn(
                  employee.status == EmployeeStatus.onLeave
                      ? 'Mark Active'
                      : 'Leave',
                  employee.status == EmployeeStatus.onLeave
                      ? const Color(0xFF2E9E5E)
                      : const Color(0xFFE8A020),
                  onToggleLeave,
                ),
                const SizedBox(width: 6),
                _btn('Terminate', const Color(0xFFE24B4A), onTerminate),
              ],
            ),
        ],
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(5)),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white38, size: 12),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _btn(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Text(label,
            style: TextStyle(
                color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
