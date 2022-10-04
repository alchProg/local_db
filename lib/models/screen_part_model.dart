import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_db/db/local_database.dart';
import 'package:local_db/models/normal_parts_lib.dart';
import 'package:local_db/models/part_model.dart';
import 'package:local_db/models/price_list_items_model.dart';
import 'package:local_db/models/price_list_model.dart';

import '../generated/assets.dart';

class ScreenPartWidget extends StatefulWidget {

  NormalPart nPart;
  int pID;
  String carType;
  String assetName;
  Color? color;
  double? xScale;
  double? width;
  double? height;
  List<double?>? left;
  List<double?>? right ;
  List<double?>? top   ;
  List<double?>? bottom;
  VoidCallback? onTap;
  bool isSide;

  ScreenPartWidget({
    Key? key,
    required this.nPart,
    required this.pID,
    required this.carType,
    required this.assetName,
    this.color,
    this.xScale ,
    this.width  ,
    this.height ,
    this.left   ,
    this.right  ,
    this.top    ,
    this.bottom ,
    this.onTap  ,
    required this.isSide,
  }) : super(key: key);

  @override
  State<ScreenPartWidget> createState() => _ScreenPartWidgetState();
}

class _ScreenPartWidgetState extends State<ScreenPartWidget> {


  bool isLoading = false;
  late Part part;

  late double xScale;
  late double width;
  late double height;


  @override
  void initState() {

    sizeInit();
    _priceListRefresh();
    super.initState();
  }

  Future _priceListRefresh() async {
    setState(() => isLoading = true);
    part = await LocalDatabase.instance.readPTTPart(widget.nPart.title, widget.pID, widget.carType);
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() => isLoading = false);
    });
  }

  sizeInit(){
    xScale = widget.xScale ?? 1;

    if(widget.isSide){
      width = widget.nPart.sWidth ?? 0;
      height = widget.nPart.sHeight ?? 0;
    } else {
      width = widget.nPart.cWidth ?? 0;
      height = widget.nPart.cHeight ?? 0;
    }
  }

  double? _offset (List<double?>? sizes) {
    if(sizes == null){return null;}
    double result = 5.0;
    if(sizes.isEmpty){return result;}
    double oSet = 3.0;
    sizes.forEach((size) {
      result += oSet + (size ?? 0);
    });
    return result * xScale;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        width:  width  * xScale,
        height: height * xScale,
        left:  _offset(widget.left   ),
        right: _offset(widget.right  ),
        top:   _offset(widget.top    ),
        bottom:_offset(widget.bottom ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(),)
            : InkWell(
                highlightColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                onTap: (){
                  _addOrDeleteItem();
                  },
                child:SvgPicture.asset(
                  widget.assetName,
                  color: color,
                ),
              ),
    );
  }
  Color color = Colors.white.withOpacity(0.4);

  void _addOrDeleteItem(){
    final isContain = selectedPartsList.contains(part);
    if (isContain) {
      setState(() {
        selectedPartsList.remove(part);
        color = Colors.white.withOpacity(0.4);
      });
      print("Part ${part.title} removed");
    }
    else {
      setState(() {
        selectedPartsList.add(part);
        color = Colors.brown.shade700;
      });
      print("Part ${part.title} added");
    }
  }

  // Color _setColor(){
  //   final Color color1 = Colors.brown.shade700;
  //   final Color color2 = Colors.white.withOpacity(0.4);
  //   final isContain = selectedPartsList.contains(part);
  //
  //   setState(() {
  //     if (isContain) {return color1;}
  //     else {return color2;}
  //   });
  // }

}
