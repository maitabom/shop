import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;

  const AppBadge({
    required this.value,
    required this.child,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color ?? Theme.of(context).colorScheme.secondary,
            ),
            constraints: BoxConstraints(minHeight: 16, minWidth: 16),
            child: Text(
              value,
              style: TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
