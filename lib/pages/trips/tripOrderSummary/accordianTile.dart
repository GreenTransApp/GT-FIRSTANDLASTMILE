import 'package:flutter/material.dart';

class AccordionTile extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const AccordionTile({
    required this.title,
    required this.children,
  });

  @override
  State<AccordionTile> createState() => _AccordionTileState();
}

class _AccordionTileState extends State<AccordionTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            trailing: Icon(
              _expanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.grey[600],
            ),
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
          if (_expanded)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: widget.children,
              ),
            ),
        ],
      ),
    );
  }
}
