import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';

class PromoCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> promos;

  const PromoCarousel({super.key, required this.promos});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  int _currentIndex = 0;

  final List<Map<String, String>> _fallbackPromos = [
    {
      'title': 'Espresso yourself!',
      'subtitle': 'Because life’s too short for bad coffee ☕',
      'buttonText': 'Stay Grounded',
    },
    {
      'title': 'Brew-tiful mornings!',
      'subtitle': 'Start your day with a little bean magic ✨',
      'buttonText': 'Perk Up',
    },
    {
      'title': 'You mocha me crazy ❤️',
      'subtitle': 'Our coffee’s smooth, our baristas smoother.',
      'buttonText': 'Order Now',
    },
    {
      'title': 'Latte love for you!',
      'subtitle': 'Sweet deals may be gone, but love’s still brewing.',
      'buttonText': 'Sip Sip Hooray',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final promosToShow = widget.promos.isEmpty ? _fallbackPromos : widget.promos;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF38241D),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/coffee_img.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CarouselSlider.builder(
                  itemCount: promosToShow.length,
                  options: CarouselOptions(
                    height: 120,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 8),
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      setState(() => _currentIndex = index);
                    },
                  ),
                  itemBuilder: (context, index, realIdx) {
                    final promo = promosToShow[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          promo['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          promo['subtitle'] ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            final code = promo['buttonText'] ?? '';
                            if (widget.promos.isEmpty) {
                              // Fallback behavior: just show a wink ;)
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('😉 No promo, just love.'),
                                  backgroundColor: Color(0xFF2c1d16),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              Clipboard.setData(ClipboardData(text: code));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Code "$code" copied to clipboard!'),
                                  backgroundColor: const Color(0xFF2c1d16),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE27D19),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            widget.promos.isEmpty
                                ? promo['buttonText'] ?? ''
                                : 'Use code ${promo['buttonText'] ?? 'ORDER30'}',
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Dots indicator
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: promosToShow.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? const Color(0xFFE27D19)
                    : Colors.grey.shade400,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
