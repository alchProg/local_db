import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_db/models/price_list_items_model.dart';
import 'package:local_db/screens/current_price_list/add_edit_user_item.dart';
import 'package:local_db/screens/current_price_list/components/counter_bloc.dart';
import 'package:local_db/screens/current_price_list/components/user_item_widget.dart';

class UserItems extends StatefulWidget {
  final Map<String, PriceListItem> userPriceItemsList;
  const UserItems({super.key, required this.userPriceItemsList});

  @override
  State<UserItems> createState() => _UserItemsState();
}

class _UserItemsState extends State<UserItems> {
  late CounterBloc _counterBloc;

  @override
  Widget build(BuildContext context) {
    _counterBloc = BlocProvider.of<CounterBloc>(context);
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
              itemCount: widget.userPriceItemsList.length,
              itemBuilder: (context, index) {
                String key = widget.userPriceItemsList.keys.elementAt(index);
                return UserItemWidget(
                  item: widget.userPriceItemsList[key]!,
                  onDeletPressed: () => setState(() {
                    widget.userPriceItemsList.remove(key);
                  }),
                  onTap: () async =>
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                              value: _counterBloc,
                              child: AddEditUserItemScreen(
                                counterBloc: _counterBloc,
                                item: widget.userPriceItemsList[key]!,
                                userPriceItemsList: widget.userPriceItemsList,
                              )))),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
