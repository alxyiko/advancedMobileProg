import 'package:firebase_nexus/appColors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../helpers/adminPageSupabaseHelper.dart';

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
  int totalOrders = 0;
  double totalSales = 0;
  int totalCustomers = 0;

  // Chart / display data
  List<_ChartData> _successChartData = [];
  List<_ChartData> _failedChartData = [
    _ChartData('Cancelled', 0, const Color(0xFFA42E1E)),
    _ChartData('Rejected', 0, const Color(0xFFF0D0CB)),
  ];

  // top-selling products
  List<Map<String, dynamic>> topSellingProducts = [];

  // helper + realtime channel
  final AdminSupabaseHelper supa = AdminSupabaseHelper();
  RealtimeChannel? _ordersChannel;
  StreamSubscription<dynamic>? _channelSub;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // fetch initial data
    fetchInitialData();

    // subscribe to realtime changes on orders table
    _subscribeToOrdersRealtime();
  }

  @override
  void dispose() {
    _tabController.dispose();
    if (_ordersChannel != null) {
      supa.unsubscribe(_ordersChannel!);
      _ordersChannel = null;
    }
    _channelSub?.cancel();
    super.dispose();
  }

  /// Fetch orders, order_items and products and compute analytics.
  Future<void> fetchInitialData() async {
    try {
      // 0) Quick: what client is used?
      debugPrint('Supabase URL: ${dotenv.env['SUPABASE_URL']}');
      debugPrint(
          'Current session: ${Supabase.instance.client.auth.currentSession}');

      // 1) fetch orders
      debugPrint('🚀 Fetching orders...');
      final ordersRaw = await supa.getAll('Orders');
      debugPrint('✅ Orders fetched: ${ordersRaw.length}');
      debugPrint(
          'Sample order row: ${ordersRaw.isNotEmpty ? ordersRaw.first : 'none'}');

      debugPrint('🚀 Fetching order_items...');
      final itemsRaw = await supa.getAll('Order_items');
      debugPrint('✅ Order_items fetched: ${itemsRaw.length}');
      debugPrint(
          'Sample item row: ${itemsRaw.isNotEmpty ? itemsRaw.first : 'none'}');

      debugPrint('🚀 Fetching products...');
      final productsRaw = await supa.getAll('Products');
      debugPrint('✅ Products fetched: ${productsRaw.length}');
      debugPrint(
          'Sample product row: ${productsRaw.isNotEmpty ? productsRaw.first : 'none'}');

      // Helper to safely read a key with many possible column-name variants
      dynamic _read(Map m, List<String> keys) {
        for (var k in keys) {
          if (m.containsKey(k) && m[k] != null) return m[k];
        }
        return null;
      }

      // quickly build maps for product lookup using common id variants
      final Map<dynamic, Map<String, dynamic>> productById = {
        for (var p in productsRaw)
          _read(p, ['id', 'ID', 'product_id', 'productID']): p
      }..removeWhere((k, v) => k == null);

      // parse orders into typed list
      final List<OrderSummary> orders = ordersRaw.map((m) {
        final id =
            (_read(m, ['id', 'ID', 'order_id', 'orderID']) ?? '').toString();
        final userId =
            (_read(m, ['userID', 'user_id', 'userId', 'buyer_id', 'buyerID']) ??
                    '')
                .toString();
        final status = (_read(m, ['status', 'order_status']) ?? '').toString();

        // try to find a total/price column (fallbacks)
        final dynamic totalRaw =
            _read(m, ['total', 'total_price', 'price', 'order_total']);
        final double total = totalRaw == null
            ? 0.0
            : (totalRaw is num
                ? totalRaw.toDouble()
                : double.tryParse(totalRaw.toString()) ?? 0.0);

        // created at / ordered_at fallback
        final createdVal =
            _read(m, ['created_at', 'ordered_at', 'createdAt', 'createdAtUtc']);
        DateTime createdAt;
        if (createdVal is String) {
          createdAt = DateTime.tryParse(createdVal) ?? DateTime.now();
        } else if (createdVal is DateTime) {
          createdAt = createdVal;
        } else {
          createdAt = DateTime.now();
        }

        return OrderSummary(
          id: id,
          userId: userId,
          status: status,
          total: total,
          createdAt: createdAt,
        );
      }).toList();

      // compute metrics for successful orders (adjust strings to your app's status)
      final successOrders = orders
          .where((o) =>
              o.status.toLowerCase() == 'Successful' ||
              o.status.toLowerCase() == 'completed' ||
              o.status.toLowerCase() == 'paid')
          .toList();
      totalOrders = successOrders.length;
      totalSales = successOrders.fold(0.0, (s, o) => s + (o.total));
      totalCustomers = successOrders
          .map((o) => o.userId)
          .where((id) => id != '')
          .toSet()
          .length;

      // compute failed counts
      final failedOrders = orders
          .where((o) =>
              o.status.toLowerCase() == 'cancelled' ||
              o.status.toLowerCase() == 'rejected' ||
              o.status.toLowerCase() == 'failed')
          .toList();
      final cancelledCount = failedOrders
          .where((o) => o.status.toLowerCase() == 'cancelled')
          .length;
      final rejectedCount = failedOrders
          .where((o) => o.status.toLowerCase() == 'rejected')
          .length;
      _failedChartData = [
        _ChartData('Cancelled', cancelledCount, const Color(0xFFA42E1E)),
        _ChartData('Rejected', rejectedCount, const Color(0xFFF0D0CB)),
      ];

      // compute category breakdown and top-selling products by aggregating order_items
      // Map product_id => sold quantity (only for successful orders)
      final Set<String> successfulOrderIds =
          successOrders.map((o) => o.id).toSet();

      final Map<dynamic, int> salesByProduct = {};
      for (var item in itemsRaw) {
        final orderId =
            _read(item, ['order_id', 'orderID', 'orderId'])?.toString();
        if (orderId == null) continue;
        if (!successfulOrderIds.contains(orderId))
          continue; // count only successful orders

        final pid =
            _read(item, ['product_id', 'productID', 'ProductID', 'ProductId']);
        if (pid == null) continue;
        final qtyRaw = _read(item, ['quantity', 'qty', 'Quantity']) ?? 1;
        final int qty =
            (qtyRaw is int) ? qtyRaw : int.tryParse(qtyRaw.toString()) ?? 0;
        salesByProduct[pid] = (salesByProduct[pid] ?? 0) + qty;
      }

      // Build category aggregation (product row may store category id or name)
      final Map<String, int> salesByCategory = {};
      salesByProduct.forEach((pid, qty) {
        final prod = productById[pid];
        // check product column variants for category / cat id
        final categoryRaw = (prod != null)
            ? _read(prod, [
                'category',
                'cat_id',
                'catID',
                'category_name',
                'name',
                'product_category'
              ])
            : null;

        // If categoryRaw looks like an id, try to map to a name; else use string
        final category =
            categoryRaw == null ? 'Others' : categoryRaw.toString();
        salesByCategory[category] = (salesByCategory[category] ?? 0) + qty;
      });

      // convert to _ChartData
      final List<Color> palette = [
        const Color(0xFFE27D19),
        const Color(0xFFFFAF5F),
        const Color(0xFFB35900),
        const Color(0xFF8A4B00),
        const Color(0xFF6A3F00)
      ];
      int pi = 0;
      _successChartData = salesByCategory.entries.map((e) {
        final c = palette[pi % palette.length];
        pi++;
        return _ChartData(e.key, e.value, c);
      }).toList();

      // top 5 products
      final sortedProducts = salesByProduct.entries.toList()
        ..sort((a, b) => (b.value).compareTo(a.value));
      topSellingProducts = sortedProducts.take(5).map((entry) {
        final prod = productById[entry.key] ?? {};
        final image = _read(
                prod, ['product_img', 'image_url', 'image', 'productImage']) ??
            '';
        final name =
            _read(prod, ['product_name', 'name', 'productName']) ?? 'Unknown';
        final category =
            _read(prod, ['category', 'cat_id', 'catID']) ?? 'Unknown';

        return {
          'product_id': entry.key,
          'name': name.toString(),
          'category': category.toString(),
          'sold': entry.value,
          'image': image.toString(),
        };
      }).toList();

      // refresh UI
      setState(() {});
    } catch (e, st) {
      debugPrint('fetchInitialData error: $e\n$st');
    }
  }

  /// Setup realtime subscription for orders table so analytics update live.
  void _subscribeToOrdersRealtime() {
    // create channel and handlers
    _ordersChannel = supa.listenToTable(
      'orders',
      onInsert: (payload) {
        fetchInitialData();
      },
      onUpdate: (payload) {
        fetchInitialData();
      },
      onDelete: (payload) {
        fetchInitialData();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBeige,
      appBar: AppBar(
        backgroundColor: brownDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
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
                  padding: const EdgeInsets.only(bottom: 16.0),
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
