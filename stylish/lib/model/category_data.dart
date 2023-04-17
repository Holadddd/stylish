import 'package:stylish/model/product_data.dart';

class CategoryData {
  final String title;
  final List<ProductData> products;

  CategoryData({
    required this.title,
    required this.products,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    List<dynamic> productData = json['products'];
    return CategoryData(
      title: json['title'],
      products: productData.map((json) => ProductData.fromJson(json)).toList(),
    );
  }
}
