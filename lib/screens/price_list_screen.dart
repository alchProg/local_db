import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:local_db/models/part_model.dart';
import 'package:local_db/models/price_list_model.dart';
import 'package:local_db/widget/fmi_widget.dart';
import 'package:local_db/widget/price_item_widget.dart';

class PriceListScreen extends StatefulWidget {
  const PriceListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PriceListScreen> createState() => _PriceListScreenState();
}

class _PriceListScreenState extends State<PriceListScreen> {
  TextEditingController titleOfListController = TextEditingController();
  late PriceList priceList;
  bool isLoading = true;
  String carType = '';

  String errMsg = "Вы забыли настроить профиль! \n"
      "На данный момент Ваш прайслист пуст.\n"
      "Перейдите в настройки профиля нажав на кнопку ниже. \n"
      "Далее в верхнем правом углу экрана нажмите на";

  @override
  void initState() {
    _priceListInit();
    super.initState();
  }

  @override
  void dispose() {
    priceOfListController.text = '0';
    super.dispose();
  }

  void _priceListInit() {
    titleOfListController.text = "Unnamed Price List";
    priceList = PriceList(
        carType: carType,
        title: titleOfListController.text,
        price: 0,
        createdTime: "createdTime");
  }

  Future refreshCars() async {
    setState(() => isLoading = true);
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _listBuilder(),
            Divider(
              color: Colors.white,
              height: 3,
            ),
            _totalPriceBuilder(),
          ],
        ),
      ),
    );
  }

  Widget _listBuilder() {
    List<Widget> listItems = [];
    for (Part part in selectedPartsList.values) {
      listItems.add(PriceItemWidget(
        part: part,
      ));
    }
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      height: (MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.top -
          90),
      child: SingleChildScrollView(
        child: Column(
          children: listItems,
        ),
      ),
    );
  }

  Widget _totalPriceBuilder() {
    return Container(
        height: 70,
        padding: const EdgeInsets.only(left: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Итого: ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextField(
                readOnly: true,
                maxLength: 20,
                controller: priceOfListController,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.lightGreen,
                ),
                decoration: const InputDecoration(
                    counterText: '', border: InputBorder.none),
              ),
            )
          ],
        ));
  }

  _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Прайс лист",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: 1,
              color: Colors.white38,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextField(
              readOnly: true,
              maxLength: 20,
              controller: titleOfListController,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.lightGreen,
              ),
              decoration: const InputDecoration(
                  counterText: '', border: InputBorder.none),
            ),
          ),
        ],
      ),
      actions: [_focusedMenu(), const SizedBox(width: 12)],
    );
  }

  _focusedMenu() {
    return FocusedMenuHolder(
      onPressed: () {},
      menuItems: _focusedMenuItems(),
      menuWidth: MediaQuery.of(context).size.width * 0.6,
      menuItemExtent: 40,
      openWithTap: true,
      menuOffset: 10.0,
      child: const Icon(Icons.menu_rounded),
    );
  }

  _focusedMenuItems() {
    var focusedMenuItemList = <FocusedMenuItem>[];
    focusedMenuItemList.add(FocusItem(
      backgroundColor: ThemeData.dark().dialogBackgroundColor,
      title: "focus item",
      onPressed: () {},
      context: context,
    ).itemT0());
    return focusedMenuItemList;
  }
}
