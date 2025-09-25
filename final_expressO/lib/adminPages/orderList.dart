import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../views/orderDetailedView.dart';
import '../models/product.dart';  class OrderListPage extends StatefulWidget {
    const OrderListPage({Key? key}) : super(key: key);

    @override
    State<OrderListPage> createState() => _OrderListPageState();
  }

  class _OrderItem {
    final Product product;
    final String status; // 'All','For Approval','Processing','Completed','Cancelled','pastry'

    _OrderItem({required this.product, required this.status});
  }

  class _OrderListPageState extends State<OrderListPage>
      with SingleTickerProviderStateMixin {
    late TabController _tabController;
    String _search = '';

    final tabs = ['All', 'For Approval', 'Processing', 'Completed', 'Cancelled', 'pastry'];

    // create mock orders with statuses
    List<_OrderItem> get _mockOrders {
      final statuses = ['For Approval', 'Processing', 'Completed', 'Cancelled', 'pastry', 'Processing'];
      return List.generate(6, (i) {
        final p = Product(id: i + 100, name: 'Order ${999000 + i}', price: 110.0 + i * 10, quantity: 1 + (i % 3));
        return _OrderItem(product: p, status: statuses[i % statuses.length]);
      });
    }

    @override
    void initState() {
      super.initState();
      _tabController = TabController(length: tabs.length, vsync: this);
    }

    @override
    void dispose() {
      _tabController.dispose();
      super.dispose();
    }

    List<_OrderItem> _filteredForTab(int tabIndex) {
      final all = _mockOrders;
      final tab = tabs[tabIndex];
      var items = all.where((o) {
        final matchSearch = _search.isEmpty || o.product.name.toLowerCase().contains(_search.toLowerCase()) || o.product.id.toString().contains(_search);
        return matchSearch;
      }).toList();

      if (tab != 'All') items = items.where((o) => o.status.toLowerCase() == tab.toLowerCase()).toList();
      return items;
    }

    @override
    Widget build(BuildContext context) {
      // Apply Quicksand font family across this page
      final themeWithQuicksand = Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Quicksand'),
      );

      return Theme(
        data: themeWithQuicksand,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF38241D),
            centerTitle: true,
            titleSpacing: 0,
            toolbarHeight: 70,
            title: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: const Text('Orders', style: TextStyle(color: Colors.white, fontFamily: 'Quicksand', fontWeight: FontWeight.w600)),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 10),
                child: SvgPicture.asset(
                  'assets/images/store_icon.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(180),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 25),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF503228),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.white70),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  style: const TextStyle(color: Colors.white, fontFamily: 'Quicksand'),
                                  decoration: const InputDecoration.collapsed(hintText: 'Search here....', hintStyle: TextStyle(color: Colors.white54, fontFamily: 'Quicksand')),
                                  onChanged: (v) => setState(() => _search = v),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(color: const Color(0xFFE27D19), borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.tune, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 45),
                  Container(
                    height: 30,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 0),
                    child: TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      tabAlignment: TabAlignment.start,
                      indicatorColor: Colors.transparent,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF9C7E60),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Quicksand'),
                      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Quicksand'),
                      tabs: tabs.map((t) => Tab(text: t)).toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: List.generate(tabs.length, (tabIndex) {
            final items = _filteredForTab(tabIndex);
            if (items.isEmpty) {
              return const Center(child: Text('No orders', style: TextStyle(fontFamily: 'Quicksand')));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderDetailedView(product: item.product))),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F2EC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset('assets/images/coffee_order_pic.png', fit: BoxFit.contain),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, fontFamily: 'Quicksand'))),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(color: item.status == 'Cancelled' ? const Color(0xFFF8D1D1) : const Color(0xFFF4E6DC), borderRadius: BorderRadius.circular(18)),
                                    child: Text(item.status, style: const TextStyle(color: Color(0xFF8E4B0E), fontFamily: 'Quicksand')),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('₱${item.product.price.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF8E4B0E), fontWeight: FontWeight.bold, fontFamily: 'Quicksand')),
                              const SizedBox(height: 6),
                              const Text('Americano, Latte, Cookies...', style: TextStyle(color: Color(0xFFB99F92), fontFamily: 'Quicksand')),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
      );
    }
  }
