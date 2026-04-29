import 'package:flutter/material.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

enum TripStatus { scheduled, ongoing, completed, cancelled }

class Trip {
  final String id;
  final String route;
  final String busNumber;
  final String driverName;
  final String departure;
  final String arrival;
  final String date;
  TripStatus status;
  final int totalSeats;
  final int bookedSeats;

  Trip({
    required this.id,
    required this.route,
    required this.busNumber,
    required this.driverName,
    required this.departure,
    required this.arrival,
    required this.date,
    this.status = TripStatus.scheduled,
    required this.totalSeats,
    required this.bookedSeats,
  });

  int get availableSeats => totalSeats - bookedSeats;
}

// ── Page ──────────────────────────────────────────────────────────────────────

/// ManageTrips — Admin page to view and manage all bus trips and schedules.
/// Shows a summary strip (total / ongoing / completed counts),
/// search bar, status filters, and a card for each trip.
/// FAB opens the "Schedule new trip" sheet.
class ManageTrips extends StatefulWidget {
  const ManageTrips({super.key});

  @override
  State<ManageTrips> createState() => _ManageTripsState();
}

class _ManageTripsState extends State<ManageTrips> {
  static const _brand = Color(0xFF630F10);

  final List<Trip> _trips = [
    Trip(
      id: 'TR-001',
      route: 'Dhaka → Ctg',
      busNumber: 'Bus #05',
      driverName: 'Jalal Uddin',
      departure: '08:00 AM',
      arrival: '02:00 PM',
      date: '24 Apr 2026',
      status: TripStatus.completed,
      totalSeats: 40,
      bookedSeats: 38,
    ),
    Trip(
      id: 'TR-002',
      route: 'Ctg → Sylhet',
      busNumber: 'Bus #09',
      driverName: 'Faruk Hossain',
      departure: '10:30 AM',
      arrival: '05:30 PM',
      date: '24 Apr 2026',
      status: TripStatus.ongoing,
      totalSeats: 35,
      bookedSeats: 22,
    ),
    Trip(
      id: 'TR-003',
      route: 'Dhaka → Sylhet',
      busNumber: 'Bus #12',
      driverName: 'Karim Mia',
      departure: '01:00 PM',
      arrival: '07:00 PM',
      date: '24 Apr 2026',
      totalSeats: 44,
      bookedSeats: 15,
    ),
    Trip(
      id: 'TR-004',
      route: 'Ctg → Dhaka',
      busNumber: 'Bus #03',
      driverName: 'Alam Sheikh',
      departure: '03:00 PM',
      arrival: '09:00 PM',
      date: '24 Apr 2026',
      status: TripStatus.cancelled,
      totalSeats: 40,
      bookedSeats: 0,
    ),
    Trip(
      id: 'TR-005',
      route: 'Dhaka → Ctg',
      busNumber: 'Bus #05',
      driverName: 'Jalal Uddin',
      departure: '06:00 PM',
      arrival: '12:00 AM',
      date: '25 Apr 2026',
      totalSeats: 40,
      bookedSeats: 5,
    ),
  ];

  TripStatus? _filterStatus;
  final _searchCtrl = TextEditingController();

  List<Trip> get _filtered {
    final q = _searchCtrl.text.toLowerCase();
    return _trips.where((t) {
      final matchSearch =
          q.isEmpty ||
          t.id.toLowerCase().contains(q) ||
          t.route.toLowerCase().contains(q) ||
          t.busNumber.toLowerCase().contains(q) ||
          t.driverName.toLowerCase().contains(q);
      final matchFilter = _filterStatus == null || t.status == _filterStatus;
      return matchSearch && matchFilter;
    }).toList();
  }

