import 'package:firebase_nexus/appColors.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'adminTransactionHistory.dart';
import 'discountPages/discountList.dart';

void main() {
  runApp(const AdminHome());
}

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFFAF6EE),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (c) => const DashboardPage(),
        '/products': (c) => const PlaceholderPage(title: 'Products'),
        '/categories': (c) => const PlaceholderPage(title: 'Categories'),
        '/orders': (c) => const PlaceholderPage(title: 'Orders'),
        '/discounts': (context) => const DiscountListPage(),
        '/analytics': (c) => const PlaceholderPage(title: 'Analytics'),
        '/transactions': (c) => const adminTransactionHistory(),
        '/profile': (c) => const PlaceholderPage(title: 'Profile'),
      },
      initialRoute: '/',
    );
  }
}

class BackendService {
  static Future<UserProfile> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return UserProfile(
      displayName: 'Express-O',
      email: 'admin123@gmail.com',
      avatarUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?fit=crop&w=200&q=60',
    );
  }

  static Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

class UserProfile {
  final String displayName;
  final String email;
  final String? avatarUrl;

  UserProfile({required this.displayName, required this.email, this.avatarUrl});
}

//donut models
class DonutSegment {
  final String label;
  final double value;
  final Color color;

  DonutSegment({required this.label, required this.value, required this.color});

  factory DonutSegment.fromJson(Map<String, dynamic> json) {
    return DonutSegment(
      label: json['label'] as String,
      value: (json['value'] as num).toDouble(),
      color: Color(int.parse(json['color'] ?? '0xFFF6A048')),
    );
  }
}

class StatsOverview {
  final double totalSales;
  final int totalCustomers;

  StatsOverview({required this.totalSales, required this.totalCustomers});

  factory StatsOverview.fromJson(Map<String, dynamic> json) => StatsOverview(
        totalSales: (json['totalSales'] as num).toDouble(),
        totalCustomers: (json['totalCustomers'] as num).toInt(),
      );
}

class PendingOrder {
  final String id;
  final String name;
  final String itemsSummary;
  final double price;

  PendingOrder(
      {required this.id,
      required this.name,
      required this.itemsSummary,
      required this.price});

  factory PendingOrder.fromJson(Map<String, dynamic> json) => PendingOrder(
        id: json['id'] as String,
        name: json['name'] as String,
        itemsSummary: json['itemsSummary'] as String,
        price: (json['price'] as num).toDouble(),
      );
}

class DashboardData {
  final List<DonutSegment> donutSegments;
  final int totalOrders;
  final StatsOverview stats;
  final List<PendingOrder> pendingOrders;

  DashboardData(
      {required this.donutSegments,
      required this.totalOrders,
      required this.stats,
      required this.pendingOrders});

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final donut = (json['donut'] as List<dynamic>)
        .map((e) => DonutSegment.fromJson(e as Map<String, dynamic>))
        .toList();
    final stats = StatsOverview.fromJson(json['stats'] as Map<String, dynamic>);
    final pending = (json['pendingOrders'] as List<dynamic>)
        .map((e) => PendingOrder.fromJson(e as Map<String, dynamic>))
        .toList();
    return DashboardData(
        donutSegments: donut,
        totalOrders: (json['totalOrders'] as num).toInt(),
        stats: stats,
        pendingOrders: pending);
  }
}

class DummyData {
  static const _sampleJson = '''
  {
    "donut": [
      {"label": "Coffee", "value": 55, "color": "0xFFF09425"},
      {"label": "Pastry", "value": 25, "color": "0xFFF6B57D"},
      {"label": "Others", "value": 20, "color": "0xFF8E4B0E"}
    ],
    "totalOrders": 65,
    "stats": {"totalSales": 2500, "totalCustomers": 70},
    "pendingOrders": [
      {"id": "ORD123", "name": "Ruel Escano", "itemsSummary": "Matcha Latte, Chocolate Croissant", "price": 240},
      {"id": "ORD124", "name": "Anna Cruz", "itemsSummary": "Americano", "price": 120}
    ]
  }
  ''';

  static Future<DashboardData> fetchDashboard() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final parsed = json.decode(_sampleJson) as Map<String, dynamic>;
    return DashboardData.fromJson(parsed);
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<DashboardData> _dashboardFuture;
  late Future<UserProfile> _profileFuture;
  String _currentRoute = '/';

