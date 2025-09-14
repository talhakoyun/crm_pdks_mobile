import 'package:flutter/material.dart';

import '../../core/init/theme/theme_extensions.dart';

const defaultValue = 56.0;

class Loader extends StatelessWidget {
  static OverlayEntry? _currentLoader;

  const Loader._(this._progressIndicator, this._themeData);

  final Widget? _progressIndicator;
  final ThemeData? _themeData;

  static OverlayState? _overlayState;
  static bool get isShown => _currentLoader != null;
  static void show(
    BuildContext context, {
    Widget? progressIndicator,
    ThemeData? themeData,
    Color? overlayColor,
    double? overlayFromTop,
    double? overlayFromBottom,
    bool isAppbarOverlay = true,
    bool isBottomBarOverlay = true,
    bool isSafeAreaOverlay = true,
  }) {
    var safeBottomPadding = MediaQuery.of(context).padding.bottom;
    var defaultPaddingTop = 0.0;
    var defaultPaddingBottom = 0.0;
    if (!isAppbarOverlay) {
      isSafeAreaOverlay = false;
    }
    if (!isSafeAreaOverlay) {
      defaultPaddingTop = defaultValue;
      defaultPaddingBottom = defaultValue + safeBottomPadding;
    } else {
      defaultPaddingTop = defaultValue;
      defaultPaddingBottom = defaultValue;
    }
    _overlayState = Overlay.of(context);
    if (_currentLoader == null) {
      _currentLoader = OverlayEntry(
        builder: (context) {
          return Stack(
            children: <Widget>[
              _overlayWidget(
                isSafeAreaOverlay,
                overlayColor ??
                    context.colorScheme.surface.withValues(alpha: 0.6),
                isAppbarOverlay ? 0.0 : overlayFromTop ?? defaultPaddingTop,
                isBottomBarOverlay
                    ? 0.0
                    : overlayFromBottom ?? defaultPaddingBottom,
              ),
              Center(child: Loader._(progressIndicator, themeData)),
            ],
          );
        },
      );
      try {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_currentLoader != null) {
            _overlayState?.insert(_currentLoader!);
          }
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  static Widget _overlayWidget(
    bool isSafeArea,
    Color overlayColor,
    double overlayFromTop,
    double overlayFromBottom,
  ) {
    return isSafeArea
        ? Container(
            color: overlayColor,
            margin: EdgeInsets.only(
              top: overlayFromTop,
              bottom: overlayFromBottom,
            ),
          )
        : SafeArea(
            child: Container(
              color: overlayColor,
              margin: EdgeInsets.only(
                top: overlayFromTop,
                bottom: overlayFromBottom,
              ),
            ),
          );
  }

  static void hide() {
    if (_currentLoader != null) {
      try {
        _currentLoader?.remove();
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        _currentLoader = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Theme(
          data:
              _themeData ??
              Theme.of(context).copyWith(
                colorScheme: Theme.of(
                  context,
                ).colorScheme.copyWith(secondary: context.colorScheme.primary),
              ),
          child:
              _progressIndicator ??
              CircularProgressIndicator(
                backgroundColor: context.colorScheme.primary,
                valueColor: AlwaysStoppedAnimation(
                  context.colorScheme.onPrimary,
                ),
                color: context.colorScheme.error,
              ),
        ),
      ),
    );
  }
}
