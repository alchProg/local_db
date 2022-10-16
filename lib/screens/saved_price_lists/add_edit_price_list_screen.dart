import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:local_db/db/local_database.dart';
import 'package:local_db/models/page_indicator_model.dart';
import 'package:local_db/models/price_list_items_model.dart';
import 'package:local_db/models/price_list_model.dart';
import 'package:local_db/screens/current_price_list/components/counter_bloc.dart';
import 'package:local_db/screens/global_user_items/global_user_items_screen.dart';
import 'package:local_db/screens/saved_price_lists/add_edit_list_item_screen.dart';
import 'package:local_db/screens/saved_price_lists/components/list_items.dart';
import 'package:local_db/screens/saved_price_lists/components/price_list_form_widget.dart';
import 'package:local_db/widget/animeted_circular_button.dart';

class AddEditPriceListScreen extends StatelessWidget {
  final PriceList? priceList;
  final List<PriceListItem>? items;
  final bool? isFromNewSetList;

  const AddEditPriceListScreen({
    Key? key,
    this.priceList,
    this.items,
    this.isFromNewSetList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CounterBloc>(
      create: (_) => CounterBloc(),
      child: AddEditPriceListScreenful(
        isFromNewSetList: isFromNewSetList,
        priceList: priceList,
        items: items,
      ),
    );
  }
}

class AddEditPriceListScreenful extends StatefulWidget {
  final PriceList? priceList;
  final List<PriceListItem>? items;
  final bool? isFromNewSetList;

  const AddEditPriceListScreenful({
    Key? key,
    this.priceList,
    this.items,
    this.isFromNewSetList,
  }) : super(key: key);

