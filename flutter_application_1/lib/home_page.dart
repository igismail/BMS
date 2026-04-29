import 'package:flutter/material.dart';
import 'ticketManagementPage.dart';
import 'manage_buses.dart';
import 'manage_employee.dart';
import 'manage_trips.dart';
import 'manage_costs.dart';

// ── Admin Home Page ────────────────────────────────────────────────────────────
//
// The main dashboard shown after admin login.
// Contains:
//  • A hero welcome section
//  • Stats strip (buses, employees, active trips, tickets sold)
//  • A 2-column card grid — each card navigates to its management page
//  • Recent alerts list
//  • Ticket quick-action buttons at the bottom

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _brand = Color(0xFF630F10);

  static const _stats = [
    {'label': 'Buses', 'value': '24'},
    {'label': 'Employees', 'value': '58'},
    {'label': 'Active trips', 'value': '12'},
    {'label': 'Tickets sold', 'value': '134'},
  ];

  static const _cards = [
    {
      'title': 'Buses',
      'sub': 'Fleet & maintenance',
      'icon': Icons.directions_bus,
    },
    {'title': 'Employees', 'sub': 'Drivers & staff', 'icon': Icons.people},
    {'title': 'Trips', 'sub': 'Routes & schedules', 'icon': Icons.route},
    {
      'title': 'Ticket Management',
      'sub': 'Sales & validation',
      'icon': Icons.confirmation_number,
    },
    {'title': 'Earnings', 'sub': 'Revenue & costs', 'icon': Icons.attach_money},
    {'title': 'Passengers', 'sub': 'Bookings & records', 'icon': Icons.badge},
  ];

  static const _alerts = [
    {'msg': 'Bus #14 maintenance due in 3 days', 'warn': true},
    {'msg': 'Trip #7 completed — Dhaka → Ctg', 'warn': false},
    {'msg': '3 tickets pending validation today', 'warn': true},
    {'msg': 'Ticket TK-012 cancelled by passenger', 'warn': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: _brand,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_bus, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Bus Company App',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            tooltip: 'Scan & validate ticket',
            onPressed: () => _openTicketPage(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(),
            const SizedBox(height: 24),
            _buildStats(),
            const SizedBox(height: 28),
            _buildSectionLabel('Management'),
            const SizedBox(height: 12),
            _buildCardGrid(context),
            const SizedBox(height: 28),
            _buildSectionLabel('Recent alerts'),
            const SizedBox(height: 12),
            _buildAlerts(),
            const SizedBox(height: 24),
            _buildTicketQuickActions(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────
  Widget _buildHero() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_bus,
              size: 36,
              color: Color(0xFFC1BEBE),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Welcome to Bus Management System',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Manage buses, employees, trips and tickets',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ── Stats ─────────────────────────────────────────────────────────────────
  Widget _buildStats() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.8,
      ),
      itemBuilder: (_, i) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              _stats[i]['value']!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _stats[i]['label']!,
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section label ─────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: Colors.white38,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
      ),
    );
  }

  // ── Card grid ─────────────────────────────────────────────────────────────
  Widget _buildCardGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (_, i) => _NavCard(
        title: _cards[i]['title'] as String,
        subtitle: _cards[i]['sub'] as String,
        icon: _cards[i]['icon'] as IconData,
        highlight: _cards[i]['title'] == 'Ticket Management',
        onTap: () => _onCardTap(context, _cards[i]['title'] as String),
      ),
    );
  }

  // ── Alerts ────────────────────────────────────────────────────────────────
  Widget _buildAlerts() {
    return Column(
      children: _alerts.map((a) {
        final isWarn = a['warn'] as bool;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isWarn
                      ? const Color(0xFFE8A020)
                      : const Color(0xFF2E9E5E),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  a['msg'] as String,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── Ticket quick-action strip ─────────────────────────────────────────────
  Widget _buildTicketQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Ticket quick actions'),
        const SizedBox(height: 12),
        Row(
          children: [
            _QuickActionBtn(
              icon: Icons.add_circle_outline,
              label: 'Issue ticket',
              color: const Color(0xFF2E9E5E),
              onTap: () => _openTicketPage(context, action: 'add'),
            ),
            const SizedBox(width: 10),
            _QuickActionBtn(
              icon: Icons.qr_code_scanner,
              label: 'Validate',
              color: const Color(0xFF378ADD),
              onTap: () => _openTicketPage(context, action: 'scan'),
            ),
            const SizedBox(width: 10),
            _QuickActionBtn(
              icon: Icons.list_alt,
              label: 'All tickets',
              color: const Color(0xFFE8A020),
              onTap: () => _openTicketPage(context),
            ),
            const SizedBox(width: 10),
            _QuickActionBtn(
              icon: Icons.cancel_outlined,
              label: 'Cancellations',
              color: const Color(0xFFE24B4A),
              onTap: () => _openTicketPage(context, action: 'cancelled'),
            ),
          ],
        ),
      ],
    );
  }

  // ── Navigation ────────────────────────────────────────────────────────────
  void _onCardTap(BuildContext context, String title) {
    switch (title) {
      case 'Buses':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ManageBuses()),
        );
        break;
      case 'Employees':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ManageEmployee()),
        );
        break;
      case 'Trips':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ManageTrips()),
        );
        break;
      case 'Ticket Management':
        _openTicketPage(context);
        break;
      case 'Earnings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ManageCosts()),
        );
        break;
      case 'Passengers':
        // Shows the ticket list filtered to passengers
        _openTicketPage(context);
        break;
      default:
        break;
    }
  }

  void _openTicketPage(BuildContext context, {String? action}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TicketManagementPage(initialAction: action),
      ),
    );
  }
}

// ── Nav Card ──────────────────────────────────────────────────────────────────
class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.highlight = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool highlight;

  static const _brand = Color(0xFF630F10);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(14),
          border: highlight
              ? Border.all(color: _brand.withOpacity(0.6), width: 1.5)
              : Border.all(color: Colors.transparent),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _brand,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                const Spacer(),
                if (highlight)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _brand.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Color(0xFFFF6B6B),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quick Action Button ───────────────────────────────────────────────────────
class _QuickActionBtn extends StatelessWidget {
  const _QuickActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 5),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
