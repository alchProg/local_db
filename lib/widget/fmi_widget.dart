import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';

class FocusItem {
  final Color? backgroundColor;
  final String title;
  final Icon? trailingIcon;
  final Icon? iconL;
  final Icon? iconR;
  final Function onPressed;
  final VoidCallback? onTapL;
  final VoidCallback? onTapR;
  final dynamic context;

  FocusItem(
      {this.backgroundColor = Colors.teal,
      required this.title,
      this.trailingIcon,
      this.iconL,
      this.iconR,
      this.onTapL,
      this.onTapR,
      required this.onPressed,
      required this.context});

  itemT0() {
    TextEditingController titleController = TextEditingController(text: title);
    return FocusedMenuItem(
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8 - 28,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.55,
            child: TextField(
              readOnly: true,
              maxLength: 15,
              controller: titleController,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                  counterText: '', border: InputBorder.none),
            ),
          ),
        ),
        onPressed: onPressed,
        trailingIcon: trailingIcon,
        backgroundColor: backgroundColor);
  }

  itemT1() {
    TextEditingController titleController = TextEditingController(text: title);
    return FocusedMenuItem(
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8 - 28,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  splashColor: Colors.tealAccent, onTap: onTapL, child: iconL),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: TextField(
                  readOnly: true,
                  maxLength: 15,
                  controller: titleController,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.lightGreen,
                  ),
                  decoration: const InputDecoration(
                      counterText: '', border: InputBorder.none),
                ),
              ),
              InkWell(
                splashColor: Colors.tealAccent,
                onTap: onTapR,
                child: iconR,
              )
            ],
          ),
        ),
        onPressed: onPressed,
        trailingIcon: trailingIcon,
        backgroundColor: backgroundColor);
  }
}
