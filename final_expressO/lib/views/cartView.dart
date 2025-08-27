import 'package:flutter/material.dart';
import 'package:firebase_nexus/providers/navigation_provider.dart';
import 'package:provider/provider.dart';
import 'notifPage.dart';
import 'orderDetails.dart';

class DummyCartPage extends StatefulWidget {
  const DummyCartPage({super.key});

  @override
  State<DummyCartPage> createState() => _DummyCartPageState();
}

class _DummyCartPageState extends State<DummyCartPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);

    final List<String> categories = [
      "All",
      "Espresso",
      "Cappuccino",
      "Latte",
      "Mocha",
      "Americano",
      "Cold Brew",
      "Macchiato",
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF38241D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFFFAF6EA)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined,
                color: Color(0xFFFAF6EA)), // 🛒 cart
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderDetails(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none,
                color: Color(0xFFFAF6EA)), // 🔔 notif
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotifPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔽 Title + Search + Categories section
          Container(
            width: double.infinity,
            color: const Color(0xFF38241D),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📝 Title
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: 'Enjoy your Favorite ',
                        style: TextStyle(color: Color(0xFFFAF6EA)),
                      ),
                      TextSpan(
                        text: 'Coffee! ☕',
                        style: TextStyle(color: Color(0xFFE27D19)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // 🔎 Search bar + filter
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF503228), // ✅ background color
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 3,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 16,
                            color: Color(0xFF9E7A6E), // ✅ text color
                          ),
                          decoration: const InputDecoration(
                            filled: true, // ✅ enable background fill
                            fillColor:
                                Color(0xFF503228), // ✅ same color as container
                            hintText: "Search coffee...",
                            hintStyle: TextStyle(
                              fontFamily: 'Quicksand',
                              color: Color(0xFF9E7A6E),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF9E7A6E),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Color(0xFFE27D19),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.filter_list,
                            color: Color(0xFF603B17)),
                        onPressed: () {
                          // TODO: filter action
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ☕ Categories
                SizedBox(
                  height: 30,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 30),
                    itemBuilder: (context, index) {
                      final isSelected = index == selectedIndex;
                      final text = categories[index];
                      final textStyle = TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white.withOpacity(isSelected ? 1.0 : 0.5),
                      );

                      double underlineWidth = 0;
                      if (isSelected) {
                        final textPainter = TextPainter(
                          text: TextSpan(text: text, style: textStyle),
                          maxLines: 1,
                          textDirection: TextDirection.ltr,
                        )..layout();
                        underlineWidth = textPainter.size.width;
                      }

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: SizedBox(
                          height: 30, // match parent height
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                text,
                                style: textStyle,
                              ),
                              if (isSelected)
                                Container(
                                  margin: const EdgeInsets.only(top: 1),
                                  height: 4,
                                  width: underlineWidth,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE27D19),
                                    borderRadius: BorderRadius.circular(2),
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
          ),

          // 📜 Grid items
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                mainAxisExtent: 180,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCFAF3),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: Image.asset(
                            "assets/images/coffee_img.png",
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Center(
                            child: Text(
                              "Coffee Name",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Color(0xFF603B17),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                "Php. 4.99",
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF603B17),
                                ),
                              ),
                              Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE27D19),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 16,
                                  icon: const Icon(Icons.add,
                                      color: Color(0xFFFFFFFF)),
                                  onPressed: () {},
                                ),
                              ),
                            ],
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
    );
  }
}
