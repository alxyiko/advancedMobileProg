import 'package:flutter/material.dart';

class Category {
  String name;
  int iconIndex;
  Category({required this.name, required this.iconIndex});
}

class CategoryLateral extends StatefulWidget {
  final Function(Category category) onSaveCategory;
  final List<Category> initialCategories;

  const CategoryLateral({
    super.key,
    required this.onSaveCategory,
    this.initialCategories = const [],
  });

  @override
  State<CategoryLateral> createState() => _CategoryLateralState();
}

class _CategoryLateralState extends State<CategoryLateral> {
  List<Category> categories = [];
  final TextEditingController _categoryNameController = TextEditingController();
  int _selectedIconIndex = 0;

  final List<IconData> availableIcons = [
    Icons.fastfood,
    Icons.local_fire_department,
    Icons.local_bar,
    Icons.coffee,
    Icons.ramen_dining,
    Icons.set_meal,
    Icons.wine_bar,
    Icons.apple,
    Icons.local_drink,
    Icons.lunch_dining,
    Icons.bakery_dining,
    Icons.spa,
    Icons.icecream,
    Icons.paste_sharp,
  ];

  @override
  void initState() {
    super.initState();
    categories = List.from(widget.initialCategories);
  }

  void _showAddEditCategoryDialog({Category? category, int? editIndex}) {
    if (category != null) {
      _categoryNameController.text = category.name;
      _selectedIconIndex = category.iconIndex;
    } else {
      _categoryNameController.clear();
      _selectedIconIndex = 0;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  Text(
                    category == null ? 'Add Category' : 'Edit Category',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Quicksand',
                        color: Color(0xFF38241D)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add a category to keep your menu organized.',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Quicksand',
                        color: Color(0xFF8E4B0E)),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Name',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Quicksand',
                        color: Color(0xFF38241D)),
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      color: Color(0xFF38241D),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Choose Icon',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Quicksand',
                        color: Color(0xFF38241D)),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: availableIcons.length,
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
                          child: Icon(
                            availableIcons[index],
                            color: isSelected ? Colors.white : Colors.orange,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final newCategory = Category(
                              name: _categoryNameController.text.trim(),
                              iconIndex: _selectedIconIndex,
                            );
                            setState(() {
                              if (editIndex != null) {
                                categories[editIndex] = newCategory;
                              } else {
                                categories.add(newCategory);
                              }
                            });
                            widget.onSaveCategory(newCategory);
                            Navigator.of(context).pop();
                            _categoryNameController.clear();
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
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Quicksand',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
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
        });
      },
    );
  }

  Widget _buildCategoryItem(Category category, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
                category.iconIndex >= 0 &&
                        category.iconIndex < availableIcons.length
                    ? availableIcons[category.iconIndex]
                    : Icons.category,
                color: Colors.orange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              category.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Quicksand',
                color: Color(0xFF38241D),
              ),
            ),
          ),
          IconButton(
            onPressed: () => _showAddEditCategoryDialog(
                category: category, editIndex: index),
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

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(color: Color(0xFFF5F3F0)),
          child: Column(
            children: [
              Container(
                height: 60,
                decoration: const BoxDecoration(color: Color(0xFF38241D)),
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
                          onTap: () => _showAddEditCategoryDialog(),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) =>
                        _buildCategoryItem(categories[index], index),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Trigger function
void showCategoryLateral(
    BuildContext context, Function(Category) onSaveCategory) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation1, animation2) {
      return CategoryLateral(onSaveCategory: onSaveCategory);
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
