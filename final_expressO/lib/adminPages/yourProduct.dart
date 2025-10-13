import 'package:firebase_nexus/adminPages/AddProduct.dart';
import 'package:firebase_nexus/adminPages/addProductFlow.dart';
import 'package:firebase_nexus/adminPages/editProduct.dart';
import 'package:firebase_nexus/adminPages/viewProduct.dart';
import 'package:flutter/material.dart';

class YourProductPage extends StatefulWidget {
  final String title;
  const YourProductPage({Key? key, required this.title}) : super(key: key);

  @override
  State<YourProductPage> createState() => _YourProductPageState();
}

class _YourProductPageState extends State<YourProductPage> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> allProducts = [
    {
      'name': 'Americano',
      'desc':
          'Strong black coffee made by forcing steam through finely ground coffee beans',
      'price': '₱ 110.00',
      'status': 'Active',
      'statusColor': Color(0xFFB6EAC7),
      'statusTextColor': Color(0xFF2E7D32),
      'image':
          'https://media.istockphoto.com/id/1430762697/photo/americano-coffee-cup-isolated-on-a-white-background.jpg?s=612x612&w=0&k=20&c=g1bRAshn2DMGDBUUwVr-Bl78TBnNBni8f8ILbK8O87E=',
      'category': 'Hot Coffee',
    },
    {
      'name': 'Cafe latte',
      'price': '₱ 120.00',
      'desc': 'Espresso with steamed milk and a light layer of foam',
      'status': 'Active',
      'statusColor': Color(0xFFB6EAC7),
      'statusTextColor': Color(0xFF2E7D32),
      'image':
          'https://t4.ftcdn.net/jpg/13/19/43/79/360_F_1319437943_nDYiP1Op6yRvFOchgDfE5UurwhxKiqTa.jpg',
      'category': 'Hot Coffee',
    },
    {
      'name': 'Cappucino',
      'price': '₱ 125.00',
      'desc': 'Equal parts espresso, steamed milk, and milk foam',
      'status': 'Active',
      'statusColor': Color(0xFFB6EAC7),
      'statusTextColor': Color(0xFF2E7D32),
      'image':
          'https://static.vecteezy.com/system/resources/previews/006/898/248/non_2x/hot-cappuccino-coffee-in-a-white-cup-isolated-on-white-background-free-photo.jpg',
      'category': 'Hot Coffee',
    },
    {
      'name': 'Caramel Macchiato',
      'price': '₱ 130.00',
      'desc': 'Espresso with vanilla syrup, steamed milk, and caramel drizzle',
      'status': 'Active',
      'statusColor': Color(0xFFB6EAC7),
      'statusTextColor': Color(0xFF2E7D32),
      'image':
          'https://static.wixstatic.com/media/ed1e06_ddc7f75c547b4c7684451a31d2970729~mv2.jpg/v1/fill/w_750,h_500,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/ed1e06_ddc7f75c547b4c7684451a31d2970729~mv2.jpg',
      'category': 'Hot Coffee',
    },
    {
      'name': 'Hot Mocha',
      'price': '₱ 135.00',
      'desc': 'Chocolate-flavored coffee with espresso and steamed milk',
      'status': 'Active',
      'statusColor': Color(0xFFB6EAC7),
      'statusTextColor': Color(0xFF2E7D32),
      'image':
          'https://static.vecteezy.com/system/resources/previews/026/553/418/large_2x/peppermint-mocha-in-a-white-cup-isolated-on-white-background-free-photo.jpg',
      'category': 'Hot Coffee',
    },
    {
      'name': 'Espresso',
      'price': '₱ 100.00',
      'desc':
          'Concentrated coffee brewed by forcing hot water through finely-ground beans',
      'status': 'Active',
      'statusColor': Color(0xFFB6EAC7),
      'statusTextColor': Color(0xFF2E7D32),
      'image':
          'null',
      'category': 'Hot Coffee',
    },
    {
      'name': 'Iced Americano',
      'price': '₱ 120.00',
      'desc': 'Chilled Americano coffee served with ice cubes',
      'status': 'Active',
      'statusColor': Color(0xFFB6EAC7),
      'statusTextColor': Color(0xFF2E7D32),
      'image':
          'https://lh3.googleusercontent.com/ptN4PvpkUuViHmfAYlYuWxicJukzkc8y0NRgZneATzIRe6kFs0xPnbn5kFYmmBkdalTGH8Iwc6xqoFHo0wGnF813EtTqZ_Tf3RVfuM54',
      'category': 'Iced Coffee',
    },
    {
      'name': 'Iced Cafe Latte',
      'price': '₱ 125.00',
      'desc': 'Chilled latte with espresso and cold milk over ice',
      'status': 'Active',
      'statusColor': Color(0xFFB6EAC7),
      'statusTextColor': Color(0xFF2E7D32),
      'image':
          'https://www.shutterstock.com/image-photo/glass-iced-latte-on-white-600nw-2478087601.jpg',
      'category': 'Iced Coffee',
    },
    {
      'name': 'Iced Cappucino',
      'price': '₱ 130.00',
      'desc': 'Cold version of cappuccino with ice and frothed milk',
      'status': 'Active',
      'statusColor': Color(0xFFB6EAC7),
      'statusTextColor': Color(0xFF2E7D32),
      'image':
          'https://thumbs.dreamstime.com/b/iced-cappuccino-coffee-mixed-sweetened-condensed-milk-fresh-milk-topped-creamy-soft-milk-froth-cocoa-powder-196983132.jpg',
      'category': 'Iced Coffee',
    },
    {
      'name': 'Lemon Tea',
      'price': '₱ 125.00',
      'desc': 'Refreshing tea with lemon flavor and citrus notes',
      'status': 'Inactive',
      'statusColor': Color(0xFFE0E0E0),
      'statusTextColor': Color(0xFF757575),
      'image':
          'https://thumbs.dreamstime.com/b/glass-ice-tea-lemon-white-background-fresh-cold-sliced-mint-isolated-34739219.jpg',
      'category': 'Tea',
    },
    {
      'name': 'Butterfly Pea',
      'price': '₱ 125.00',
      'desc': 'Traditional Japanese green tea with a delicate flavor',
      'status': 'Inactive',
      'statusColor': Color(0xFFE0E0E0),
      'statusTextColor': Color(0xFF757575),
      'image':
          'https://www.shutterstock.com/image-vector/butterfly-pea-flower-lemonade-tea-600nw-2210535173.jpg',
      'category': 'Tea',
    },
    {
      'name': 'Strawberry Milkshake',
      'price': '₱ 120.00',
      'desc': 'Creamy milkshake with fresh strawberry flavor',
      'status': 'Active',
      'statusColor': Color(0xFFB6EAC7),
      'statusTextColor': Color(0xFF2E7D32),
      'image':
          'https://t3.ftcdn.net/jpg/09/14/18/00/360_F_914180005_Xartj1IbbxF7wCczzTEHokUelWrXLSJ7.jpg',
      'category': 'Non-Coffee',
    },
    {
      'name': 'Vanilla Milkshake',
      'price': '₱ 120.00',
      'desc': 'Smooth and creamy vanilla flavored milkshake',
      'status': 'Inactive',
      'statusColor': Color(0xFFE0E0E0),
      'statusTextColor': Color(0xFF757575),
      'image':
          'https://st2.depositphotos.com/1817018/7191/i/950/depositphotos_71913083-stock-photo-milk-shakes-vanilla-flavor-with.jpg',
      'category': 'Non-Coffee',
    },
    {
      'name': 'Croissant',
      'price': '₱ 120.00',
      'desc': 'Buttery, flaky pastry with a light texture',
      'status': 'Inactive',
      'statusColor': Color(0xFFE0E0E0),
      'statusTextColor': Color(0xFF757575),
      'image':
          'https://st2.depositphotos.com/1008077/11643/i/950/depositphotos_116438620-stock-photo-croissant-with-white-background.jpg',
      'category': 'Pastries',
    },
    {
      'name': 'Blueberry Cheesecake',
      'price': '₱ 210.00',
      'desc': 'Rich cheesecake with blueberry topping',
      'status': 'Active',
      'statusColor': Color(0xFFB6EAC7),
      'statusTextColor': Color(0xFF2E7D32),
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQP7AlY1xuzv-cFAVgDYPKPHK3KWK2R7hLapA&s',
      'category': 'Pastries',
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

  List<Map<String, dynamic>> get filteredProducts {
    List<Map<String, dynamic>> filtered = allProducts;

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((product) => product['category'] == _selectedCategory)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        final name = product['name'].toString().toLowerCase();
        final desc = product['desc'].toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || desc.contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6ED),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B2E19),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Your Products',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF4B2E19),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF6B4F2A),
                      hintText: 'Search here...',
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.white70),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB84C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_alt_outlined,
                        color: Color(0xFF4B2E19)),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFF4B2E19),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: categories.map((cat) {
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Column(
                        children: [
                          Text(
                            cat,
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFFFFB84C)
                                  : Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          if (isSelected)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              height: 3,
                              width: 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFB84C),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try a different search or category',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to ViewProductPage when the card is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewProductPage(productData: product),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    product['image'] as String,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.error),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Price - not bold, normal weight
                                      Text(
                                        product['price'] as String,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xFF4B2E19),
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Product name and status on the same line
                                      Row(
                                        children: [
                                          Text(
                                            product['name'] as String,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF4B2E19),
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: product['statusColor']
                                                  as Color,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              product['status'] as String,
                                              style: TextStyle(
                                                color:
                                                    product['statusTextColor']
                                                        as Color,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Description
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          product['desc'] as String,
                                          style: const TextStyle(
                                            color: Color(0xFF757575),
                                            fontSize: 12,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: Color(0xFF4B2E19),
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    // Navigate to EditProduct screen with product data
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditProduct(productData: product),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFB84C),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
        onPressed: () {
          // Navigate to the AddProduct screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductFlow()),
          );
        },
      ),
    );
  }
}
