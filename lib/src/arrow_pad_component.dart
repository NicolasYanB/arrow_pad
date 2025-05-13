// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:math';

import 'package:flutter/material.dart';

import 'arrow_pad_icon_style.dart';
import 'click_trigger.dart';
import 'press_direction.dart';

/// the arrow pad widget
class ArrowPad extends StatelessWidget {
  /// creates a rounded widget with 4 arrow keys
  ///
  /// - The widget uses parent's size if
  /// [height] and [width] are not specified
  /// - If [height] and [width] are mentioned,
  /// widget takes the user defined values
  /// - If parent's size is available and also user mentioned size,
  /// then the least of the two is taken
  /// - If the parent doesn't have a size, and user haven't mentioned the size,
  /// it takes a value of [height] = 90 and [width] = 90 as default
  ///
  /// Note: It is better to use it with min size of 55.0
  ///
  /// Use [onPressed] to declare functions on pressed arrows
  ///
  /// Use [clickTrigger] to declare when to trigger the pressed functions.
  /// Either on [ClickTrigger.onTapDown] or [ClickTrigger.onTapUp]
  ///
  /// [ArrowPadIconStyle] determines the style of the arrow keys
  ///
  /// Default padding will be `const EdgeInsets.all(8.0)` unless mentioned
  ///
  /// By default, the theming of the arrow pad will be taken from the
  /// [ThemeData] of ancestors (if available). There are also different
  /// customization options  available like [innerColor], [outerColor], etc.
  ///
  /// Example usage:
  /// ```dart
  /// ArrowPad(
  ///   height: 70,
  ///   width: 70,
  ///   arrowPadIconStyle = ArrowPadIconStyle.arrow,
  ///   clickTrigger: ClickTrigger.onTapUp,
  ///   onPressed: (direction) => print('Pressed $direction'),
  /// ),
  /// ```
  const ArrowPad({
    Key? key,
    this.height,
    this.width,
    this.onPressedUp,
    this.onPressedDown,
    this.onPressedLeft,
    this.onPressedRight,
    this.onPressed,
    this.onLeave,
    this.clickTrigger = ClickTrigger.onTapDown,
    this.arrowPadIconStyle = ArrowPadIconStyle.chevron,
    this.outerColor,
    this.innerColor,
    this.iconColor,
    this.splashColor,
    this.hoverColor,
    this.padding,
  })  : assert(
            !(onPressed != null &&
                (onPressedDown != null ||
                    onPressedUp != null ||
                    onPressedRight != null ||
                    onPressedLeft != null)),
            'Either use [onPressed] or the old 4 methods.'),
        super(key: key);

  /// height of the arrow pad
  final double? height;

  /// width of the arrow pad
  final double? width;

  /// function when up arrow is pressed
  @Deprecated('Use [onPressed] instead')
  final void Function()? onPressedUp;

  /// function when down arrow is pressed
  @Deprecated('Use [onPressed] instead')
  final void Function()? onPressedDown;

  /// function when right arrow is pressed
  @Deprecated('Use [onPressed] instead')
  final void Function()? onPressedRight;

  /// function when left arrow is pressed
  @Deprecated('Use [onPressed] instead')
  final void Function()? onPressedLeft;

  /// function when pressed any button
  final void Function(PressDirection direction)? onPressed;
  final void Function(PressDirection direction)? onLeave;

  /// When to trigger the pressed functions using [ClickTrigger]
  ///
  /// Defaults to [ClickTrigger.onTapDown]
  final ClickTrigger? clickTrigger;

  /// Icon style of the arrow pad [ArrowPadIconStyle]
  ///
  /// Defaults to [ArrowPadIconStyle.chevron]
  final ArrowPadIconStyle arrowPadIconStyle;

  /// outer circle color of the arrow pad
  final Color? outerColor;

  /// inner circle color of the arrow pad
  final Color? innerColor;

  /// arrow icon color of the arrow pad
  final Color? iconColor;

  /// splash color of the inner circle arrow pad
  final Color? splashColor;

  /// hover color of the inner circle arrow pad
  final Color? hoverColor;

  /// The amount of space by which to inset the child.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final icons = arrowPadIconStyle.getIcons();

    var lSplashColor = splashColor;
    if (Theme.of(context).useMaterial3) {
      // use dynamic color from primary when using material 3
      lSplashColor =
          splashColor ?? Theme.of(context).colorScheme.primary.withAlpha(80);
    }

