import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:local_db/models/price_list_items_model.dart';
import 'package:local_db/screens/current_price_list/components/counter_bloc.dart';

class UserItemWidget extends StatelessWidget {
  final PriceListItem item;
  final Function onDeletPressed;
  final VoidCallback onTap;

  UserItemWidget({
    Key? key,
    required this.item,
    required this.onDeletPressed,
    required this.onTap,
  }) : super(key: key);

  late CounterBloc _counterBloc;

  @override
  Widget build(BuildContext context) {
    _counterBloc = BlocProvider.of<CounterBloc>(context);
    return Card(
      color: Colors.black,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.zero,
          child: ListTile(
            title: Text(
              item.title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: _deletButton(),
            onTap: onTap,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
                color: ThemeData.dark().dialogBackgroundColor.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(4),
                )),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      item.isGlobal ? Icons.g_mobiledata : Icons.person,
                      size: 20,
                      color: Colors.black,
                      shadows: const [
                        Shadow(
                            color: Colors.white,
                            blurRadius: 15,
                            offset: Offset(0, 0)),
                        Shadow(
                            color: Colors.white,
                            blurRadius: 15,
                            offset: Offset(0, 0)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 1,
                        height: 25,
                        color: Colors.white38,
                      ),
                    ),
                    Text(
                      NumberFormat.currency(
                              locale: 'Ru-ru', symbol: '₽', decimalDigits: 0)
                          .format(item.price),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  item.desc!,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget _deletButton() {
    return IconButton(
      onPressed: (() {
        _counterBloc.add(Decrement(value: item.price!));
        onDeletPressed();
      }),
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
        size: 30,
      ),
      splashRadius: 20,
    );
  }
}
