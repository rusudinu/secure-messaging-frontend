import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class Loading extends StatefulWidget {
  final bool maintenance;
  final String reason;

  Loading(this.maintenance, this.reason);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: AutomatedAnimator(
              animateToggle: true,
              doRepeatAnimation: true,
              duration: Duration(seconds: 10),
              buildWidget: (double animationPosition) {
                return WaveLoadingBubble(
                  foregroundWaveColor: Colors.red,
                  backgroundWaveColor: Colors.red[200],
                  loadingWheelColor: Colors.red,
                  period: animationPosition,
                  backgroundWaveVerticalOffset: 90 - animationPosition * 200,
                  foregroundWaveVerticalOffset: 90 +
                      reversingSplitParameters(
                        position: animationPosition,
                        numberBreaks: 6,
                        parameterBase: 8.0,
                        parameterVariation: 8.0,
                        reversalPoint: 0.75,
                      ) -
                      animationPosition * 200,
                  waveHeight: reversingSplitParameters(
                    position: animationPosition,
                    numberBreaks: 5,
                    parameterBase: 12,
                    parameterVariation: 8,
                    reversalPoint: 0.75,
                  ),
                );
              },
            ),
          ),
          if (widget.maintenance)
            Positioned(
              bottom: 10,
              right: 10,
              left: 10,
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.only(bottom: 20, top: 30),
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Text(
                        "We are performing maintenance on the server",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  if (widget.reason != null)
                    Text(
                      widget.reason,
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class AutomatedAnimator extends StatefulWidget {
  AutomatedAnimator({
    @required this.buildWidget,
    @required this.animateToggle,
    this.duration = const Duration(milliseconds: 300),
    this.doRepeatAnimation = false,
    Key key,
  }) : super(key: key);

  final Widget Function(double animationValue) buildWidget;
  final Duration duration;
  final bool animateToggle;
  final bool doRepeatAnimation;

  @override
  _AutomatedAnimatorState createState() => _AutomatedAnimatorState();
}

class _AutomatedAnimatorState extends State<AutomatedAnimator> with SingleTickerProviderStateMixin {
  _AutomatedAnimatorState();

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration)..addListener(() => setState(() {}));
    if (widget.animateToggle == true) controller.forward();
    if (widget.doRepeatAnimation == true) controller.repeat();
  }

  @override
  void didUpdateWidget(AutomatedAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animateToggle == true) {
      controller.forward();
      return;
    }
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return widget.buildWidget(controller.value);
  }
}

//*======================================================================
//* Additional functions to allow custom periodicity of animations
//*======================================================================

//*======================================================================
//* varies (parameterVariation) a paramter (parameterBase) based on an
//* animation position (position), broken into a number of parts
//* (numberBreaks).
//* the animation reverses at the halfway point (0.5)
//*
//* returns a value of 0.0 - 1.0
//*======================================================================

double reversingSplitParameters({
  @required double position,
  @required double numberBreaks,
  @required double parameterBase,
  @required double parameterVariation,
  @required double reversalPoint,
}) {
  assert(reversalPoint <= 1.0 && reversalPoint >= 0.0, "reversalPoint must be a number between 0.0 and 1.0");
  final double finalAnimationPosition = breakAnimationPosition(position, numberBreaks);

  if (finalAnimationPosition <= 0.5) {
    return parameterBase - (finalAnimationPosition * 2 * parameterVariation);
  } else {
    return parameterBase - ((1 - finalAnimationPosition) * 2 * parameterVariation);
  }
}

//*======================================================================
//* Breaks down a long animation controller value into a number of
//* smaller animations,
//* used for creating a single looping animation with multiple
//* sub animations with different periodicites that are able to
//* maintain a consistent unbroken loop
//*
//* Returns a value of 0.0 - 1.0 based on a given animationPosition
//* split into a discrete number of breaks (numberBreaks)
//*======================================================================

double breakAnimationPosition(double position, double numberBreaks) {
  double finalAnimationPosition = 0;
  final double breakPoint = 1.0 / numberBreaks;

  for (var i = 0; i < numberBreaks; i++) {
    if (position <= breakPoint * (i + 1)) {
      finalAnimationPosition = (position - i * breakPoint) * numberBreaks;
      break;
    }
  }

  return finalAnimationPosition;
}

class WaveLoadingBubble extends StatelessWidget {
  const WaveLoadingBubble({
    this.bubbleDiameter = 200.0,
    this.loadingCircleWidth = 10.0,
    this.waveInsetWidth = 5.0,
    this.waveHeight = 10.0,
    this.foregroundWaveColor = Colors.lightBlue,
    this.backgroundWaveColor = Colors.blue,
    this.loadingWheelColor = Colors.white,
    this.foregroundWaveVerticalOffset = 10.0,
    this.backgroundWaveVerticalOffset = 0.0,
    this.period = 0.0,
    Key key,
  }) : super(key: key);

  final double bubbleDiameter;
  final double loadingCircleWidth;
  final double waveInsetWidth;
  final double waveHeight;
  final Color foregroundWaveColor;
  final Color backgroundWaveColor;
  final Color loadingWheelColor;
  final double foregroundWaveVerticalOffset;
  final double backgroundWaveVerticalOffset;
  final double period;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaveLoadingBubblePainter(
        bubbleDiameter: bubbleDiameter,
        loadingCircleWidth: loadingCircleWidth,
        waveInsetWidth: waveInsetWidth,
        waveHeight: waveHeight,
        foregroundWaveColor: foregroundWaveColor,
        backgroundWaveColor: backgroundWaveColor,
        loadingWheelColor: loadingWheelColor,
        foregroundWaveVerticalOffset: foregroundWaveVerticalOffset,
        backgroundWaveVerticalOffset: backgroundWaveVerticalOffset,
        period: period,
      ),
    );
  }
}

