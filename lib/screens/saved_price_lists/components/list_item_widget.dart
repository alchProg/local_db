import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_db/models/price_list_items_model.dart';

class ListItemWidget extends StatefulWidget {
  final PriceListItem item;
  final VoidCallback? onTap;
  final VoidCallback? onDeletePressed;
  final bool? isEditMode;

  const ListItemWidget({
    Key? key,
    this.onTap,
    this.isEditMode,
    this.onDeletePressed,
    required this.item,
  }) : super(key: key);

  @override
  State<ListItemWidget> createState() => _ListItemWidgetState();
}

class _ListItemWidgetState extends State<ListItemWidget> {
  late bool _checked;
  late bool _isEditMode;

  @override
  void initState() {
    _checked = false;
    super.initState();
  }

  @override
  void dispose() {
    _checked = false;
    super.dispose();
  }

  Widget _deleteButton() {
    return IconButton(
        onPressed: widget.onDeletePressed,
        icon: const Icon(Icons.delete, color: Colors.red, size: 30.0));
  }

  @override
  Widget build(BuildContext context) {
    _isEditMode = widget.isEditMode ?? false;
    if (!_isEditMode) {
      _checked = false;
    }
    return Card(
      color: Colors.black,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.zero,
          child: ListTile(
            title: Text(
              widget.item.title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: _isEditMode ? _deleteButton() : null,
            onTap: widget.onTap,
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
                      widget.item.isGlobal ? Icons.g_mobiledata : Icons.person,
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
                          .format(widget.item.price),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.item.desc!,
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
}
