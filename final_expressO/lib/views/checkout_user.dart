import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkout',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CheckoutPage(),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPaymentMethod = 'counter';
  TextEditingController _discountController = TextEditingController();
  double _subtotal = 100.00;
  double _discount = 0.0;
  double _total = 100.00;

  void _applyDiscount() {
    setState(() {
      if (_discountController.text.isNotEmpty) {
        _discount = 10.0; // 10% discount for demo
        _total = _subtotal - (_subtotal * _discount / 100);
      } else {
        _discount = 0.0;
        _total = _subtotal;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address Section
            _buildSection(
              'Address',
              _buildAddressSection(),
            ),
            SizedBox(height: 20),
            
            // News Section
            _buildSection(
              'News',
              _buildNewsSection(),
            ),
            SizedBox(height: 20),
            
            // Divider
            Divider(height: 1, color: Colors.grey[300]),
            SizedBox(height: 20),
            
            // Add Discount Code
            _buildDiscountSection(),
            SizedBox(height: 20),
            
            // Payment Method
            _buildSection(
              'Payment Method',
              _buildPaymentMethodSection(),
            ),
            SizedBox(height: 20),
            
            // Payment Details
            _buildSection(
              'Payment Details',
              _buildPaymentDetails(),
            ),
            SizedBox(height: 30),
            
            // Trade Section
            _buildTradeSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildAddressSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'B1.1.1.2 Golden Web Safariers | Communities City, Ocelia',
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildNewsSection() {
    return Column(
      children: List.generate(3, (index) => _buildNewsItem()),
    );
  }

  Widget _buildNewsItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey[50],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: Text(
              'F250',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Coronel Nocciato',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Discount Code',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _discountController,
                decoration: InputDecoration(
                  hintText: 'Enter discount code',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: _applyDiscount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text('Apply'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      children: [
        _buildPaymentOption(
          value: 'counter',
          title: 'Pay us the counter',
        ),
        SizedBox(height: 8),
        _buildPaymentOption(
          value: 'online',
          title: 'Online Payment',
        ),
      ],
    );
  }

  Widget _buildPaymentOption({required String value, required String title}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: RadioListTile<String>(
        title: Text(title),
        value: value,
        groupValue: _selectedPaymentMethod,
        onChanged: (value) {
          setState(() {
            _selectedPaymentMethod = value!;
          });
        },
        contentPadding: EdgeInsets.only(left: 8),
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          _buildPaymentDetailRow('Pricing', '9:00:30'),
          SizedBox(height: 8),
          _buildPaymentDetailRow('Submit', '9:00:30'),
          SizedBox(height: 8),
          _buildPaymentDetailRow('Vendor Added', '9:00:30'),
          SizedBox(height: 8),
          Divider(height: 1, color: Colors.grey[300]),
          SizedBox(height: 8),
          _buildPaymentDetailRow(
            'Total Payment',
            _total.toStringAsFixed(2),
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTradeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trade # ${_subtotal.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'C:\\Users\\crc',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAppBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total Payment',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '\$${_total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Handle checkout logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Checkout',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}