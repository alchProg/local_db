import 'package:flutter/material.dart';

class CarFormWidget extends StatelessWidget {

  final String? title;
  final bool checked;
  final ValueChanged<String> onChangedTitle;
  final Function(dynamic) onChangedCheckBox;


  const CarFormWidget({
    Key? key,
    this.title,
    required this.checked,
    required this.onChangedTitle,
    required this.onChangedCheckBox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(color: Colors.black, height: 1.0,),
              titleTextField(),
              const SizedBox(height: 2),
              checkBox(),
            ],
          ),
        ),
      );

  Widget titleTextField () {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      child: TextFormField(
        onChanged: onChangedTitle,
        validator: (title) {
          if(title == null || title.isEmpty){
            return 'Поле не может быть пустым!';
          } else { return null;}
        },
        style: const TextStyle(color: Colors.white),
        autofocus: true,
        decoration: InputDecoration(
          errorStyle: const TextStyle(
            color: Colors.red,
          ),
          labelText: "Название*",
          hintText: title,
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
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0),
        child: CheckboxListTile(

          isThreeLine: true,
          title: const Text("Глобальный тип", style: TextStyle(color: Colors.white),),
          subtitle: const Text(
            "Глобальный тип будет автоматически добавляться при создании "
                "нового профиля", style: TextStyle(color: Colors.white38, fontSize: 12),),
          value: checked,
          onChanged: onChangedCheckBox,
        ),
      ),
    );
  }
}
