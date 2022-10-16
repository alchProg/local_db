import 'package:flutter/material.dart';
import 'package:local_db/db/local_database.dart';
import 'package:local_db/models/price_list_items_model.dart';
import 'package:local_db/screens/global_user_items/components/add_edit_global_user_item.dart';
import 'package:local_db/screens/global_user_items/components/global_user_item_widget.dart';
import 'package:local_db/screens/current_price_list/components/counter_bloc.dart';

class GlobalUserItems extends StatefulWidget {
  final Map<String, PriceListItem>? userPriceItemsList;
  final List<PriceListItem>? items;
  final CounterBloc? counterBloc;
  final int? lID;
  const GlobalUserItems({
    super.key,
    this.userPriceItemsList,
    this.counterBloc,
    this.items,
    this.lID,
  });

  @override
  State<GlobalUserItems> createState() => _GlobalUserItemsState();
}

class _GlobalUserItemsState extends State<GlobalUserItems> {
  late TextEditingController _titleOfScreen;
  late List<PriceListItem> _selectedItems;
  late List<PriceListItem> _items;
  late bool _longPressed;
  late bool _isLoading;
  late bool _openFromPriceList;
  late bool _openFromPriceListEdit;

  @override
  void initState() {
    _openFromPriceList = widget.userPriceItemsList != null;
    _openFromPriceListEdit = widget.items != null;
    _longPressed = false;
    _selectedItems = [];
    _titleOfScreen = TextEditingController(text: 'Глобальные');
    _refreshItems();
    super.initState();
  }

  @override
  void dispose() {
    _longPressed = false;
    _selectedItems.clear();
    _titleOfScreen.dispose();
    super.dispose();
  }

  void _refreshItems() async {
    setState(() => _isLoading = true);
    await LocalDatabase.instance.readGlobalPriceListItems().then((dBitems) {
      _items = dBitems;
      if (_openFromPriceList) {
        for (String listItem in widget.userPriceItemsList!.keys) {
          _items.removeWhere((item) => item.title == listItem);
        }
      }
      if (_openFromPriceListEdit) {
        for (PriceListItem listItem in widget.items!) {
          _items.removeWhere((item) => item.title == listItem.title);
        }
      }
      setState(() => _isLoading = false);
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
        height: (MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.top -
            120),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _items.isEmpty
                ? _listIsEmpty()
                : _itemsBuilder(),
      ),
      floatingActionButton: _longPressed ? _isSelected() : _addNewItem(),
    );
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
              controller: _titleOfScreen,
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

  void _addOrDeleteItem(bool checked, PriceListItem item) {
    if (checked) {
      _selectedItems.add(item);
    } else {
      _selectedItems.remove(item);
    }
  }

  Widget _itemsBuilder() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return GlobalUserItemWidget(
                item: _items[index],
                onCheckedChanged: (value) =>
                    _addOrDeleteItem(value, _items[index]),
                longPressed: _longPressed,
                onLongPressed: (longPressed) {
                  setState(() {
                    _longPressed = longPressed;
                    if (!longPressed) {
                      _selectedItems.clear();
                    }
                  });
                },
                onTap: () async {
                  await Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => AddEditGlobalUserItemScreen(
                                item: _items[index],
                              )))
                      .then((_) => _refreshItems());
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
              setState(() => _isLoading = true);
              for (PriceListItem item in _selectedItems) {
                await LocalDatabase.instance.deletePriceListItem(item.id!);
              }
              _refreshItems();
            },
          ),
          _openFromPriceList
              ? FloatingActionButton(
                  backgroundColor: Colors.green,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    int totalPlussPrice = 0;
                    for (PriceListItem item in _selectedItems) {
                      final newItem = PriceListItem(
                        title: item.title,
                        price: item.price,
                        desc: item.desc,
                        isGlobal: false,
                      );
                      if (!widget.userPriceItemsList!
                          .containsKey(newItem.title)) {
                        widget.userPriceItemsList![newItem.title] = newItem;
                        totalPlussPrice += newItem.price!;
                      }
                    }
                    widget.counterBloc!.add(Increment(value: totalPlussPrice));
                    setState(() {
                      _longPressed = false;
                    });
                    Navigator.of(context).pop();
                  },
                )
              : _openFromPriceListEdit
                  ? FloatingActionButton(
                      backgroundColor: Colors.green,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () async {
                        _addToList()
                            .whenComplete(() => Navigator.of(context).pop());
                      },
                    )
                  : const Padding(padding: EdgeInsets.all(0)),
        ],
      ),
    );
  }

  Future<void> _addToList() async {
    int totalPlussPrice = 0;
    for (PriceListItem item in _selectedItems) {
      final newItem = PriceListItem(
        lID: widget.lID,
        title: item.title,
        price: item.price,
        desc: item.desc,
        isGlobal: false,
      );
      totalPlussPrice += newItem.price!;

      widget.lID == null
          ? widget.items!.add(newItem)
          : await LocalDatabase.instance.createPriceListItem(newItem);
    }
    widget.counterBloc!.add(Increment(value: totalPlussPrice));
    setState(() {
      _longPressed = false;
    });
  }

  Widget _addNewItem() {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      child: const Icon(
        Icons.fiber_new_outlined,
        color: Colors.white,
        size: 30,
      ),
      onPressed: () async {
        await Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => const AddEditGlobalUserItemScreen(
                      isGlobal: true,
                    )))
            .then((_) => _refreshItems());
      },
    );
  }
}
