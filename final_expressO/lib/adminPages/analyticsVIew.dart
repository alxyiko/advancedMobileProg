import 'package:firebase_nexus/appColors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

const brownDark = Color(0xFF3E2016);
const lightBeige = Color(0xFFF6F0E6);

class AnalyticsVIew extends StatelessWidget {
  const AnalyticsVIew({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Analytics Demo',
      theme: ThemeData(
        primaryColor: brownDark,
        scaffoldBackgroundColor: lightBeige,
        useMaterial3: true,
      ),
      home: const AnalyticsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
  });
}

class OrderSummary {
  final String id;
  final String userId;
  final String status;
  final double total;
  final DateTime createdAt;

  OrderSummary({
    required this.id,
    required this.userId,
    required this.status,
    required this.total,
    required this.createdAt,
  });
}

/// --- Dummy data
final List<Product> dummyProducts = [
  Product(
    id: 'p1',
    name: 'Matcha Latte',
    category: 'Coffee',
    price: 150.0,
    imageUrl:
        'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=200&h=200&fit=crop',
  ),
  Product(
    id: 'p2',
    name: 'Chocolate Pastry',
    category: 'Pastry',
    price: 85.0,
    imageUrl:
        'https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=200&h=200&fit=crop',
  ),
  Product(
    id: 'p3',
    name: 'Iced Americano',
    category: 'Coffee',
    price: 120.0,
    imageUrl:
        'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=200&h=200&fit=crop',
  ),
];

