import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Quicksand',
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Optional padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFCFAF3),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        color: Color(0xFFD4D0C2),
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(
                          Icons.search,
                          color: Color(0xFFD4D0C2), // Match hint text color
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor:
                          Color(0xFFFCFAF3), // Match container's background
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  height: 180,
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF2D1D17),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left Side: Text and Button
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '30% Discount!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'A more affordable fix just for you!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFE27D19),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Order Now!'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      // Right Side: Image
                      Container(
                        height: 100,
                        width: 100,
                        child: Image.asset(
                          'coffee_img.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Bestsellers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D1D17),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 160, // adjust height as needed
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Box 1
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset('cappuccino_img.png',
                                    fit: BoxFit.cover),
                              ),
                              SizedBox(height: 8),
                              Text(
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
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset('matcha_img.png',
                                    fit: BoxFit.cover),
                              ),
                              SizedBox(height: 8),
                              Text(
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
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset('latte_img.png',
                                    fit: BoxFit.cover),
                              ),
                              SizedBox(height: 8),
                              Text(
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
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
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
                      child: Text(
                        'See All →',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFE27D19),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(
                              0xFFE27D19), 
                          decorationThickness:
                              1.5, 
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
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
                SizedBox(height: 55),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF603B17),
        unselectedItemColor: Color(0xFFB0AFAF),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_cafe), // Hot coffee icon
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

Widget _buildCategoryBox(String label, IconData icon) {
  return Expanded(
    child: Column(
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: Color(0xFFE27D19),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(
              icon,
              color: Colors.white, // or any color you like
              size: 40,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D1D17),
          ),
        ),
      ],
    ),
  );
}
