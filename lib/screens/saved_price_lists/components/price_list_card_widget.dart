import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_db/models/price_list_model.dart';
import 'package:local_db/models/text_phone_formatter.dart';

class PriceListCardWidget extends StatefulWidget {
  final bool? longPressed;
  final PriceList priceList;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onChanged;
  final ValueChanged<bool>? onLongPressed;

  const PriceListCardWidget({
    Key? key,
    this.onTap,
    this.onChanged,
    this.longPressed,
    this.onLongPressed,
    required this.priceList,
  }) : super(key: key);

  @override
  State<PriceListCardWidget> createState() => _PriceListCardWidgetState();
}

class _PriceListCardWidgetState extends State<PriceListCardWidget> {
  late Size _size;
  late String _clientPhoneNumber;
  late String _clientFullName;
  late List<Shadow> _shadows;
  late bool _longPressed;
  late bool _checked;
  late bool _isCompleted;
  late bool _isPaid;

  @override
  void initState() {
    _dataInit();
    super.initState();
  }

  void _dataInit() {
    _clientFullName = widget.priceList.clientFullName ?? '';
    _clientPhoneNumber = widget.priceList.clientPhoneNumber ?? '';
    _isCompleted = widget.priceList.isCompleted;
    _isPaid = widget.priceList.isPaid;
    _shadows = const [
      Shadow(color: Colors.white, blurRadius: 15, offset: Offset(0, 0)),
      Shadow(color: Colors.white, blurRadius: 15, offset: Offset(0, 0)),
    ];
    _checked = false;
  }

  Widget _checkBox() {
    return Checkbox(
      value: _checked,
      onChanged: (bool? checked) {
        setState(() {
          _checked = checked!;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(checked!);
        }
      },
    );
  }

  _onLongPressed() {
    setState(() {
      _longPressed = !_longPressed;
      if (_longPressed) {
        _checked = true;
      } else {
        _checked = false;
      }
      if (widget.onLongPressed != null) {
        widget.onLongPressed!(_longPressed);
      }
      if (widget.onChanged != null) {
        widget.onChanged!(_checked);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _longPressed = widget.longPressed ?? false;
    if (!_longPressed) {
      _checked = false;
    }
    _size = MediaQuery.of(context).size;
    return Card(
      color: Colors.black,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _cardTile(),
        _clientInfoRow(),
        _priceListInfoRow(),
      ]),
    );
  }

  Widget _cardTile() {
    return Padding(
      padding: EdgeInsets.zero,
      child: ListTile(
        title: Text(
          widget.priceList.title,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        onLongPress: () {
          _onLongPressed();
        },
        trailing: _longPressed ? _checkBox() : null,
        onTap: widget.longPressed!
            ? () {
                setState(() => _checked = !_checked);
                if (widget.onChanged != null) {
                  widget.onChanged!(_checked);
                }
              }
            : widget.onTap,
      ),
    );
  }

  Widget _clientInfoRow() {
    Widget clientName() {
      return SizedBox(
        width: _size.width * 0.4,
        child: Row(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_box_sharp,
                  size: 20,
                  color: Colors.black,
                  shadows: _shadows,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: 1,
                    height: 20,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: _size.width * 0.3,
              child: TextField(
                readOnly: true,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.greenAccent,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  hintText: _clientFullName,
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.amber,
                  ),
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      );
    }

    Widget clientPhone() {
      return SizedBox(
        width: _size.width * 0.4,
        child: Row(
          children: [
            Icon(
              Icons.phone_rounded,
              size: 20,
              color: Colors.black,
              shadows: _shadows,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 1,
                height: 25,
                color: Colors.white38,
              ),
            ),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.3,
            //   child: TextField(
            //     readOnly: true,
            //     inputFormatters: [PhoneFormatter()],
            //     controller: TextEditingController(text: _clientPhoneNumber),
            //     style: const TextStyle(
            //       fontSize: 14,
            //       color: Colors.lightGreen,
            //     ),
            //     decoration: const InputDecoration(
            //         counterText: '', border: InputBorder.none),
            //   ),
            // ),
            Text(
              _clientPhoneNumber,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
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
            clientName(),
            clientPhone(),
            Icon(
              Icons.paid,
              color: _isPaid ? Colors.greenAccent : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceListInfoRow() {
    return Padding(
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
            SizedBox(
              width: _size.width * 0.4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.insert_drive_file_rounded,
                    size: 20,
                    color: Colors.black,
                    shadows: _shadows,
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
                        .format(widget.priceList.price),
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: _size.width * 0.4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 20,
                    color: Colors.black,
                    shadows: _shadows,
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
                    widget.priceList.deadLineTime.toString(),
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.build_rounded,
              color: _isCompleted ? Colors.greenAccent : Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
