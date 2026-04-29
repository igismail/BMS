import 'package:flutter/material.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

enum BusStatus { active, maintenance, retired }

class Bus {
  final String id;
  final String plateNumber;
  final String model;
  final int capacity;
  BusStatus status;
  final String assignedRoute;
  final String lastService;

  Bus({
    required this.id,
    required this.plateNumber,
    required this.model,
    required this.capacity,
    this.status = BusStatus.active,
    required this.assignedRoute,
    required this.lastService,
  });
}

// ── Page ──────────────────────────────────────────────────────────────────────

/// ManageBuses — Admin page to view, add, edit and manage the bus fleet.
/// Shows a summary strip (total / active / maintenance counts),
/// a search bar, status filter chips, and a card list of all buses.
/// Tap a card to see full details. FAB opens "Add new bus" sheet.
class ManageBuses extends StatefulWidget {
  const ManageBuses({super.key});

  @override
  State<ManageBuses> createState() => _ManageBusesState();
}

class _ManageBusesState extends State<ManageBuses> {
  static const _brand = Color(0xFF630F10);

  // Sample bus fleet data
  final List<Bus> _buses = [
    Bus(
      id: 'B-001',
      plateNumber: 'CTG-1234',
      model: 'Hino AK',
      capacity: 40,
      assignedRoute: 'Dhaka → Ctg',
      lastService: '10 Apr 2026',
    ),
    Bus(
      id: 'B-002',
      plateNumber: 'CTG-5678',
      model: 'Tata LP',
      capacity: 35,
      assignedRoute: 'Ctg → Sylhet',
      lastService: '5 Apr 2026',
    ),
    Bus(
      id: 'B-003',
      plateNumber: 'DHA-9900',
      model: 'Volvo B8R',
      capacity: 44,
      status: BusStatus.maintenance,
      assignedRoute: 'Dhaka → Sylhet',
      lastService: '1 Apr 2026',
    ),
    Bus(
      id: 'B-004',
      plateNumber: 'CTG-3344',
      model: 'Scania K',
      capacity: 44,
      assignedRoute: 'Ctg → Dhaka',
      lastService: '8 Apr 2026',
    ),
    Bus(
      id: 'B-005',
      plateNumber: 'DHA-7788',
      model: 'Hino AK',
      capacity: 40,
      status: BusStatus.retired,
      assignedRoute: '—',
      lastService: '1 Jan 2026',
    ),
  ];

  BusStatus? _filterStatus;
  final _searchCtrl = TextEditingController();

  List<Bus> get _filtered {
    final q = _searchCtrl.text.toLowerCase();
    return _buses.where((b) {
      final matchSearch =
          q.isEmpty ||
          b.id.toLowerCase().contains(q) ||
          b.plateNumber.toLowerCase().contains(q) ||
          b.model.toLowerCase().contains(q) ||
          b.assignedRoute.toLowerCase().contains(q);
      final matchFilter = _filterStatus == null || b.status == _filterStatus;
      return matchSearch && matchFilter;
    }).toList();
  }

