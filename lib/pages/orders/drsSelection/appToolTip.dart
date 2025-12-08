import 'package:flutter/material.dart';

class TooltipItem {
  final Color color;
  final String text;

  TooltipItem(this.color, this.text);
}

class AppTooltip extends StatefulWidget {
  final Widget child;
  final List<TooltipItem> items;
  final Color backgroundColor;
  final Duration duration;
  final EdgeInsets padding;
  final double borderRadius;

  const AppTooltip({
    super.key,
    required this.child,
    required this.items,
    this.backgroundColor = Colors.white,
    this.duration = const Duration(seconds: 3),
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = 12,
  });

  @override
  State<AppTooltip> createState() => _AppTooltipState();
}

class _AppTooltipState extends State<AppTooltip> {
  OverlayEntry? _overlayEntry;

  void showTooltip() {
    if (_overlayEntry != null) return;

    final overlay = Overlay.of(context);
    final box = context.findRenderObject() as RenderBox;
    final size = box.size;
    final offset = box.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: offset.dy + size.height + 6,
          left: offset.dx,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item.color,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.text,
                          style: const TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
    Future.delayed(widget.duration, hideTooltip);
  }

  void hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _overlayEntry == null ? showTooltip() : hideTooltip(),
      child: widget.child,
    );
  }
}