class WaveLoadingBubblePainter extends CustomPainter {
  WaveLoadingBubblePainter({
    this.bubbleDiameter,
    this.loadingCircleWidth,
    this.waveInsetWidth,
    this.waveHeight,
    this.foregroundWaveColor,
    this.backgroundWaveColor,
    this.loadingWheelColor,
    this.foregroundWaveVerticalOffset,
    this.backgroundWaveVerticalOffset,
    this.period,
  })  : foregroundWavePaint = Paint()..color = foregroundWaveColor,
        backgroundWavePaint = Paint()..color = backgroundWaveColor,
        loadingCirclePaint = Paint()
          ..shader = SweepGradient(
            colors: [
              Colors.transparent,
              loadingWheelColor,
              Colors.transparent,
            ],
            stops: [0.0, 0.9, 1.0],
            startAngle: 0,
            endAngle: math.pi * 1,
            transform: GradientRotation(period * math.pi * 2 * 5),
          ).createShader(Rect.fromCircle(
            center: Offset(0.0, 0.0),
            radius: bubbleDiameter / 2,
          ));

  final double bubbleDiameter;
  final double loadingCircleWidth;
  final double waveInsetWidth;
  final double waveHeight;
  final Paint foregroundWavePaint;
  final Paint backgroundWavePaint;
  final Paint loadingCirclePaint;
  final Color foregroundWaveColor;
  final Color backgroundWaveColor;
  final Color loadingWheelColor;
  final double foregroundWaveVerticalOffset;
  final double backgroundWaveVerticalOffset;
  final double period;

  @override
  void paint(Canvas canvas, Size size) {
    final double loadingBubbleRadius = (bubbleDiameter / 2);
    final double insetBubbleRadius = loadingBubbleRadius - waveInsetWidth;
    final double waveBubbleRadius = insetBubbleRadius - loadingCircleWidth;

    Path backgroundWavePath = WavePathHorizontal(
      amplitude: waveHeight,
      period: 1.0,
      startPoint: Offset(0.0 - waveBubbleRadius, 0.0 + backgroundWaveVerticalOffset),
      width: bubbleDiameter,
      crossAxisEndPoint: waveBubbleRadius,
      doClosePath: true,
      phaseShift: period * 2 * 5,
    ).build();

    Path foregroundWavePath = WavePathHorizontal(
      amplitude: waveHeight,
      period: 1.0,
      startPoint: Offset(0.0 - waveBubbleRadius, 0.0 + foregroundWaveVerticalOffset),
      width: bubbleDiameter,
      crossAxisEndPoint: waveBubbleRadius,
      doClosePath: true,
      phaseShift: -period * 2 * 5,
    ).build();

    Path circleClip = Path()..addRRect(RRect.fromLTRBXY(-waveBubbleRadius, -waveBubbleRadius, waveBubbleRadius, waveBubbleRadius, waveBubbleRadius, waveBubbleRadius));

    //Path insetCirclePath = Path()..addRRect(RRect.fromLTRBXY(-insetBubbleRadius, -insetBubbleRadius, insetBubbleRadius, insetBubbleRadius, insetBubbleRadius, insetBubbleRadius));
    //Path loadingCirclePath = Path()..addRRect(RRect.fromLTRBXY(-loadingBubbleRadius, -loadingBubbleRadius, loadingBubbleRadius, loadingBubbleRadius, loadingBubbleRadius, loadingBubbleRadius));

    // canvas.drawPath(Path.combine(PathOperation.difference, loadingCirclePath, insetCirclePath), loadingCirclePaint);
    canvas.clipPath(circleClip, doAntiAlias: true);
    canvas.drawPath(backgroundWavePath, backgroundWavePaint);
    canvas.drawPath(foregroundWavePath, foregroundWavePaint);
  }

  @override
  bool shouldRepaint(WaveLoadingBubblePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(WaveLoadingBubblePainter oldDelegate) => false;
}

class WavePathHorizontal {
  WavePathHorizontal({
    @required this.width,
    @required this.amplitude,
    @required this.period,
    @required this.startPoint,
    this.phaseShift = 0.0,
    this.doClosePath = false,
    this.crossAxisEndPoint = 0,
  }) : assert(crossAxisEndPoint != null || doClosePath == false, "if doClosePath is true you must provide an end point (crossAxisEndPoint)");

  final double width;
  final double amplitude;
  final double period;
  final Offset startPoint;
  final double crossAxisEndPoint; //*
  final double phaseShift; //* shift the starting value of the wave, in radians, repeats every 2 radians
  final bool doClosePath;

  Path build() {
    double startPointX = startPoint.dx;
    double startPointY = startPoint.dy;
    Path returnPath = new Path();
    returnPath.moveTo(startPointX, startPointY);

    for (double i = 0; i <= width; i++) {
      returnPath.lineTo(
        i + startPointX,
        startPointY + amplitude * math.sin((i * 2 * period * math.pi / width) + phaseShift * math.pi),
      );
    }
    if (doClosePath == true) {
      returnPath.lineTo(startPointX + width, crossAxisEndPoint);
      returnPath.lineTo(startPointX, crossAxisEndPoint);
      returnPath.close();
    }
    return returnPath;
  }
}
