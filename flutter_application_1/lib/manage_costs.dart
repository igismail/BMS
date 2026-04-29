import 'package:flutter/material.dart';

// ── Models ────────────────────────────────────────────────────────────────────

enum CostType { fuel, maintenance, salary, other }

class CostEntry {
  final String id;
  final String description;
  final CostType type;
  final double amount;
  final String date;
  final String busNumber;

  CostEntry({
    required this.id,
    required this.description,
    required this.type,
    required this.amount,
    required this.date,
    required this.busNumber,
  });
}

class RevenueEntry {
  final String tripId;
  final String route;
  final int ticketsSold;
  final double revenue;
  final String date;

  RevenueEntry({
    required this.tripId,
    required this.route,
    required this.ticketsSold,
    required this.revenue,
    required this.date,
  });
}

// ── Page ──────────────────────────────────────────────────────────────────────

/// ManageCosts — Admin earnings and cost overview page.
/// Top summary cards show total revenue, total costs and net profit.
/// Two tabs switch between Revenue (per trip) and Costs (expenses) views.
/// FAB on the Costs tab opens an "Add expense" sheet.
class ManageCosts extends StatefulWidget {
  const ManageCosts({super.key});

  @override
  State<ManageCosts> createState() => _ManageCostsState();
}

class _ManageCostsState extends State<ManageCosts>
    with SingleTickerProviderStateMixin {
  static const _brand = Color(0xFF630F10);

  late final TabController _tabCtrl;

  final List<RevenueEntry> _revenues = [
    RevenueEntry(
      tripId: 'TR-001',
      route: 'Dhaka → Ctg',
      ticketsSold: 38,
      revenue: 20900,
      date: '24 Apr 2026',
    ),
    RevenueEntry(
      tripId: 'TR-002',
      route: 'Ctg → Sylhet',
      ticketsSold: 22,
      revenue: 10560,
      date: '24 Apr 2026',
    ),
    RevenueEntry(
      tripId: 'TR-003',
      route: 'Dhaka → Sylhet',
      ticketsSold: 15,
      revenue: 10500,
      date: '24 Apr 2026',
    ),
    RevenueEntry(
      tripId: 'TR-005',
      route: 'Dhaka → Ctg',
      ticketsSold: 5,
      revenue: 2750,
      date: '25 Apr 2026',
    ),
  ];

  final List<CostEntry> _costs = [
    CostEntry(
      id: 'C-001',
      description: 'Diesel refuel',
      type: CostType.fuel,
      amount: 8500,
      date: '24 Apr 2026',
      busNumber: 'Bus #05',
    ),
    CostEntry(
      id: 'C-002',
      description: 'Tyre replacement',
      type: CostType.maintenance,
      amount: 12000,
      date: '22 Apr 2026',
      busNumber: 'Bus #03',
    ),
    CostEntry(
      id: 'C-003',
      description: 'Driver salaries (April)',
      type: CostType.salary,
      amount: 45000,
      date: '20 Apr 2026',
      busNumber: 'All',
    ),
    CostEntry(
      id: 'C-004',
      description: 'Diesel refuel',
      type: CostType.fuel,
      amount: 7200,
      date: '23 Apr 2026',
      busNumber: 'Bus #09',
    ),
    CostEntry(
      id: 'C-005',
      description: 'Engine oil change',
      type: CostType.maintenance,
      amount: 3200,
      date: '18 Apr 2026',
      busNumber: 'Bus #12',
    ),
    CostEntry(
      id: 'C-006',
      description: 'Office supplies',
      type: CostType.other,
      amount: 1500,
      date: '15 Apr 2026',
      busNumber: '—',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  double get _totalRevenue => _revenues.fold(0, (s, r) => s + r.revenue);
  double get _totalCosts => _costs.fold(0, (s, c) => s + c.amount);
  double get _netProfit => _totalRevenue - _totalCosts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: _brand,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Earnings & Costs',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'Revenue'),
            Tab(text: 'Costs'),
          ],
        ),
      ),
      floatingActionButton: _tabCtrl.index == 1
          ? FloatingActionButton.extended(
              backgroundColor: _brand,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text(
                'Add Expense',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: _showAddCostSheet,
            )
          : null,
      body: Column(
        children: [
          // Summary cards
          _buildSummaryCards(),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [_buildRevenueList(), _buildCostsList()],
            ),
          ),
        ],
      ),
    );
  }

  // ── Summary cards ──────────────────────────────────────────────────────
  Widget _buildSummaryCards() {
    return Container(
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _summaryCard(
            'Total Revenue',
            '৳${_totalRevenue.toStringAsFixed(0)}',
            const Color(0xFF2E9E5E),
          ),
          const SizedBox(width: 8),
          _summaryCard(
            'Total Costs',
            '৳${_totalCosts.toStringAsFixed(0)}',
            const Color(0xFFE24B4A),
          ),
          const SizedBox(width: 8),
          _summaryCard(
            'Net Profit',
            '৳${_netProfit.toStringAsFixed(0)}',
            _netProfit >= 0 ? const Color(0xFFF0A500) : const Color(0xFFE24B4A),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF242424),
          borderRadius: BorderRadius.circular(12),
          border: Border(bottom: BorderSide(color: color, width: 2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white38, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── Revenue list ───────────────────────────────────────────────────────
  Widget _buildRevenueList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: _revenues.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final r = _revenues[i];
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(14),
            border: const Border(
              left: BorderSide(color: Color(0xFF2E9E5E), width: 3),
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.route,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.confirmation_number,
                          color: Colors.white38,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${r.ticketsSold} tickets sold',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.white38,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          r.date,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      r.tripId,
                      style: const TextStyle(
                        color: Colors.white24,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '৳${r.revenue.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Color(0xFF2E9E5E),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Costs list ─────────────────────────────────────────────────────────
  Widget _buildCostsList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: _costs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final c = _costs[i];
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(14),
            border: Border(
              left: BorderSide(color: _costColor(c.type), width: 3),
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _costColor(c.type).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _costIcon(c.type),
                  color: _costColor(c.type),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.directions_bus,
                          color: Colors.white38,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          c.busNumber,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.white38,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          c.date,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '৳${c.amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Color(0xFFE24B4A),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _costColor(CostType t) => switch (t) {
    CostType.fuel => const Color(0xFFF0A500),
    CostType.maintenance => const Color(0xFF378ADD),
    CostType.salary => const Color(0xFF9B59B6),
    CostType.other => const Color(0xFF888888),
  };

  IconData _costIcon(CostType t) => switch (t) {
    CostType.fuel => Icons.local_gas_station,
    CostType.maintenance => Icons.build,
    CostType.salary => Icons.people,
    CostType.other => Icons.attach_money,
  };

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

  void _showAddCostSheet() {
    final descCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final busCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    CostType selectedType = CostType.fuel;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
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
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  'Add Expense',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _sheetField(descCtrl, 'Description', Icons.description),
                const SizedBox(height: 10),
                _sheetField(
                  amountCtrl,
                  'Amount (৳)',
                  Icons.attach_money,
                  isNumber: true,
                ),
                const SizedBox(height: 10),
                _sheetField(
                  busCtrl,
                  'Bus Number (or "All")',
                  Icons.directions_bus,
                ),
                const SizedBox(height: 10),
                _sheetField(
                  dateCtrl,
                  'Date (e.g. 24 Apr 2026)',
                  Icons.calendar_today,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Type',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: CostType.values.map((t) {
                    final label = t.name[0].toUpperCase() + t.name.substring(1);
                    final sel = selectedType == t;
                    return ChoiceChip(
                      label: Text(label),
                      selected: sel,
                      onSelected: (_) => setLocal(() => selectedType = t),
                      backgroundColor: const Color(0xFF2A2A2A),
                      selectedColor: _brand,
                      labelStyle: TextStyle(
                        color: sel ? Colors.white : Colors.white54,
                        fontSize: 12,
                      ),
                      side: BorderSide.none,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save, size: 18),
                    label: const Text(
                      'Add Expense',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _brand,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final desc = descCtrl.text.trim();
                      final amount =
                          double.tryParse(amountCtrl.text.trim()) ?? 0;
                      final date = dateCtrl.text.trim();
                      if (desc.isEmpty || amount <= 0 || date.isEmpty) {
                        _snack('Please fill all required fields');
                        return;
                      }
                      final newId =
                          'C-${(_costs.length + 1).toString().padLeft(3, '0')}';
                      setState(() {
                        _costs.add(
                          CostEntry(
                            id: newId,
                            description: desc,
                            type: selectedType,
                            amount: amount,
                            date: date,
                            busNumber: busCtrl.text.trim().isEmpty
                                ? '—'
                                : busCtrl.text.trim(),
                          ),
                        );
                      });
                      Navigator.pop(ctx);
                      _snack('Expense added');
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

  Widget _sheetField(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
