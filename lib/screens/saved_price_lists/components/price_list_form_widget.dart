import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_db/models/text_phone_formatter.dart';
import 'package:local_db/widget/date_time_picker.dart';

class PriceListFormWidget extends StatefulWidget {
  final String? price;
  final String? clientName;
  final String? clientPhone;
  final String? deadLine;
  final String? desc;
  final bool? isCompleted;
  final bool? isPaid;
  final bool isEditMode;
  final ValueChanged<String>? onChangedPrice;
  final ValueChanged<String>? onChangedClientName;
  final ValueChanged<String>? onChangedClientPhone;
  final ValueChanged<String>? onChangedDeadLine;
  final ValueChanged<String>? onChangedDesc;
  final ValueChanged<bool?>? onChangedisCompleted;
  final ValueChanged<bool?>? onChangedisPaid;

  const PriceListFormWidget({
    Key? key,
    this.price,
    this.clientName,
    this.clientPhone,
    this.deadLine,
    this.desc,
    this.isCompleted,
    this.isPaid,
    this.onChangedPrice,
    this.onChangedClientName,
    this.onChangedClientPhone,
    this.onChangedDeadLine,
    this.onChangedDesc,
    this.onChangedisCompleted,
    this.onChangedisPaid,
    required this.isEditMode,
  }) : super(key: key);

  @override
  State<PriceListFormWidget> createState() => _PriceListFormWidgetState();
}

class _PriceListFormWidgetState extends State<PriceListFormWidget> {
  late Size _size;
  late DateTime? _chosenDateTime;

  late TextEditingController _priceController;
  late TextEditingController _clientNameController;
  late TextEditingController _clientPhoneController;
  late TextEditingController _deadLineController;
  late TextEditingController _descController;

  late bool _nameIsTaped;
  late bool _descIsTaped;
  late bool _phoneIsTaped;
  late bool? _isCompleted;
  late bool? _isPaid;

  @override
  void initState() {
    _chosenDateTime = DateTime.now();

    _priceController = TextEditingController(text: widget.price ?? '');
    _clientNameController =
        TextEditingController(text: widget.clientName ?? '');
    _clientPhoneController =
        TextEditingController(text: widget.clientPhone ?? '');
    _deadLineController = TextEditingController(
        text: widget.deadLine ??
            DateFormat('dd.MM.yyyy - kk:mm').format(DateTime.now()));
    _descController = TextEditingController(text: widget.desc ?? '');

    _isCompleted = widget.isCompleted ?? false;
    _isPaid = widget.isPaid ?? false;

    _nameIsTaped = false;
    _descIsTaped = false;
    _phoneIsTaped = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _priceController.dispose();
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    _deadLineController.dispose();
    _descController.dispose();
  }

  _selectAll(TextEditingController textController, bool isTapepd) {
    if (textController.text.isEmpty || isTapepd) {
      return;
    }
    isTapepd = true;
    return textController.selection =
        TextSelection(baseOffset: 0, extentOffset: textController.text.length);
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 2,
            color: Colors.black,
          ),
          _clientName(),
          const SizedBox(height: 2),
          _clientPhone(),
          const SizedBox(height: 2),
          _desc(),
          const SizedBox(height: 2),
          _deadLineTime(),
          const SizedBox(height: 2),
          _checkBoxisPaid(),
          const SizedBox(height: 2),
          _checkBoxIsCompleted(),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  Widget _clientName() {
    return Container(
      padding: const EdgeInsets.all(5),
      color: Colors.black38,
      child: TextField(
        enabled: widget.isEditMode,
        onTap: () {
          if (_clientNameController.text.isEmpty || _nameIsTaped) {
            return;
          }
          _nameIsTaped = true;
          _clientNameController.selection = TextSelection(
              baseOffset: 0, extentOffset: _clientNameController.text.length);
        },
        onEditingComplete: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _nameIsTaped = false;
        },
        onChanged: widget.onChangedClientName,
        controller: _clientNameController,
        style: const TextStyle(color: Colors.white),
        autofocus: false,
        decoration: InputDecoration(
          counterText: '',
          errorStyle: const TextStyle(color: Colors.red, fontSize: 12.0),
          hintText: "Имя клиента",
          hintStyle: const TextStyle(fontSize: 18, color: Colors.white38),
          prefixIcon: const Icon(Icons.account_box_sharp),
          border: OutlineInputBorder(
            gapPadding: _size.width * 0.55,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        maxLines: 1,
        maxLength: 30,
      ),
    );
  }

  Widget _clientPhone() {
    return Container(
      padding: const EdgeInsets.all(5),
      color: Colors.black38,
      child: TextField(
        enabled: widget.isEditMode,
        inputFormatters: [PhoneFormatter()],
        onTap: () {
          if (_clientPhoneController.text.isEmpty || _phoneIsTaped) {
            return;
          }
          _phoneIsTaped = true;
          _clientPhoneController.selection = TextSelection(
              baseOffset: 0, extentOffset: _clientPhoneController.text.length);
        },
        onEditingComplete: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _phoneIsTaped = false;
        },
        onChanged: widget.onChangedClientPhone,
        controller: _clientPhoneController,
        style: const TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "+7 (###) - ## - ####",
          hintStyle: const TextStyle(fontSize: 18, color: Colors.white38),
          prefixIcon: const Icon(Icons.phone),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        maxLines: 1,
      ),
    );
  }

