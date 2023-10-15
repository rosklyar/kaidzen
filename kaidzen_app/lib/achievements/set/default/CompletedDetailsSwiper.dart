import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompletedDetailsSwiper extends StatelessWidget {
  final int itemCount;
  final String subfolder;
  final String filePrefix;
  final Color color;

  const CompletedDetailsSwiper(
      {super.key,
      required this.itemCount,
      required this.subfolder,
      required this.filePrefix,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                bottom: MediaQuery.of(context).size.height * 0.05,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    border: Border.all(
                      color: color,
                      width: 1.0,
                    )),
                child: Stack(children: [
                  Positioned(
                      left: MediaQuery.of(context).size.width * 0.03,
                      top: MediaQuery.of(context).size.height * 0.01,
                      child: Text(
                          index + 1 == itemCount
                              ? "You will get this!"
                              : "Step ${index + 1}:",
                          style: GoogleFonts.montserrat(
                              textStyle:
                                  TextStyle(fontSize: 16, color: color)))),
                  Align(
                      child: Image.asset(
                          "assets/achievements/sets/$subfolder/${filePrefix}_${1 + index}.png",
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.6),
                      alignment: Alignment.center)
                ])));
      },
      itemCount: itemCount,
      viewportFraction: 0.8,
      scale: 0.9,
      loop: false,
      pagination: const SwiperPagination(
          margin: EdgeInsets.only(bottom: 20),
          builder: DotSwiperPaginationBuilder(
              size: 4,
              activeSize: 8,
              color: Color.fromRGBO(189, 188, 199, 1),
              activeColor: Color.fromRGBO(186, 169, 255, 1))),
    );
  }
}
