import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetail {
  final String coverImageName;
  final String title;
  final String productID;
  final int price;
  final List<String> sizes;
  final List<Color> colors;
  final String contents;
  final List<String> contentImageName;
  ProductDetail({
    required this.coverImageName,
    required this.title,
    required this.productID,
    required this.price,
    required this.sizes,
    required this.colors,
    required this.contents,
    required this.contentImageName,
  });
}

class ProductDetailPage extends StatelessWidget {
  @override
  const ProductDetailPage({Key? key, required this.productDetail})
      : super(key: key);

  final ProductDetail productDetail;
  Widget build(BuildContext buildContext) {
    final coverImage = Image(
      image: AssetImage(productDetail.coverImageName),
      fit: BoxFit.fill,
    );

    final priceText = Text('Price: ${productDetail.price}');

    final productDetails = Column(
      children: [
        coverImage,
        priceText,
      ],
    );

    Widget productDetailsWidget;
    final screenWidth = MediaQuery.of(buildContext).size.width;
    if (screenWidth < 800) {
      productDetailsWidget = Column(children: [productDetails]);
    } else {
      productDetailsWidget = Row(children: [productDetails]);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Container(
          padding: EdgeInsets.all(5),
          height: 50,
          child: Image(image: AssetImage('assets/bar_image.png')),
        ),
      ),
      body: SafeArea(
        child: Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: productDetailsWidget,
          ),
        ),
      ),
    );
  }
}
