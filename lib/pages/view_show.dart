import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pumped/imports.dart';
import 'package:pumped/models/show.dart';
import 'package:pumped/models/slide.dart';

class ViewShow extends StatefulWidget {
  final Show show;
  const ViewShow(this.show, {super.key});
  @override
  State<StatefulWidget> createState() => _ViewShowState();
}

class _ViewShowState extends State<ViewShow> {
  @override
  void didChangeDependencies() {
    widget.show.slides.forEach(precache);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CarouselSlider.builder(
          options: CarouselOptions(
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            height: height,
          ),
          itemCount: widget.show.slides.length,
          itemBuilder: (context, i, ri) {
            final slide = widget.show.slides[i];
            late Widget child;
            switch (slide.runtimeType) {
              case (TextSlide):
                slide as TextSlide;
                child = AutoSizeText(
                  slide.text,
                  style: TextStyle(fontSize: 40, color: slide.textColor),
                  textAlign: TextAlign.center,
                )
                    .center()
                    .height(height)
                    .width(width)
                    .decorated(color: slide.backgroundColor);
                break;
              case (ImageSlide):
                slide as ImageSlide;
                child = Container().height(height).width(width).decorated(
                    image: DecorationImage(
                        image: FileImage(slide.image!), fit: BoxFit.cover));
                break;
              default:
                child = Container();
            }
            return child;
          }),
    );
  }

  void precache(slide) {
    if (slide is ImageSlide) {
      precacheImage(FileImage(slide.image!), context);
    }
  }
}
