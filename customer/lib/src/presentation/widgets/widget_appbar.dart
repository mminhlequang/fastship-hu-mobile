import 'package:app/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';

class WidgetAppBar extends StatelessWidget {
  final dynamic title;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  const WidgetAppBar(
      {super.key, required this.title, this.actions, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 8 + MediaQuery.of(context).padding.top, 16, 14 - 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  appHaptic();
                  Navigator.pop(context);
                  onBack?.call();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WidgetAppSVG('icon40', width: 24, height: 24),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: title is Widget
                    ? title
                    : Text(
                        title,
                        style: w600TextStyle(
                          fontSize: 18.sw,
                        ),
                      ),
              ),
              if (actions != null) ...actions!,
              const SizedBox(width: 4),
            ],
          ),
        ],
      ),
    );
  }
}
