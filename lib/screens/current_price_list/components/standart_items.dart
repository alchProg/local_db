import 'package:flutter/material.dart';
import 'package:local_db/models/price_list_items_model.dart';
import 'package:local_db/screens/current_price_list/components/standart_item_widget.dart';

class StandartItems extends StatefulWidget {
  final Map<String, List<dynamic>> selectedPartsList;
  final Map<String, PriceListItem> standartPriceItemsList;
  const StandartItems({
    super.key,
    required this.standartPriceItemsList,
    required this.selectedPartsList,
  });

  @override
  State<StandartItems> createState() => _StandartItemsState();
}

class _StandartItemsState extends State<StandartItems> {
  final List<Widget> listItems = [];

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.selectedPartsList.length,
              itemBuilder: ((context, index) {
                String key = widget.selectedPartsList.keys.elementAt(index);
                return StandartItemWidget(
                  standartPriceItemsList: widget.standartPriceItemsList,
                  part: widget.selectedPartsList[key]![0],
                  dataIndex: widget.selectedPartsList[key]![1],
                  onDataIndexChanged: (newIndex) {
                    widget.selectedPartsList[key]![1] = newIndex;
                  },
                  onDeletPressed: () {
                    setState(() {
                      widget.selectedPartsList.remove(key);
                      widget.standartPriceItemsList.remove(key);
                    });
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
