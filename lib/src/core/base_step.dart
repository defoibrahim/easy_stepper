import 'package:easy_stepper/easy_stepper.dart';
import 'package:easy_stepper/src/core/easy_border.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter_svg/flutter_svg.dart';

/// Callback is fired when a step is reached.
typedef OnStepReached = void Function(int index);

enum StepShape { circle, rRectangle }

enum BorderType { normal, dotted }

class BaseStep extends StatelessWidget {
  const BaseStep({
    Key? key,
    required this.step,
    required this.isActive,
    required this.isFinished,
    required this.isFormsCompleted,
    required this.isUnreached,
    required this.onStepSelected,
    required this.showTitle,
    required this.radius,
    required this.activeStepBackgroundColor,
    required this.finishedBackgroundColor,
    required this.unreachedBackgroundColor,
    required this.activeStepBorderColor,
    required this.finishedBorderColor,
    required this.unreachedBorderColor,
    required this.activeTextColor,
    required this.activeIconColor,
    required this.finishedTextColor,
    required this.unreachedTextColor,
    required this.unreachedIconColor,
    required this.finishedIconColor,
    required this.lottieAnimation,
    required this.padding,
    required this.stepShape,
    required this.stepRadius,
    required this.borderThickness,
    required this.borderType,
    required this.dashPattern,
    required this.showStepBorder,
    required this.showLoadingAnimation,
    required this.textDirection,
    required this.lineLength,
  }) : super(key: key);
  final EasyStep step;
  final bool isActive;
  final bool isFinished;
  final bool isFormsCompleted;
  final bool isUnreached;
  final VoidCallback? onStepSelected;
  final double radius;
  final bool showTitle;
  final Color? activeStepBackgroundColor;
  final Color? unreachedBackgroundColor;
  final Color? finishedBackgroundColor;
  final Color? activeStepBorderColor;
  final Color? unreachedBorderColor;
  final Color? finishedBorderColor;
  final Color? activeTextColor;
  final Color? activeIconColor;
  final Color? unreachedTextColor;
  final Color? unreachedIconColor;
  final Color? finishedTextColor;
  final Color? finishedIconColor;
  final double borderThickness;
  final String? lottieAnimation;
  final double? padding;
  final StepShape stepShape;
  final double? stepRadius;
  final BorderType borderType;
  final List<double> dashPattern;
  final bool showStepBorder;
  final bool showLoadingAnimation;
  final TextDirection textDirection;
  final double lineLength;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: (radius * 2) + (padding ?? 0),
          height: 45,
          child: Column(
            children: [
              const SizedBox(height: 5),
              Material(
                color: Colors.transparent,
                shape:
                    stepShape == StepShape.circle ? const CircleBorder() : null,
                clipBehavior: Clip.antiAlias,
                borderRadius: stepShape != StepShape.circle
                    ? BorderRadius.circular(stepRadius ?? 0)
                    : null,
                child: InkWell(
                  onTap: onStepSelected,
                  canRequestFocus: false,
                  radius: radius,
                  child: Container(
                    width: radius * 3,
                    height: radius * 1.3,
                    decoration: BoxDecoration(
                      shape: stepShape == StepShape.circle
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                      borderRadius: stepShape != StepShape.circle
                          ? BorderRadius.circular(stepRadius ?? 0)
                          : null,
                      color: isFinished
                          ? finishedBackgroundColor ??
                              Theme.of(context).colorScheme.primary
                          : isActive
                              ? activeStepBackgroundColor ?? Colors.transparent
                              : unreachedBackgroundColor ?? Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: showStepBorder
                        ? EasyBorder(
                            borderShape: stepShape == StepShape.circle
                                ? BorderShape.Circle
                                : BorderShape.RRect,
                            radius: stepShape != StepShape.circle
                                ? Radius.circular(stepRadius ?? 0)
                                : const Radius.circular(0),
                            color: isActive
                                ? activeStepBorderColor ??
                                    Theme.of(context).colorScheme.primary
                                : isFinished
                                    ? finishedBorderColor ?? Colors.transparent
                                    : unreachedBorderColor ??
                                        Colors.transparent,
                            strokeWidth: borderThickness,
                            dashPattern: borderType == BorderType.normal
                                ? [1, 0]
                                : dashPattern,
                            child: isActive && showLoadingAnimation
                                ? _buildLoadingIcon()
                                : _buildIcon(context),
                          )
                        : isActive && showLoadingAnimation
                            ? _buildLoadingIcon()
                            : _buildIcon(context),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isFinished || isFormsCompleted)
          Positioned(
            top: 0,
            right: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9999),
              child: SvgPicture.asset(
                'assets/svg/check_mark.svg',
                width: 20,
              ),
            ),
          )
      ],
    );
  }

  SizedBox _buildIcon(BuildContext context) {
    return SizedBox(
      // width: radius * 3,
      // height: radius * 1.3,
      child: Center(
        child: step.customStep ??
            Container(
              color: isFinished
                  ? Colors.transparent
                  : isActive
                      ? Colors.transparent
                      : unreachedIconColor ?? Colors.grey[300],
              child: isActive && step.activeIcon != null
                  ? step.activeIcon!
                  : isFinished && step.finishIcon != null
                      ? step.finishIcon!
                      : step.icon!,
            ),
      ),
    );
  }

  Center _buildLoadingIcon() {
    return Center(
      child: Lottie.asset(
        lottieAnimation ??
            (((activeStepBackgroundColor != null &&
                        activeStepBackgroundColor!.computeLuminance() < 0.35) &&
                    activeStepBackgroundColor != Colors.transparent)
                ? "packages/easy_stepper/assets/loading_white.json"
                : "packages/easy_stepper/assets/loading_black.json"),
        width: radius * 1.6,
        height: radius * 1.6,
        fit: BoxFit.contain,
      ),
    );
  }
}