final List<OrderSummary> dummyOrders = [
  OrderSummary(
      id: 'o1',
      userId: 'u1',
      status: 'Completed',
      total: 2500,
      createdAt: DateTime.now().subtract(const Duration(days: 1))),
  OrderSummary(
      id: 'o2',
      userId: 'u2',
      status: 'Cancelled',
      total: 150,
      createdAt: DateTime.now().subtract(const Duration(days: 2))),
  OrderSummary(
      id: 'o3',
      userId: 'u2',
      status: 'Rejected',
      total: 150,
      createdAt: DateTime.now().subtract(const Duration(days: 3))),
  OrderSummary(
      id: 'o4',
      userId: 'u3',
      status: 'Cancelled',
      total: 150,
      createdAt: DateTime.now().subtract(const Duration(days: 4))),
];

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Replace with real fetched values
  int totalOrders = 65;
  double totalSales = 2500;
  int totalCustomers = 70;

  // Sample category breakdown for successful orders
  final List<_ChartData> _successChartData = [
    _ChartData('Coffee', 40, const Color(0xFFE27D19)),
    _ChartData('Pastry', 15, const Color(0xFFFFAF5F)),
    _ChartData('Others', 10, const Color(0xFFB35900)),
  ];

  // Sample failed orders breakdown
  final List<_ChartData> _failedChartData = [
    _ChartData('Cancelled', 3, const Color(0xFFA42E1E)),
    _ChartData('Rejected', 2, const Color(0xFFF0D0CB)),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // TODO: call fetchInitialData() to populate data from Supabase
  }

  Future<void> fetchInitialData() async {
    // final resp = await Supabase.instance.client.from('orders').select().execute();
    // parse and setState(...)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBeige,
      appBar: AppBar(
        backgroundColor: brownDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Analytics',
          style: TextStyle(color: Colors.white), 
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 13.0, right: 13.0),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8), // background of TabBar
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.orange[300],
                labelColor: const Color(0xFFE27D19),
                unselectedLabelColor: const Color(0xFF49454F),
                tabs: const [
                  Tab(text: 'Successful Orders'),
                  Tab(text: 'Failed Orders'),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSuccessfulTab(),
                  _buildFailedTab(),
                ],
              ),
            ),
          ),
        ],
      ),
     
    );
  }

  Widget _buildSuccessfulTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _roundedCard(
            child: Column(
              children: [
                // Donut chart using fl_chart
                SizedBox(
                  height: 240,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sections: _successChartData
                              .map((d) => PieChartSectionData(
                                    value: d.y.toDouble(),
                                    color: d.color,
                                    title: '',
                                    radius: 30,
                                    titleStyle: const TextStyle(
                                        fontSize: 0), // hide inline titles
                                  ))
                              .toList(),
                          centerSpaceRadius: 60,
                          sectionsSpace: 4,
                          startDegreeOffset: -90,
                          pieTouchData: PieTouchData(enabled: false),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$totalOrders',
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: brownDark),
                          ),
                          const SizedBox(height: 4),
                          Text('Total Orders',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Legend row
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _successChartData
                        .map(
                          (d) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: d.color,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(d.x),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1, // keeps it a square
                    child: _roundedCard(
                      color: Colors.orange[600]!,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.attach_money,
                                color: Colors.white, size: 60),
                            const SizedBox(height: 12),
                            const Text(
                              'Total Sales',
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              NumberFormat.currency(
                                      locale: 'en_PH', symbol: '₱')
                                  .format(totalSales),
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: _roundedCard(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.people_outline,
                                color: brownDark, size: 60),
                            const SizedBox(height: 12),
                            const Text(
                              'Total Customers',
                              style: TextStyle(color: brownDark),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '$totalCustomers',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: brownDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Top-selling products
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: const [
                Icon(Icons.bar_chart_outlined,
                    size: 18, color: Colors.deepOrange),
                SizedBox(width: 8),
                Text('Top-selling Products',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 8),

          _roundedCard(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              child: Column(
                children: dummyProducts
                    .map((p) => _productListTile(p,
                        sold:
                            50)) // pass sold count (dummy) GAWING TOP 5 yung lalabas tnx pi
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailedTab() {
    final failedOrders = dummyOrders
        .where((o) => o.status == 'Cancelled' || o.status == 'Rejected')
        .toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          _roundedCard(
            child: Column(
              children: [
                SizedBox(
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(PieChartData(
                        sections: _failedChartData
                            .map((d) => PieChartSectionData(
                                  value: d.y.toDouble(),
                                  color: d.color,
                                  title: '',
                                  radius: 30,
                                ))
                            .toList(),
                        centerSpaceRadius: 60,
                        sectionsSpace: 4,
                        startDegreeOffset: -90,
                      )),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${failedOrders.length}',
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: brownDark),
                          ),
                          const SizedBox(height: 4),
                          Text('Failed Orders',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(12.0), 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _failedChartData
                        .map((d) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: d.color,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(d.x),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: failedOrders.map((o) => _failedOrderCard(o)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _productListTile(Product p, {required int sold}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10), 
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // soft subtle shadow
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(8), 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), 
        ),
        child: Row(
          children: [
         
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 1),
                color: Colors.grey[100],
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ClipOval(
                  child: Image.network(
                    p.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.image, color: Colors.grey[400]),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // product name
            Expanded(
              child: Text(
                p.name,
                style: const TextStyle(
                  color: brownDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  height: 1.05,
                ),
              ),
            ),

            // sold count
            Text(
              '$sold sold',
              style: const TextStyle(
                color: brownDark,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _failedOrderCard(OrderSummary o) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: _roundedCard(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 25,
            horizontal: 16,
          ),
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFE27D19),
            child: Text(
              'JD',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: const Text('Juan Dela Cruz'), // replace with user fetch
          subtitle: Text('Matcha Latte, Caramel Macchiato...'),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _statusBadge(o.status),
              const SizedBox(height: 4),
              Text(NumberFormat.currency(locale: 'en_PH', symbol: '₱')
                  .format(o.total)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color textColor = Colors.white;
    if (status == 'Cancelled') {
      bg = const Color(0xFFF0D0CB);
      textColor = const Color(0xFFA42E1E);
    } else if (status == 'Rejected') {
      bg = const Color(0xFFF0D0CB);
      textColor = const Color(0xFFA42E1E);
    } else {
      bg = const Color(0xFFF0D0CB);
      textColor = const Color(0xFFA42E1E);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(
        status,
        style: TextStyle(fontSize: 12, color: textColor),
      ),
    );
  }

  /// helper to create rounded white card with elevation
  Widget _roundedCard({required Widget child, Color color = Colors.white}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ChartData {
  final String x;
  final num y;
  final Color color;
  _ChartData(this.x, this.y, this.color);
}
