import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class PriceItemFormWidget extends StatefulWidget {
  final String? title;
  final String? desc;
  final String? price;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDesc;
  final ValueChanged<String> onChangedPrice;

  const PriceItemFormWidget({
    Key? key,
    this.title,
    this.desc,
    this.price,
    required this.onChangedTitle,
    required this.onChangedDesc,
    required this.onChangedPrice,
  }) : super(key: key);

  @override
  State<PriceItemFormWidget> createState() => _PriceItemFormWidgetState();
}

class _PriceItemFormWidgetState extends State<PriceItemFormWidget> {
  late bool priceIsTaped;
  late bool descIsTaped;
  late bool titleIsTaped;
  late Size size;
  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController descController;

  @override
  void initState() {
    priceIsTaped = false;
    descIsTaped = false;
    titleIsTaped = false;
    priceController = TextEditingController(
        text: widget.price == '0' ? '' : widget.price.toString());
    descController = TextEditingController(text: widget.desc ?? '');
    titleController = TextEditingController(text: widget.title ?? '');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    priceController.dispose();
    descController.dispose();
  }

  _selectAll(TextEditingController textController) {
    if (textController.text.isEmpty || priceIsTaped) {
      return;
    }
    priceIsTaped = true;
    return textController.selection =
        TextSelection(baseOffset: 0, extentOffset: textController.text.length);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            color: Colors.black,
            height: 1.0,
          ),
          titleTextField(),
          const SizedBox(height: 2),
          descPriceBox(),
        ],
      ),
    );
  }

  Widget titleTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      child: TextFormField(
        onTap: () => _selectAll(titleController),
        onChanged: widget.onChangedTitle,
        onEditingComplete: () {
          FocusManager.instance.primaryFocus?.unfocus();
          titleIsTaped = false;
        },
        validator: (title) {
          if (title == null || title.isEmpty) {
            return 'Поле не может быть пустым!';
          } else {
            return null;
          }
        },
        controller: titleController,
        style: const TextStyle(color: Colors.white),
        autofocus: false,
        decoration: const InputDecoration(
          errorStyle: TextStyle(
            color: Colors.red,
          ),
          labelText: "Наименование",
          labelStyle: TextStyle(color: Colors.white38),
          border: InputBorder.none,
        ),
        maxLines: 1,
      ),
    );
  }

  Widget descPriceBox() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Container(
            height: 100,
            width: size.width - 10,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: size.width * 0.55,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      onTap: () => _selectAll(descController),
                      onEditingComplete: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        descIsTaped = false;
                      },
                      onChanged: widget.onChangedDesc,
                      validator: (desc) {
                        if ((priceController.text.isNotEmpty &&
                                priceController.text != "0") &&
                            desc!.isEmpty) {
                          return 'Укажите краткое описание цены';
                        } else {
                          return null;
                        }
                      },
                      controller: descController,
                      style: const TextStyle(color: Colors.white),
                      autofocus: false,
                      decoration: InputDecoration(
                        counterText: '',
                        errorStyle:
                            const TextStyle(color: Colors.red, fontSize: 12.0),
                        labelText: "Описание",
                        hintText: widget.desc,
                        labelStyle: const TextStyle(
                            fontSize: 14, color: Colors.white38),
                        border: OutlineInputBorder(
                          gapPadding: size.width * 0.55,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxLines: 1,
                      maxLength: 25,
                    ),
                  ),
                  Container(
                    width: size.width * 0.33,
                    decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                      child: TextFormField(
                        onTap: () => _selectAll(priceController),
                        onEditingComplete: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          priceIsTaped = false;
                        },
                        onChanged: widget.onChangedPrice,
                        validator: (price) {
                          if (price!.isNotEmpty && !isNumeric(price)) {
                            return 'Введите сумму';
                          }
                          return null;
                        },
                        controller: priceController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: '',
                          errorStyle: const TextStyle(
                              color: Colors.red, fontSize: 12.0),
                          labelText: "Цена",
                          labelStyle: const TextStyle(
                              fontSize: 14, color: Colors.white38),
                          border: OutlineInputBorder(
                            gapPadding: size.width * 0.33,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: const Icon(
                            Icons.currency_ruble_rounded,
                            color: Colors.green,
                          ),
                        ),
                        maxLines: 1,
                        maxLength: 6,
                      ),
                    ),
                  )
                ]),
          ),
        ),
      ],
    );
  }
}
