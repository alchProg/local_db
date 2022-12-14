import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:local_db/db/local_database.dart';
import 'package:local_db/screens/car/components/car_model.dart';
import 'package:local_db/models/price_list_items_model.dart';
import 'package:local_db/screens/current_price_list/current_price_list_screen.dart';
import 'package:local_db/screens/profile/profile_settings_screen.dart';
import 'package:local_db/widget/fmi_widget.dart';
import 'package:local_db/screens/current_price_list/components/images_parts.dart';

class SetScreen extends StatefulWidget {
  final int pID;
  final String pName;
  const SetScreen({Key? key, required this.pID, required this.pName})
      : super(key: key);

  @override
  State<SetScreen> createState() => _SetScreenState();
}

class _SetScreenState extends State<SetScreen> {
  late Map<String, List<dynamic>> selectedPartsList;
  late Map<String, PriceListItem> userPriceItemsList, standartPriceItemsList;
  late List<Car> cars;
  bool isLoading = true;
  String currentCarType = '------';

  String errMsg = "Вы забыли настроить профиль! \n"
      "На данный момент Ваш прайслист пуст.\n"
      "Перейдите в настройки профиля нажав на кнопку ниже. \n"
      "Далее в верхнем правом углу экрана нажмите на";

  @override
  void initState() {
    selectedPartsList = {};
    userPriceItemsList = {};
    standartPriceItemsList = {};
    partsAndCarsInit();
    super.initState();
  }

  @override
  void dispose() {
    selectedPartsList.clear();
    userPriceItemsList.clear();
    standartPriceItemsList.clear();
    super.dispose();
  }

  Future partsAndCarsInit() async {
    setState(() => isLoading = true);
    cars = await LocalDatabase.instance.readProfileCars(widget.pID);
    if (cars.isNotEmpty) {
      for (Car car in cars) {
        if (car.isGlobal) {
          final tParts = await LocalDatabase.instance
              .readProfileParts(car.title, widget.pID, null);
          if (tParts.isEmpty) {
            await LocalDatabase.instance
                .createProfileParts(widget.pID, car.title);
          }
        }
      }
      currentCarType = cars.last.title;
    }
    setState(() => isLoading = false);
  }

  Future refreshCars() async {
    setState(() => isLoading = true);
    cars = await LocalDatabase.instance.readProfileCars(widget.pID);
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() => isLoading = false);
    });
  }

  void _stateUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : cars.isEmpty
                    ? _carsIsEmpty()
                    : Center(
                        child: InteractiveViewer(
                          panEnabled: false,
                          boundaryMargin: const EdgeInsets.all(10),
                          minScale: 0.5,
                          maxScale: 1.5,
                          child: ImagesParts(
                            pID: widget.pID,
                            carType: currentCarType,
                            selectedPartsList: selectedPartsList,
                          ),
                        ),
                      ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward_ios_rounded),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PriceListScreen(
                    carType: currentCarType,
                    selectedPartsList: selectedPartsList,
                    standartPriceItemsList: standartPriceItemsList,
                    userPriceItemsList: userPriceItemsList,
                  )));
          _stateUpdate();
        },
      ),
    );
  }

  _appBar() {
    Widget focusedMenu() {
      List<FocusedMenuItem> focusedMenuItems() {
        var focusedMenuItemList = <FocusedMenuItem>[];
        if (cars.isNotEmpty) {
          for (Car car in cars) {
            focusedMenuItemList.add(FocusItem(
              backgroundColor: ThemeData.dark().dialogBackgroundColor,
              title: car.title,
              onPressed: () {
                setState(() => currentCarType = car.title);
                refreshCars();
                selectedPartsList.clear();
              },
              context: context,
            ).itemT0());
          }
        }
        return focusedMenuItemList;
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FocusedMenuHolder(
            onPressed: () {},
            menuItems: focusedMenuItems(),
            menuWidth: MediaQuery.of(context).size.width * 0.8,
            menuItemExtent: MediaQuery.of(context).size.height * 0.08,
            openWithTap: true,
            menuOffset: 10.0,
            child: const Icon(Icons.car_repair_rounded),
          ),
          Text(
            currentCarType,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Colors.lightBlueAccent),
          ),
        ],
      );
    }

    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextField(
              readOnly: true,
              maxLength: 20,
              controller: TextEditingController(text: widget.pName),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.lightGreen,
              ),
              decoration: const InputDecoration(
                  counterText: '', border: InputBorder.none),
            ),
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
          const Text(
            "Выбор\nдеталей",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: [
        isLoading ? const CircularProgressIndicator() : focusedMenu(),
        const SizedBox(width: 12)
      ],
    );
  }

  Widget _carsIsEmpty() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, top: 30, right: 10),
          child: Icon(
            Icons.warning_amber_rounded,
            size: 100,
            color: Colors.red,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            errMsg,
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.car_repair),
            Text(
              "=> 'Добавить'",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PartsSettingsScreen(
                      pID: widget.pID,
                      pName: widget.pName,
                    )));
            currentCarType == '------' ? partsAndCarsInit() : refreshCars();
          },
          child: const Text(
            "Настройка профиля",
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
