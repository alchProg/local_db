import 'package:flutter/material.dart';
import 'package:local_db/models/part_model.dart';
import 'package:local_db/screens/car/components/car_form_widget.dart';

import '../../db/local_database.dart';
import 'components/car_model.dart';



class AddEditCarScreen extends StatefulWidget {
  final int pID;
  final Car? car;


  const AddEditCarScreen({Key? key, required this.pID, this.car }) : super(key: key);

  @override
  _AddEditCarScreenState createState() => _AddEditCarScreenState();
}

class _AddEditCarScreenState extends State<AddEditCarScreen> {

  final formKey = GlobalKey<FormState>();

  late List<Part> _parts;
  late bool isGlobal;
  late String title;
  late String buttonTxt;
  bool isLoading = false;

  @override
  void initState() {
    isGlobal = widget.car?.isGlobal ?? false;

    if (widget.car?.title != null) {
      title = widget.car!.title;
      buttonTxt = 'Сохранить';
      _refreshParts();
    } else {
      title = '';
      buttonTxt = 'Создать';
    }
    super.initState();
  }

  _refreshParts() async {
    setState(() => isLoading = true);
    isGlobal
    ? _parts = await LocalDatabase.instance.readTypeParts(widget.car!.title)
    : _parts = await LocalDatabase.instance.readProfileParts(widget.car!.title, widget.pID, null);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title.isEmpty
          ? 'Корпус - новый'
          : 'Корпус - редакт',
          style: const TextStyle(fontSize: 24),
        ),
          actions: [buildButton()],
      ),
      body: Form(
        key: formKey,
        child: CarFormWidget(
        checked: isGlobal,
        title: title,
        onChangedTitle: (txt) => setState(() => title = txt),
        onChangedCheckBox: (val) => setState(() => isGlobal = val),
      )),
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
        onPressed: addOrUpdateCar,
        child: Text(buttonTxt),
      ),
    );
  }

  void addOrUpdateCar() async {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      final isUpdating = widget.car != null;

      if (isUpdating) {
        await updateCar();
      } else {
        await addCar();
      }
      Navigator.of(context).pop();
    }
  }

  Future updateCar() async {
    _refreshParts();
    final car = widget.car!.copy(
      title: title,
      isGlobal: isGlobal,
    );
    await LocalDatabase.instance.updateCar(car);
    while(isLoading){}
    for (Part part in _parts) {
      part.carType = title;
      await LocalDatabase.instance.updatePart(part);
    }
  }

  Future addCar() async {
    final car =
    isGlobal
        ? Car(
            title: title,
            isGlobal: isGlobal,
          )
        : Car(
            pID: widget.pID,
            title: title,
            isGlobal: isGlobal,
          );

    await LocalDatabase.instance.createCar(car);
    await LocalDatabase.instance.createProfileParts(widget.pID, car.title);
  }
}