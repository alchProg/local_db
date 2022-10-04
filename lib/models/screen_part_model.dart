import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_db/blocs/color_bloc.dart';
import 'package:local_db/db/local_database.dart';
import 'package:local_db/models/normal_parts_lib.dart';
import 'package:local_db/models/part_model.dart';

class ScreenPartWidget extends StatefulWidget {
  final NormalPart nPart;
  final int pID;
  final String carType;
  final String assetName;
  final Color? color;
  final double? xScale;
  final double? width;
  final double? height;
  final List<double?>? left;
  final List<double?>? right;
  final List<double?>? top;
  final List<double?>? bottom;
  final VoidCallback? onTap;
  final bool isSide;

  const ScreenPartWidget({
    Key? key,
    required this.nPart,
    required this.pID,
    required this.carType,
    required this.assetName,
    this.color,
    this.xScale,
    this.width,
    this.height,
    this.left,
    this.right,
    this.top,
    this.bottom,
    this.onTap,
    required this.isSide,
  }) : super(key: key);

  @override
  State<ScreenPartWidget> createState() => _ScreenPartWidgetState();
}

class _ScreenPartWidgetState extends State<ScreenPartWidget> {
  bool isLoading = false;
  late Part part;
  late ColorBloc _bloc;

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
    part = await LocalDatabase.instance
        .readPTTPart(widget.nPart.title, widget.pID, widget.carType);
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() => isLoading = false);
    });
  }

  sizeInit() {
    xScale = widget.xScale ?? 1;

    if (widget.isSide) {
      width = widget.nPart.sWidth ?? 0;
      height = widget.nPart.sHeight ?? 0;
    } else {
      width = widget.nPart.cWidth ?? 0;
      height = widget.nPart.cHeight ?? 0;
    }
  }

  double? _offset(List<double?>? sizes) {
    if (sizes == null) {
      return null;
    }
    double result = 5.0;
    if (sizes.isEmpty) {
      return result;
    }
    double oSet = 3.0;
    for (double? size in sizes) {
      result += oSet + (size ?? 0);
    }
    return result * xScale;
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<ColorBloc>(context);
    return Positioned(
      width: width * xScale,
      height: height * xScale,
      left: _offset(widget.left),
      right: _offset(widget.right),
      top: _offset(widget.top),
      bottom: _offset(widget.bottom),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : BlocBuilder<ColorBloc, Color> (
            builder: (context, currentColor) {
              return InkWell(
                  highlightColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  onTap: () {
                    _addOrDeleteItem();
                  },
                  child: SvgPicture.asset(
                    widget.assetName,
                    color: _setColor(),
                  ),
                );
            }
          ),
    );
  }

  Color color = Colors.white.withOpacity(0.4);

  void _addOrDeleteItem() {
    final isContain = selectedPartsList.containsKey(part.title);

    if (isContain) {
      setState(() {
        selectedPartsList.remove(part.title);
      });
      _bloc.add(SelectedColorEvent());
    } else {
      setState(() {
        selectedPartsList[part.title] = part;
      });
      _bloc.add(UnSelectedColorEvent());
    }
    
    debugPrint('selectedPartsList: ${selectedPartsList.keys}');
  }

  Color _setColor() {
    final isContain = selectedPartsList.containsKey(part.title);
    if (isContain) {
      return Colors.brown.shade700;
    } else {
      return Colors.white.withOpacity(0.4);
    }
  }
}
