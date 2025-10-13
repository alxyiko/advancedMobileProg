import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_nexus/appColors.dart';
import '../adminHome.dart'; // adjust path depending on your folder structure

import './discountView.dart';
import './discountAdd.dart';
import './discountEdit.dart';

// ---------- STATUS BADGE ----------
class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  Map<String, Color> _getColors(String status) {
    switch (status) {
      case 'Active':
        return {
          'bg': const Color(0xFFCBF0D8),
          'text': const Color(0xFF1EA44B),
        };
      case 'Expired':
        return {
          'bg': const Color(0xFFFFE0E0),
          'text': const Color(0xFFD32F2F),
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

// ---------- DISCOUNT CARD ----------
class DiscountCard extends StatelessWidget {
  final IconData icon;
  final String discountCode;
  final String description;
  final String status;
  final DateTime createdAt;

  const DiscountCard({
    super.key,
    required this.icon,
    required this.discountCode,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(13), // spacing around icon
              decoration: const BoxDecoration(
                color: Color(0xFFF8F2E2), // background color
                shape: BoxShape.circle, // makes it circular
              ),
              child: Icon(
                icon,
                size: 24, // smaller so it fits nicely inside circle
                color: AppColors.secondaryVariant,
              ),
            ),

            const SizedBox(width: 12),

            // Middle Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(discountCode,
                      style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.secondary)),
                  const SizedBox(height: 4),
                  Text(description,
                      style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14,
                          color: AppColors.input)),
                  const SizedBox(height: 6),
                  Text(
                    "Created ${DateTime.now().difference(createdAt).inHours}h ago",
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.input,
                        fontFamily: 'Quicksand'),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusBadge(status: status),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.grey),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscountEdit(
                              code: "DEFAULTCODE",
                              description: "Default description",
                              discountType: "percentage",
                              discountValue: "0",
                              usageLimit: "0",
                              startDate: DateTime.now(),
                              endDate:
                                  DateTime.now().add(const Duration(days: 30)),
                              isAvailable: false,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ---------- MAIN PAGE ----------
class DiscountListPage extends StatelessWidget {
  const DiscountListPage({super.key});

  Future<UserProfile> fetchUserProfile() async {
    // TODO: replace with your real backend call
    await Future.delayed(const Duration(milliseconds: 300));
    return UserProfile(
      displayName: 'Express-O',
      email: 'admin123@gmail.com',
      avatarUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?...',
    );
  }

  @override
  Widget build(BuildContext context) {
    final _rand = Random();
    final sampleStatuses = ["Active", "Expired", "Inactive"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        iconTheme:
            const IconThemeData(color: Colors.white), // back/menu icon white
        title: const Text("Discount Codes",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Quicksand',
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),

      drawer: AdminDrawer(
        profileFuture: fetchUserProfile(), // <-- your future method
        selectedRoute: "/discounts", // mark this as active/highlighted
        onNavigate: (route) {
          Navigator.pushNamed(context, route);
        },
      ),

      // ✅ Floating Button Bottom Right
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const discountAdd()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 5, // or your real list length
        itemBuilder: (context, index) {
          final status = sampleStatuses[_rand.nextInt(sampleStatuses.length)];
          final hoursAgo = _rand.nextInt(12); // random 0..11 hours ago
          final createdAt = DateTime.now().subtract(Duration(hours: hoursAgo));

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DiscountViewPage(discountCode: "CODE$index"),
                ),
              );
            },
            child: DiscountCard(
              icon: Icons.local_offer,
              discountCode: "CODE$index",
              description: "Sample discount description #$index",
              status: status,
              createdAt: createdAt,
            ),
          );
        },
      ),
    );
  }
}
