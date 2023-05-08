import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/home/home_bloc_bloc.dart';
import 'bloc/home/home_bloc_state.dart';

class ProductDetail {
  final String coverImageName;
  final String title;
  final String productID;
  final double price;
  final List<String> sizes;
  final List<String> colors;
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
  const ProductDetailPage({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext buildContext) {
    final coverImage = Image(image: AssetImage('assets/header_image.jpg'));
    final priceText = Container(
      width: 350,
      height: 500,
      child: BlocBuilder<HomeBlocBloc, HomeBlocState>(
        builder: (context, state) {
          return DetailSelector(
            productID: id,
          );
        },
      ),
    );

    Widget productDetailsWidget;
    final screenWidth = MediaQuery.of(buildContext).size.width;
    if (screenWidth < 800) {
      productDetailsWidget = Expanded(
        child: Center(
          child: Column(children: [
            coverImage,
            const SizedBox(width: 20),
            priceText,
          ]),
        ),
      );
    } else {
      productDetailsWidget = Expanded(
        child: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            coverImage,
            const SizedBox(width: 20),
            priceText,
          ]),
        ),
      );
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
              child: productDetailsWidget,
            ),
          ),
        ),
      ),
    );
  }
}

class DetailSelector extends StatefulWidget {
  const DetailSelector({Key? key, required this.productID}) : super(key: key);

  final String productID;

  @override
  State<DetailSelector> createState() => _DetailSelectorState();
}

class _DetailSelectorState extends State<DetailSelector> {
  int _selectedSizeIndex = -1;

  void _selectSize(int index) {
    setState(() {
      _selectedSizeIndex = index;
    });
  }

  int _selectedColorIndex = -1;

  void _selectColor(int index) {
    setState(() {
      _selectedColorIndex = index;
    });
  }

  int _amout = 0;

  void _addAmount(int count) {
    setState(() {
      _amout += count;
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Detail Title",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          "Detail string",
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        Text(
          'NT\$: detail price', //Escape the dollar sign character so that it is displayed as a literal character in the string
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Divider(thickness: 1),
        Row(
          children: [
            const Text("顏色"),
            Container(height: 24, child: const VerticalDivider()),
            Wrap(
              spacing: 16,
              children: List.generate(
                3,
                (index) => Container(
                  color: _selectedColorIndex == index
                      ? Colors.black
                      : Colors.white,
                  padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                  child: SizedBox(
                    child: InkWell(
                      onTap: () {
                        _selectColor(index);
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Text("尺寸"),
            Container(height: 24, child: const VerticalDivider()),
            Wrap(
              spacing: 16,
              children: List.generate(
                3,
                (index) => SizedBox(
                  height: 24,
                  width: 32,
                  child: ChoiceChip(
                    backgroundColor: _selectedSizeIndex == index
                        ? Colors.grey
                        : Colors.white,
                    selected: false,
                    label: Padding(
                      padding: EdgeInsets.zero,
                      child: Center(
                        child: Text("L"),
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    onSelected: (isSelected) {
                      _selectSize(index);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Text("數量"),
            Container(height: 24, child: const VerticalDivider()),
            ElevatedButton(
              child: const Text("-"),
              onPressed: () {
                if (_amout > 0) {
                  _addAmount(-1);
                }
              },
            ),
            Expanded(
              child: Center(
                child: Text(_amout.toString()),
              ),
            ),
            ElevatedButton(
              child: const Text("+"),
              onPressed: () {
                _addAmount(1);
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          child: Text(
            "請選擇尺寸",
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () {},
        ),
        Flexible(
          child: Container(
            color: Colors.white, // Set the background color to white
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 20), // Set a fixed height for the last container
              ],
            ),
          ),
        ),
      ],
    );
  }
}
