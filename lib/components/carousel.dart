import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import '../db/Carousel_service.dart';

class CarouselImages extends StatefulWidget {
  @override
  _CarouselImagesState createState() => _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImages> {
  List<DocumentSnapshot> carouselImages = <DocumentSnapshot>[];
  CarouselImageService carouselImageService = CarouselImageService();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _getCarouselImage();
  }

  _getCarouselImage() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<DocumentSnapshot> data =
          await carouselImageService.getCarouselImages();
      setState(() {
        carouselImages = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading?Loading():Carousel(
      boxFit: BoxFit.cover,
      dotBgColor: Colors.transparent,
      images: [
        Image.network(
          carouselImages[0]['image'],
          fit: BoxFit.cover,
        ),
        Image.network(
          carouselImages[1]['image'],
          fit: BoxFit.cover,
        ),
        Image.network(
          carouselImages[2]['image'],
          fit: BoxFit.cover,
        ),
        Image.network(
          carouselImages[3]['image'],
          fit: BoxFit.cover,
        ),
        Image.network(
          carouselImages[4]['image'],
          fit: BoxFit.cover,
        ),
        Image.network(
          carouselImages[5]['image'],
          fit: BoxFit.cover,
        ),
      ],
      autoplayDuration: Duration(seconds: 6),
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(milliseconds: 1000),
      dotSize: 3.0,
      indicatorBgPadding: 8.0,
    );
  }
}
