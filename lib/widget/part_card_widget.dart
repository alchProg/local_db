import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/part_model.dart';

class PartCardWidget extends StatefulWidget {
  PartCardWidget({
    Key? key,
    required this.part,
    required this.index,
  }) : super(key: key);

  final Part part;
  final int index;

  @override
  State<PartCardWidget> createState() => _PartCardWidgetState();
}

class _PartCardWidgetState extends State<PartCardWidget> {

  late List<int> prices;
  late List<IconData> icons;

  @override
  void initState() {
    prices = [
      widget.part.price1!,
      widget.part.price2!,
      widget.part.price3!,
      widget.part.price4!,
    ];
    icons = [
      Icons.looks_one_outlined,
      Icons.looks_two_outlined,
      Icons.looks_3_outlined,
      Icons.looks_4_outlined,
    ];
    super.initState();
  }

  List <Widget> _subtitleBuilder(List<int> prices) {
    List <Widget> items = [];
    setState(() {
      for (int price in prices){
        final item = Center(
            child: Row(
              children: [
                Icon(icons[prices.indexOf(price)], color: Colors.yellow.withOpacity(0.5), size: 18,),
                const SizedBox(
                  width: 2,
                ),
                Text( price != 0 ?
                NumberFormat.currency(
                    locale: 'Ru-ru', symbol: '₽', decimalDigits: 0)
                    .format(price) : " - ",
                  //textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 14,
                  ),
                ),
              ],
            )
        );
        items.add(item);
      }
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    prices = [
      widget.part.price1!,
      widget.part.price2!,
      widget.part.price3!,
      widget.part.price4!,
    ];
    return Card(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
              child: Text(
                widget.part.title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                    color: ThemeData.dark().dialogBackgroundColor.withOpacity(0.5),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(4),)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 20,
                child: GridView.count(
                  primary: false,
                  crossAxisCount: 4,
                  childAspectRatio: 5,
                  padding: const EdgeInsets.all(2),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: _subtitleBuilder(prices),
                ),
              ),
            )
          ]
      ),
    );
  }
}