  int get _activeCount =>
      _buses.where((b) => b.status == BusStatus.active).length;
  int get _maintenanceCount =>
      _buses.where((b) => b.status == BusStatus.maintenance).length;
  int get _retiredCount =>
      _buses.where((b) => b.status == BusStatus.retired).length;

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
          'Manage Buses',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _brand,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Bus',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: _showAddSheet,
      ),
      body: Column(
        children: [
          // Summary strip
          Container(
            color: const Color(0xFF1A1A1A),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Row(
              children: [
                _statItem('Total', '${_buses.length}', Colors.white),
                _statItem('Active', '$_activeCount', const Color(0xFF2E9E5E)),
                _statItem(
                  'Maintenance',
                  '$_maintenanceCount',
                  const Color(0xFFE8A020),
                ),
                _statItem('Retired', '$_retiredCount', const Color(0xFF888888)),
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
                hintText: 'Search by ID, plate, model, route…',
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white38,
                  size: 20,
                ),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.white38,
                          size: 18,
                        ),
                        onPressed: () => setState(() => _searchCtrl.clear()),
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children:
                  {
                    'All': null,
                    'Active': BusStatus.active,
                    'Maintenance': BusStatus.maintenance,
                    'Retired': BusStatus.retired,
                  }.entries.map((e) {
                    final selected = _filterStatus == e.value;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(e.key),
                        selected: selected,
                        onSelected: (_) =>
                            setState(() => _filterStatus = e.value),
                        backgroundColor: const Color(0xFF1E1E1E),
                        selectedColor: _brand,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.white54,
                          fontSize: 12,
                        ),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 4),
          // Bus list
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No buses found',
                      style: TextStyle(color: Colors.white38, fontSize: 15),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _BusCard(
                      bus: _filtered[i],
                      onEdit: () => _showEditSheet(_filtered[i]),
                      onToggleMaintenance: () =>
                          _toggleMaintenance(_filtered[i]),
                      onRetire: () => _retire(_filtered[i]),
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
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }

  void _toggleMaintenance(Bus bus) {
    setState(() {
      bus.status = bus.status == BusStatus.maintenance
          ? BusStatus.active
          : BusStatus.maintenance;
    });
    _snack(
      bus.status == BusStatus.maintenance
          ? '${bus.id} sent to maintenance'
          : '${bus.id} marked active',
    );
  }

  void _retire(Bus bus) {
    setState(() => bus.status = BusStatus.retired);
    _snack('${bus.id} retired');
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

  void _showAddSheet() => _showBusSheet();

  void _showEditSheet(Bus bus) => _showBusSheet(existing: bus);

  void _showBusSheet({Bus? existing}) {
    final plateCtrl = TextEditingController(text: existing?.plateNumber ?? '');
    final modelCtrl = TextEditingController(text: existing?.model ?? '');
    final capacityCtrl = TextEditingController(
      text: existing?.capacity.toString() ?? '',
    );
    final routeCtrl = TextEditingController(
      text: existing?.assignedRoute ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
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
              Text(
                existing == null ? 'Add New Bus' : 'Edit ${existing.id}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _sheetField(
                plateCtrl,
                'Plate Number (e.g. CTG-1234)',
                Icons.directions_bus,
              ),
              const SizedBox(height: 10),
              _sheetField(modelCtrl, 'Bus Model (e.g. Hino AK)', Icons.build),
              const SizedBox(height: 10),
              _sheetField(
                capacityCtrl,
                'Seat Capacity',
                Icons.event_seat,
                isNumber: true,
              ),
              const SizedBox(height: 10),
              _sheetField(routeCtrl, 'Assigned Route', Icons.route),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save, size: 18),
                  label: Text(
                    existing == null ? 'Add Bus' : 'Save Changes',
                    style: const TextStyle(
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
                    final plate = plateCtrl.text.trim();
                    final model = modelCtrl.text.trim();
                    final cap = int.tryParse(capacityCtrl.text.trim()) ?? 0;
                    final route = routeCtrl.text.trim();

                    if (plate.isEmpty || model.isEmpty || cap <= 0) {
                      _snack('Please fill all required fields');
                      return;
                    }

                    setState(() {
                      if (existing == null) {
                        final newId =
                            'B-${(_buses.length + 1).toString().padLeft(3, '0')}';
                        _buses.add(
                          Bus(
                            id: newId,
                            plateNumber: plate,
                            model: model,
                            capacity: cap,
                            assignedRoute: route.isEmpty ? '—' : route,
                            lastService: '—',
                          ),
                        );
                        _snack('$newId added successfully');
                      } else {
                        // Update existing (in a real app you'd update the model fields)
                        _snack('${existing.id} updated');
                      }
                    });
                    Navigator.pop(ctx);
                  },
                ),
              ),
            ],
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

// ── Bus Card ──────────────────────────────────────────────────────────────────

class _BusCard extends StatelessWidget {
  const _BusCard({
    required this.bus,
    required this.onEdit,
    required this.onToggleMaintenance,
    required this.onRetire,
  });

  final Bus bus;
  final VoidCallback onEdit;
  final VoidCallback onToggleMaintenance;
  final VoidCallback onRetire;

  Color get _statusColor => switch (bus.status) {
    BusStatus.active => const Color(0xFF2E9E5E),
    BusStatus.maintenance => const Color(0xFFE8A020),
    BusStatus.retired => const Color(0xFF888888),
  };

  String get _statusLabel => switch (bus.status) {
    BusStatus.active => 'Active',
    BusStatus.maintenance => 'Maintenance',
    BusStatus.retired => 'Retired',
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
              Text(
                bus.id,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            bus.plateNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            bus.model,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _chip(Icons.event_seat, '${bus.capacity} seats'),
              _chip(Icons.route, bus.assignedRoute),
              _chip(Icons.build, 'Service: ${bus.lastService}'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (bus.status != BusStatus.retired) ...[
                _btn(
                  bus.status == BusStatus.maintenance
                      ? 'Mark Active'
                      : 'Maintenance',
                  bus.status == BusStatus.maintenance
                      ? const Color(0xFF2E9E5E)
                      : const Color(0xFFE8A020),
                  onToggleMaintenance,
                ),
                const SizedBox(width: 6),
              ],
              _btn('Edit', const Color(0xFF378ADD), onEdit),
              if (bus.status != BusStatus.retired) ...[
                const SizedBox(width: 6),
                _btn('Retire', const Color(0xFF888888), onRetire),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white38, size: 12),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
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
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
