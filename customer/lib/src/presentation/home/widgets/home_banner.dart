import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeBanner extends StatefulWidget {
  final List<String> bannerImages;
  final Function(int) onBannerTap;

  const HomeBanner({
    Key? key,
    required this.bannerImages,
    required this.onBannerTap,
  }) : super(key: key);

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.bannerImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.bannerImages.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () =>
                      widget.onBannerTap(widget.bannerImages.indexOf(imageUrl)),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.bannerImages.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
