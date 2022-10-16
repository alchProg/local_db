import 'package:flutter/material.dart';
import 'package:local_db/db/local_database.dart';
import 'package:local_db/models/price_list_items_model.dart';
import 'package:local_db/screens/current_price_list/components/price_item_form_widget.dart';

class AddEditGlobalUserItemScreen extends StatefulWidget {
  final bool? isGlobal;
  final PriceListItem? item;
  final ValueChanged<int>? onPriceChanged;

  const AddEditGlobalUserItemScreen({
    Key? key,
    this.isGlobal,
    this.item,
    this.onPriceChanged,
  }) : super(key: key);

  @override
  _AddEditGlobalUserItemScreenState createState() =>
      _AddEditGlobalUserItemScreenState();
}

class _AddEditGlobalUserItemScreenState
    extends State<AddEditGlobalUserItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _buttonTxt;
  late String _pageTitle;
  late String _price;
  late String _desc;
  late bool _isGlobal;

  @override
  void initState() {
    _isGlobal = widget.item?.isGlobal ?? true;

    if (widget.item?.title != null) {
      _title = widget.item!.title;
      _buttonTxt = 'Сохранить';
      _pageTitle = 'Редактирование';
    } else {
      _title = '';
      _buttonTxt = 'Создать';
      _pageTitle = 'Новая';
    }
    _price = widget.item?.price.toString() ?? '0';
    _desc = widget.item?.desc ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitle,
          style: const TextStyle(fontSize: 24),
        ),
        actions: [buildButton()],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PriceItemFormWidget(
              title: _title,
              price: _price,
              desc: _desc,
              onChangedTitle: (cTitle) => setState(() => _title = cTitle),
              onChangedDesc: (cDesc) => setState(() => _desc = cDesc),
              onChangedPrice: (cPrice) => setState(() => _price = cPrice),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton() {
    final isFormValid = _title.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: _addOrUpdateItem,
        child: Text(_buttonTxt),
      ),
    );
  }

  void _addOrUpdateItem() async {
    final isValid = _formKey.currentState!.validate();
    if (widget.onPriceChanged != null) {
      widget.onPriceChanged!(int.parse(_price));
    }
    if (isValid) {
      final isUpdating = widget.item != null;
      if (isUpdating) {
        await _updateItem().then((value) => Navigator.of(context).pop());
      } else {
        await _addItem().then((value) => Navigator.of(context).pop());
      }
    }
  }

  Future _updateItem() async {
    final item = widget.item!.copy(
      title: _title,
      price: _price.isEmpty ? 0 : int.parse(_price),
      desc: _desc,
    );
    await LocalDatabase.instance.updatePriceListItem(item);
  }

  Future _addItem() async {
    final item = PriceListItem(
      title: _title,
      price: int.parse(_price),
      desc: _desc,
      isGlobal: _isGlobal,
    );

    await LocalDatabase.instance.createPriceListItem(item);
  }
}
