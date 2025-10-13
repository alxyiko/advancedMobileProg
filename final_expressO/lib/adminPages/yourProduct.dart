import 'package:firebase_nexus/adminPages/AddProduct.dart';
import 'package:firebase_nexus/adminPages/addProductFlow.dart';
import 'package:firebase_nexus/adminPages/editProduct.dart';
import 'package:firebase_nexus/adminPages/viewProduct.dart';
import 'package:firebase_nexus/helpers/adminPageSupabaseHelper.dart';
import 'package:firebase_nexus/helpers/local_database_helper.dart';
import 'package:firebase_nexus/widgets/loading_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  int _selectedIconIndex = 0;
  final TextEditingController _categoryNameController = TextEditingController();

  final supabaseHelper = AdminSupabaseHelper();
  bool _loading = true;
  final List<String> _categories = ['All'];
  List<Map<String, dynamic>> _products = [];

  List<Map<String, dynamic>> get filteredProducts {
    List<Map<String, dynamic>> filtered = _products;

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
    print('STARTING INIT STATE');
    _loadInitialData();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  Future<void> _loadInitialData() async {
    try {
      print('STARTED');

      final categories = await supabaseHelper.getAll("Categories");
      final products = await supabaseHelper.getAll("product_list");
      if (categories.isNotEmpty) {
        print('Categoried loaded!');
        print(categories);
      }

      if (products.isNotEmpty) {
        print('products loaded!');
        print(products);
      }
      // _categories = categories;

      setState(() {
        _loading = false;
        _categories.addAll(categories.map((e) => e['name'] as String).toList());
        _products = products;
      });
    } catch (e) {
      print("Error fetching categories: $e");
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🔶 LOADING OVERLAY
    if (_loading) {
      return LoadingScreens(
        message: 'Loading...',
        error: false,
        onRetry: null,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6ED),
      appBar: AppBar(
        backgroundColor: const Color(0xFF38241D),
        centerTitle: true,
        titleSpacing: 0,
        toolbarHeight: 60,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: const Text('Products',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600)),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => _showCategoriesPanel(context),
              child: const Icon(
                Icons.sort_by_alpha,
                size: 24,
                color: Colors.white, // optional — match your theme
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(160),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 25),
            child: Column(
              children: [
                Container(
                  color: const Color(0xFF38241D),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF503228),
                            hintText: 'Search here...',
                            hintStyle: const TextStyle(color: Colors.white70),
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.white70),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
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
                          color: const Color(0xFFE27D19),
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
                  color: const Color(0xFF38241D),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: _categories.map((cat) {
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
                                        ? const Color(0xFFE27D19)
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
                                      color: const Color(0xFFE27D19),
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
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
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
                                    product['img'] ?? '',
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
                                        "Php ${product['price'].toString()}",
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
                                              color: getStatColor(
                                                      product['status'])[
                                                  'labelColor'],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              product['status'] as String,
                                              style: TextStyle(
                                                color: getStatColor(
                                                        product['status'])[
                                                    'textColor'],
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
        backgroundColor: const Color(0xFFE27D19),
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

  void _showCategoriesPanel(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F3F0),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFF38241D),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.chevron_left,
                                  color: Colors.white, size: 28),
                            ),
                            const Expanded(
                              child: Text(
                                'Categories',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Quicksand',
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showAddCategoryDialog(context),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE27D19),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Categories List
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildCategoryItem('assets/categoryimages/1.svg',
                              'Hot Coffee', Colors.orange),
                          const SizedBox(height: 12),
                          _buildCategoryItem('assets/categoryimages/2.svg',
                              'Iced Coffee', Colors.orange),
                          const SizedBox(height: 12),
                          _buildCategoryItem('assets/categoryimages/3.svg',
                              'Tea', Colors.orange),
                          const SizedBox(height: 12),
                          _buildCategoryItem('assets/categoryimages/4.svg',
                              'Non-Coffee', Colors.orange),
                          const SizedBox(height: 12),
                          _buildCategoryItem('assets/categoryimages/5.svg',
                              'Pastries', Colors.orange),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(1.0, 0.0),
            end: const Offset(0.0, 0.0),
          ).animate(CurvedAnimation(
            parent: animation1,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
    );
  }

  Widget _buildCategoryItem(String svgIcon, String title, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                svgIcon,
                color: iconColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Quicksand',
                color: Color(0xFF38241D),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              _showEditCategoryDialog(context, svgIcon, title);
            },
            icon: const Icon(
              Icons.edit_outlined,
              color: Color(0xFF8E4B0E),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(
      BuildContext context, String currentIcon, String currentName) {
    // Set the initial values for editing
    _categoryNameController.text = currentName;
    // Find the index of the current icon in the available icons list
    final List<String> availableSvgIcons = [
      'assets/categoryimages/1.svg',
      'assets/categoryimages/2.svg',
      'assets/categoryimages/3.svg',
      'assets/categoryimages/4.svg',
      'assets/categoryimages/5.svg',
      'assets/categoryimages/7.svg',
      'assets/categoryimages/8.svg',
      'assets/categoryimages/9.svg',
      'assets/categoryimages/10.svg',
      'assets/categoryimages/11.svg',
      'assets/categoryimages/12.svg',
      'assets/categoryimages/13.svg',
      'assets/categoryimages/14.svg',
      'assets/categoryimages/1.svg', // Duplicate to reach 14 icons
    ];
    _selectedIconIndex = availableSvgIcons.indexOf(currentIcon);
    if (_selectedIconIndex == -1)
      _selectedIconIndex = 0; // Default to first icon if not found

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Edit Category',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Quicksand',
                        color: Color(0xFF38241D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add a category to keep your menu organized.',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Quicksand',
                        color: Color(0xFF8E4B0E),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Name input
                    const Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Quicksand',
                        color: Color(0xFF38241D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _categoryNameController,
                      decoration: InputDecoration(
                        hintText: 'Category Name',
                        hintStyle: const TextStyle(
                          color: Color(0xFFBBBBBB),
                          fontFamily: 'Quicksand',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE7D3B4)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE7D3B4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE27D19)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        color: Color(0xFF38241D),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Choose Icon section
                    const Text(
                      'Choose Icon',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Quicksand',
                        color: Color(0xFF38241D),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Icon grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: availableSvgIcons.length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedIconIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              _selectedIconIndex = index;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFE27D19)
                                  : const Color(0xFFF5F3F0),
                              borderRadius: BorderRadius.circular(8),
                              border: isSelected
                                  ? null
                                  : Border.all(color: const Color(0xFFE7D3B4)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                availableSvgIcons[index],
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF8E4B0E),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    // Action buttons
                    Column(
                      children: [
                        // Save Changes button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle saving category changes
                              Navigator.of(context).pop();
                              _categoryNameController.clear();
                              _selectedIconIndex = 0;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE27D19),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Quicksand',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Cancel button
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _categoryNameController.clear();
                              _selectedIconIndex = 0;
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Quicksand',
                                color: Color(0xFF8E4B0E),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Available SVG icons for categories (14 total)
            final List<String> availableSvgIcons = [
              'assets/categoryimages/1.svg',
              'assets/categoryimages/2.svg',
              'assets/categoryimages/3.svg',
              'assets/categoryimages/4.svg',
              'assets/categoryimages/5.svg',
              'assets/categoryimages/7.svg',
              'assets/categoryimages/8.svg',
              'assets/categoryimages/9.svg',
              'assets/categoryimages/10.svg',
              'assets/categoryimages/11.svg',
              'assets/categoryimages/12.svg',
              'assets/categoryimages/13.svg',
              'assets/categoryimages/14.svg',
              'assets/categoryimages/1.svg', // Duplicate to reach 14 icons
            ];

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Add Category',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Quicksand',
                        color: Color(0xFF38241D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add a category to keep your menu organized.',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Quicksand',
                        color: Color(0xFF8E4B0E),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Name input
                    const Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Quicksand',
                        color: Color(0xFF38241D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _categoryNameController,
                      decoration: InputDecoration(
                        hintText: 'Category Name',
                        hintStyle: const TextStyle(
                          color: Color(0xFFBBBBBB),
                          fontFamily: 'Quicksand',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE7D3B4)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE7D3B4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE27D19)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        color: Color(0xFF38241D),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Choose Icon section
                    const Text(
                      'Choose Icon',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Quicksand',
                        color: Color(0xFF38241D),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Icon grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: availableSvgIcons.length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedIconIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              _selectedIconIndex = index;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFE27D19)
                                  : const Color(0xFFF5F3F0),
                              borderRadius: BorderRadius.circular(8),
                              border: isSelected
                                  ? null
                                  : Border.all(color: const Color(0xFFE7D3B4)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                availableSvgIcons[index],
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF8E4B0E),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    // Action buttons
                    Column(
                      children: [
                        // Yes button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle adding category
                              Navigator.of(context).pop();
                              _categoryNameController.clear();
                              _selectedIconIndex = 0;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE27D19),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Yes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Quicksand',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Cancel button
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _categoryNameController.clear();
                              _selectedIconIndex = 0;
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Quicksand',
                                color: Color(0xFF8E4B0E),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
