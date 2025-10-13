import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/product.dart';

class AdminOrderDetailedPage extends StatefulWidget {
  final Product product;
  final String orderStatus;

  const AdminOrderDetailedPage({
    Key? key, 
    required this.product,
    this.orderStatus = 'Processing',
  }) : super(key: key);

  @override
  State<AdminOrderDetailedPage> createState() => _AdminOrderDetailedPageState();
}

class _AdminOrderDetailedPageState extends State<AdminOrderDetailedPage> with TickerProviderStateMixin {
  late String _currentStatus;
  bool _isCustomerInfoExpanded = true;
  bool _isOrderItemsExpanded = true;
  bool _isTimelineExpanded = true;
  bool _isPaymentDetailsExpanded = true;
  bool _isFabExpanded = false;
  late AnimationController _fabAnimationController;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.orderStatus;
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF38241D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Customer Information Card
            _buildCustomerInfoCard(),
            const SizedBox(height: 16),
            
            // Order Items Card
            _buildOrderItemsCard(),
            const SizedBox(height: 16),
            
            // Order Timeline Card
            _buildOrderTimelineCard(),
            const SizedBox(height: 16),
            
            // Payment Details Card
            _buildPaymentDetailsCard(),
            const SizedBox(height: 100), // Extra space for floating button
          ],
        ),
      ),
      floatingActionButton: _buildExpandableFab(),
    );
  }

  Widget _buildCustomerInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF603B17),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with dropdown
          GestureDetector(
            onTap: () {
              setState(() {
                _isCustomerInfoExpanded = !_isCustomerInfoExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: _isCustomerInfoExpanded ? const Border(
                  bottom: BorderSide(color: Color(0xFFE7D3B4), width: 1),
                ) : null,
                borderRadius: _isCustomerInfoExpanded ? const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ) : BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text(
                    'Customer Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Quicksand',
                      color: Color(0xFF38241D),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isCustomerInfoExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: const Color(0xFF8E4B0E),
                  ),
                ],
              ),
            ),
          ),
          
          // Expandable content
          if (_isCustomerInfoExpanded) ...[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
          // Customer Name
          Text(
            'Juan Dela Cruz',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Quicksand',
              color: Color(0xFF38241D),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'admin123@gmail.com',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Quicksand',
              color: Color(0xFF8E4B0E),
            ),
          ),
          const SizedBox(height: 16),
          
          // Payment Method Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/qricon.svg',
                  width: 16,
                  height: 16,
                  color: const Color(0xFF1976D2),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Online Payment',
                  style: TextStyle(
                    color: Color(0xFF1976D2),
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Customer Details
          _buildInfoRow(Icons.email_outlined, 'Email', 'bossjuan@gmail.com'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.phone_outlined, 'Number', '09123456789'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.location_on_outlined, 'Address', 'Blk 1 Lt 2 Ph 2 Maple Street\nDiamond Ville Salawag\nDasmarinas Cavite'),
          const SizedBox(height: 12),
          _buildMethodRow(),
          const SizedBox(height: 12),
          
          // Vouchers
          Row(
            children: [
              const Icon(Icons.local_offer_outlined, color: Color(0xFF8E4B0E), size: 20),
              const SizedBox(width: 12),
              const Text(
                'Voucher(s)',
                style: TextStyle(
                  color: Color(0xFF8E4B0E),
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF6EA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'SAVE50',
                  style: TextStyle(
                    color: Color(0xFF7B5B3C),
                    fontFamily: 'Quicksand',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF6EA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'BUY1GET1',
                  style: TextStyle(
                    color: Color(0xFF7B5B3C),
                    fontFamily: 'Quicksand',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF8E4B0E), size: 20),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8E4B0E),
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF38241D),
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMethodRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.local_shipping_outlined, color: Color(0xFF8E4B0E), size: 20),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: const Text(
            'Method',
            style: TextStyle(
              color: Color(0xFF8E4B0E),
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE1BEE7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Walk-in',
            style: TextStyle(
              color: Color(0xFF7B1FA2),
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItemsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF603B17),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: () {
              setState(() {
                _isOrderItemsExpanded = !_isOrderItemsExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: _isOrderItemsExpanded ? const Border(bottom: BorderSide(color: Color(0xFFE7D3B4), width: 1)) : null,
                borderRadius: _isOrderItemsExpanded ? const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ) : BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Text(
                    'Order#: ${widget.product.id}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Quicksand',
                      color: Color(0xFF603B17),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(_currentStatus).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _currentStatus,
                      style: TextStyle(
                        color: _getStatusColor(_currentStatus),
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _isOrderItemsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: const Color(0xFF8E4B0E),
                  ),
                ],
              ),
            ),
          ),
          
          // Order Items
          if (_isOrderItemsExpanded)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3, // Mock 3 items
              separatorBuilder: (context, index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: const Divider(
                  color: Color(0xFFE7D3B4), 
                  height: 1,
                  thickness: 1,
                ),
              ),
              itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Item Details (Left side)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₱${widget.product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF603B17),
                              fontFamily: 'Quicksand',
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Caramel Macchiato',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF603B17),
                              fontFamily: 'Quicksand',
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Coffee Image (Right side)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F2EC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/coffee_order_pic.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTimelineCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF603B17),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isTimelineExpanded = !_isTimelineExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: _isTimelineExpanded ? const Border(
                  bottom: BorderSide(color: Color(0xFFE7D3B4), width: 1),
                ) : null,
                borderRadius: _isTimelineExpanded ? const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ) : BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text(
                    'Order Timeline',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Quicksand',
                      color: Color(0xFF603B17),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isTimelineExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: const Color(0xFF8E4B0E),
                  ),
                ],
              ),
            ),
          ),
          
          if (_isTimelineExpanded) ...[
            const SizedBox(height: 20),
          
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Timeline Items
                  _buildTimelineItem(
                    true,
                    const Color(0xFFE27D19),
                    'assets/images/orderplacedicon.svg',
                    'Order Placed',
                    'We have received your order on\n16 Aug 2025',
                  ),
                  _buildTimelineItem(
                    true,
                    const Color(0xFFE27D19),
                    'assets/images/orderconfirmed.svg',
                    'Order Confirmed',
                    'We has been confirmed\n16 Aug 2025',
                  ),
                  _buildTimelineItem(
                    true,
                    const Color(0xFF4CAF50),
                    'assets/images/orderprocessed.svg',
                    'Order Processed',
                    'We are now processing your order',
                  ),
                  _buildTimelineItem(
                    false,
                    Colors.grey,
                    'assets/images/readytoserve.svg',
                    'Ready to Serve',
                    'Your Order is ready to serve',
                  ),
                  _buildTimelineItem(
                    false,
                    Colors.grey,
                    'assets/images/storeicon.svg',
                    'Order Completed',
                    'Your Order is completed on 16\nAug 2025, 10:35 PM',
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineItem(bool isCompleted, Color color, String svgPath, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Indicator
          Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  svgPath,
                  width: 18,
                  height: 18,
                  color: Colors.white,
                ),
              ),
              if (title != 'Order Completed') // Don't show line for last item
                Container(
                  width: 2,
                  height: 30,
                  color: isCompleted ? color : Colors.grey.shade300,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
            ],
          ),
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? const Color(0xFF38241D) : Colors.grey,
                    fontFamily: 'Quicksand',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isCompleted ? const Color(0xFF8E4B0E) : Colors.grey,
                    fontFamily: 'Quicksand',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF603B17),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isPaymentDetailsExpanded = !_isPaymentDetailsExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: _isPaymentDetailsExpanded ? const Border(
                  bottom: BorderSide(color: Color(0xFFE7D3B4), width: 1),
                ) : null,
                borderRadius: _isPaymentDetailsExpanded ? const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ) : BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.receipt, color: Color(0xFFE27D19), size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Payment Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Quicksand',
                      color: Color(0xFF603B17),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isPaymentDetailsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: const Color(0xFF8E4B0E),
                  ),
                ],
              ),
            ),
          ),
          
          if (_isPaymentDetailsExpanded) ...[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
          
          _buildPaymentRow('Shipping', '₱ 50.00'),
          const SizedBox(height: 12),
          _buildPaymentRow('Subtotal', '₱ 500.00'),
          const SizedBox(height: 12),
          _buildPaymentRow('Voucher Applied', '₱ -500.00', isVoucher: true),
          const SizedBox(height: 16),
          
          const Divider(color: Color(0xFFE7D3B4)),
          const SizedBox(height: 16),
          
          Row(
            children: [
              const Text(
                'Total Payment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Quicksand',
                  color: Color(0xFF38241D),
                ),
              ),
              const Spacer(),
              Text(
                '₱ ${widget.product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Quicksand',
                  color: Color(0xFF38241D),
                ),
              ),
            ],
          ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String amount, {bool isVoucher = false}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Quicksand',
            color: Color(0xFF8E4B0E),
          ),
        ),
        const Spacer(),
        Text(
          amount,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Quicksand',
            color: isVoucher ? Colors.red : const Color(0xFF38241D),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return const Color(0xFF2196F3);
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'cancelled':
        return const Color(0xFFF44336);
      case 'for approval':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF8E4B0E);
    }
  }

  Widget _buildExpandableFab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Action Buttons (appear when expanded)
        if (_isFabExpanded) ...[
          // Approve Button (Green Check)
          AnimatedBuilder(
            animation: _fabAnimationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _fabAnimationController.value,
                child: FloatingActionButton(
                  onPressed: () {
                    _approveOrder();
                  },
                  backgroundColor: const Color(0xFF4CAF50),
                  heroTag: "approve",
                  child: const Icon(Icons.check, color: Colors.white),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          
          // Deny Button (Red X)
          AnimatedBuilder(
            animation: _fabAnimationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _fabAnimationController.value,
                child: FloatingActionButton(
                  onPressed: () {
                    _denyOrder();
                  },
                  backgroundColor: const Color(0xFFE53E3E),
                  heroTag: "deny",
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          
          // More Options Button (Orange Plus)
          AnimatedBuilder(
            animation: _fabAnimationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _fabAnimationController.value,
                child: FloatingActionButton(
                  onPressed: () {
                    _showMoreOptions();
                  },
                  backgroundColor: const Color(0xFFE27D19),
                  heroTag: "more",
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
        
        // Main FAB
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _isFabExpanded = !_isFabExpanded;
              if (_isFabExpanded) {
                _fabAnimationController.forward();
              } else {
                _fabAnimationController.reverse();
              }
            });
          },
          backgroundColor: const Color(0xFFE27D19),
          child: AnimatedRotation(
            turns: _isFabExpanded ? 0.125 : 0, // 45 degrees when expanded
            duration: const Duration(milliseconds: 300),
            child: Icon(
              _isFabExpanded ? Icons.close : Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _approveOrder() {
    setState(() {
      _currentStatus = 'Approved';
      _isFabExpanded = false;
      _fabAnimationController.reverse();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order approved successfully!'),
        backgroundColor: Color(0xFF4CAF50),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _denyOrder() {
    setState(() {
      _currentStatus = 'Cancelled';
      _isFabExpanded = false;
      _fabAnimationController.reverse();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order has been denied'),
        backgroundColor: Color(0xFFE53E3E),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showMoreOptions() {
    setState(() {
      _isFabExpanded = false;
      _fabAnimationController.reverse();
    });
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'More Options',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Quicksand',
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.edit, color: Color(0xFF8E4B0E)),
                title: const Text('Edit Order'),
                onTap: () {
                  Navigator.pop(context);
                  // Add edit functionality here
                },
              ),
              ListTile(
                leading: const Icon(Icons.print, color: Color(0xFF8E4B0E)),
                title: const Text('Print Receipt'),
                onTap: () {
                  Navigator.pop(context);
                  // Add print functionality here
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Color(0xFF8E4B0E)),
                title: const Text('Share Order Details'),
                onTap: () {
                  Navigator.pop(context);
                  // Add share functionality here
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
