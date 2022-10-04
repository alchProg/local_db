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

  FocusItem({
    this.backgroundColor = Colors.teal,
    required this.title,
    this.trailingIcon,
    this.iconL,
    this.iconR,
    this.onTapL,
    this.onTapR,
    required this.onPressed,
    required this.context
  });


  itemT0() {
    return FocusedMenuItem(
      title: SizedBox(
        width: MediaQuery.of(context).size.width*0.6 - 28,
        child: Text(title, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center,),
      ),
      onPressed: onPressed,
      trailingIcon: trailingIcon,
      backgroundColor: backgroundColor
    );
  }

  itemT1() {
    return FocusedMenuItem(
        title: SizedBox(
          width: MediaQuery.of(context).size.width*0.6 - 28,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  splashColor: Colors.tealAccent,
                  onTap: onTapL,
                  child: iconL),
              Text(title, style: const TextStyle(color: Colors.white),),
              InkWell(
                  splashColor: Colors.tealAccent,
                  onTap: onTapR,
                  child: iconR,)
            ],
          ),
        ),
        onPressed: onPressed,
        trailingIcon: trailingIcon,
        backgroundColor: backgroundColor
    );
  }
}