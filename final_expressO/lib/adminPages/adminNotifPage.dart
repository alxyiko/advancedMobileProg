import 'dart:math';
import 'package:firebase_nexus/adminPages/orderPages/adminOrderDetailedPage.dart';
import 'package:firebase_nexus/helpers/adminPageSupabaseHelper.dart';
import 'package:firebase_nexus/helpers/userPageSupabaseHelper.dart';
import 'package:firebase_nexus/models/order.dart';
import 'package:firebase_nexus/providers/userProvider.dart';
import 'package:firebase_nexus/views/user_OrderPages/orderDetailedView.dart';
import 'package:firebase_nexus/widgets/loading_screens.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Converted AdminNotifPage (Stateful) with pulse on High Priority cards only.
class AdminNotifPage extends StatefulWidget {
  const AdminNotifPage({super.key});

  @override
  State<AdminNotifPage> createState() => Admin_NotifPageState();
}

class Admin_NotifPageState extends State<AdminNotifPage> {
  bool _loading = true;
  List<Order> _orders = [];
  final supabaseHelper = AdminSupabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUser(context);
      print('INIT STARTED');
      final rawOrders =
          await supabaseHelper.getOrdersForUser(null);
      print('Orders fetched: $rawOrders');

      final orders = (rawOrders as List)
          .map((o) => Order.fromJson(Map<String, dynamic>.from(o)))
          .toList();

      // Sort by most recent
      orders
          .sort((a, b) => a.created_at.compareTo(b.updated_at ?? b.created_at));

      setState(() {
        _loading = false;
        _orders = orders;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() => _loading = false);
    }
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('MMM d, h:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return LoadingScreens(
        message: 'Loading...',
        error: false,
        onRetry: null,
      );
    }

    // Filter orders by importance
    final highPriority = _orders
        .where((o) => o.status == 'Pending' || o.status == 'Processing')
        .toList();
    final others = _orders
        .where((o) => !(o.status == 'Pending' || o.status == 'Processing'))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0XFFFFFAED),
      appBar: AppBar(
        backgroundColor: const Color(0xFF38241D),
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ListView(
            children: [
              const SizedBox(height: 30),
              if (highPriority.isNotEmpty) ...[
                const Text(
                  "High Priority",
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: highPriority.map((o) {
                    return buildCard(
                        order: o, isHighPriority: true, context: context);
                  }).toList(),
                ),
                const SizedBox(height: 16),
                CustomPaint(
                  size: const Size(double.infinity, 1),
                  painter: DashedLinePainter(),
                ),
              ],
              const SizedBox(height: 16),
              const Text(
                "Other Notifications",
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: others.map((o) {
                  return buildCard(order: o, context: context);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for dashed line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;
    final paint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 1;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

String _timeAgoText(DateTime dt) {
  print(dt);
  final diff = DateTime.now().difference(dt);
  if (diff.inSeconds < 60) return 'Now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}

Widget buildCard(
    {required Order order,
    bool isHighPriority = false,
    required BuildContext context}) {
  final timeText = _timeAgoText(DateTime.parse(order.created_at));
  final firstItem = order.items.isNotEmpty ? order.items.first : null;

  const double cardHeight = 140.0;

  final cardBody = SizedBox(
    height: cardHeight,
    child: GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => AdminOrderDetailedPage(
              order: order, product: firstItem!, orderStatus: order.status))),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFEF9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.36),
              blurRadius: 2,
              offset: const Offset(2, 2),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Thumbnail
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F2E2),
                shape: BoxShape.circle,
                image: firstItem?.img != null
                    ? DecorationImage(
                        image: NetworkImage(firstItem!.img ??
                            'https://placehold.co/200x150/png'),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: firstItem?.img == null
                  ? const Icon(
                      Icons.local_cafe,
                      size: 22,
                      color: Color(0xFF603B17),
                    )
                  : null,
            ),

            const SizedBox(width: 12),

            // Main details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timeText,
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 12,
                      color: Color(0xFFC8A888),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Review this order",
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF603B17),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "This order #${order.id} was ${order.status.toLowerCase()}.",
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 13,
                      color: Color(0xFFC8A888),
                    ),
                  ),
                  // if (firstItem != null)
                  //   Text(
                  //     "${firstItem.name} (${firstItem.size}) - ₱${firstItem.price} x ${firstItem.quantity}",
                  //     style: const TextStyle(
                  //       fontFamily: 'Quicksand',
                  //       fontSize: 12,
                  //       color: Color(0xFF9C7C5C),
                  //     ),
                  //   ),
                  const SizedBox(height: 6),
                  Text(
                    "Total: ₱${order.discounted.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF603B17),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            StatusBadge(status: order.status),
          ],
        ),
      ),
    ),
  );

  // Normal card
  if (!isHighPriority) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: cardBody,
    );
  }

  // High priority card with pulse
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: PulsingBorder(
      minWidth: 1.0,
      maxWidth: 2.5,
      duration: const Duration(milliseconds: 900),
      color: const Color(0xFFE27D19),
      borderRadius: BorderRadius.circular(12),
      child: cardBody,
    ),
  );
}

