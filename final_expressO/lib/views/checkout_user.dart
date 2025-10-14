import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Checkout Page',
      home: const CheckoutPage(),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool onlinePayment = false;

  final Color brown = const Color(0xFF38241D);
  final Color beige = const Color(0xFFFAF3EA);
  final Color accentOrange = const Color(0xFFE49B3C);
  final Color whiteCard = const Color(0xFFFFF8F1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beige,
      appBar: AppBar(
        backgroundColor: brown,
        title: const Text("Check Out", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              icon: Icons.location_on,
              title: "Address",
              child: const Text(
                "Blk 1 Lt 2 Golden Ville Salitran II Dasmariñas City Cavite",
                style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
              ),
            ),

            const SizedBox(height: 16),

            _buildSection(
              icon: Icons.local_cafe,
              title: "Items",
              child: Column(
                children: List.generate(3, (index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              "https://cdn-icons-png.flaticon.com/512/415/415733.png",
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              "Caramel Macchiato",
                              style: TextStyle(fontSize: 15, color: Colors.black87),
                            ),
                          ),
                          Text(
                            "₱250",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: brown,
                            ),
                          ),
                        ],
                      ),
                      if (index != 2)
                        Divider(color: Colors.brown.shade100, height: 20),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            _buildSection(
              icon: Icons.local_offer_outlined,
              title: "Add Discount Code",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox.shrink(),
                  Icon(Icons.arrow_forward_ios, color: brown, size: 18),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildSection(
              icon: Icons.payments_outlined,
              title: "Payment Method",
              child: Column(
                children: [
                  RadioListTile<bool>(
                    title: Row(
                      children: [
                        const Text("Pay at the counter"),
                        const SizedBox(width: 5),
                        Icon(Icons.store, color: accentOrange, size: 18),
                      ],
                    ),
                    value: false,
                    activeColor: accentOrange,
                    groupValue: onlinePayment,
                    onChanged: (val) => setState(() => onlinePayment = val!),
                  ),
                  RadioListTile<bool>(
                    title: Row(
                      children: [
                        const Text("Online Payment"),
                        const SizedBox(width: 5),
                        Icon(Icons.credit_card, color: accentOrange, size: 18),
                      ],
                    ),
                    value: true,
                    activeColor: accentOrange,
                    groupValue: onlinePayment,
                    onChanged: (val) => setState(() => onlinePayment = val!),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildSection(
              icon: Icons.receipt_long_outlined,
              title: "Payment Details",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _PaymentRow(label: "Shipping", value: "₱50.00"),
                  _PaymentRow(label: "Subtotal", value: "₱500.00"),
                  _PaymentRow(
                    label: "Voucher Applied",
                    value: "-₱500.00",
                    isNegative: true,
                  ),
                  Divider(),
                  _PaymentRow(label: "Total Payment", value: "₱50.00", isTotal: true),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Bottom total and button
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                color: whiteCard,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total: ₱500.00",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: brown,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: const Text("Check out",
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentOrange, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: brown,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isNegative;
  final bool isTotal;

  const _PaymentRow({
    required this.label,
    required this.value,
    this.isNegative = false,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 15 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 15 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isNegative
                  ? Colors.red
                  : isTotal
                      ? Colors.black
                      : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
