import 'package:flutter/widgets.dart';

class ConditionalWidget extends StatelessWidget {
  final bool condition;
  final Widget? child;
  final List<Widget>? children;
  final ConditionalChildrenType? childrenType;
  final Widget onFalse;
  final bool isAnimated;
  final int animationDuration;
  final ConditionalAnimationType? animationType;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;

  const ConditionalWidget({
    super.key,
    required this.condition,
    this.child,
    this.children,
    this.childrenType,
    required this.onFalse,
    this.isAnimated = false,
    this.animationDuration = 400,
    this.animationType,
    this.transitionBuilder,
  })  : assert(
          child != null || children != null,
          'Either child or children must be provided.',
        ),
        assert(
          !(child != null && children != null),
          'Cannot provide both child and children.',
        ),
        assert(
          children != null ? childrenType != null : true,
          'childrenType must be provided when using children.',
        ),
        assert(
          transitionBuilder == null || animationType == null,
          'Provide either animationType or transitionBuilder, not both.',
        );

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (children != null) {
      switch (childrenType!) {
        case ConditionalChildrenType.row:
          content = Row(children: children!);
          break;
        case ConditionalChildrenType.column:
          content = Column(children: children!);
          break;
      }
    } else if (child != null) {
      content = child!;
    } else {
      content = const SizedBox.shrink();
    }

    Widget result = condition ? content : onFalse;

    if (isAnimated) {
      AnimatedSwitcherTransitionBuilder effectiveTransitionBuilder;

      if (transitionBuilder != null) {
        effectiveTransitionBuilder = transitionBuilder!;
      } else if (animationType != null) {
        effectiveTransitionBuilder = _getTransitionBuilder(animationType!);
      } else {
        effectiveTransitionBuilder = AnimatedSwitcher.defaultTransitionBuilder;
      }

      return AnimatedSwitcher(
        duration: Duration(milliseconds: animationDuration),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: effectiveTransitionBuilder,
        child: KeyedSubtree(
          key: ValueKey(condition),
          child: result,
        ),
      );
    } else {
      return result;
    }
  }

  AnimatedSwitcherTransitionBuilder _getTransitionBuilder(
      ConditionalAnimationType type) {
    switch (type) {
      case ConditionalAnimationType.fade:
        return (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        };
      case ConditionalAnimationType.slideUp:
        return (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        };
      case ConditionalAnimationType.slideDown:
        return (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        };
      case ConditionalAnimationType.slideLeft:
        return (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        };
      case ConditionalAnimationType.slideRight:
        return (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        };
    }
  }
}

enum ConditionalChildrenType {
  column,
  row,
}

enum ConditionalAnimationType {
  fade,
  slideUp,
  slideDown,
  slideLeft,
  slideRight,
}