  @override
  void initState() {
    super.initState();
    _loadData();
    _profileFuture = BackendService.getProfile();
  }

  void _loadData() {
    _dashboardFuture = DummyData.fetchDashboard();
  }

  void _onNavigate(String route) {
    // close drawer then navigate
    Navigator.of(context).pop();
    if (route == '/logout') {
      _performLogout();
      return;
    }
    if (route != _currentRoute) {
      setState(() => _currentRoute = route);
      Navigator.of(context).pushNamed(route);
    }
  }

  Future<void> _performLogout() async {
    // example backend call for logout
    await BackendService.logout();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out (demo)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const safePadding = 16.0;
    return Scaffold(
      // attach a Drawer
      drawer: AdminDrawer(
        profileFuture: _profileFuture,
        selectedRoute: _currentRoute,
        onNavigate: _onNavigate,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: safePadding),
          child: FutureBuilder<DashboardData>(
            future: _dashboardFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final data = snapshot.data!;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildTopBar(),
                    const SizedBox(height: 12),
                    _buildDonutCard(data),
                    const SizedBox(height: 16),
                    _buildShortcutsRow(),
                    const SizedBox(height: 18),
                    _buildStatisticsOverview(data),
                    const SizedBox(height: 18),
                    _buildPendingOrders(data),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        const SizedBox(width: 6),
        const Text('Hello, Admin',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const Spacer(),
        const CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFFF08F2A),
          child: Text('AD',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildDonutCard(DashboardData data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            SizedBox(
              height: 190,
              child: Row(
                children: [
                  Expanded(
                    child: Center(child: _buildDonutChart(data)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: data.donutSegments
                  .map((seg) => _buildLegendItem(seg))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(DonutSegment seg) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: seg.color, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 6),
          Text(seg.label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildDonutChart(DashboardData data) {
    final total = data.donutSegments.fold<double>(0.0, (p, e) => p + e.value);
    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            borderData: FlBorderData(show: false),
            sectionsSpace: 2,
            centerSpaceRadius: 46,
            sections: data.donutSegments.map((seg) {
              return PieChartSectionData(
                value: seg.value,
                radius: 46,
                showTitle: false,
                color: seg.color,
              );
            }).toList(),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${data.totalOrders}',
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D3510))),
            const SizedBox(height: 4),
            const Text('Total Orders',
                style: TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        )
      ],
    );
  }

  Widget _buildShortcutsRow() {
    final items = [
      _ShortcutItem(icon: Icons.person_outline, label: 'Customers'),
      _ShortcutItem(icon: Icons.coffee_outlined, label: 'Products'),
      _ShortcutItem(icon: Icons.receipt_long, label: 'Orders'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Shortcuts', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.map((i) => _buildShortcutCard(i)).toList(),
        ),
      ],
    );
  }

  Widget _buildShortcutCard(_ShortcutItem item) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: GestureDetector(
          onTap: () => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Tapped ${item.label}'))),
          child: Container(
            height: 84,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, size: 28, color: const Color(0xFFF08F2A)),
                const SizedBox(height: 8),
                Text(item.label, style: const TextStyle(fontSize: 13))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsOverview(DashboardData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Statistics Overview',
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                    color: const Color(0xFFF08F2A),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.attach_money, color: Colors.white),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Sales',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Text('₱ ${data.stats.totalSales.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.people_outline,
                          color: Color(0xFF8E4B0E)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Customers',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Text('${data.stats.totalCustomers}',
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildPendingOrders(DashboardData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Pending Orders',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Text('· ${data.pendingOrders.length}',
                style: const TextStyle(color: Colors.black54)),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          children: data.pendingOrders
              .map((ord) => _buildPendingOrderCard(ord))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPendingOrderCard(PendingOrder ord) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        title: Row(
          children: [
            Expanded(
                child: Text(ord.name,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            Text('₱ ${ord.price.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF5D3510))),
          ],
        ),
        subtitle: Text('${ord.id} • ${ord.itemsSummary}',
            style: const TextStyle(color: Colors.black45)),
        onTap: () => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Open order ${ord.id}'))),
      ),
    );
  }
}

class _ShortcutItem {
  final IconData icon;
  final String label;
  _ShortcutItem({required this.icon, required this.label});
}

/// ---------------------- Admin Drawer Widget (styled to match screenshot) ----------------------
class AdminDrawer extends StatelessWidget {
  final Future<UserProfile> profileFuture;
  final String selectedRoute;
  final void Function(String route) onNavigate;

  const AdminDrawer({
    super.key,
    required this.profileFuture,
    required this.selectedRoute,
    required this.onNavigate,
  });

  static const Color _headerBrown = Color(0xFF3F2B23);
  static const Color _accentOrange = Color(0xFFF08F2A);

  Widget _navItem(
      {required BuildContext context,
      required IconData icon,
      required String label,
      required String route,
      bool highlight = false}) {
    final bg = highlight ? const Color(0xFFFFD7AB) : Colors.transparent;
    final fg = highlight ? const Color(0xFFE27D19) : Colors.brown.shade400;
    return InkWell(
      onTap: () => onNavigate(route),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: fg),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                    color: fg,
                    fontWeight:
                        highlight ? FontWeight.w600 : FontWeight.normal)),
            const Spacer(),
            if (highlight)
              const Icon(Icons.chevron_right, size: 18, color:const Color(0xFFE27D19)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Drawer width tuned for tablet/desktop look (adjust as needed)
    return Drawer(
      width: 320,
      child: Container(
        color: const Color(0xFFFAF6EE),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              color: _headerBrown,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: SafeArea(
                bottom: false,
                child: FutureBuilder<UserProfile>(
                  future: profileFuture,
                  builder: (context, snap) {
                    final profile = snap.data;
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.white,
                          backgroundImage: profile?.avatarUrl != null
                              ? NetworkImage(profile!.avatarUrl!)
                              : null,
                          child: profile?.avatarUrl == null
                              ? const Icon(Icons.coffee,
                                  color: Color(0xFF6B3E2B))
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(profile?.displayName ?? 'Express-O',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  )),
                              const SizedBox(height: 4),
                              Text(profile?.email ?? 'admin@example.com',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                        // chevron
                        IconButton(
                          onPressed: () {
                            // maybe open profile detail in the future
                            onNavigate('/profile');
                          },
                          icon: const Icon(Icons.chevron_right,
                              color: Colors.white),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),

            // content
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Home (highlighted)
                      _navItem(
                          context: context,
                          icon: Icons.home,
                          label: 'Home',
                          route: '/',
                          highlight: selectedRoute == '/'),

                      const SizedBox(height: 8),
                      const Text('Store Management',
                          style: TextStyle(
                              color: Color(0xFF8E6A4A),
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),

                      _navItem(
                          context: context,
                          icon: Icons.coffee_outlined,
                          label: 'Products',
                          route: '/products',
                          highlight: selectedRoute == '/products'),
                      _navItem(
                          context: context,
                          icon: Icons.list_alt,
                          label: 'Categories',
                          route: '/categories',
                          highlight: selectedRoute == '/categories'),
                      _navItem(
                          context: context,
                          icon: Icons.shopping_cart_outlined,
                          label: 'Orders',
                          route: '/orders',
                          highlight: selectedRoute == '/orders'),
                      _navItem(
                          context: context,
                          icon: Icons.local_offer_outlined,
                          label: 'Discount Codes',
                          route: '/discounts',
                          highlight: selectedRoute == '/discounts'),

                      const SizedBox(height: 16),
                      const Text('Reports',
                          style: TextStyle(
                              color: Color(0xFF8E6A4A),
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),

                      _navItem(
                          context: context,
                          icon: Icons.show_chart_outlined,
                          label: 'Analytics',
                          route: '/analytics',
                          highlight: selectedRoute == '/analytics'),
                      _navItem(
                          context: context,
                          icon: Icons.history,
                          label: 'Transaction History',
                          route: '/transactions',
                          highlight: selectedRoute == '/transactions'),

                      const SizedBox(height: 16),
                      const Text('More',
                          style: TextStyle(
                              color: Color(0xFF8E6A4A),
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),

                      _navItem(
                          context: context,
                          icon: Icons.person_outline,
                          label: 'Profile',
                          route: '/profile',
                          highlight: selectedRoute == '/profile'),
                      _navItem(
                          context: context,
                          icon: Icons.logout,
                          label: 'Logout',
                          route: '/logout',
                          highlight: false),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------- Placeholder page used by routes in this demo ----------------------
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF5D3510),
      ),
      body: Center(child: Text('This is the $title page (placeholder).')),
    );
  }
}
