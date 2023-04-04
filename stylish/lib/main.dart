import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Stylish',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        ),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            title: Container(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              height: 50,
              child: Image(image: AssetImage('assets/bar_image.png')),
            ),
          ),
          body: SafeArea(
            child: HomePage(),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Column(
      children: [
        /* Header image */
        HeaderImageListView(imageList: appState.headerImageList),
        /*Category*/
        MediaQuery.of(context).size.width > 800
            ? CategoryHView(categoryList: appState.categoryList)
            : CategoryVView(categoryList: appState.categoryList),
      ],
    );
  }
}

class CategoryHView extends StatelessWidget {
  const CategoryHView({
    super.key,
    required this.categoryList,
  });

  final List<CategoryItem> categoryList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Flex(
        direction: Axis.horizontal, // Switch axis with device width
        children: List.generate(
          categoryList.length,
          (index) => CategoryHSubView(
            item: categoryList[index],
            viewWidth: MediaQuery.of(context).size.width / categoryList.length,
          ),
        ),
      ),
    );
  }
}

class CategoryHSubView extends StatelessWidget {
  final CategoryItem item;
  final double viewWidth;

  const CategoryHSubView(
      {Key? key, required this.item, required this.viewWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 50,
            child: Center(
              child: Text(
                item.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: SizedBox(
                width: viewWidth,
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: item.productList.length,
                      itemBuilder: (BuildContext context, int productIndex) {
                        return ProductCard(
                            item: item.productList[productIndex]);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryVView extends StatelessWidget {
  const CategoryVView({
    Key? key,
    required this.categoryList,
  }) : super(key: key);

  final List<CategoryItem> categoryList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: kIsWeb
            ? Column(
                children: List.generate(
                  categoryList.length,
                  (index) => Column(
                    children: [
                      Text(categoryList[index].title),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: categoryList[index].productList.length,
                        itemBuilder: (context, productIndex) {
                          return ProductCard(
                              item: categoryList[index]
                                  .productList[productIndex]);
                        },
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                //Detect platform
                children: List.generate(
                  categoryList.length,
                  (index) => ExpandableList(
                    title: categoryList[index].title,
                    productList: categoryList[index].productList,
                  ),
                ),
              ),
      ),
    );
  }
}

class ExpandableList extends StatelessWidget {
  final String title;
  final List<ProductItem> productList;

  ExpandableList({required this.title, required this.productList});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(dividerColor: Colors.white), // set top line color here
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          title: Text(title),
          textColor: Colors.black,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return ProductCard(item: productList[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderImageListView extends StatelessWidget {
  final List<String> imageList;

  const HeaderImageListView({Key? key, required this.imageList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      height: 200.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          imageList.length,
          (index) => Container(
            width: 400.0,
            child: HeaderImageView(
              imageName: imageList[index],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.item,
  });

  final ProductItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: SizedBox(
        height: 100,
        child: Card(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Image(
                    width: 100,
                    height: 100,
                    image: AssetImage(
                      item.imageName,
                    ),
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(item.title), Text(item.subtitle)],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var headerImageList = [
    'assets/header_image.jpg',
    'assets/header_image.jpg',
    'assets/header_image.jpg',
    'assets/header_image.jpg',
    'assets/header_image.jpg',
    'assets/header_image.jpg'
  ];

  var categoryList = [
    CategoryItem(title: "女裝", productList: [
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 女裝",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 女裝",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 女裝",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 女裝",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 女裝",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 女裝",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 女裝",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 女裝",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 女裝",
          subtitle: "NT\$ 323")
    ]),
    CategoryItem(title: "男裝", productList: [
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 男裝",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 男裝",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 男裝",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 男裝",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 男裝",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 男裝",
          subtitle: "NT\$ 323")
    ]),
    CategoryItem(title: "配件", productList: [
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 配件",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 配件",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 配件",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 配件",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 配件",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 配件",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 配件",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 配件",
          subtitle: "NT\$ 323"),
      ProductItem(
          imageName: 'assets/header_image.jpg',
          title: "UNIQLO 配件",
          subtitle: "NT\$ 323")
    ])
  ];
}

class CategoryItem {
  final String title;
  final List<ProductItem> productList;

  CategoryItem({
    required this.title,
    required this.productList,
  });
}

class ProductItem {
  final String imageName;
  final String title;
  final String subtitle;

  ProductItem({
    required this.imageName,
    required this.title,
    required this.subtitle,
  });
}

class HeaderImageView extends StatelessWidget {
  const HeaderImageView({
    Key? key,
    required this.imageName,
    this.borderRadius = 10.0,
  }) : super(key: key);

  final String imageName;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.inversePrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image(
          image: AssetImage(imageName),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
