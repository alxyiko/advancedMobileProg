import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/product.dart';
import 'adminOrderDetailedPage.dart';  class OrderListPage extends StatefulWidget {
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
    
    // Filter variables
    List<String> _selectedStatuses = [];
    DateTimeRange? _selectedDateRange;
    double _minPrice = 0;
    double _maxPrice = 1000;

    // Add Category variables
    int _selectedIconIndex = 0;
    final TextEditingController _categoryNameController = TextEditingController();

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
      _categoryNameController.dispose();
      super.dispose();
    }

    List<_OrderItem> _filteredForTab(int tabIndex) {
      final all = _mockOrders;
      final tab = tabs[tabIndex];
      var items = all.where((o) {
        final matchSearch = _search.isEmpty || o.product.name.toLowerCase().contains(_search.toLowerCase()) || o.product.id.toString().contains(_search);
        
        // Apply additional filters if any are selected
        final matchStatus = _selectedStatuses.isEmpty || _selectedStatuses.contains(o.status);
        final matchPrice = o.product.price >= _minPrice && o.product.price <= _maxPrice;
        
        return matchSearch && matchStatus && matchPrice;
      }).toList();

      if (tab != 'All') items = items.where((o) => o.status.toLowerCase() == tab.toLowerCase()).toList();
      return items;
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
                      height: 100,
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
                                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
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
                            _buildCategoryItem('assets/categoryimages/1.svg', 'Hot Coffee', Colors.orange),
                            const SizedBox(height: 12),
                            _buildCategoryItem('assets/categoryimages/2.svg', 'Iced Coffee', Colors.orange),
                            const SizedBox(height: 12),
                            _buildCategoryItem('assets/categoryimages/3.svg', 'Tea', Colors.orange),
                            const SizedBox(height: 12),
                            _buildCategoryItem('assets/categoryimages/4.svg', 'Non-Coffee', Colors.orange),
                            const SizedBox(height: 12),
                            _buildCategoryItem('assets/categoryimages/5.svg', 'Pastries', Colors.orange),
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

    void _showEditCategoryDialog(BuildContext context, String currentIcon, String currentName) {
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
      if (_selectedIconIndex == -1) _selectedIconIndex = 0; // Default to first icon if not found

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
                            borderSide: const BorderSide(color: Color(0xFFE7D3B4)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE7D3B4)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE27D19)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                color: isSelected ? const Color(0xFFE27D19) : const Color(0xFFF5F3F0),
                                borderRadius: BorderRadius.circular(8),
                                border: isSelected ? null : Border.all(color: const Color(0xFFE7D3B4)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  availableSvgIcons[index],
                                  color: isSelected ? Colors.white : const Color(0xFF8E4B0E),
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
                            borderSide: const BorderSide(color: Color(0xFFE7D3B4)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE7D3B4)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE27D19)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                color: isSelected ? const Color(0xFFE27D19) : const Color(0xFFF5F3F0),
                                borderRadius: BorderRadius.circular(8),
                                border: isSelected ? null : Border.all(color: const Color(0xFFE7D3B4)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  availableSvgIcons[index],
                                  color: isSelected ? Colors.white : const Color(0xFF8E4B0E),
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

    void _showFilterDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('Filter Orders', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w600)),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Status Filter
                      const Text('Order Status:', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Quicksand')),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: ['For Approval', 'Processing', 'Completed', 'Cancelled', 'pastry'].map((status) {
                          return FilterChip(
                            label: Text(status, style: const TextStyle(fontSize: 12, fontFamily: 'Quicksand')),
                            selected: _selectedStatuses.contains(status),
                            onSelected: (selected) {
                              setDialogState(() {
                                if (selected) {
                                  _selectedStatuses.add(status);
                                } else {
                                  _selectedStatuses.remove(status);
                                }
                              });
                            },
                            selectedColor: const Color(0xFFE27D19).withOpacity(0.2),
                            checkmarkColor: const Color(0xFF8E4B0E),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      
                      // Price Range Filter
                      const Text('Price Range:', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Quicksand')),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _minPrice.toString(),
                              decoration: const InputDecoration(
                                labelText: 'Min Price',
                                prefixText: '₱',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final price = double.tryParse(value);
                                if (price != null) {
                                  setDialogState(() => _minPrice = price);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              initialValue: _maxPrice.toString(),
                              decoration: const InputDecoration(
                                labelText: 'Max Price',
                                prefixText: '₱',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final price = double.tryParse(value);
                                if (price != null) {
                                  setDialogState(() => _maxPrice = price);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Date Range Filter
                      const Text('Date Range:', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Quicksand')),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final DateTimeRange? range = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now(),
                            initialDateRange: _selectedDateRange,
                          );
                          if (range != null) {
                            setDialogState(() => _selectedDateRange = range);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE7D3B4)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.date_range, color: Color(0xFF8E4B0E)),
                              const SizedBox(width: 8),
                              Text(
                                _selectedDateRange == null 
                                  ? 'Select Date Range'
                                  : '${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month} - ${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}',
                                style: const TextStyle(fontFamily: 'Quicksand'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setDialogState(() {
                        _selectedStatuses.clear();
                        _selectedDateRange = null;
                        _minPrice = 0;
                        _maxPrice = 1000;
                      });
                    },
                    child: const Text('Clear All', style: TextStyle(color: Colors.grey, fontFamily: 'Quicksand')),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontFamily: 'Quicksand')),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {}); // Refresh the main page with new filters
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE27D19),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Apply', style: TextStyle(fontFamily: 'Quicksand')),
                  ),
                ],
              );
            },
          );
        },
      );
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
                child: GestureDetector(
                  onTap: () => _showCategoriesPanel(context),
                  child: SvgPicture.asset(
                    'assets/images/store_icon.svg',
                    width: 24,
                    height: 24,
                  ),
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
                      InkWell(
                        onTap: _showFilterDialog,
                        borderRadius: BorderRadius.circular(5),
                        child: SvgPicture.asset(
                          'assets/images/filter_icon.svg',
                          width: 44,
                          height: 44,
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
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AdminOrderDetailedPage(product: item.product, orderStatus: item.status))),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
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
