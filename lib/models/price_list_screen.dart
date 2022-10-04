
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:local_db/models/part_model.dart';
import 'package:local_db/models/price_list_items_model.dart';
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

  late PriceList priceList;
  bool isLoading = true;
  String carType = '';
  TextEditingController priceOfListController = TextEditingController(text: "$priceOfList");


  String errMsg = "Вы забыли настроить профиль! \n"
      "На данный момент Ваш прайслист пуст.\n"
      "Перейдите в настройки профиля нажав на кнопку ниже. \n"
      "Далее в верхнем правом углу экрана нажмите на";




  @override
  void initState() {
    _priceListInit();
    super.initState();
  }



  void _priceListInit() {
    priceList = PriceList(
        carType: carType,
        title: "Unnamed Price List",
        price: priceOfList,
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
    priceOfListController.text = priceOfList.toString();
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView (
        child: Column (
          children: _listBuilder(),
        ),
      ),
    );
  }

  _listBuilder() {
    List<Widget> temp = [];
    selectedPartsList.forEach((part) {
      temp.add(PriceItemWidget(part: part, priceList: priceList,));
    });
    return temp;
  }

  _appBar(){
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width*0.3,
            child: TextField(
              readOnly: true,
              maxLength: 20,
              controller: TextEditingController(text: "$priceOfList"),
              style: const TextStyle(fontSize: 14, color: Colors.lightGreen,),
              decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 5),
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: 1,
              color: Colors.white38,
            ),
          ),
          const Text(
            "Прайс \n лист",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: [
        _focusedMenu(),
        const SizedBox(width: 12)],
    );
  }

  _focusedMenu(){
    return FocusedMenuHolder(
      onPressed: (){},
      menuItems: _focusedMenuItems(),
      menuWidth: MediaQuery.of(context).size.width*0.6,
      menuItemExtent: 40,
      openWithTap: true,
      menuOffset: 10.0,
      child: const Icon(Icons.menu_rounded),
    );
  }

  _focusedMenuItems() {
    var focusedMenuItemList = <FocusedMenuItem>[];
        focusedMenuItemList.add(
            FocusItem(
              backgroundColor: ThemeData.dark().dialogBackgroundColor,
              title: "focus item",
              onPressed: () {
              },
              context: context,).itemT0()
        );
    return focusedMenuItemList;
  }
}
