import 'package:flutter/material.dart';

class PageIndicatorPainter extends CustomPainter {
  PageIndicatorPainter({
    required this.pageCount,
    required this.dotRadius,
    required this.dotOutlineThickness,
    required this.spacing,
    this.scrollPosition = 0.0,
    required Color dotFillColor,
    required Color dotOutlineColor,
    required Color indcatorColor,
  })  : dotFillPaint = Paint()..color = dotFillColor,
        dotOutlinePaint = Paint()..color = dotOutlineColor,
        indcatorPaint = Paint()..color = indcatorColor;

  final int pageCount;
  final double dotRadius;
  final double dotOutlineThickness;
  final double spacing;
  final double scrollPosition;
  final Paint dotFillPaint;
  final Paint dotOutlinePaint;
  final Paint indcatorPaint;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);

    final double totalWidth =
        (pageCount * (2 * dotRadius)) + ((pageCount - 1) * spacing);

    _drowDots(canvas, center, totalWidth);

    _drowPageIndicator(canvas, center, totalWidth);
  }

  void _drowPageIndicator(Canvas canvas, Offset center, double totalWidth) {
    final int pageIndesToLeft = scrollPosition.floor();
    final double leftDotX = (center.dx - (totalWidth / 2)) +
        (pageIndesToLeft * ((2 * dotRadius) + spacing));
    final double transitionPrecent = scrollPosition - pageIndesToLeft;

    final lagingLeftPositionPercent =
        (transitionPrecent - 0.3).clamp(0.0, 1.0) / 0.7;

    final double indicatorLeftX =
        leftDotX + (lagingLeftPositionPercent * ((2 * dotRadius) + spacing));

    final acceleratedRightPositionPercent =
        (transitionPrecent / 0.5).clamp(0.0, 1.0);

    final double indicatorRightX = leftDotX +
        (acceleratedRightPositionPercent * ((2 * dotRadius) + spacing)) +
        (2 * dotRadius);

    canvas.drawRRect(
      RRect.fromLTRBR(
        indicatorLeftX,
        -dotRadius,
        indicatorRightX,
        dotRadius,
        Radius.circular(dotRadius),
      ),
      indcatorPaint,
    );
  }

  void _drowDots(Canvas canvas, Offset center, double totalWidth) {
    Offset dotCenter = center.translate((-totalWidth / 2) + dotRadius, 0);

    for (int i = 0; i < pageCount; ++i) {
      _drowDot(canvas, dotCenter);
      dotCenter = dotCenter.translate((2 * dotRadius) + spacing, 0);
    }
  }

  void _drowDot(Canvas canvas, Offset dotCenter) {
    canvas.drawCircle(dotCenter, dotRadius - dotOutlineThickness, dotFillPaint);

    Path outlinePath = Path()
      ..addOval(Rect.fromCircle(center: dotCenter, radius: dotRadius))
      ..addOval(Rect.fromCircle(
          center: dotCenter, radius: dotRadius - dotOutlineThickness))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(outlinePath, dotOutlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
