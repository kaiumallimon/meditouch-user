import 'package:flutter/material.dart';

class WidgetMotion extends StatefulWidget {
  const WidgetMotion({
    super.key,
    required this.child,
    required this.direction,
    this.duration = const Duration(milliseconds: 800),
  });

  final String direction; // 'up', 'down', 'left', 'right'
  final Widget child;
  final Duration duration;

  @override
  State<WidgetMotion> createState() => _WidgetMotionState();
}

class _WidgetMotionState extends State<WidgetMotion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Map the direction to an Offset
    Offset beginOffset;
    switch (widget.direction) {
      case 'up':
        beginOffset = const Offset(0, 1); // From bottom to up
        break;
      case 'down':
        beginOffset = const Offset(0, -1); // From top to down
        break;
      case 'left':
        beginOffset = const Offset(-1, 0); // From left to right
        break;
      case 'right':
        beginOffset = const Offset(1, 0); // From right to left
        break;
      default:
        beginOffset = Offset.zero; // No motion if invalid direction
    }

    // Slide animation
    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Opacity animation
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start the animation on widget load
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}