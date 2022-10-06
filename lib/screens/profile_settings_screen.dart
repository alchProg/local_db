import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:local_db/db/local_database.dart';
import 'package:local_db/models/page_indicator_model.dart';
import '../models/car_model.dart';
import '../models/part_model.dart';
import '../widget/fmi_widget.dart';
import '../widget/parts_side_slide_items.dart';
import 'add_edit_car_screen.dart';

class PartsSettingsScreen extends StatefulWidget {
  final int pID;
  final String pName;

  const PartsSettingsScreen({Key? key, required this.pID, required this.pName})
      : super(key: key);

  @override
  _PartsSettingsScreenState createState() => _PartsSettingsScreenState();
}

class _PartsSettingsScreenState extends State<PartsSettingsScreen> {
  late List<Car> cars;
  late List<List<Part>> parts;
  bool isLoading = true;
  String currentCarType = '';
  String side = "Лево";
  late PageController _pageController;

  @override
  void initState() {
    partsAndCarsInit();
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
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
      currentCarType = cars.first.title;
      parts = [
        await LocalDatabase.instance
            .readProfileParts(currentCarType, widget.pID, 'Лево'),
        await LocalDatabase.instance
            .readProfileParts(currentCarType, widget.pID, 'Центр'),
        await LocalDatabase.instance
            .readProfileParts(currentCarType, widget.pID, 'Право'),
      ];
    }
    setState(() => isLoading = false);
  }

  Future refreshCars() async {
    setState(() => isLoading = true);
    cars = await LocalDatabase.instance.readProfileCars(widget.pID);
    setState(() => isLoading = false);
  }

  Future refreshParts() async {
    setState(() => isLoading = true);
    parts = [
      await LocalDatabase.instance
          .readProfileParts(currentCarType, widget.pID, 'Лево'),
      await LocalDatabase.instance
          .readProfileParts(currentCarType, widget.pID, 'Центр'),
      await LocalDatabase.instance
          .readProfileParts(currentCarType, widget.pID, 'Право'),
    ];
    Future.delayed(const Duration(milliseconds: 5), () {
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : cars.isEmpty
              ? const Center(
                  child: Text(
                    'Выберите тип',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                )
              : parts[0].isEmpty
                  ? const Center(
                      child: Text(
                        'Нет частей',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: _pageIndicator(),
                        ),
                        Expanded(
                          child: PageView.builder(
                              controller: _pageController,
                              itemCount: parts.length,
                              itemBuilder: (ctx, i) {
                                return PartsSlideItems(
                                  pID: widget.pID,
                                  currentCarType: currentCarType,
                                  pName: widget.pName,
                                  parts: parts[i],
                                );
                              }),
                        ),
                      ],
                    ),
    );
  }

  Widget _pageIndicator() {
    return AnimatedBuilder(
        animation: _pageController,
        builder: (context, snapshot) {
          return CustomPaint(
            painter: PageIndicatorPainter(
              pageCount: 3,
              dotRadius: 10,
              dotOutlineThickness: 2,
              spacing: 30,
              scrollPosition:
                  _pageController.hasClients ? _pageController.page! : 0.0,
              dotFillColor: Colors.black12,
              dotOutlineColor: Colors.black38,
              indcatorColor: Colors.teal,
            ),
          );
        });
  }

  _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
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
            "Настройка\nпрофиля",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: [
        isLoading ? const CircularProgressIndicator() : _focusedMenu(),
        const SizedBox(width: 12)
      ],
    );
  }

  _focusedMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FocusedMenuHolder(
          onPressed: () {},
          menuItems: _focusedMenuItems(),
          menuWidth: MediaQuery.of(context).size.width * 0.8,
          menuItemExtent: MediaQuery.of(context).size.height * 0.07,
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

  _focusedMenuItems() {
    var focusedMenuItemList = <FocusedMenuItem>[];
    if (cars.isNotEmpty) {
      for (Car car in cars) {
        focusedMenuItemList.add(FocusItem(
          backgroundColor: ThemeData.dark().dialogBackgroundColor,
          title: car.title,
          onPressed: () {
            setState(() {
              currentCarType = car.title;
              refreshParts();
            });
          },
          onTapL: () async {
            await LocalDatabase.instance.deleteCar(car.id!);
            await LocalDatabase.instance
                .deleteTypeParts(widget.pID, car.title, car.isGlobal);
            partsAndCarsInit();
            setState(() => Navigator.of(context).pop());
          },
          iconL: const Icon(
            Icons.delete_rounded,
            color: Colors.red,
          ),
          onTapR: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddEditCarScreen(
                      pID: widget.pID,
                      car: car,
                    )));
            partsAndCarsInit();
            setState(() => Navigator.of(context).pop());
          },
          iconR: const Icon(
            Icons.edit_note_rounded,
            color: Colors.lightBlue,
          ),
          context: context,
        ).itemT1());
      }
    }

    focusedMenuItemList.add(FocusItem(
            title: "Добавить",
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddEditCarScreen(pID: widget.pID)));
              partsAndCarsInit();
            },
            context: context)
        .itemT0());
    return focusedMenuItemList;
  }
}
