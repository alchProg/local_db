import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class PartFormWidget extends StatefulWidget {

  final  String? price;
  final String? desc;
  final String? labelText;
  final bool? autofocus;
  final ValueChanged<String>? onChangedPrice;
  final ValueChanged<String>? onChangedDesc;
  final BorderRadius? borderRadius;

  const PartFormWidget({
    Key? key,
    this.autofocus,
    this.price,
    this.desc,
    this.labelText,
    this.onChangedPrice,
    this.onChangedDesc,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<PartFormWidget> createState() => _PartFormWidgetState();
}

class _PartFormWidgetState extends State<PartFormWidget> {
  late bool priceIsTaped;
  late bool descIsTaped;
  late TextEditingController priceController;
  late TextEditingController descController;

  @override
  void initState() {
    priceIsTaped = false;
    descIsTaped = false;
    priceController = TextEditingController(text: widget.price == '0' ? '' : widget.price);
    descController = TextEditingController(text: widget.desc ?? '');
    super.initState();
  }

  _selectAll(TextEditingController textController){
    if (textController.text.isEmpty || priceIsTaped){return;}
    priceIsTaped = true;
      return textController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: textController.text.length);
  }

  @override
  Widget build(BuildContext context) {
  
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 3, top: 3, right: 3),
          child: Container(
            height: 100,
            width: MediaQuery
                .of(context)
                .size
                .width - 6,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: widget.borderRadius,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*0.55,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10),),
                    child: TextFormField(
                      onTap: () => _selectAll(descController),
                      onEditingComplete: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        descIsTaped = false;
                      },
                      onChanged: widget.onChangedDesc,
                      validator: (desc) {
                        if ((priceController.text.isNotEmpty && priceController.text != "0") && desc!.isEmpty) {
                          return 'Укажите краткое описание цены';
                        } else {
                          return null;
                        }
                      },
                      controller: descController,
                      style: const TextStyle(color: Colors.white),
                      autofocus: widget.autofocus ?? false,
                      decoration: InputDecoration(
                        counterText: '',
                        errorStyle: const TextStyle(
                            color: Colors.red,
                            fontSize: 12.0
                        ),
                        labelText: "Описание",
                        hintText: widget.desc,
                        labelStyle: const TextStyle(
                            fontSize: 14, color: Colors.white38),
                        border: OutlineInputBorder(
                          gapPadding: MediaQuery
                              .of(context)
                              .size
                              .width*0.55,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxLines: 1,
                      maxLength: 25,
                    ),
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*0.33,
                    decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(10)
                    ),
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
                          if (price!.isNotEmpty && !isNumeric(price)){
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
                            color: Colors.red,
                            fontSize: 12.0
                          ),
                          labelText: "Цена",
                          labelStyle: const TextStyle(
                              fontSize: 14, color: Colors.white38),
                          border: OutlineInputBorder(
                            gapPadding: MediaQuery
                                .of(context)
                                .size
                                .width*0.33,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: const Icon(
                            Icons.currency_ruble_rounded, color: Colors.green,),
                        ),
                        maxLines: 1,
                        maxLength: 6,
                      ),
                    ),
                  )
                ]
            ),
          ),
        ),

      ],
    );
  }
}
