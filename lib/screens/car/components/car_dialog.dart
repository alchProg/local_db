import 'package:flutter/material.dart';

class CarDialog {

  final BuildContext context;
  final String label;
  final String labelTextName;
  final VoidCallback press;
  final String pressText;
  final TextEditingController controllerName;
  final GlobalKey<FormState> formKey;
  bool? checked;
  final void Function(bool?) checkPressed;

  CarDialog({
    required this.context,
    required this.label,
    required this.labelTextName,
    required this.press,
    required this.pressText,
    required this.controllerName,
    required this.checked,
    required this.formKey,
    required this.checkPressed,

  });

  final Color _fieldBackgroundColor = Colors.black;

  Widget nameTextField () {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: 100,
      decoration: BoxDecoration(
        color: _fieldBackgroundColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6)),
      ),
      child: TextFormField(
        controller: controllerName,
        validator: (title) {
          if(title != null && title.isEmpty && title == ""){
            return 'Поле не может быть пустым!';
          } else { return null;}
        },
        //textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          errorStyle: const TextStyle(
            color: Colors.red,
          ),
          labelText: "$labelTextName*",
          labelStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
        ),
        maxLines: 1,
      ),
    );
  }

  Widget checkBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: 50,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0),
        child: CheckboxListTile(
          title: const Text("Глобальный тип - ", style: TextStyle(color: Colors.white),),
          subtitle: const Text(
            "глобальный тип будет автоматически добавляться при создании "
                "нового профиля", style: TextStyle(color: Colors.white38, fontSize: 10),),
          value: checked,
          onChanged: checkPressed,
        ),
      ),
    );
  }

  Widget mainButton() {
    return InkWell(
      splashColor: Colors.tealAccent,
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(32.0),
      ),
      onTap: press,
      child: Container(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(32.0),),
        ),
        child:Text(
          pressText,
          style: const TextStyle(color: Colors.tealAccent, fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  openDialog() {
    throw showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            backgroundColor: ThemeData.dark().dialogTheme.backgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            contentPadding: const EdgeInsets.all(1.5),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(label, //Label
                        style: const TextStyle(fontSize: 24.0, color: Colors.white),
                      ),
                    )
                  ],
                ),
                Container(color: Colors.black, height: 1.0,),
                nameTextField(),
                const SizedBox(height: 2),
                checkBox(),
                Container(color: Colors.black, height: 1.0,),
                mainButton(),
              ],
            ),
          ),
        );
      },
    );
  }
}
