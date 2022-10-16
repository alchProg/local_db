import 'package:flutter/material.dart';
import 'package:local_db/db/local_database.dart';
import 'package:local_db/models/price_list_model.dart';
import 'package:local_db/screens/saved_price_lists/add_edit_price_list_screen.dart';
import 'package:local_db/screens/saved_price_lists/components/price_list_card_widget.dart';

class PriceListsSreen extends StatefulWidget {
  const PriceListsSreen({
    super.key,
  });

  @override
  State<PriceListsSreen> createState() => _PriceListsSreenState();
}

class _PriceListsSreenState extends State<PriceListsSreen> {
  late PageController _pageController;
  late TextEditingController _titleOfScreen;
  late List<PriceList> _selectedPriceLists;
  late List<PriceList> _priceLists;
  late bool _longPressed;
  late bool _isLoading;

  @override
  void initState() {
    _pageController = PageController();
    _isLoading = true;
    _priceLists = [];
    _longPressed = false;
    _selectedPriceLists = [];
    _titleOfScreen = TextEditingController(text: 'Сохраненные прайс листы');
    _refreshPriceLists();
    super.initState();
  }

  @override
  void dispose() {
    _selectedPriceLists.clear();
    _pageController.dispose();
    _titleOfScreen.dispose();
    super.dispose();
  }

  void _refreshPriceLists() async {
    setState(() => _isLoading = true);
    _priceLists =
        await LocalDatabase.instance.readAllPriceLists().whenComplete(() {
      Future.delayed(const Duration(milliseconds: 10), () {
        setState(() => _isLoading = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _priceLists.isEmpty
                ? _listIsEmpty()
                : _priceListsBuilder(),
      ),
      floatingActionButton: _longPressed ? _isSelected() : _addNewPriceList(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: TextField(
          readOnly: true,
          maxLength: 40,
          controller: _titleOfScreen,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          decoration:
              const InputDecoration(counterText: '', border: InputBorder.none),
        ),
      ),
      actions: _longPressed
          ? [
              IconButton(
                  onPressed: (() => setState(() => _longPressed = false)),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.lightBlueAccent,
                    size: 30,
                  )),
              const SizedBox(
                width: 10,
              )
            ]
          : [],
    );
  }

  Widget _listIsEmpty() {
    return const Center(
      child: Text(
        "Список пуст.\n"
        "Добавьте позицию кликнув на кнпку '+' \n"
        "в нижнем правом углу экрана",
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  void _addOrDeleteItem(bool checked, PriceList priceList) {
    if (checked) {
      _selectedPriceLists.add(priceList);
    } else {
      _selectedPriceLists.remove(priceList);
    }
  }

  Widget _priceListsBuilder() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _priceLists.length,
            itemBuilder: (context, index) {
              return PriceListCardWidget(
                priceList: _priceLists[index],
                onChanged: (value) =>
                    _addOrDeleteItem(value, _priceLists[index]),
                longPressed: _longPressed,
                onLongPressed: (longPressed) {
                  setState(() {
                    _longPressed = longPressed;
                    if (!longPressed) {
                      _selectedPriceLists.clear();
                    }
                  });
                },
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddEditPriceListScreen(
                            priceList: _priceLists[index],
                          )));
                  _refreshPriceLists();
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _isSelected() {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.red,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () async {
              for (PriceList priceList in _selectedPriceLists) {
                await LocalDatabase.instance.deletePriceList(priceList.id!);
                await LocalDatabase.instance
                    .deletePriceListItems(priceList.id!);
              }
              setState(() => _longPressed = false);
              _refreshPriceLists();
            },
          ),
          FloatingActionButton(
            backgroundColor: Colors.lightBlueAccent,
            child: const Icon(
              Icons.share_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              int totalPlussPrice = 0;
              for (PriceList priceList in _selectedPriceLists) {
                return;
              }
              setState(() {
                _longPressed = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _addNewPriceList() {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      child: const Icon(
        Icons.fiber_new_outlined,
        color: Colors.white,
        size: 30,
      ),
      onPressed: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddEditPriceListScreen()));
        _refreshPriceLists();
      },
    );
  }
}
