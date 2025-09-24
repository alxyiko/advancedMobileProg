import 'package:flutter/material.dart';

class YourProductPage extends StatelessWidget {
  const YourProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample product data
    final products = [
      {
        'name': 'Americano',
        'price': '₱ 110.00',
        'desc': '',
        'status': 'Active',
        'statusColor': Color(0xFFB6EAC7),
        'statusTextColor': Color(0xFF2E7D32),
        'image': 'assets/images/americano.png',
      },
      {
        'name': 'Americano',
        'price': '₱ 110.00',
        'desc': '',
        'status': 'Inactive',
        'statusColor': Color(0xFFE0E0E0),
        'statusTextColor': Color(0xFF757575),
        'image': 'assets/images/americano.png',
      },
      {
        'name': 'Americano',
        'price': '₱ 110.00',
        'desc': '',
        'status': 'Inactive',
        'statusColor': Color(0xFFE0E0E0),
        'statusTextColor': Color(0xFF757575),
        'image': 'assets/images/americano.png',
      },
      {
        'name': 'Americano',
        'price': '₱ 110.00',
        'desc': '',
        'status': 'Out of Stock',
        'statusColor': Color(0xFFF8D7DA),
        'statusTextColor': Color(0xFFC62828),
        'image': 'assets/images/americano.png',
      },
    ];

    final categories = [
      'All',
      'Hot Coffee',
      'Iced Coffee',
      'Tea',
      'Non-Coffee',
      'Pastries'
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF9F6ED),
      appBar: AppBar(
        backgroundColor: Color(0xFF4B2E19),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          'Your Products',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xFF4B2E19),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF6B4F2A),
                      hintText: 'Search here...',
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white70),
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFB84C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.filter_alt_outlined, color: Color(0xFF4B2E19)),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Color(0xFF4B2E19),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  final isSelected = cat == 'All';
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      children: [
                        Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? Color(0xFFFFB84C) : Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (isSelected)
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            height: 3,
                            width: 24,
                            decoration: BoxDecoration(
                              color: Color(0xFFFFB84C),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        product['image'] as String,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                          product['price'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4B2E19),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: product['statusColor'] as Color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            product['status'] as String,
                            style: TextStyle(
                              color: product['statusTextColor'] as Color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4B2E19),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          product['desc'] as String,
                          style: TextStyle(
                            color: Color(0xFF757575),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Color(0xFF4B2E19)),
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFFB84C),
        child: Icon(Icons.add, color: Colors.white, size: 32),
        onPressed: () {},
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF4B2E19),
        unselectedItemColor: Color(0xFFBDBDBD),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}