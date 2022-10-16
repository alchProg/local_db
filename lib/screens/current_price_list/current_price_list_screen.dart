import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:local_db/models/page_indicator_model.dart';
import 'package:local_db/models/price_list_items_model.dart';
import 'package:local_db/screens/global_user_items/global_user_items_screen.dart';
import 'package:local_db/screens/current_price_list/add_edit_user_item.dart';
import 'package:local_db/screens/current_price_list/components/counter_bloc.dart';
import 'package:local_db/screens/current_price_list/components/standart_items.dart';
import 'package:local_db/screens/current_price_list/components/user_items.dart';
import 'package:local_db/screens/saved_price_lists/add_edit_price_list_screen.dart';
import 'package:local_db/widget/animeted_circular_button.dart';

class PriceListScreen extends StatelessWidget {
  final String carType;
  final Map<String, List<dynamic>> selectedPartsList;
  final Map<String, PriceListItem> userPriceItemsList, standartPriceItemsList;

  const PriceListScreen({
    super.key,
    required this.carType,
    required this.selectedPartsList,
    required this.userPriceItemsList,
    required this.standartPriceItemsList,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CounterBloc>(
      create: (_) => CounterBloc(),
      child: PriceListScreenful(
        carType: carType,
        selectedPartsList: selectedPartsList,
        standartPriceItemsList: standartPriceItemsList,
        userPriceItemsList: userPriceItemsList,
      ),
    );
  }
}

class PriceListScreenful extends StatefulWidget {
  final String carType;
  final Map<String, List<dynamic>> selectedPartsList;
  final Map<String, PriceListItem> userPriceItemsList, standartPriceItemsList;
  const PriceListScreenful({
    Key? key,
    required this.carType,
    required this.selectedPartsList,
    required this.userPriceItemsList,
    required this.standartPriceItemsList,
  }) : super(key: key);

  @override
  State<PriceListScreenful> createState() => _PriceListScreenfulState();
}

class _PriceListScreenfulState extends State<PriceListScreenful>
    with SingleTickerProviderStateMixin {
  late TextEditingController _titleOfListController;
  late PageController _pageController;
  late AnimationController _buttonAnimationController;
  late Animation _buttonNewAnimation, _buttonTwoAnimation, _rotationAnimation;
  late CounterBloc _counterBloc;
  late int _totalPrice;
  double _ignoredHeight = 60;
  bool _isLoading = false;

  @override
  void initState() {
    _priceListInit();
    _buttonAnimationsInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _totalPriceInit().whenComplete(
          () => Future.delayed(const Duration(milliseconds: 10), () {
                _counterBloc.add(InitValue(value: _totalPrice));
              }));
    });

