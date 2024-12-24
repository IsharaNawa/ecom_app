import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class CarouselSection extends StatelessWidget {
  const CarouselSection({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<String> bannerList = [
      "assets/images/banners/banner1.png",
      "assets/images/banners/banner2.png",
    ];

    return SizedBox(
      height: 195,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(20),
          shadowColor: Colors.black.withOpacity(0.9),
          child: Swiper(
            autoplay: true,
            curve: Curves.easeIn,
            itemBuilder: (BuildContext context, int index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  bannerList[index],
                  fit: BoxFit.cover,
                ),
              );
            },
            itemCount: bannerList.length,
            pagination: SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                activeColor: Theme.of(context).colorScheme.primary,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
