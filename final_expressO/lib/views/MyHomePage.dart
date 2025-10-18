import 'package:firebase_nexus/appColors.dart';
import 'package:firebase_nexus/providers/userProvider.dart';
import 'package:firebase_nexus/views/UserProducts.dart';
import 'package:firebase_nexus/views/user_OrderPages/CartList.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notifPage.dart';
import '../widgets/promo_carousel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final promos = [
    {
      'title': '30% Discount!', // value + type (if percentage or fixed)
      'subtitle':
          'A more affordable fix just for you!', // description + minimum spend rin pero oks na sguro desc lng?
      'buttonText': 'COFFEE30', // discount code to be copied
      'onTap': () {
        debugPrint('COFFEE30 clicked!');
      },
    },
    {
      'title': '₱50 Off Your Order!',
      'subtitle': 'Valid until this weekend only!',
      'buttonText': 'SAVE50',
      'onTap': () {
        debugPrint('SAVE50 clicked!');
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (!userProvider.isLoaded || userProvider.user == null) {
      userProvider.loadUser(context);
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = userProvider.user;

    print(user);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF38241D),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            style: const TextStyle(
              letterSpacing: -0.5,
              fontSize: 18,
              color: Color.fromARGB(255, 255, 255, 255),
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w600,
            ),
            children: [
              const TextSpan(text: "Hello, "),
              TextSpan(
                text: user!['username'],
                style: const TextStyle(
                  color: Color(0xFFE27D19),
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined,
                color: Color.fromARGB(255, 255, 255, 255), size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none,
                color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotifPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0XFFFFFAED),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Optional padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 14),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment:
                //       CrossAxisAlignment.center, // ✅ aligns icons with text
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(
                //           left: 8.0), // ✅ left padding for text
                //       child: RichText(
                //         text: TextSpan(
                //           style: const TextStyle(
                //             letterSpacing: -0.5,
                //             fontSize: 18,
                //             color: Color(0xFF2D1D17),
                //             fontFamily: 'Quicksand',
                //             fontWeight: FontWeight.w600,
                //           ),
                //           children: [
                //             const TextSpan(text: "Hello, "),
                //             TextSpan(
                //               text: user!['username'],
                //               style: const TextStyle(
                //                 fontWeight: FontWeight.bold,
                //                 letterSpacing: -0.5,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //     Row(
                //       children: [
                //         IconButton(
                //           onPressed: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (context) => const CartPage(),
                //               ),
                //             );
                //           },
                //           icon: const Icon(
                //             Icons.shopping_cart_outlined,
                //             color: Color(0xFF2D1D17),
                //             size: 22, // ✅ smaller size
                //           ),
                //         ),
                //         IconButton(
                //           icon: const Icon(Icons.notifications_none,
                //               color: Color(0xFF2D1D17)),
                //           onPressed: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => const NotifPage()),
                //             );
                //           },
                //         ),
                //       ],
                //     ),
                //   ],
                // ),

                // Container(
                //   decoration: BoxDecoration(
                //     color: const Color(0xFFFCFAF3),
                //     borderRadius: BorderRadius.circular(15),
                //     boxShadow: const [
                //       BoxShadow(
                //           color: Color(0x19B8B8B8),
                //           blurRadius: 2,
                //           offset: Offset(0, 1)),
                //       BoxShadow(
                //           color: Color(0x16B8B8B8),
                //           blurRadius: 4,
                //           offset: Offset(0, 4)),
                //       BoxShadow(
                //           color: Color(0x0CB8B8B8),
                //           blurRadius: 5,
                //           offset: Offset(0, 8)),
                //     ],
                //   ),
                //   child: TextField(
                //     decoration: InputDecoration(
                //       hintText: 'Search...',
                //       hintStyle: const TextStyle(
                //         color: Color(0xFFD4D0C2),
                //         fontSize: 16,
                //         fontWeight: FontWeight.w500,
                //       ),
                //       prefixIcon: const Icon(
                //         Icons.search,
                //         color: Color(0xFFD4D0C2),
                //         size: 20,
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(15),
                //         borderSide: const BorderSide(
                //           color: Color.fromARGB(255, 255, 255,
                //               255), // border color when not focused
                //           width: 1,
                //         ),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(15),
                //         borderSide: const BorderSide(
                //           color: Color(0xFFE27D19), // border color when focused
                //           width: 2,
                //         ),
                //       ),
                //       contentPadding: const EdgeInsets.symmetric(
                //           vertical: 15, horizontal: 16),
                //       filled: true,
                //       fillColor: const Color.fromARGB(255, 255, 255, 255),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 10),
                PromoCarousel(promos: promos),

                const SizedBox(height: 30),
                const Text(
                  'Bestsellers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D1D17),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 160, // adjust height as needed
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Box 1
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset(
                                    'assets/images/cappuccino_img.png',
                                    fit: BoxFit.contain),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Cappuccino',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Box 2
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset(
                                    'assets/images/matcha_img.png',
                                    fit: BoxFit.contain),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Matcha Latte',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset(
                                    'assets/images/latte_img.png',
                                    fit: BoxFit.contain),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Iced Latte',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D1D17),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // You can navigate or show a dialog here
                      },
                      child: const Text(
                        'See All →',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFE27D19),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFFE27D19),
                          decorationThickness: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCategoryBox('Coffee', Icons.coffee_outlined),
                      _buildCategoryBox(
                          'Tea', Icons.emoji_food_beverage_outlined),
                      _buildCategoryBox('Pastries', Icons.cake_outlined),
                      _buildCategoryBox('Others', Icons.more_horiz),
                    ],
                  ),
                ),
                const SizedBox(height: 55),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildCategoryBox(String label, IconData icon) {
  return Expanded(
    child: Column(
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: const Color(0xFFE27D19),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(
              icon,
              color: Colors.white, // or any color you like
              size: 25,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D1D17),
          ),
        ),
      ],
    ),
  );
}
