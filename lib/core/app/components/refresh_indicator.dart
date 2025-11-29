import 'dart:math' as math;

import 'package:async/async.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';

class RefreshAndLoadingIndicator extends StatelessWidget {
  const RefreshAndLoadingIndicator({
    required this.child,
    super.key,
    this.onRefresh,
    this.onLoading,
    this.enabledOnLoading = true,
    this.loadingNotificationPredicate = _defaultLoadingNotificationPredicate,
  });

  final Widget child;
  final bool enabledOnLoading;
  final RefreshCallback? onRefresh;
  final RefreshCallback? onLoading;
  final bool Function(double outRange) loadingNotificationPredicate;

  @override
  Widget build(BuildContext context) {
    Widget child = ScrollConfiguration(
      behavior: const _RefreshIndicatorScrollBehavior(),
      child: this.child,
    );

    if (onLoading != null) {
      child = _LoadingIndicator(
        onRefresh: onLoading!,
        enabled: enabledOnLoading,
        loadingNotificationPredicate: loadingNotificationPredicate,
        child: child,
      );
    }

    if (onRefresh != null) {
      return _AnimatedRefreshIndicator.header(
        onRefresh: onRefresh!,
        child: child,
      );
    }

    return child;
  }
}

/// 共通のアニメーション付きリフレッシュインジケーター
class _AnimatedRefreshIndicator extends StatefulWidget {
  const _AnimatedRefreshIndicator.header({
    required this.child,
    required this.onRefresh,
  }) : trigger = IndicatorTrigger.leadingEdge,
       padding = const .only(top: 24, bottom: 4),
       reverseDuration = const Duration(milliseconds: 1000),
       containerExtentPercentageToArmed = null;

  final Widget child;
  final Future<void> Function() onRefresh;
  final IndicatorTrigger trigger;
  final EdgeInsets padding;
  final Duration reverseDuration;
  final double? containerExtentPercentageToArmed;

  @override
  State<_AnimatedRefreshIndicator> createState() =>
      _AnimatedRefreshIndicatorState();
}

class _AnimatedRefreshIndicatorState extends State<_AnimatedRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;
  late final IndicatorController _controller;

  void _controllerListener() {
    switch (_controller.state) {
      case IndicatorState.armed:
      case IndicatorState.dragging:
        _animationController.value = _controller.value;
      case IndicatorState.idle:
      case IndicatorState.canceling:
      case IndicatorState.settling:
      case IndicatorState.loading:
      case IndicatorState.complete:
      case IndicatorState.finalizing:
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = IndicatorController()..addListener(_controllerListener);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: widget.reverseDuration,
      vsync: this,
    );
    _sizeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onStateChanged(IndicatorStateChange change) {
    switch (change.newState) {
      case IndicatorState.loading:
        _animationController.forward();
      case IndicatorState.complete:
      case IndicatorState.finalizing:
      case IndicatorState.canceling:
        _animationController.reverse();
      case IndicatorState.settling:
      case IndicatorState.idle:
        break;
      case IndicatorState.armed:
      case IndicatorState.dragging:
        _animationController.animateTo(_controller.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      controller: _controller,
      onRefresh: widget.onRefresh,
      triggerMode: IndicatorTriggerMode.anywhere,
      trigger: widget.trigger,
      onStateChanged: _onStateChanged,
      containerExtentPercentageToArmed: widget.containerExtentPercentageToArmed,
      builder:
          (BuildContext context, Widget child, IndicatorController controller) {
            final indicator = Padding(
              padding: widget.padding,
              child: const _ProgressIndicator(),
            );

            final axis = switch (controller.direction) {
              AxisDirection.up || AxisDirection.down => Axis.vertical,
              AxisDirection.right || AxisDirection.left => Axis.horizontal,
            };

            return Flex(
              direction: axis,
              children: widget.trigger == IndicatorTrigger.trailingEdge
                  ? [
                      Expanded(child: child),
                      SizeTransition(
                        sizeFactor: _sizeAnimation,
                        axis: axis,
                        axisAlignment: -1,
                        child: indicator,
                      ),
                    ]
                  : [
                      SizeTransition(
                        sizeFactor: _sizeAnimation,
                        axis: axis,
                        axisAlignment: 1,
                        child: indicator,
                      ),
                      Expanded(child: child),
                    ],
            );
          },
      child: widget.child,
    );
  }
}

class _RefreshIndicatorScrollBehavior extends ScrollBehavior {
  const _RefreshIndicatorScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const AlwaysScrollableScrollPhysics(
      parent: BouncingScrollPhysics(),
    );
  }
}

class _LoadingIndicator extends StatefulWidget {
  const _LoadingIndicator({
    required this.onRefresh,
    required this.child,
    required this.loadingNotificationPredicate,
    required this.enabled,
  });

  final bool enabled;
  final RefreshCallback onRefresh;
  final Widget child;
  final bool Function(double outRange) loadingNotificationPredicate;

  @override
  State<_LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<_LoadingIndicator> {
  final _asyncCache = AsyncCache<void>.ephemeral();

  double _outRange = 0;

  Future<void> _onRefresh() async {
    if (!widget.enabled) {
      return;
    }

    await widget.onRefresh();
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        if (!widget.enabled) {
          return false;
        }

        setState(() {
          _outRange =
              notification.metrics.pixels -
              notification.metrics.maxScrollExtent;
        });

        if (widget.loadingNotificationPredicate(_outRange)) {
          _asyncCache.fetch(_onRefresh);
        }
        return false;
      },
      child: Stack(
        children: [
          widget.child,
          if (widget.enabled && _outRange > 0)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: math.max(_outRange, 0),
                padding: .only(
                  bottom: 32 + MediaQuery.paddingOf(context).bottom,
                  top: 4,
                ),
                child: OverflowBox(
                  maxHeight: math.max(_outRange, 24),
                  child: _ProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

bool _defaultLoadingNotificationPredicate(double outRange) {
  return outRange > -100;
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox.square(dimension: 24, child: CircularProgressIndicator()),
    );
  }
}
