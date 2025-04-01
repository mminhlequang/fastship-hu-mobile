import 'package:app/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';

abstract class BaseLoadingState<T extends StatefulWidget> extends State<T> {
  bool _isLoading = false;

  bool get isStateLoading => _isLoading;

  @protected
  void setLoading(bool loading) {
    if (mounted) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildContent(context),
        if (_isLoading)
          Positioned.fill(
            child: WidgetGlassBackground(
              backgroundColor: Colors.black.withOpacity(0.1),
              child: const Center(
                child: WidgetAppLoader(),
              ),
            ),
          ),
      ],
    );
  }
}

class WidgetAppLoader extends StatelessWidget {
  const WidgetAppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: appColorPrimary,
        strokeCap: StrokeCap.round,
        valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary),
        backgroundColor: appColorElement,
        strokeWidth: 5.sw,
        trackGap: 1.sw,
      ),
    );
  }
}
