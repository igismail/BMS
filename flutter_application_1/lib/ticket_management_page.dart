import 'package:flutter/material.dart';

// ── Models ────────────────────────────────────────────────────────────────────

enum TicketStatus { active, used, cancelled }

class Ticket {
  final String id;
  final String passengerName;
  final String phone;
  final String route;
  final String busNumber;
  final String departure;
  final String seat;
  final double price;
  TicketStatus status;
  final DateTime issuedAt;

  Ticket({
    required this.id,
    required this.passengerName,
    required this.phone,
    required this.route,
    required this.busNumber,
    required this.departure,
    required this.seat,
    required this.price,
    this.status = TicketStatus.active,
    DateTime? issuedAt,
  }) : issuedAt = issuedAt ?? DateTime.now();
}

// ── Page ──────────────────────────────────────────────────────────────────────

class TicketManagementPage extends StatefulWidget {
  const TicketManagementPage({super.key, this.initialAction});

  // 'add'       → open new ticket sheet immediately
  // 'scan'      → open scan dialog immediately
  // 'cancelled' → pre-filter to cancelled
  // null        → normal open
  final String? initialAction;

  @override
  State<TicketManagementPage> createState() => _TicketManagementPageState();
}

class _TicketManagementPageState extends State<TicketManagementPage> {
  static const _brand = Color(0xFF630F10);

