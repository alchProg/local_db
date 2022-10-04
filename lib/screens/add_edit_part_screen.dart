import 'package:flutter/material.dart';
import 'package:local_db/models/part_model.dart';
import 'package:local_db/widget/part_form_widget.dart';
import '../db/local_database.dart';




class AddEditPartScreen extends StatefulWidget {
  final int pID;
  final String pName;
  final Part? part;


  const AddEditPartScreen({
    Key? key,
    required this.pID,
    required this.pName,
    this.part }) : super(key: key);

  @override
  _AddEditPartScreenState createState() => _AddEditPartScreenState();
}

class _AddEditPartScreenState extends State<AddEditPartScreen> {

  final formKey = GlobalKey<FormState>();
  late String title;
  late String buttonTxt;
  bool isLoading = false;

  List<List<String>> items = [];

  late String price1;
  late String price2;
  late String price3;
  late String price4;

  late String desc1;
  late String desc2;
  late String desc3;
  late String desc4;

  @override
  void initState() {
    if (widget.part?.title != null) {
      title = widget.part!.title;
      buttonTxt = 'Сохранить';
    } else {
      title = '';
      buttonTxt = 'Создать';
    }

    price1 = widget.part?.price1.toString() ?? '0';
    price2 = widget.part?.price2.toString() ?? '0';
    price3 = widget.part?.price3.toString() ?? '0';
    price4 = widget.part?.price4.toString() ?? '0';

    desc1 = widget.part?.desc1 ?? 'nope';
    desc2 = widget.part?.desc2 ?? 'nope';
    desc3 = widget.part?.desc3 ?? 'nope';
    desc4 = widget.part?.desc4 ?? 'nope';

    items.addAll({
      [price1, desc1],
      [price2, desc2],
      [price3, desc3],
      [price4, desc4],
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title.isEmpty
              ? 'Деталь - новая'
              : 'Деталь - редакт',
          style: const TextStyle(fontSize: 24),
        ),
        actions: [buildButton()],
      ),
      body: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              header(),
              Expanded(
                child: ListView.builder(
                  primary: true,
                  itemCount: items.length,
                  itemBuilder: (ctx, i){
                    BorderRadius? borderRadius;
                    if(i == 0){
                      borderRadius = const BorderRadius.vertical(top: Radius.circular(20));
                    } else if (i == items.length - 1){
                      borderRadius = const BorderRadius.vertical(bottom: Radius.circular(20));
                    }
                    return PartFormWidget(
                      price: items[i][0],
                      desc: items[i][1],
                      onChangedDesc: (cDesc) =>
                          setState(() => items[i][1] = cDesc),
                      onChangedPrice: (cPrice) =>
                          setState(() => items[i][0] = cPrice),
                      borderRadius: borderRadius,
                    );
                  }),
              ),
            ],
          ),
      ),
    );
  }

  Widget header () {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        child: ListTile(
          title: Text(title, style: TextStyle(fontSize: 24),),
          subtitle: Text(widget.pName, style: TextStyle(fontSize: 14),),
        ),
      ),
    );
  }



  Widget buildButton() {
    final isFormValid = title.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: _addOrUpdatePart,
        child: Text(buttonTxt),
      ),
    );
  }

  void _addOrUpdatePart() async {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      final isUpdating = widget.part != null;

      if (isUpdating) {
        await _updatePart();
      } else {
        await _addPart();
      }
      Navigator.of(context).pop();
    }
  }

  Future _updatePart() async {
    final part = widget.part!.copy(
      price1: items[0][0].isEmpty ? 0 : int.parse(items[0][0]),
      price2: items[1][0].isEmpty ? 0 : int.parse(items[1][0]),
      price3: items[2][0].isEmpty ? 0 : int.parse(items[2][0]),
      price4: items[3][0].isEmpty ? 0 : int.parse(items[3][0]),
      desc1: items[0][1],
      desc2: items[1][1],
      desc3: items[2][1],
      desc4: items[3][1],
    );
    await LocalDatabase.instance.updatePart(part);
  }

  Future _addPart() async {
    final part = Part(
      pID: widget.pID,
      title: title,
      price1: int.parse(price1),
    );
    await LocalDatabase.instance.createPart(part);

  }
}