import 'package:flutter/material.dart';

class GlobalLoader {
  static OverlayEntry? _loader;

  static void show(BuildContext context) {
    if (_loader != null) return;

    final overlayState = Overlay.of(context, rootOverlay: true);
    _loader = OverlayEntry(builder: (context) => const _GlobalLoaderWidget());

    overlayState.insert(_loader!);
  }

  static void hide() {
    _loader?.remove();
    _loader = null;
  }
}

class _GlobalLoaderWidget extends StatefulWidget {
  const _GlobalLoaderWidget();

  @override
  State<_GlobalLoaderWidget> createState() => _GlobalLoaderWidgetState();
}

class _GlobalLoaderWidgetState extends State<_GlobalLoaderWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 300),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Stack(
        children: [
          const ModalBarrier(
            dismissible: false,
            color: Colors.black54, // or withAlpha(100)
          ),
          const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      ),
    );
  }
}
