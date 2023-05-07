class ProductData {
  int id;
  String category;
  String title;
  String description;
  int price;
  String texture;
  String wash;
  String place;
  String note;
  String story;
  List<ColorData> colors;
  List<String> sizes;
  List<Variant> variants;
  String mainImage;
  List<String> images;

  ProductData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        category = json['category'],
        title = json['title'],
        description = json['description'],
        price = json['price'],
        texture = json['texture'],
        wash = json['wash'],
        place = json['place'],
        note = json['note'],
        story = json['story'],
        colors = List<dynamic>.from(json['colors'])
            .map((json) => ColorData.fromJson(json))
            .toList(),
        sizes = List<String>.from(json['sizes']),
        variants = List<dynamic>.from(json['variants'])
            .map((json) => Variant.fromJson(json))
            .toList(),
        mainImage = json['main_image'],
        images = List<String>.from(json['images']);
}

class Variant {
  final String colorCode;
  final String size;
  final int stock;

  Variant({required this.colorCode, required this.size, required this.stock});

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      colorCode: json['color_code'],
      size: json['size'],
      stock: json['stock'],
    );
  }
}

class ColorData {
  final String code;
  final String name;

  ColorData({required this.code, required this.name});

  factory ColorData.fromJson(Map<String, dynamic> json) {
    return ColorData(
      code: json['code'],
      name: json['name'],
    );
  }
}