/// Modular status badge placed outside AdminNotifPage so it can be reused.
class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  // returns background color and text color for a given status
  Map<String, Color> _getColors(String status) {
    switch (status) {
      case 'For Pickup':
        return {
          'bg': const Color(0xFFFACBAE),
          'text': const Color(0xFFC95B17),
        };
      case 'Pending':
        return {
          'bg': const Color(0xFFECF0CB),
          'text': const Color(0xFF95A41E),
        };
      case 'Completed':
        return {
          'bg': const Color(0xFFCBF0D8),
          'text': const Color(0xFF1EA44B),
        };
      case 'Processing':
        return {
          'bg': const Color(0xFFCBDBF0),
          'text': const Color(0xFF1E58A4),
        };
      case 'Cancelled':
        return {
          'bg': const Color(0xFFF0D0CB),
          'text': const Color(0xFFA42E1E),
        };
      default:
        return {
          'bg': const Color(0xFFEDEDED),
          'text': const Color(0xFF333333),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors['bg'],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w600,
          color: colors['text'],
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Widget that paints an animated pulsing border around its child.
/// PulsingBorder that **overlays** a painted border so the child's layout never changes.
class PulsingBorder extends StatefulWidget {
  final Widget child;
  final double minWidth;
  final double maxWidth;
  final Color color;
  final BorderRadius borderRadius;
  final Duration duration;

  const PulsingBorder({
    super.key,
    required this.child,
    this.minWidth = 1.0,
    this.maxWidth = 2.0,
    this.color = const Color(0xFFB3B3B3),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  _PulsingBorderState createState() => _PulsingBorderState();
}

class _PulsingBorderState extends State<PulsingBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = Tween<double>(begin: widget.minWidth, end: widget.maxWidth).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Stack: child is laid out normally; the CustomPaint overlays the animated stroke.
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // The child defines the layout (fixed size if you wrap it with SizedBox)
            child!,
            // Overlay painter that draws the border without affecting layout.
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _BorderPainter(
                    strokeWidth: _anim.value,
                    color: widget.color,
                    borderRadius: widget.borderRadius,
                  ),
                ),
              ),
            ),
          ],
        );
      },
      child: widget.child,
    );
  }
}

/// Paints a rounded rect stroke (used by PulsingBorder)
class _BorderPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final BorderRadius borderRadius;

  _BorderPainter({
    required this.strokeWidth,
    required this.color,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;
    // Draw stroke centered on the edge; strokeWidth won't push layout.
    canvas.drawRRect(rrect.deflate(strokeWidth / 2), paint);
  }

  @override
  bool shouldRepaint(covariant _BorderPainter old) {
    return old.strokeWidth != strokeWidth || old.color != color;
  }
}