  int get _scheduledCount =>
      _trips.where((t) => t.status == TripStatus.scheduled).length;
  int get _ongoingCount =>
      _trips.where((t) => t.status == TripStatus.ongoing).length;
  int get _completedCount =>
      _trips.where((t) => t.status == TripStatus.completed).length;

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
          'Manage Trips',
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
        icon: const Icon(Icons.add_road),
        label: const Text(
          'Schedule Trip',
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
                _statItem('Total', '${_trips.length}', Colors.white),
                _statItem(
                  'Scheduled',
                  '$_scheduledCount',
                  const Color(0xFF378ADD),
                ),
                _statItem('Ongoing', '$_ongoingCount', const Color(0xFFE8A020)),
                _statItem(
                  'Completed',
                  '$_completedCount',
                  const Color(0xFF2E9E5E),
                ),
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
                hintText: 'Search by route, bus, driver…',
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
                    'Scheduled': TripStatus.scheduled,
                    'Ongoing': TripStatus.ongoing,
                    'Completed': TripStatus.completed,
                    'Cancelled': TripStatus.cancelled,
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
          // Trips list
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No trips found',
                      style: TextStyle(color: Colors.white38, fontSize: 15),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _TripCard(
                      trip: _filtered[i],
                      onMarkOngoing: () =>
                          _setStatus(_filtered[i], TripStatus.ongoing),
                      onMarkCompleted: () =>
                          _setStatus(_filtered[i], TripStatus.completed),
                      onCancel: () =>
                          _setStatus(_filtered[i], TripStatus.cancelled),
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

  void _setStatus(Trip trip, TripStatus newStatus) {
    setState(() => trip.status = newStatus);
    final msg = switch (newStatus) {
      TripStatus.ongoing => '${trip.id} is now ongoing',
      TripStatus.completed => '${trip.id} marked as completed',
      TripStatus.cancelled => '${trip.id} cancelled',
      TripStatus.scheduled => '${trip.id} rescheduled',
    };
    _snack(msg);
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
    final routeCtrl = TextEditingController();
    final busCtrl = TextEditingController();
    final driverCtrl = TextEditingController();
    final deptCtrl = TextEditingController();
    final arrCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    final seatsCtrl = TextEditingController();

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
              const Text(
                'Schedule New Trip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _sheetField(routeCtrl, 'Route (e.g. Dhaka → Ctg)', Icons.route),
              const SizedBox(height: 10),
              _sheetField(busCtrl, 'Bus Number', Icons.directions_bus),
              const SizedBox(height: 10),
              _sheetField(driverCtrl, 'Driver Name', Icons.person),
              const SizedBox(height: 10),
              _sheetField(
                deptCtrl,
                'Departure Time (e.g. 08:00 AM)',
                Icons.schedule,
              ),
              const SizedBox(height: 10),
              _sheetField(
                arrCtrl,
                'Arrival Time (e.g. 02:00 PM)',
                Icons.schedule_outlined,
              ),
              const SizedBox(height: 10),
              _sheetField(
                dateCtrl,
                'Date (e.g. 25 Apr 2026)',
                Icons.calendar_today,
              ),
              const SizedBox(height: 10),
              _sheetField(
                seatsCtrl,
                'Total Seats',
                Icons.event_seat,
                isNumber: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_road, size: 18),
                  label: const Text(
                    'Schedule Trip',
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
                    final route = routeCtrl.text.trim();
                    final dept = deptCtrl.text.trim();
                    final date = dateCtrl.text.trim();
                    final seats = int.tryParse(seatsCtrl.text.trim()) ?? 0;
                    if (route.isEmpty ||
                        dept.isEmpty ||
                        date.isEmpty ||
                        seats <= 0) {
                      _snack('Please fill all required fields');
                      return;
                    }
                    final newId =
                        'TR-${(_trips.length + 1).toString().padLeft(3, '0')}';
                    setState(() {
                      _trips.add(
                        Trip(
                          id: newId,
                          route: route,
                          busNumber: busCtrl.text.trim().isEmpty
                              ? '—'
                              : busCtrl.text.trim(),
                          driverName: driverCtrl.text.trim().isEmpty
                              ? '—'
                              : driverCtrl.text.trim(),
                          departure: dept,
                          arrival: arrCtrl.text.trim().isEmpty
                              ? '—'
                              : arrCtrl.text.trim(),
                          date: date,
                          totalSeats: seats,
                          bookedSeats: 0,
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                    _snack('$newId scheduled successfully');
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

// ── Trip Card ─────────────────────────────────────────────────────────────────

class _TripCard extends StatelessWidget {
  const _TripCard({
    required this.trip,
    required this.onMarkOngoing,
    required this.onMarkCompleted,
    required this.onCancel,
  });

  final Trip trip;
  final VoidCallback onMarkOngoing;
  final VoidCallback onMarkCompleted;
  final VoidCallback onCancel;

  Color get _statusColor => switch (trip.status) {
    TripStatus.scheduled => const Color(0xFF378ADD),
    TripStatus.ongoing => const Color(0xFFE8A020),
    TripStatus.completed => const Color(0xFF2E9E5E),
    TripStatus.cancelled => const Color(0xFFE24B4A),
  };

  String get _statusLabel => switch (trip.status) {
    TripStatus.scheduled => 'Scheduled',
    TripStatus.ongoing => 'Ongoing',
    TripStatus.completed => 'Completed',
    TripStatus.cancelled => 'Cancelled',
  };

  @override
  Widget build(BuildContext context) {
    final fillPct = trip.totalSeats > 0
        ? trip.bookedSeats / trip.totalSeats
        : 0.0;

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
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                trip.id,
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
          // Route
          Text(
            trip.route,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            trip.date,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 8),
          // Info chips
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _chip(Icons.access_time, '${trip.departure} → ${trip.arrival}'),
              _chip(Icons.directions_bus, trip.busNumber),
              _chip(Icons.person, trip.driverName),
            ],
          ),
          const SizedBox(height: 10),
          // Seat fill bar
          Row(
            children: [
              const Text(
                'Seats:',
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fillPct,
                    backgroundColor: Colors.white12,
                    color: fillPct > 0.8
                        ? const Color(0xFFE24B4A)
                        : const Color(0xFF2E9E5E),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${trip.bookedSeats}/${trip.totalSeats}',
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Action buttons
          if (trip.status != TripStatus.cancelled &&
              trip.status != TripStatus.completed)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (trip.status == TripStatus.scheduled)
                  _btn('Start Trip', const Color(0xFFE8A020), onMarkOngoing),
                if (trip.status == TripStatus.ongoing) ...[
                  _btn('Complete', const Color(0xFF2E9E5E), onMarkCompleted),
                ],
                const SizedBox(width: 6),
                _btn('Cancel', const Color(0xFFE24B4A), onCancel),
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
