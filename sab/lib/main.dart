import 'package:flutter/material.dart';
import 'screen/order_history.dart';

void main() {
  runApp(OrderHistoryApp());
}

class OrderHistoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order History',
      debugShowCheckedModeBanner: false,
      home: OrderHistoryScreen(),
    );
  }
}
