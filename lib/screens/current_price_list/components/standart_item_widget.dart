import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:local_db/models/price_list_items_model.dart';
// import 'package:local_db/models/price_list_model.dart';
import 'package:local_db/screens/current_price_list/components/counter_bloc.dart';
import 'package:local_db/widget/fmi_widget.dart';
import '../../../models/part_model.dart';

class StandartItemWidget extends StatefulWidget {
  final Part part;
  final int dataIndex;
  final Function? onDeletPressed;
  final ValueChanged<int>? onDataIndexChanged;
  final Map<String, PriceListItem> standartPriceItemsList;

  const StandartItemWidget({
    Key? key,
    required this.part,
    required this.dataIndex,
    this.onDataIndexChanged,
    this.onDeletPressed,
    required this.standartPriceItemsList,
  }) : super(key: key);

  @override
  State<StandartItemWidget> createState() => _StandartItemWidgetState();
}

class _StandartItemWidgetState extends State<StandartItemWidget> {
  late List<dynamic> _currentData;
  late PriceListItem _priceItem;
  late IconData _priceIcon;
  late int _priceIndex;
  late int _oldPrice;

  @override
  void initState() {
    _dataInit();
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
      isGlobal: false,
    );
    widget.standartPriceItemsList[_priceItem.title] = _priceItem;
    _oldPrice = _priceItem.price!;
  }

  void _onIndexChangedUpdate() {
    ValueChanged<int>? onIndexChanged = widget.onDataIndexChanged;
    if (onIndexChanged == null) {
      return;
    }
    onIndexChanged(_priceIndex);
  }

  DismissDirectionCallback dissmissed(DismissDirection direction) {
    return (direction) {};
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.zero,
          child: _focusedMenu(),
        ),
        Padding(
          padding: const EdgeInsets.all(2),
          child: _itemInfo(),
        )
      ]),
    );
  }

  Widget _focusedMenu() {
    List<FocusedMenuItem> focusedMenuItems() {
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
                _priceIndex = i;
                widget.standartPriceItemsList[_priceItem.title] = _priceItem;
              });
              context
                  .read<CounterBloc>()
                  .add(Increment(value: _priceItem.price! - _oldPrice));
              _onIndexChangedUpdate();
              _oldPrice = _priceItem.price!;
            },
            context: context,
          ).itemT0());
        }
      }
      return focusedMenuItemList;
    }

    Widget deletButton() {
      return IconButton(
        onPressed: (() async {
          context.read<CounterBloc>().add(Decrement(value: _priceItem.price!));
          widget.onDeletPressed!();
        }),
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
          size: 30,
        ),
        splashRadius: 20,
      );
    }

    return FocusedMenuHolder(
      onPressed: () {},
      menuItems: focusedMenuItems(),
      menuWidth: MediaQuery.of(context).size.width * 0.8,
      menuItemExtent: MediaQuery.of(context).size.height * 0.07,
      openWithTap: true,
      animateMenuItems: false,
      menuOffset: 10.0,
      child: ListTile(
        title: Text(
          _priceItem.title,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
        ),
        trailing: deletButton(),
      ),
    );
  }

  Widget _itemInfo() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade800,
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
    );
  }
}
