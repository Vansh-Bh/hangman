import 'package:flutter/material.dart';

class HangmanPainter extends CustomPainter {
  final int lives;
  final double progress;

  HangmanPainter(this.lives, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(size.width * 0.25, size.height * 0.9),
        Offset(size.width * 0.75, size.height * 0.9), paint);
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.9),
        Offset(size.width * 0.5, size.height * 0.1), paint);
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.1),
        Offset(size.width * 0.7, size.height * 0.1), paint);
    canvas.drawLine(Offset(size.width * 0.7, size.height * 0.1),
        Offset(size.width * 0.7, size.height * 0.25), paint);

    if (lives >= 1) {
      final headProgress = (lives == 1) ? progress : 1.0;
      canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.3),
          20 * headProgress, paint);
    }
    if (lives >= 2) {
      final bodyProgress = (lives == 2) ? progress : 1.0;
      canvas.drawLine(
        Offset(size.width * 0.7, size.height * 0.35),
        Offset(size.width * 0.7, size.height * (0.35 + 0.15 * bodyProgress)),
        paint,
      );
    }
    if (lives >= 3) {
      final leftArmProgress = (lives == 3) ? progress : 1.0;
      canvas.drawLine(
        Offset(size.width * 0.7, size.height * 0.4),
        Offset(size.width * (0.7 - 0.05 * leftArmProgress),
            size.height * (0.4 + 0.05 * leftArmProgress)),
        paint,
      );
    }
    if (lives >= 4) {
      final rightArmProgress = (lives == 4) ? progress : 1.0;
      canvas.drawLine(
        Offset(size.width * 0.7, size.height * 0.4),
        Offset(size.width * (0.7 + 0.05 * rightArmProgress),
            size.height * (0.4 + 0.05 * rightArmProgress)),
        paint,
      );
    }
    if (lives >= 5) {
      final leftLegProgress = (lives == 5) ? progress : 1.0;
      canvas.drawLine(
        Offset(size.width * 0.7, size.height * 0.5),
        Offset(size.width * (0.7 - 0.05 * leftLegProgress),
            size.height * (0.5 + 0.1 * leftLegProgress)),
        paint,
      );
    }
    if (lives >= 6) {
      final rightLegProgress = (lives == 6) ? progress : 1.0;
      canvas.drawLine(
        Offset(size.width * 0.7, size.height * 0.5),
        Offset(size.width * (0.7 + 0.05 * rightLegProgress),
            size.height * (0.5 + 0.1 * rightLegProgress)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
