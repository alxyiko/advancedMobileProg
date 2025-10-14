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
      home: CheckoutPage(),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isOnlinePayment = false;
  bool showDiscountField = false;
  bool discountApplied = false;
  final TextEditingController discountController = TextEditingController();

  final double itemPrice = 250.0;
  final int itemCount = 3;
  final double shippingFee = 50.0;
  double voucherDiscount = 0.0;

  double get subtotal => itemPrice * itemCount;
  double get totalPayment => (subtotal + shippingFee) - voucherDiscount;

  @override
  Widget build(BuildContext context) {
    final brown = const Color(0xFF38241D);
    final background = const Color(0xFFFFF9F2);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: brown,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Check Out",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading:
            const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              title: "Address",
              icon: Icons.location_on_outlined,
              child: const Text(
                "Blk 1 Lt 2 Golden Ville Salitran II Dasmariñas City Cavite",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 12),
            _buildSection(
              title: "Items",
              icon: Icons.coffee_outlined,
              child: Column(
                children: List.generate(
                  itemCount,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("₱250",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87)),
                              SizedBox(height: 4),
                              Text("Caramel Macchiato",
                                  style: TextStyle(color: Colors.black54)),
                            ],
                          ),
                        ),
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                              "https://cdn-icons-png.flaticon.com/512/415/415733.png"),
                          backgroundColor: Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildDiscountSection(brown),
            const SizedBox(height: 12),
            _buildSection(
              title: "Payment Method",
              icon: Icons.credit_card_outlined,
              child: Column(
                children: [
                  RadioListTile<bool>(
                    title: const Text("Pay at the counter"),
                    secondary: const Icon(Icons.store_outlined),
                    activeColor: brown,
                    value: false,
                    groupValue: isOnlinePayment,
                    onChanged: (val) => setState(() => isOnlinePayment = val!),
                  ),
                  RadioListTile<bool>(
                    title: const Text("Online Payment"),
                    secondary: const Icon(Icons.payment_outlined),
                    activeColor: brown,
                    value: true,
                    groupValue: isOnlinePayment,
                    onChanged: (val) => setState(() => isOnlinePayment = val!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildSection(
              title: "Payment Details",
              icon: Icons.receipt_long_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPaymentRow("Shipping", shippingFee),
                  _buildPaymentRow("Subtotal", subtotal),
                  if (voucherDiscount > 0)
                    _buildPaymentRow("Voucher Applied", -voucherDiscount,
                        isDiscount: true),
                  const Divider(),
                  _buildPaymentRow("Total Payment", totalPayment, isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildBottomSummary(brown),
          ],
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final brown = const Color(0xFF38241D);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: brown, size: 18),
            const SizedBox(width: 6),
            Text(title,
                style: TextStyle(
                    color: brown, fontWeight: FontWeight.w600, fontSize: 15)),
          ]),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildDiscountSection(Color brown) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                showDiscountField = !showDiscountField;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Icon(Icons.local_offer_outlined, color: brown, size: 18),
                  const SizedBox(width: 6),
                  Text("Add Discount Code",
                      style: TextStyle(
                          color: brown,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                ]),
                Icon(
                  showDiscountField
                      ? Icons.expand_less
                      : Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black45,
                ),
              ],
            ),
          ),
          if (showDiscountField) ...[
            const SizedBox(height: 10),
            TextField(
              controller: discountController,
              decoration: InputDecoration(
                hintText: "Enter your discount code",
                hintStyle: const TextStyle(color: Colors.black38),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: brown.withOpacity(0.3), width: 1),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCF8C47),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                setState(() {
                  if (discountController.text.trim().toUpperCase() ==
                      "SAVE50") {
                    voucherDiscount = 500.0;
                    discountApplied = true;
                  } else {
                    voucherDiscount = 0.0;
                    discountApplied = false;
                  }
                });

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: discountApplied ? Colors.green : Colors.red,
                  content: Text(discountApplied
                      ? "Discount Applied Successfully!"
                      : "Invalid Discount Code"),
                  duration: const Duration(seconds: 2),
                ));
              },
              child: const Text("Apply",
                  style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, double value,
      {bool isDiscount = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
                  color: Colors.black87)),
          Text(
            "₱${value.toStringAsFixed(2)}",
            style: TextStyle(
              color: isDiscount ? Colors.red : Colors.black87,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSummary(Color brown) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total: ₱${totalPayment.toStringAsFixed(2)}",
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCF8C47),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              "Check out",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}
