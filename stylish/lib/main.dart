import 'package:english_words/english_words.dart';
import 'package:stylish/bloc/home/home_bloc_event.dart';
import 'package:stylish/product_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/home/home_bloc_bloc.dart';
import 'bloc/home/home_bloc_state.dart';
import 'package:stylish/model/category_data.dart';
import 'package:stylish/model/product_data.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'productDetail/:id',
          builder: (BuildContext context, GoRouterState state) {
            var id = state.params['id'] as String?;
            return id == null ? const SizedBox() : ProductDetailPage(id: id);
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBlocBloc>(
          create: (BuildContext context) => HomeBlocBloc()..add(LoadEvent()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Stylish',
        routerConfig: _router,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        ),
      ),
    );
  }
}

typedef ProductItemCallback = void Function(ProductData item);

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Container(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          height: 50,
          child: Image(image: AssetImage('assets/bar_image.png')),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<HomeBlocBloc, HomeBlocState>(
          builder: (context, state) {
            if (state is HomeInitial) {
              return const CircularProgressIndicator(
                color: Colors.blue,
              );
            }

            if (state is HomeLoaded) {
              return Column(
                children: [
                  /* Header image */
                  HeaderImageListView(
                    imageList:
                        state.campaignList.map((e) => e.picture).toList(),
                  ),
                  /*Category*/
                  MediaQuery.of(context).size.width > 800
                      ? CategoryHView(
                          categoryList: state.categoryList,
                          didClickItem: (item) {
                            // Handle navigate
                            context.go('/productDetail/${item.id}');
                          })
                      : CategoryVView(
                          categoryList: state.categoryList,
                          didClickItem: (item) {
                            // Handle navigate
                            context.go('/productDetail/${item.id}');
                          },
                        ),
                ],
              );
            } else {
              return const Text("Something went wrong!!!");
            }
          },
        ),
      ),
    );
  }
}

class CategoryHView extends StatelessWidget {
  const CategoryHView({
    super.key,
    required this.categoryList,
    required this.didClickItem,
  });

  final List<CategoryData> categoryList;
  final ProductItemCallback didClickItem;

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
            didClickItem: (item) {
              didClickItem(item);
            },
          ),
        ),
      ),
    );
  }
}

class CategoryHSubView extends StatelessWidget {
  final CategoryData item;
  final double viewWidth;
  final ProductItemCallback didClickItem;

  const CategoryHSubView({
    Key? key,
    required this.item,
    required this.viewWidth,
    required this.didClickItem,
  }) : super(key: key);

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
                      itemCount: item.products.length,
                      itemBuilder: (BuildContext context, int productIndex) {
                        return ProductCard(
                          item: item.products[productIndex],
                          onPressed: () {
                            didClickItem(item.products[productIndex]);
                          },
                        );
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
    required this.didClickItem,
  }) : super(key: key);

  final List<CategoryData> categoryList;
  final ProductItemCallback didClickItem;

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
                        itemCount: categoryList[index].products.length,
                        itemBuilder: (context, productIndex) {
                          return ProductCard(
                            item: categoryList[index].products[productIndex],
                            onPressed: () {
                              didClickItem(
                                  categoryList[index].products[productIndex]);
                            },
                          );
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
                    productList: categoryList[index].products,
                    didClickItem: didClickItem,
                  ),
                ),
              ),
      ),
    );
  }
}

class ExpandableList extends StatelessWidget {
  final String title;
  final List<ProductData> productList;
  final ProductItemCallback didClickItem;

  ExpandableList({
    required this.title,
    required this.productList,
    required this.didClickItem,
  });

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
                return ProductCard(
                  item: productList[index],
                  onPressed: () {
                    didClickItem(productList[index]);
                  },
                );
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
              imageUrl: imageList[index],
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
    required this.onPressed,
  });

  final ProductData item;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
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
                      image: NetworkImage(item.mainImage),
                      fit: BoxFit.fitHeight,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.title),
                        Text(item.description),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderImageView extends StatelessWidget {
  const HeaderImageView({
    Key? key,
    required this.imageUrl,
    this.borderRadius = 10.0,
  }) : super(key: key);

  final String imageUrl;
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
          image: NetworkImage(imageUrl),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