    super.initState();
  }

  @override
  void dispose() {
    _titleOfListController.dispose();
    _pageController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void _priceListInit() {
    _totalPrice = 0;
    _titleOfListController = TextEditingController(text: "Unnamed Price List");
    _pageController = PageController(initialPage: 0);
  }

  void _buttonAnimationsInit() {
    _buttonAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _buttonNewAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(_buttonAnimationController);
    _buttonTwoAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 45.0),
    ]).animate(_buttonAnimationController);
    _rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _buttonAnimationController, curve: Curves.easeOut));
    super.initState();
    _buttonAnimationController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _totalPriceInit() async {
    int summValue = 0;
    for (PriceListItem standartItem in widget.standartPriceItemsList.values) {
      summValue += standartItem.price!;
    }
    for (PriceListItem userItem in widget.userPriceItemsList.values) {
      summValue += userItem.price!;
    }
    _totalPrice = summValue;
  }

  Future<void> refreshCars() async {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext priceListContext) {
    _counterBloc = BlocProvider.of<CounterBloc>(priceListContext);
    Size size = MediaQuery.of(priceListContext).size;
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.all(5),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(priceListContext).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: _pageIndicator(),
                  ),
                  _slideItemsBuilder(),
                  const Divider(
                    color: Colors.white,
                    height: 2,
                  ),
                  _totalPriceBuilder(),
                ],
              ),
              _animeitedButon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pageIndicator() {
    Color color(Color activ, Color unActiv) {
      bool isSwaped =
          _pageController.hasClients ? _pageController.page! > 0.5 : false;
      return isSwaped ? unActiv : activ;
    }

    return AnimatedBuilder(
        animation: _pageController,
        builder: (context, snapshot) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                        color: color(Colors.lightBlueAccent, Colors.black26),
                        fontSize: 16),
                    child: const Text(
                      "Стандартные",
                      textAlign: TextAlign.right,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: CustomPaint(
                    painter: PageIndicatorPainter(
                      pageCount: 2,
                      dotRadius: 10,
                      dotOutlineThickness: 2,
                      spacing: 30,
                      scrollPosition: _pageController.hasClients
                          ? _pageController.page!
                          : 0.0,
                      dotFillColor: Colors.black12,
                      dotOutlineColor: Colors.black38,
                      indcatorColor: Colors.lightBlueAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Stack(children: [
                  AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                          color: color(Colors.black38, Colors.lightBlueAccent),
                          fontSize: 16),
                      child: const Text(
                        "Свои",
                        textAlign: TextAlign.left,
                      )),
                ]),
              ),
            ],
          );
        });
  }

  Widget _slideItemsBuilder() {
    return Expanded(
      child: PageView.builder(
          controller: _pageController,
          itemCount: 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return StandartItems(
                selectedPartsList: widget.selectedPartsList,
                standartPriceItemsList: widget.standartPriceItemsList,
              );
            } else {
              return UserItems(
                userPriceItemsList: widget.userPriceItemsList,
              );
            }
          }),
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
            BlocBuilder<CounterBloc, int>(
              bloc: _counterBloc,
              builder: (context, state) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    NumberFormat.currency(
                            locale: 'Ru-ru', symbol: '₽', decimalDigits: 0)
                        .format(state),
                    style:
                        const TextStyle(fontSize: 24, color: Colors.lightGreen),
                  ),
                );
              },
            )
          ],
        ));
  }

  PreferredSizeWidget _appBar() {
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
              controller: _titleOfListController,
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
      actions: [_saveButton(), const SizedBox(width: 12)],
    );
  }

  Widget _saveButton() {
    return IconButton(
      icon: const Icon(
        Icons.save,
        size: 30,
        color: Colors.lightBlueAccent,
      ),
      onPressed: () async {
        List<PriceListItem> tempList = [];
        tempList.addAll(widget.standartPriceItemsList.values);
        tempList.addAll(widget.userPriceItemsList.values);

        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddEditPriceListScreen(
                  items: tempList,
                  isFromNewSetList: true,
                )));
        tempList.clear;
      },
    );
  }

  Widget _animeitedButon() {
    return Positioned(
        right: 20,
        bottom: 5,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30)),
                height: _ignoredHeight,
                width: 60.0,
              ),
            ),
            AnimetedCircularButton(
                color: Colors.lightGreen,
                icon: const Icon(
                  Icons.fiber_new_outlined,
                ),
                onClick: () async {
                  await Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                              value: _counterBloc,
                              child: AddEditUserItemScreen(
                                  userPriceItemsList: widget.userPriceItemsList,
                                  counterBloc: _counterBloc))))
                      .then((value) {
                    _buttonAnimationController.reverse();
                    setState(() {
                      _ignoredHeight = 60;
                    });
                  });
                },
                degOffsetDir: 270,
                degAnimation: _buttonNewAnimation,
                rotationAnimation: _rotationAnimation),
            AnimetedCircularButton(
                color: Colors.blue,
                icon: const Icon(
                  Icons.g_mobiledata,
                  color: Colors.white,
                ),
                onClick: () async {
                  await Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                                value: _counterBloc,
                                child: GlobalUserItems(
                                  userPriceItemsList: widget.userPriceItemsList,
                                  counterBloc: _counterBloc,
                                ),
                              )))
                      .then((value) {
                    _buttonAnimationController.reverse();
                    setState(() {
                      _ignoredHeight = 60;
                    });
                  });
                },
                degOffsetDir: 270,
                liniarOffset: 75,
                degAnimation: _buttonTwoAnimation,
                rotationAnimation: _rotationAnimation),
            AnimetedCircularButton(
                width: 60,
                height: 60,
                color: Colors.teal.withOpacity(0.0),
                icon: const Icon(
                  Icons.add,
                  size: 40,
                  color: Colors.lightBlueAccent,
                ),
                onClick: () {
                  if (_buttonAnimationController.isCompleted) {
                    _buttonAnimationController.reverse();
                    setState(() {
                      _ignoredHeight = 60;
                    });
                  } else {
                    _buttonAnimationController.forward();
                    _pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn);
                    setState(() {
                      _ignoredHeight = 225;
                    });
                  }
                },
                rotationAnimation: _rotationAnimation),
          ],
        ));
  }
}
