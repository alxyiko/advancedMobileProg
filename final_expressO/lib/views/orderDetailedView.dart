import 'package:flutter/material.dart';

class OrderDetailedView extends StatelessWidget {
  const OrderDetailedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF6EA),
        elevation: 0, // looks cleaner without shadow
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          iconSize: 32,
          color: const Color(0xFF2D1D17),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 32, 24, 8),
            child: Text(
              'Track Order#:',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: Color(0xFF2D1D17),
              ),
            ),
          ),

          // Main container with all sections
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              width: double.infinity,
              height: 660,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFF2D1D17),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order ID section
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 18, 20, 8),
                    child: Text(
                      'Order#: 999012',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Color(0xFF2D1D17),
                      ),
                    ),
                  ),
                  // Divider
                  const Divider(
                    color: Color(0xFF2D1D17),
                    thickness: 1.5,
                    height: 0,
                  ),
                  // Order details + image
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order info
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Caramel Macchiato',
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Color(0xFF2D1D17),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '₱250',
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Color(0xFF2D1D17),
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Text(
                                    'Order Status: ',
                                    style: TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFF2D1D17),
                                    ),
                                  ),
                                  Text(
                                    'Processed',
                                    style: TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Coffee image
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Image.asset(
                            'assets/images/coffee_img.png',
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Divider
                  const Divider(
                    color: Color(0xFF2D1D17),
                    thickness: 1.5,
                    height: 0,
                  ),
                  // Track your order title
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: Text(
                      'Track your order',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xFF603B17),
                      ),
                    ),
                  ),
                  // Order tracker timeline (placeholder)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Center(
                        child: Text(
                          'Order tracker timeline goes here',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 16,
                            color: Color(0xFF2D1D17),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