    return Padding(
      padding: padding ?? const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double cHeight = constraints.maxHeight;
          double cWidth = constraints.maxWidth;

          if (height != null && height! <= cHeight) {
            cHeight = height!;
          } else if (cHeight == double.infinity) {
            cHeight = 90.0;
          }
          if (width != null && width! <= cWidth) {
            cWidth = width!;
          } else if (cWidth == double.infinity) {
            cWidth = 90.0;
          }

          double padSize = min(cHeight, cWidth);

          return SizedBox(
            height: cHeight,
            width: cWidth,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: outerColor ??
                      Theme.of(context).colorScheme.primary.withAlpha(80),
                  shape: BoxShape.circle,
                ),
                height: padSize,
                width: padSize,
                child: Padding(
                  padding: EdgeInsets.all(padSize * 0.035),
                  child: Center(
                    child: Material(
                      color: Colors.transparent,
                      child: Card(
                        color: innerColor ??
                            Theme.of(context).colorScheme.primaryContainer,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(padSize),
                        ),
                        child: InkWell(
                          splashColor: lSplashColor,
                          hoverColor: hoverColor,
                          borderRadius: BorderRadius.circular(padSize - 10),
                          onTap: () {},
                          onTapUp: (details) =>
                              clickTrigger == ClickTrigger.onTapUp || clickTrigger == ClickTrigger.onTapBoth
                                  ? _tapHandle(details, padSize, 1)
                                  : null,
                          onTapDown: (details) =>
                              clickTrigger == ClickTrigger.onTapDown || clickTrigger == ClickTrigger.onTapBoth
                                  ? _tapHandle(details, padSize, 0)
                                  : null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: IconTheme(
                              data: IconThemeData(
                                size: padSize / 5,
                                color: iconColor ??
                                    Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(icons[0]),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(icons[1]),
                                        Icon(icons[2]),
                                      ],
                                    ),
                                  ),
                                  Icon(icons[3]),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// handle the tap on the arrow pad.
  ///
  /// Can be used only on the [details] that contains localPosition.
  /// Example: [TapDownDetails] or [TapUpDetails]
  _tapHandle(details, double padSize, bool up) {
    double x = details.localPosition.dx;
    double y = details.localPosition.dy;
    double part = (padSize - 20) / 3;
    if (x > part && x < part * 2) {
      // up or down
      if (y < part) {
        if (onPressed != null && (clickTrigger == ClickTrigger.onTapDown || clickTrigger == ClickTrigger.onTapBoth) && !up) {
          onPressed!(PressDirection.up);
        }
        if (onLeave != null && (clickTrigger == ClickTrigger.onTapUp || clickTrigger == ClickTrigger.onTapBoth) && up) {
          onLeave!(PressDirection.up);
        }
        if (onPressedUp != null) {
          onPressedUp!();
        }
      } else if (y > part * 2) {
        if (onPressed != null && (clickTrigger == ClickTrigger.onTapDown || clickTrigger == ClickTrigger.onTapBoth) && !up) {
          onPressed!(PressDirection.down);
        }
        if (onLeave != null && (clickTrigger == ClickTrigger.onTapUp || clickTrigger == ClickTrigger.onTapBoth) && up) {
          onLeave!(PressDirection.down);
        }
        if (onPressedDown != null) {
          onPressedDown!();
        }
      }
    } else if (y > part && y < part * 2) {
      // left or right
      if (x < part) {
        if (onPressed != null && (clickTrigger == ClickTrigger.onTapDown || clickTrigger == ClickTrigger.onTapBoth) && !up) {
          onPressed!(PressDirection.left);
        }
        if (onLeave != null && (clickTrigger == ClickTrigger.onTapUp || clickTrigger == ClickTrigger.onTapBoth) && up) {
          onLeave!(PressDirection.left);
        }
        if (onPressedLeft != null) {
          onPressedLeft!();
        }
      } else if (x > part * 2) {
        if (onPressed != null && (clickTrigger == ClickTrigger.onTapDown || clickTrigger == ClickTrigger.onTapBoth) && !up) {
          onPressed!(PressDirection.right);
        }
        if (onLeave != null && (clickTrigger == ClickTrigger.onTapUp || clickTrigger == ClickTrigger.onTapBot) && up) {
          onLeave!(PressDirection.right);
        }
        if (onPressedRight != null) {
          onPressedRight!();
        }
      }
    }
  }
}
