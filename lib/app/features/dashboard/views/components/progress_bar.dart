import 'package:flutter/material.dart';

class ProgressBarWithIndicator extends StatefulWidget {
  final double progress;
  final int count;
  final Color indicatorColor;
  final double indicatorSize;

  ProgressBarWithIndicator({
    required this.progress,
    required this.count,
    required this.indicatorColor,
    this.indicatorSize = 20.0,
  });

  @override
  _ProgressBarWithIndicatorState createState() =>
      _ProgressBarWithIndicatorState();
}

class _ProgressBarWithIndicatorState extends State<ProgressBarWithIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Hızı ayarlamak için süreyi ayarla
    );

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: widget.indicatorColor,
    ).animate(_animationController);

    _animationController.repeat(reverse: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, // Sütunları daha yakın hale getir
      children: List.generate(widget.count, (index) { // Daha fazla sütun oluşturmak için
        final bool isActive = index < (widget.progress * 10).floor();
        return Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 8.0,
                  height: 100.0,
                  color: isActive ? Colors.blueGrey : Colors.blueGrey,
                ),
                Positioned(
                  top: 50.0 - (widget.indicatorSize / 2),
                  child: AnimatedBuilder(
                    animation: _colorAnimation,
                    builder: (context, child) => Container(
                      width: widget.indicatorSize,
                      height: widget.indicatorSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _colorAnimation.value,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text('Kolon ${index + 1}'),
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