  Widget _deadLineTime() {
    Future<void> onDeadLineSelect(BuildContext context) async {
      _chosenDateTime = await selectDateTime(context);
    }

    return Container(
      padding: const EdgeInsets.only(left: 5, top: 15, right: 5, bottom: 5),
      decoration: const BoxDecoration(
        color: Colors.black38,
        borderRadius: null,
      ),
      child: TextField(
        enabled: widget.isEditMode,
        readOnly: true,
        inputFormatters: [PhoneFormatter()],
        onTap: () {
          onDeadLineSelect(context).then((_) {
            setState(() {
              _deadLineController.text =
                  DateFormat('dd.MM.yyyy - kk:mm').format(_chosenDateTime!);
              if (widget.onChangedDeadLine != null) {
                widget.onChangedDeadLine!(_deadLineController.text);
              }
            });
          });
        },
        style: const TextStyle(color: Colors.white),
        autofocus: false,
        controller: _deadLineController,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: "Выполнить до",
          labelStyle: const TextStyle(fontSize: 24, color: Colors.white38),
          errorStyle: const TextStyle(color: Colors.red, fontSize: 12.0),
          hintText: _deadLineController.text,
          hintStyle: const TextStyle(fontSize: 18, color: Colors.white38),
          prefixIcon: const Icon(Icons.calendar_month_rounded),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        maxLines: 1,
      ),
    );
  }

  Widget _desc() {
    return Container(
      padding: const EdgeInsets.all(5),
      color: Colors.black38,
      child: TextField(
        enabled: widget.isEditMode,
        onTap: () => _selectAll(_descController, _descIsTaped),
        onEditingComplete: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _phoneIsTaped = false;
        },
        onChanged: widget.onChangedDesc,
        controller: _descController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          counterText: '',
          hintText: "Доп. информация",
          labelStyle: const TextStyle(fontSize: 14, color: Colors.white38),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        maxLines: 4,
        maxLength: 120,
      ),
    );
  }

  Widget _checkBoxisPaid() {
    return Container(
      padding: const EdgeInsets.all(5),
      color: Colors.black38,
      child: CheckboxListTile(
        enabled: widget.isEditMode,
        secondary:
            Icon(Icons.paid, color: _isPaid! ? Colors.greenAccent : Colors.red),
        title: const Text("Заказ оплачен"),
        value: _isPaid,
        onChanged: (value) {
          setState(() {
            _isPaid = !_isPaid!;
          });
          if (widget.onChangedisPaid == null) {
            return;
          }
          widget.onChangedisPaid!(value);
        },
      ),
    );
  }

  Widget _checkBoxIsCompleted() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      child: CheckboxListTile(
        enabled: widget.isEditMode,
        secondary: Icon(Icons.build,
            color: _isCompleted! ? Colors.greenAccent : Colors.red),
        title: const Text("Заказ выполнен"),
        value: _isCompleted,
        onChanged: (value) {
          setState(() {
            _isCompleted = !_isCompleted!;
          });
          if (widget.onChangedisCompleted == null) {
            return;
          }
          widget.onChangedisCompleted!(value);
        },
      ),
    );
  }
}
