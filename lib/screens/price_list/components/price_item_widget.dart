import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:local_db/models/price_list_items_model.dart';
import 'package:local_db/models/price_list_model.dart';
import 'package:local_db/widget/fmi_widget.dart';
import '../../../models/part_model.dart';

class PriceItemWidget extends StatefulWidget {
  const PriceItemWidget({
    Key? key,
    required this.part,
    this.onIndexChanged,
    this.onPriceChanged,
    required this.dataIndex,
  }) : super(key: key);

  final Part part;
  final ValueChanged<int>? onIndexChanged;
  final ValueChanged<int>? onPriceChanged;
  final int dataIndex;

  @override
  State<PriceItemWidget> createState() => _PriceItemWidgetState();
}

class _PriceItemWidgetState extends State<PriceItemWidget> {
  late List<dynamic> _currentData;
  late PriceListItem _priceItem;
  late IconData _priceIcon;
  late int _priceIndex;
  int _oldItemPrice = 0;

  @override
  void initState() {
    _dataInit();
    standartPriceItemsList[_priceItem.title] = _priceItem;
    super.initState();
  }

  void _dataInit() {
    _priceIndex = widget.dataIndex;

    _currentData = [
      [Icons.looks_one_rounded, widget.part.desc1!, widget.part.price1!],
      [Icons.looks_two_rounded, widget.part.desc2!, widget.part.price2!],
      [Icons.looks_3_rounded, widget.part.desc3!, widget.part.price3!],
      [Icons.looks_4_rounded, widget.part.desc4!, widget.part.price4!],
    ];

    _priceIcon = _currentData[_priceIndex][0];
    _priceItem = PriceListItem(
      title: widget.part.title,
      desc: _currentData[_priceIndex][1],
      price: _currentData[_priceIndex][2],
    );

    _oldItemPrice = _priceItem.price!;
  }

  int _parseReplace(String inputStr) {
    RegExp regEx = RegExp(r'[^0-9]');
    return int.parse(inputStr.replaceAll(regEx, ''));
  }

  void _onPriceChanged() {
    ValueChanged<int>? onPriceChanged = widget.onPriceChanged;
    if (onPriceChanged == null) {
      return;
    }
    onPriceChanged(_priceItem.price! - _oldItemPrice);
  }

  void _onIndexChanged() {
    ValueChanged<int>? onIndexChanged = widget.onIndexChanged;
    if (onIndexChanged == null) {
      return;
    }
    onIndexChanged(_priceIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.zero,
          child: ListTile(
            title: Text(
              _priceItem.title,
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
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(4),
                )),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      _priceIcon,
                      size: 20,
                      color: Colors.black,
                      shadows: const [
                        Shadow(
                            color: Colors.white,
                            blurRadius: 15,
                            offset: Offset(0, 0)),
                        Shadow(
                            color: Colors.white,
                            blurRadius: 15,
                            offset: Offset(0, 0)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 1,
                        height: 25,
                        color: Colors.white38,
                      ),
                    ),
                    Text(
                      NumberFormat.currency(
                              locale: 'Ru-ru', symbol: '₽', decimalDigits: 0)
                          .format(_priceItem.price),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  _priceItem.desc!,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  _focusedMenu() {
    return FocusedMenuHolder(
      onPressed: () {},
      menuItems: _focusedMenuItems(),
      menuWidth: MediaQuery.of(context).size.width * 0.8,
      menuItemExtent: MediaQuery.of(context).size.height * 0.07,
      openWithTap: true,
      animateMenuItems: false,
      menuOffset: 10.0,
      child: const Icon(
        Icons.format_paint_rounded,
        size: 30,
        color: Colors.black,
        shadows: [
          Shadow(color: Colors.white, blurRadius: 5, offset: Offset(0, 0)),
          Shadow(color: Colors.white, blurRadius: 15, offset: Offset(0, 0)),
        ],
      ),
    );
  }

  _focusedMenuItems() {
    List<FocusedMenuItem> focusedMenuItemList = <FocusedMenuItem>[];
    List<dynamic> cdt = _currentData;
    for (int i = 0; i < _currentData.length; i++) {
      if (cdt[i][2] != 0) {
        focusedMenuItemList.add(FocusItem(
          backgroundColor: ThemeData.dark().dialogBackgroundColor,
          title: cdt[i][1],
          onPressed: () {
            setState(() {
              _priceIcon = cdt[i][0];
              _priceItem.desc = cdt[i][1];
              _priceItem.price = cdt[i][2];

              int newPrice = _parseReplace(priceOfListController.text) +
                  (-_oldItemPrice + _priceItem.price!);
              priceOfListController.text = NumberFormat.currency(
                      locale: 'Ru-ru', symbol: '₽', decimalDigits: 0)
                  .format(newPrice);
              _oldItemPrice = _priceItem.price!;
              _priceIndex = i;
              _onIndexChanged();
              _onPriceChanged();
              // const PriceListScreen().createState().reassemble();
            });
          },
          context: context,
        ).itemT0());
      }
    }
    return focusedMenuItemList;
  }
}
