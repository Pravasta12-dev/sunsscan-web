import 'package:flutter/material.dart';

class CircularGauge extends StatelessWidget {
  const CircularGauge({
    super.key,
    required this.progress, // 0.0 - 1.0
    required this.color,
    this.size = 100,
    this.strokeWidth = 10,
    this.isLoading = false,
  });

  final double progress;
  final Color color;
  final double size;
  final double strokeWidth;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: isLoading
              ? CircularProgressIndicator(
                  value: null, // 🔄 muter terus
                  strokeWidth: strokeWidth,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.grey.withAlpha(40),
                  valueColor: AlwaysStoppedAnimation(color),
                )
              : TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (_, value, _) {
                    return CircularProgressIndicator(
                      value: value,
                      strokeWidth: strokeWidth,
                      strokeCap: StrokeCap.round,
                      backgroundColor: Colors.grey.withAlpha(40),
                      valueColor: AlwaysStoppedAnimation(color),
                    );
                  },
                ),
        ),

        /// Text tengah
        isLoading
            ? const Text('...', style: TextStyle(fontWeight: FontWeight.bold))
            : Text(
                '${(progress * 100).round()}%',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
      ],
    );
  }
}
