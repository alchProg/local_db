import 'package:flutter/material.dart';
import 'package:local_db/db/local_database.dart';
import 'package:local_db/models/price_list_items_model.dart';
import 'package:local_db/screens/current_price_list/components/price_item_form_widget.dart';

class AddEditListItemScreen extends StatefulWidget {
  final PriceListItem? item;
  final int? lID;
  final List<PriceListItem>? items;
  final ValueChanged<int>? onPriceChanged;
  const AddEditListItemScreen({
    Key? key,
    this.item,
    this.onPriceChanged,
    this.items,
    this.lID,
  }) : super(key: key);

  @override
  _AddEditListItemScreenState createState() => _AddEditListItemScreenState();
}

class _AddEditListItemScreenState extends State<AddEditListItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _buttonTxt;
  late String _pageTitle;
  late String _price;
  late String _desc;

  @override
  void initState() {
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
    final isDbItem = widget.item!.lID != null;
    final item = widget.item!.copy(
      title: _title,
      price: _price.isEmpty ? 0 : int.parse(_price),
      desc: _desc,
    );
    if (isDbItem) {
      await LocalDatabase.instance.updatePriceListItem(item);
    } else if (widget.items != null) {
      widget.items!
        ..remove(widget.item)
        ..add(item);
    }
  }

  Future _addItem() async {
    final item = PriceListItem(
      lID: widget.lID,
      title: _title,
      price: int.parse(_price),
      desc: _desc,
      isGlobal: false,
    );
    if (widget.lID != null) {
      await LocalDatabase.instance.createPriceListItem(item);
    } else if (widget.items != null) {
      widget.items!.add(item);
    }
  }
}
