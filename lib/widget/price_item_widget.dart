import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:local_db/models/price_list_items_model.dart';
import 'package:local_db/models/price_list_model.dart';
import 'package:local_db/widget/fmi_widget.dart';
import '../models/part_model.dart';
import '../models/price_list_screen.dart';

class PriceItemWidget extends StatefulWidget {
  PriceItemWidget({
    Key? key,
    required this.part,
    required this.priceList,
  }) : super(key: key);

  final Part part;
  final PriceList priceList;

  @override
  State<PriceItemWidget> createState() => _PriceItemWidgetState();
}

class _PriceItemWidgetState extends State<PriceItemWidget> {

  late List<dynamic> data;
  late PriceListItem priceItem;
  late IconData priceIcon;
  int oldPrice = 0;

  @override
  void initState() {
    _priceItemInit();
    _dataInit();
    super.initState();
  }

  void _dataInit() {
    data = [
      [Icons.looks_one_outlined , widget.part.desc1!  , widget.part.price1!],
      [Icons.looks_two_outlined , widget.part.desc2!  , widget.part.price2!],
      [Icons.looks_3_outlined   , widget.part.desc3!  , widget.part.price3!],
      [Icons.looks_4_outlined   , widget.part.desc4!  , widget.part.price4!],
    ];
    priceIcon = data[0][0];
    oldPrice = priceItem.price!;
    priceOfList += oldPrice;
  }

  void _priceItemInit() {
    priceItem = PriceListItem(
        title: widget.part.title,
        price: widget.part.price1,
        desc: widget.part.desc1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                title: Text(
                  priceItem.title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: _focusedMenu(),
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
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(priceIcon, size: 15, color: Colors.yellow,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(width: 1, height: 25, color: Colors.white38,),
                        ),
                        Text(
                          NumberFormat.currency(
                              locale: 'Ru-ru', symbol: '₽', decimalDigits: 0)
                              .format(priceItem.price),
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      priceItem.desc!,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]
      ),
    );
  }

  _focusedMenu(){
    return FocusedMenuHolder(
      onPressed: (){},
      menuItems: _focusedMenuItems(),
      menuWidth: MediaQuery.of(context).size.width*0.6,
      menuItemExtent: 40,
      openWithTap: true,
      animateMenuItems: false,
      menuOffset: 10.0,
      child: const Icon(Icons.format_paint_rounded),
    );
  }

  _focusedMenuItems() {
    var focusedMenuItemList = <FocusedMenuItem>[];
    data.forEach((dt) {
      if(dt[2] != 0) {
        focusedMenuItemList.add(
            FocusItem(
              backgroundColor: ThemeData
                  .dark()
                  .dialogBackgroundColor,
              title: dt[1],
              onPressed: () {
                setState(() => priceIcon = dt[0]);
                setState(() => priceItem.desc = dt[1]);
                setState(() => priceItem.price = dt[2]);
                setState(() {
                  priceItem.price = dt[2];
                  priceOfList += - oldPrice + priceItem.price!;
                  oldPrice = priceItem.price!;
                  const PriceListScreen().createState().reassemble();
                });
              },
              context: context,).itemT0()
        );
      }
      });
    return focusedMenuItemList;
  }

}