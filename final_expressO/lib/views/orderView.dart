import 'package:flutter/material.dart';
import '../models/product.dart';
import 'orderDetailedView.dart';

class DummyOrderPage extends StatefulWidget {
  const DummyOrderPage({super.key});

  @override
  State<DummyOrderPage> createState() => _DummyOrderPageState();
}

class _DummyOrderPageState extends State<DummyOrderPage> {
  bool isEditing = false;
  List<bool> selectedItems = List.generate(10, (_) => false);

  @override
  Widget build(BuildContext context) {
    // navigation provider available if needed
    // final navProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF603B17),
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Your Cart',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '3 items',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                      // Reset checkboxes when exiting edit mode
                      if (!isEditing) {
                        selectedItems =
                            List.generate(selectedItems.length, (_) => false);
                      }
                    });
                  },
                  child: Text(
                    isEditing ? 'Done' : 'Edit',
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF603B17),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              color: Color(0xFF603B17),
              thickness: 1.5,
              height: 2,
            ),
          ),

          // List
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Show checkbox + delete outside the card
                    if (isEditing)
                      SizedBox(
                        height: 200,
                        width: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Checkbox Container
                            SizedBox(
                              height: 85,
                              width: 50,
                              child: Container(
                                margin: const EdgeInsets.only(top: 1),
                                decoration: BoxDecoration(
                                  color: selectedItems[index]
                                      ? const Color(
                                          0xFFE27D19) // selected: orange background
                                      : const Color(
                                          0xFFFFFFFF), // not selected: light brown background
                                  border: Border.all(
                                    color: selectedItems[index]
                                        ? const Color(0xFFE27D19)
                                        : const Color(0xFFF1E2D3),
                                    width: 2,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: Center(
                                  child: Checkbox(
                                    value: selectedItems[index],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedItems[index] = value ?? false;
                                      });
                                    },
                                    checkColor: const Color(0xFFE27D19),
                                    fillColor: WidgetStateProperty.resolveWith(
                                        (states) {
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return Colors
                                            .white; // selected: checkbox fill is white
                                      }
                                      return const Color(
                                          0xFFFFFFFF); // not selected: checkbox fill is F1E2D3
                                    }),
                                    side: BorderSide(
                                      color: selectedItems[index]
                                          ? const Color(0xFFE27D19)
                                          : const Color(0xFFF1E2D3),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Delete Button Container
                            SizedBox(
                              height: 85,
                              width: 50,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFFF1E2D3),
                                    width: 2,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color(0xFFF1E2D3),
                                    size: 24,
                                  ),
                                  onPressed: selectedItems[index]
                                      ? () {
                                          setState(() {
                                            selectedItems.removeAt(index);
                                          });
                                        }
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Slide the card when editing
                    Expanded(
                      child: AnimatedPadding(
                        duration: const Duration(milliseconds: 650),
                        padding: EdgeInsets.only(left: isEditing ? 0 : 0),
                        child: InkWell(
                          onTap: () {
                            // Construct a Product from the displayed values and navigate
                            final product = Product(
                              id: null,
                              name: 'Caramel Macchiato',
                              price: 250.0,
                              quantity: 3,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrderDetailedView(product: product),
                              ),
                            );
                          },
                          child: Card(
                            color: const Color(0xFFFCFAF3),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Row(
                                children: [
                                  // COLUMN 1 — Image and Price
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/coffee_img.png',
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          '₱250',
                                          style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // COLUMN 2 — Details
                                  const Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Caramel Macchiato',
                                          style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Date',
                                          style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '09/05/25',
                                          style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Amount',
                                          style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '3',
                                          style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // COLUMN 3 — Add / Minus Buttons
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Add Button
                                        IconButton(
                                          icon: const Icon(Icons.add_circle,
                                              color: Color(0xFF603B17)),
                                          onPressed: () {
                                            // increase logic here
                                          },
                                        ),
                                        // Current Amount
                                        const Text(
                                          '1',
                                          style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        // Minus Button (Gray if amount == 1)
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove_circle,
                                            color: 1 == 1
                                                ? Colors.grey
                                                : Color(0xFF603B17),
                                          ),
                                          onPressed: 1 == 1
                                              ? null
                                              : () {
                                                  // decrease logic here
                                                },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
