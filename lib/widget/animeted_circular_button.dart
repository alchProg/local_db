import 'package:flutter/material.dart';

class AnimetedCircularButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  final Icon icon;
  final VoidCallback onClick;
  final double? degOffsetDir;
  final double? liniarOffset;
  final Widget? child;
  final Animation<dynamic>? degAnimation;
  final Animation<dynamic> rotationAnimation;

  const AnimetedCircularButton({
    Key? key,
    this.color,
    this.width = 50,
    this.height = 50,
    this.liniarOffset = 0,
    this.degOffsetDir,
    this.degAnimation,
    this.child,
    required this.icon,
    required this.onClick,
    required this.rotationAnimation,
  }) : super(key: key);

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  Widget build(BuildContext context) {
    return degOffsetDir == null
        ? Transform(
            transform: Matrix4.rotationZ(
                getRadiansFromDegree(rotationAnimation.value)),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              width: width,
              height: height,
              child: IconButton(
                  icon: icon, enableFeedback: true, onPressed: onClick),
            ),
          )
        : Transform.translate(
            offset: Offset.fromDirection(getRadiansFromDegree(degOffsetDir!),
                degAnimation!.value * (100 + liniarOffset!)),
            child: Transform(
              transform: Matrix4.rotationZ(
                  getRadiansFromDegree(rotationAnimation.value))
                ..scale(degAnimation!.value),
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                width: width,
                height: height,
                child: child ??
                    IconButton(
                        icon: icon, enableFeedback: true, onPressed: onClick),
              ),
            ),
          );
  }
}
