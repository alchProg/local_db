import 'package:flutter/material.dart';
import 'package:local_db/db/local_database.dart';
import 'package:local_db/models/price_list_items_model.dart';
import 'package:local_db/screens/global_user_items/components/add_edit_global_user_item.dart';
import 'package:local_db/screens/global_user_items/components/global_user_item_widget.dart';
import 'package:local_db/screens/current_price_list/components/counter_bloc.dart';
import 'package:local_db/screens/saved_price_lists/add_edit_list_item_screen.dart';
import 'package:local_db/screens/saved_price_lists/components/list_item_widget.dart';

class ListItems extends StatefulWidget {
  final VoidCallback? onDeletePressed;
  final bool? isEditMode;
  final List<PriceListItem>? items;
  final CounterBloc? counterBloc;
  final int? lID;
  final int? price;
  const ListItems({
    super.key,
    this.counterBloc,
    this.lID,
    this.items,
    this.price,
    this.onDeletePressed,
    this.isEditMode,
  });

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  late List<PriceListItem> _selectedItems;
  late List<PriceListItem> _items;
  late bool _longPressed;
  late bool _isLoading;

  @override
  void initState() {
    _isLoading = false;
    _longPressed = false;
    _selectedItems = [];
    _items = [];
    _refreshItems();
    super.initState();
  }

  @override
  void dispose() {
    _longPressed = false;
    _selectedItems.clear();
    super.dispose();
  }

  void _refreshItems() async {
    if (widget.lID == null && widget.items == null) {
      return;
    }
    setState(() => _isLoading = true);
    _items = widget.items ??
        await LocalDatabase.instance.readLIDPriceListItems(widget.lID!);
    Future.delayed(const Duration(milliseconds: 15), () {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return ListItemWidget(
                  item: _items[index],
                  isEditMode: widget.isEditMode,
                  onDeletePressed: () async {
                    widget.counterBloc
                        ?.add(Decrement(value: (_items[index].price!.toInt())));
                    if (widget.lID != null) {
                      await LocalDatabase.instance
                          .deletePriceListItem(_items[index].id!);
                    }
                    setState(() => _items.remove(_items[index]));
                  },
                  onTap: () async {
                    await Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => AddEditListItemScreen(
                                  item: _items[index],
                                  onPriceChanged: (deltaPrice) {
                                    widget.counterBloc?.add(Increment(
                                        value: (deltaPrice -
                                            _items[index].price!.toInt())));
                                  },
                                )))
                        .then((_) => _refreshItems());
                  },
                );
              },
            ),
          ),
        ],
      ),
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
        ],
      ),
    );
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
