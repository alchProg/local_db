import 'package:flutter/material.dart';
import 'package:local_db/models/part_model.dart';
import 'package:local_db/widget/price_item_widget.dart';

class StandartItems extends StatelessWidget {
  final VoidCallback? onDissmissed;
  final ValueChanged<int>? onPriceChanged;

  StandartItems({super.key, this.onDissmissed, this.onPriceChanged});
  List<Widget> listItems = [];

  void _onDissmisedUpdate() {
    VoidCallback? _onDissmissed = onDissmissed;
    if (_onDissmissed == null) {
      return;
    }
    _onDissmissed();
  }

  @override
  Widget build(BuildContext context) {
    for (List part in selectedPartsList.values) {
      listItems.add(Dismissible(
          key: Key(part[0].title),
          onDismissed: (direction) {
            selectedPartsList.remove(part[0].title);
            _onDissmisedUpdate();
          },
          child: PriceItemWidget(
            part: part[0],
            dataIndex: part[1],
            onIndexChanged: (newIndex) {
              part[1] = newIndex;
            },
            onPriceChanged: onPriceChanged,
          )));
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
