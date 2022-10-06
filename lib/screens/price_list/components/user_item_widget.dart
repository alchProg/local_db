import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_db/models/price_list_items_model.dart';

class UserItemWidget extends StatelessWidget {
  const UserItemWidget({
    Key? key,
    required this.item,
  }) : super(key: key);
  final PriceListItem item;


  @override
  Widget build(BuildContext context) {
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
            trailing: _focusedMenu(),
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
                    const Icon(
                      Icons.currency_ruble,
                      size: 20,
                      color: Colors.black,
                      shadows: [
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

  _focusedMenu() {
    return const Icon(Icons.verified_user,
        size: 30,
        color: Colors.black,
        shadows: [
          Shadow(color: Colors.white, blurRadius: 5, offset: Offset(0, 0)),
          Shadow(color: Colors.white, blurRadius: 15, offset: Offset(0, 0)),
        ],
      );
  }
}
