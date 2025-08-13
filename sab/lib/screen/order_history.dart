import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int _selectedIndex = 1;
  String selectedTab = 'Complete';
  TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> orders = [
    {
      'title': 'Caramel Macchiato',
      'date': '09/05/25',
      'price': '₱250',
      'status': 'Complete'
    },
    {
      'title': 'Espresso',
      'date': '09/05/25',
      'price': '₱70',
      'status': 'Cancelled'
    },
    {
      'title': 'Americano',
      'date': '09/05/25',
      'price': '₱150',
      'status': 'Complete'
    },
    {
      'title': 'Mocha',
      'date': '09/05/25',
      'price': '₱180',
      'status': 'Cancelled'
    },
  ];

  List<Map<String, String>> filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _filterOrders();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _filterOrders();
  }

  void _filterOrders() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredOrders = orders
          .where((order) =>
              order['status'] == selectedTab &&
              order['title']!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order History',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[900],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildTabButton(screenWidth, 'Complete'),
                  const SizedBox(width: 10),
                  _buildTabButton(screenWidth, 'Cancelled'),
                ],
              ),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 16),
              Expanded(
                child: filteredOrders.isEmpty
                    ? Center(child: Text('No matching orders found.'))
                    : ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          return OrderCard(order: filteredOrders[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.brown,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.coffee), label: 'Orders'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildTabButton(double screenWidth, String tabName) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              selectedTab == tabName ? const Color(0xFFE27D19) : Colors.white,
          foregroundColor: selectedTab == tabName ? Colors.white : Colors.grey,
          elevation: selectedTab == tabName ? 3 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.035),
        ),
        onPressed: () {
          setState(() {
            selectedTab = tabName;
            _filterOrders(); // re-filter based on tab
          });
        },
        child: Text(tabName),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search here...',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, String> order;

  const OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Color statusColor = order['status'] == 'Cancelled'
        ? Colors.red
        : Colors.green; // complete = green, cancelled = red
    Color statusBG =
        order['status'] == 'Cancelled' ? Colors.red[50]! : Colors.green[50]!;

    return Container(
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.local_cafe, size: screenWidth * 0.1, color: Colors.brown),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order['title'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                    fontSize: screenWidth * 0.045,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InfoText(label: 'Amount', value: '1'),
                    InfoText(label: 'Date', value: order['date'] ?? ''),
                    InfoText(label: 'Price', value: order['price'] ?? ''),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusBG,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: statusColor),
            ),
            child: Text(
              order['status'] ?? '',
              style:
                  TextStyle(color: statusColor, fontSize: screenWidth * 0.03),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoText extends StatelessWidget {
  final String label;
  final String value;

  const InfoText({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.brown[300], fontSize: screenWidth * 0.03)),
        Text(value,
            style: TextStyle(
                color: Colors.brown[800],
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.035)),
      ],
    );
  }
}
