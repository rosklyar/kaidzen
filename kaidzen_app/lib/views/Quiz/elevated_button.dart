import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ElevatedIconButton extends StatefulWidget {
  final IconData iconData;
  final Color color;
  final Color iconColor;
  final bool isDarkMode;
  final Function(bool) onLongPressCompleted;

  const ElevatedIconButton({
    Key? key,
    required this.iconData,
    required this.color,
    required this.iconColor,
    required this.isDarkMode,
    required this.onLongPressCompleted,
  }) : super(key: key);

  @override
  _ElevatedIconButtonState createState() => _ElevatedIconButtonState();
}

class _ElevatedIconButtonState extends State<ElevatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Timer? _holdTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 9)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _holdTimer?.cancel();
    super.dispose();
  }

  void _onLongPress() {
    _controller.forward(); // Start the scaling animation
    if (_holdTimer?.isActive ?? false) {
      _holdTimer!.cancel();
    }

    // Start the vibration
    Vibration.vibrate(pattern: [500, 1000], repeat: 3);

    // Set up a timer for 4 seconds to trigger the action if the button is held long enough.
    _holdTimer = Timer(const Duration(seconds: 4), () {
      widget.onLongPressCompleted(widget.isDarkMode);
      Vibration.cancel(); // Stop the vibration when the action is triggered
    });
  }

  void _onLongPressUp() {
    _controller.reverse(); // Reverse the scaling animation
    if (_holdTimer?.isActive ?? false) {
      _holdTimer!.cancel(); // Cancel the timer if the press is released early
    }
    Vibration.cancel(); // Cancel any ongoing vibration
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _onLongPress,
      onLongPressUp: _onLongPressUp,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 111, // Initial size of the button
                  height: 111,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
          Icon(
            widget.iconData,
            size: 36,
            color: widget.iconColor,
          ),
        ],
      ),
    );
  }
}