  // ── Sample data — replace with your real data source ──────────────────
  final List<Ticket> _tickets = [
    Ticket(
      id: 'TK-001',
      passengerName: 'Arif Hossain',
      phone: '01711-000001',
      route: 'Dhaka → Ctg',
      busNumber: 'Bus #05',
      departure: '08:00 AM',
      seat: 'A1',
      price: 550,
      issuedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Ticket(
      id: 'TK-002',
      passengerName: 'Mitu Begum',
      phone: '01822-000002',
      route: 'Ctg → Sylhet',
      busNumber: 'Bus #09',
      departure: '10:30 AM',
      seat: 'B3',
      price: 480,
      status: TicketStatus.used,
      issuedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Ticket(
      id: 'TK-003',
      passengerName: 'Rahim Uddin',
      phone: '01933-000003',
      route: 'Dhaka → Sylhet',
      busNumber: 'Bus #12',
      departure: '01:00 PM',
      seat: 'C2',
      price: 700,
      issuedAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Ticket(
      id: 'TK-004',
      passengerName: 'Nadia Islam',
      phone: '01600-000004',
      route: 'Ctg → Dhaka',
      busNumber: 'Bus #03',
      departure: '03:00 PM',
      seat: 'D5',
      price: 550,
      status: TicketStatus.cancelled,
      issuedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Ticket(
      id: 'TK-005',
      passengerName: 'Kamal Ahmed',
      phone: '01555-000005',
      route: 'Dhaka → Ctg',
      busNumber: 'Bus #05',
      departure: '06:00 PM',
      seat: 'A4',
      price: 550,
      issuedAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Ticket(
      id: 'TK-006',
      passengerName: 'Sumaiya Khatun',
      phone: '01777-000006',
      route: 'Sylhet → Dhaka',
      busNumber: 'Bus #07',
      departure: '09:00 AM',
      seat: 'B1',
      price: 700,
      status: TicketStatus.used,
      issuedAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
  ];

  TicketStatus? _filterStatus;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialAction == 'cancelled') {
      _filterStatus = TicketStatus.cancelled;
    }
    if (widget.initialAction == 'add' || widget.initialAction == 'scan') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.initialAction == 'add') _showAddSheet();
        if (widget.initialAction == 'scan') _showScanDialog();
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Derived data ───────────────────────────────────────────────────────
  List<Ticket> get _filtered {
    final q = _searchCtrl.text.toLowerCase();
    return _tickets.where((t) {
      final matchSearch =
          q.isEmpty ||
          t.passengerName.toLowerCase().contains(q) ||
          t.id.toLowerCase().contains(q) ||
          t.route.toLowerCase().contains(q) ||
          t.phone.contains(q) ||
          t.busNumber.toLowerCase().contains(q);
      final matchFilter = _filterStatus == null || t.status == _filterStatus;
      return matchSearch && matchFilter;
    }).toList();
  }

  int get _activeCount =>
      _tickets.where((t) => t.status == TicketStatus.active).length;
  int get _usedCount =>
      _tickets.where((t) => t.status == TicketStatus.used).length;
  int get _cancelledCount =>
      _tickets.where((t) => t.status == TicketStatus.cancelled).length;
  double get _totalRevenue => _tickets
      .where((t) => t.status != TicketStatus.cancelled)
      .fold(0, (sum, t) => sum + t.price);

  // ── Build ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: _brand,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Ticket Management',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            tooltip: 'Scan & validate',
            onPressed: _showScanDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _brand,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Issue ticket',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: _showAddSheet,
      ),
      body: Column(
        children: [
          _buildSummaryStrip(),
          _buildSearchBar(),
          _buildFilterChips(),
          const SizedBox(height: 4),
          Expanded(
            child: _filtered.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _TicketCard(
                      ticket: _filtered[i],
                      onMarkUsed: () =>
                          _setStatus(_filtered[i], TicketStatus.used),
                      onCancel: () =>
                          _setStatus(_filtered[i], TicketStatus.cancelled),
                      onReactivate: () =>
                          _setStatus(_filtered[i], TicketStatus.active),
                      onDelete: () => _deleteTicket(_filtered[i]),
                      onViewDetail: () => _showDetailSheet(_filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Summary strip ──────────────────────────────────────────────────────
  Widget _buildSummaryStrip() {
    final items = [
      {'label': 'Total', 'value': '${_tickets.length}', 'color': Colors.white},
      {
        'label': 'Active',
        'value': '$_activeCount',
        'color': const Color(0xFF2E9E5E),
      },
      {
        'label': 'Used',
        'value': '$_usedCount',
        'color': const Color(0xFF888888),
      },
      {
        'label': 'Cancelled',
        'value': '$_cancelledCount',
        'color': const Color(0xFFE24B4A),
      },
      {
        'label': 'Revenue',
        'value': '৳${_totalRevenue.toStringAsFixed(0)}',
        'color': const Color(0xFFF0A500),
      },
    ];

    return Container(
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Row(
        children: items
            .map(
              (item) => Expanded(
                child: Column(
                  children: [
                    Text(
                      item['value'] as String,
                      style: TextStyle(
                        color: item['color'] as Color,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['label'] as String,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ── Search bar ─────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search by name, ID, route, phone…',
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 20),
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
    );
  }

  // ── Filter chips ───────────────────────────────────────────────────────
  Widget _buildFilterChips() {
    final filters = <String, TicketStatus?>{
      'All': null,
      'Active': TicketStatus.active,
      'Used': TicketStatus.used,
      'Cancelled': TicketStatus.cancelled,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: filters.entries.map((e) {
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
                fontSize: 12,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            color: Colors.white24,
            size: 64,
          ),
          SizedBox(height: 14),
          Text(
            'No tickets found',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Try a different search or filter',
            style: TextStyle(color: Colors.white24, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ── Actions ────────────────────────────────────────────────────────────
  void _setStatus(Ticket ticket, TicketStatus newStatus) {
    setState(() => ticket.status = newStatus);
    final msg = switch (newStatus) {
      TicketStatus.used => '${ticket.id} marked as used',
      TicketStatus.cancelled => '${ticket.id} cancelled',
      TicketStatus.active => '${ticket.id} reactivated',
    };
    _showSnack(msg);
  }

  void _deleteTicket(Ticket ticket) {
    setState(() => _tickets.remove(ticket));
    _showSnack('${ticket.id} deleted');
  }

  void _showSnack(String msg) {
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

  // ── Add ticket sheet ───────────────────────────────────────────────────
  void _showAddSheet() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final routeCtrl = TextEditingController();
    final busCtrl = TextEditingController();
    final deptCtrl = TextEditingController();
    final seatCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

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
              // Sheet handle
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
                'Issue new ticket',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Fill in the passenger and trip details',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
              const SizedBox(height: 20),

              // Fields
              _sheetField(nameCtrl, 'Passenger name', Icons.person),
              const SizedBox(height: 10),
              _sheetField(
                phoneCtrl,
                'Phone number',
                Icons.phone,
                isPhone: true,
              ),
              const SizedBox(height: 10),
              _sheetField(routeCtrl, 'Route (e.g. Dhaka → Ctg)', Icons.route),
              const SizedBox(height: 10),
              _sheetField(busCtrl, 'Bus number', Icons.directions_bus),
              const SizedBox(height: 10),
              _sheetField(deptCtrl, 'Departure time', Icons.access_time),
              const SizedBox(height: 10),
              _sheetField(seatCtrl, 'Seat number', Icons.event_seat),
              const SizedBox(height: 10),
              _sheetField(
                priceCtrl,
                'Price (৳)',
                Icons.attach_money,
                isNumber: true,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.confirmation_number, size: 18),
                  label: const Text(
                    'Issue ticket',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                    final name = nameCtrl.text.trim();
                    final phone = phoneCtrl.text.trim();
                    final route = routeCtrl.text.trim();
                    final bus = busCtrl.text.trim();
                    final dept = deptCtrl.text.trim();
                    final seat = seatCtrl.text.trim();
                    final price = double.tryParse(priceCtrl.text.trim()) ?? 0;

                    if (name.isEmpty ||
                        route.isEmpty ||
                        dept.isEmpty ||
                        seat.isEmpty ||
                        price <= 0) {
                      _showSnack('Please fill all required fields');
                      return;
                    }

                    final newId =
                        'TK-${(_tickets.length + 1).toString().padLeft(3, '0')}';

                    setState(() {
                      _tickets.add(
                        Ticket(
                          id: newId,
                          passengerName: name,
                          phone: phone,
                          route: route,
                          busNumber: bus.isEmpty ? '—' : bus,
                          departure: dept,
                          seat: seat,
                          price: price,
                        ),
                      );
                    });

                    Navigator.pop(ctx);
                    _showSnack('$newId issued successfully');
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
    bool isPhone = false,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber
          ? TextInputType.number
          : isPhone
          ? TextInputType.phone
          : TextInputType.text,
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

  // ── Detail bottom sheet ────────────────────────────────────────────────
  void _showDetailSheet(Ticket ticket) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 36),
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

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ticket.id,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _StatusBadge(status: ticket.status),
              ],
            ),
            const SizedBox(height: 20),

            // Details grid
            _detailRow(Icons.person, 'Passenger', ticket.passengerName),
            _detailRow(Icons.phone, 'Phone', ticket.phone),
            _detailRow(Icons.route, 'Route', ticket.route),
            _detailRow(Icons.directions_bus, 'Bus', ticket.busNumber),
            _detailRow(Icons.access_time, 'Departure', ticket.departure),
            _detailRow(Icons.event_seat, 'Seat', ticket.seat),
            _detailRow(
              Icons.attach_money,
              'Price',
              '৳${ticket.price.toStringAsFixed(0)}',
            ),
            _detailRow(
              Icons.calendar_today,
              'Issued at',
              '${ticket.issuedAt.day}/${ticket.issuedAt.month}/${ticket.issuedAt.year} '
                  '${ticket.issuedAt.hour.toString().padLeft(2, '0')}:${ticket.issuedAt.minute.toString().padLeft(2, '0')}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 16),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── QR scan dialog ─────────────────────────────────────────────────────
  void _showScanDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Scan ticket',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white38,
                size: 80,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Point the camera at a ticket QR code to validate it instantly.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 6),
            const Text(
              'Integrate mobile_scanner package to activate.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white24,
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFF630F10)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Ticket card ───────────────────────────────────────────────────────────────

class _TicketCard extends StatelessWidget {
  const _TicketCard({
    required this.ticket,
    required this.onMarkUsed,
    required this.onCancel,
    required this.onReactivate,
    required this.onDelete,
    required this.onViewDetail,
  });

  final Ticket ticket;
  final VoidCallback onMarkUsed;
  final VoidCallback onCancel;
  final VoidCallback onReactivate;
  final VoidCallback onDelete;
  final VoidCallback onViewDetail;

  Color get _statusColor => switch (ticket.status) {
    TicketStatus.active => const Color(0xFF2E9E5E),
    TicketStatus.used => const Color(0xFF888888),
    TicketStatus.cancelled => const Color(0xFFE24B4A),
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewDetail,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: _statusColor, width: 3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ticket.id,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  _StatusBadge(status: ticket.status),
                ],
              ),
              const SizedBox(height: 8),

              // Passenger name
              Text(
                ticket.passengerName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                ticket.phone,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
              const SizedBox(height: 8),

              // Route / bus / seat row
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  _InfoChip(Icons.route, ticket.route),
                  _InfoChip(Icons.directions_bus, ticket.busNumber),
                  _InfoChip(Icons.access_time, ticket.departure),
                  _InfoChip(Icons.event_seat, 'Seat ${ticket.seat}'),
                ],
              ),
              const SizedBox(height: 10),

              // Price + actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '৳${ticket.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Color(0xFFF0A500),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildActions(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    return switch (ticket.status) {
      TicketStatus.active => Row(
        children: [
          _ActionBtn(
            label: 'Mark used',
            color: const Color(0xFF2E9E5E),
            onTap: onMarkUsed,
          ),
          const SizedBox(width: 6),
          _ActionBtn(
            label: 'Cancel',
            color: const Color(0xFFE24B4A),
            onTap: onCancel,
          ),
        ],
      ),
      TicketStatus.used => Row(
        children: [
          _ActionBtn(
            label: 'Reactivate',
            color: const Color(0xFF378ADD),
            onTap: onReactivate,
          ),
          const SizedBox(width: 6),
          _DeleteBtn(onTap: onDelete),
        ],
      ),
      TicketStatus.cancelled => Row(
        children: [
          _ActionBtn(
            label: 'Reactivate',
            color: const Color(0xFF378ADD),
            onTap: onReactivate,
          ),
          const SizedBox(width: 6),
          _DeleteBtn(onTap: onDelete),
        ],
      ),
    };
  }
}

// ── Small reusable widgets ────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final TicketStatus status;

  Color get _color => switch (status) {
    TicketStatus.active => const Color(0xFF2E9E5E),
    TicketStatus.used => const Color(0xFF888888),
    TicketStatus.cancelled => const Color(0xFFE24B4A),
  };

  String get _label => switch (status) {
    TicketStatus.active => 'Active',
    TicketStatus.used => 'Used',
    TicketStatus.cancelled => 'Cancelled',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: _color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
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
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.label,
    required this.color,
    required this.onTap,
  });
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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

class _DeleteBtn extends StatelessWidget {
  const _DeleteBtn({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(7),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white38,
          size: 16,
        ),
      ),
    );
  }
}