  @override
  _AddEditPriceListScreenfulState createState() =>
      _AddEditPriceListScreenfulState();
}

class _AddEditPriceListScreenfulState extends State<AddEditPriceListScreenful>
    with SingleTickerProviderStateMixin {
  late Size _size;

  late CounterBloc _counterBloc;

  late PageController _pageController;
  late AnimationController _buttonAnimationController;

  late Animation _buttonNewAnimation, _buttonTwoAnimation, _rotationAnimation;

  late List<PriceListItem> _items;

  late String _title;
  late String _pageTitle;
  late String _desc;
  late String _type;
  late String _clientPhoneNumber;
  late String _clientFullName;
  late String _deadLineTime;

  late double _ignoredHeight;
  late int _price;

  late bool _isCompleted;
  late bool _isPaid;
  late bool _isNew;
  late bool _isEditMode;
  late bool _isFromNewSetList;
  late bool _isLoading;

  @override
  void initState() {
    _counterBloc = CounterBloc();
    _pageController = PageController(initialPage: 0);

    _dataInit();
    _itemsInit();
    _buttonAnimationsInit();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _buttonAnimationController.dispose();
    _items.clear();
    super.dispose();
  }

  void _dataInit() {
    _isLoading = false;
    _ignoredHeight = 60;
    _isNew = widget.priceList == null;
    _isFromNewSetList = widget.isFromNewSetList ?? false;

    if (_isNew) {
      _isEditMode = true;
      _title = '';
      _pageTitle = 'Новый прайс лист';
    } else {
      if (widget.priceList!.title.isNotEmpty) {
        _title = widget.priceList!.title;
      } else {
        _title =
            "Прайс лист №${widget.priceList!.id} от ${widget.priceList!.createdTime}";
      }
      _isEditMode = false;
      _pageTitle = _title;
    }

    _price = widget.priceList?.price ?? 0;
    _desc = widget.priceList?.desc ?? '';
    _type = widget.priceList?.carType ?? '';
    _clientFullName = widget.priceList?.clientFullName ?? '';
    _clientPhoneNumber = widget.priceList?.clientPhoneNumber ?? '';
    _deadLineTime = widget.priceList?.deadLineTime ??
        DateFormat('dd.MM.yy - kk:mm').format(DateTime.now());
    _isCompleted = widget.priceList?.isCompleted ?? false;
    _isPaid = widget.priceList?.isPaid ?? false;
  }

  Future<void> _itemsInit() async {
    int tempInt = 0;
    if (_isNew) {
      if (widget.items != null) {
        _items = widget.items!;
      } else {
        _items = [];
        _counterBloc.add(InitValue(value: _price));
        return;
      }
    } else {
      await LocalDatabase.instance
          .readLIDPriceListItems(widget.priceList!.id!)
          .then((dbItems) {
        _items = dbItems;
      });
    }
    for (PriceListItem item in _items) {
      tempInt += item.price!.toInt();
    }
    _price = tempInt;
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() => _counterBloc.add(InitValue(value: tempInt)));
    });
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

  Future<void> _dbItemsRefresh() async {
    setState(() => _isLoading = true);
    await LocalDatabase.instance
        .readLIDPriceListItems(widget.priceList!.id!)
        .then((dbItems) {
      _items = List.from(dbItems);
      Future.delayed(const Duration(milliseconds: 10),
          () => setState(() => _isLoading = false));
    });
  }

  void _instaPriceUpdate() async {
    if (widget.priceList != null) {
      final priceList = widget.priceList!.copy(
        price: _price,
      );
      await LocalDatabase.instance.updatePriceList(priceList);
    }
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _counterBloc = BlocProvider.of<CounterBloc>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          _pageTitle,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [buildButton()],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: _pageIndicator(),
        ),
      ),
      body: SizedBox(
        width: _size.width,
        height: _size.height,
        child: Stack(children: [
          _slideItemsBuilder(),
          _animeitedButon(),
        ]),
      ),
    );
  }

  Widget _pageIndicator() {
    Color color(Color activ, Color unActiv) {
      bool isSwaped = _pageController.hasClients
          ? _pageController.page == null
              ? false
              : _pageController.page! > 0.5
          : false;
      return isSwaped ? unActiv : activ;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedBuilder(
          animation: _pageController,
          builder: (context, snapshot) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: _size.width * 0.35,
                  child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                          color: color(Colors.lightBlueAccent, Colors.black26),
                          fontSize: 16),
                      child: const Text(
                        "Информация",
                        textAlign: TextAlign.right,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: SizedBox(
                    width: _size.width * 0.2,
                    child: CustomPaint(
                      painter: PageIndicatorPainter(
                        pageCount: 2,
                        dotRadius: 10,
                        dotOutlineThickness: 2,
                        spacing: 30,
                        scrollPosition: _pageController.hasClients
                            ? _pageController.page == null
                                ? 0.0
                                : _pageController.page!
                            : 0.0,
                        dotFillColor: Colors.black12,
                        dotOutlineColor: Colors.black38,
                        indcatorColor: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: _size.width * 0.35,
                  child: Stack(children: [
                    AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                            color:
                                color(Colors.black38, Colors.lightBlueAccent),
                            fontSize: 16),
                        child: const Text(
                          "Список",
                          textAlign: TextAlign.left,
                        )),
                  ]),
                ),
              ],
            );
          }),
    );
  }

  Widget _slideItemsBuilder() {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
              controller: _pageController,
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        PriceListFormWidget(
                          isEditMode: _isEditMode,
                          clientName: _clientFullName,
                          clientPhone: _clientPhoneNumber,
                          desc: _desc,
                          isCompleted: _isCompleted,
                          isPaid: _isPaid,
                          deadLine: _deadLineTime,
                          onChangedClientName: (cName) =>
                              setState(() => _clientFullName = cName),
                          onChangedClientPhone: (cPhone) =>
                              setState(() => _clientPhoneNumber = cPhone),
                          onChangedDesc: (cDesc) =>
                              setState(() => _desc = cDesc),
                          onChangedDeadLine: (cDeadLineTime) =>
                              setState(() => _deadLineTime = cDeadLineTime),
                          onChangedisCompleted: (cCompleted) =>
                              setState(() => _isCompleted = cCompleted!),
                          onChangedisPaid: (cPaid) =>
                              setState(() => _isPaid = cPaid!),
                        ),
                      ],
                    ),
                  );
                } else {
                  return _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListItems(
                          isEditMode: _isEditMode,
                          lID: widget.priceList?.id,
                          items: _items,
                          counterBloc: _counterBloc,
                        );
                }
              }),
        ),
        _totalPriceBuilder(),
      ],
    );
  }

  Widget _totalPriceBuilder() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Container(
          height: 70,
          padding: const EdgeInsets.only(left: 10),
          decoration: const BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "На сумму: ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              BlocBuilder<CounterBloc, int>(
                bloc: _counterBloc,
                builder: (context, state) {
                  _price = state;
                  _instaPriceUpdate();
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      NumberFormat.currency(
                              locale: 'Ru-ru', symbol: '₽', decimalDigits: 0)
                          .format(state),
                      style: const TextStyle(
                          fontSize: 24, color: Colors.lightGreen),
                    ),
                  );
                },
              )
            ],
          )),
    );
  }

  Widget buildButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: IconButton(
        onPressed: () {
          setState(() => _isEditMode = !_isEditMode);
          _isEditMode ? _addOrUpdate : {};
        },
        icon: Icon(
          _isEditMode ? Icons.save : Icons.edit,
          color: Colors.lightBlueAccent,
        ),
      ),
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
                        builder: (context) => AddEditListItemScreen(
                              lID: widget.priceList?.id,
                              items: _isNew ? _items : null,
                              onPriceChanged: (addToPrice) {
                                _counterBloc.add(Increment(value: addToPrice));
                              },
                            )))
                    .then((_) {
                  _buttonAnimationController.reverse();
                  setState(() => _ignoredHeight = 60);
                });
                if (!_isNew) {
                  _dbItemsRefresh();
                }
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
                                items: _items,
                                lID: widget.priceList?.id,
                                counterBloc: _counterBloc,
                              ),
                            )))
                    .then((value) {
                  _buttonAnimationController.reverse();
                  setState(() => _ignoredHeight = 60);
                });
                if (!_isNew) {
                  _dbItemsRefresh();
                }
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
      ),
    );
  }

  void _addOrUpdate() async {
    final isUpdating = widget.priceList != null;
    if (isUpdating) {
      await _update();
    } else {
      await _add();
    }
  }

  Future _update() async {
    final priceList = widget.priceList!.copy(
      price: _price,
      title: _title,
      desc: _desc,
      carType: _type,
      clientFullName: _clientFullName,
      clientPhoneNumber: _clientPhoneNumber,
      deadLineTime: _deadLineTime,
      isCompleted: _isCompleted,
      isPaid: _isPaid,
    );
    await LocalDatabase.instance.updatePriceList(priceList).whenComplete(() {});
  }

  Future _add() async {
    final newPriceList = PriceList(
      createdTime: DateFormat('dd.MM.yyyy – kk:mm').format(DateTime.now()),
      deadLineTime: _deadLineTime,
      price: _price,
      title: _title,
      desc: _desc,
      carType: _type,
      clientFullName: _clientFullName,
      clientPhoneNumber: _clientPhoneNumber,
      isCompleted: _isCompleted,
      isPaid: _isPaid,
    );

    await LocalDatabase.instance
        .createPriceList(newPriceList)
        .then((priceList) async {
      for (PriceListItem item in _items) {
        item.lID = priceList.id;
        await LocalDatabase.instance.createPriceListItem(item);
      }

      final tempList = priceList.copy(
        title: "Прайс лист №${priceList.id} от ${priceList.createdTime}",
      );
      await LocalDatabase.instance.updatePriceList(tempList).whenComplete(() {
        if (_isFromNewSetList) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => true);
          Navigator.pushNamed(context, '/priceLists');
        } else {
          Navigator.of(context).pop();
        }
      });
    });
  }
}
