import 'package:flutter/material.dart';
import 'package:local_db/models/price_list_items_model.dart';
import 'package:local_db/screens/price_list/components/user_item_widget.dart';

class UserItems extends StatelessWidget {
  final VoidCallback? onDissmissed;
  final ValueChanged<int>? onPriceChanged;

  UserItems({super.key, this.onDissmissed, this.onPriceChanged});
  List<Widget> listItems = [];

  void _onDissmisedUpdate() {
    VoidCallback? _onDissmissed = onDissmissed;
    if (_onDissmissed == null) {
      return;
    }
    _onDissmissed();
  }

  void _onPriceChangedUpdate(item) {
    ValueChanged<int>? _onPriceChanged = onPriceChanged;
    if (_onPriceChanged == null) {
      return;
    }
    _onPriceChanged(item);
  }

  @override
  Widget build(BuildContext context) {
    for (PriceListItem item in userPriceItemsList.values) {
      listItems.add(Dismissible(
          key: Key(item.title),
          onDismissed: (direction) {
            userPriceItemsList.remove(item.title);
            _onPriceChangedUpdate(item.price);
          },
          child: UserItemWidget(item: item)));
    }
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      height: (MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.top -
          120),
      child: SingleChildScrollView(
        child: Column(
          children: listItems,
        ),
      ),
    );
  }
}

// onDissmised
          // setState(() {
          //   selectedPartsList.remove(part[0].title);
          //   int newPrice =
          //       _parseReplace(priceOfListController.text) - currentPrice;
          //   priceOfListController.text = NumberFormat.currency(
          //           locale: 'Ru-ru', symbol: '₽', decimalDigits: 0)
          //       .format(newPrice);
          // });

// onPriceChanged
        //currentPrice = newPrice;
