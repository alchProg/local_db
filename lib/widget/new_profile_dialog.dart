import 'package:flutter/material.dart';

class RoundedAlertBox {

  final BuildContext context;
  final String label;
  final String labelTextName;
  final String labelTextDesc;
  final VoidCallback press;
  final String pressText;
  final TextEditingController controllerName;
  final TextEditingController controllerDesc;
  final GlobalKey<FormState> formKey;

  RoundedAlertBox({
    required this.context,
    required this.label,
    required this.labelTextName,
    required this.labelTextDesc,
    required this.press,
    required this.pressText,
    required this.controllerName,
    required this.controllerDesc,
    required this.formKey,
  });

  final Color _fieldBackgroundColor = Colors.black;



  openAlertBox() {
    return showDialog(
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
                titleField(),
                const SizedBox(height: 2),
                descTextField (),
                Container(color: Colors.black, height: 1.0,),
                mainButton(),
              ],
            ),
          ),
        );
        },
    );
  }

  Widget titleField () {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: 100,
      decoration: BoxDecoration(
        color: _fieldBackgroundColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6)),
      ),
      child: TextFormField(
        controller: controllerName,
        maxLength: 20,
        validator: (title) {
          if(title != null && title.isEmpty && title == ""){
            return 'Поле не может быть пустым!';
          } else { return null;}
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          counterText: "",
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

  Widget descTextField () {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: 50,
      decoration: BoxDecoration(
        color: _fieldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0),
        child: TextField(
          controller: controllerDesc,
          //textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            isDense: true,
            labelText: labelTextDesc,
            labelStyle: const TextStyle(color: Colors.white38),
            border: InputBorder.none,
          ),
          maxLines:4,
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
}