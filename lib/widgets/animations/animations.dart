import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simple_animations/simple_animations.dart';

// enum Anims { anim1, anim2, anim3, anim4 }
//
// class AnimWidget extends StatefulWidget {
//   final Anims anim;
//   final Widget? child;
//   final int duration;
//   final int delayForward;
//   final int delayReverse;
//   final bool isReverse;
//
//   AnimWidget({
//     this.child,
//     this.delayForward = 0,
//     this.delayReverse = 0,
//     this.anim = Anims.anim1,
//     this.duration = 700,
//     this.isReverse = false,
//   }) {
//     print('$runtimeType constraint');
//   }
//
//   @override
//   _AnimWidgetState createState() => _AnimWidgetState();
// }
//
// class _AnimWidgetState extends State<AnimWidget> with TickerProviderStateMixin {
//   Animation<Offset>? animation;
//   AnimationController? animationController;
//   // Animation<double>? curve;
//
//   @override
//   void initState() {
//     super.initState();
//     print(' $runtimeType initState');
//
//     animationController = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration));
//     Tween<Offset> tween;
//     CurvedAnimation curvedAnim;
//     switch (widget.anim) {
//       case Anims.anim1:
//         tween = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 1.2));
//         curvedAnim = CurvedAnimation(
//           parent: animationController,
//           curve: Curves.easeInOutBack,
//           reverseCurve: Curves.easeInOutBack,
//         );
//         break;
//       case Anims.anim2:
//         tween = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(-0.1, 0.0));
//         curvedAnim = CurvedAnimation(
//           parent: animationController,
//           curve: Curves.fastOutSlowIn,
//           reverseCurve: Curves.fastOutSlowIn,
//         );
//         break;
//
//       case Anims.anim3:
//       case Anims.anim4:
//         tween = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0));
//         curvedAnim = CurvedAnimation(
//           parent: animationController,
//           curve: Curves.fastOutSlowIn,
//           reverseCurve: Curves.fastOutSlowIn,
//         );
//         break;
//     }
//
//     animation = tween.animate(curvedAnim)
//       ..addListener(() {
//         if (animationController.status == AnimationStatus.completed) {
//           if (widget.isReverse) Future.delayed(Duration(milliseconds: widget.delayReverse)).then((_) => animationController.reverse());
//         }
//       });
//
//     Future.delayed(Duration(milliseconds: widget.delayForward)).then((_) {
//       animationController?.forward();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SlideTransition(position: animation, child: widget.child);
//   }
//
//   @override
//   void dispose() {
//     // print(' $runtimeType dispose');
//     animationController.dispose();
//     super.dispose();
//   }
// }
//
// class FadeIn extends StatelessWidget {
//   FadeIn({@required this.delay, @required this.child, this.begin, this.end});
//
//   Widget child;
//   int delay;
//   double begin;
//   double end;
//
//   @override
//   Widget build(BuildContext context) {
//     final tween = MultiTrackTween([
//       Track("opacity").add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
//       Track("translateX").add(Duration(milliseconds: 500), Tween(begin: begin ?? 0.0, end: end ?? 40.0), curve: Curves.easeOut),
//       Track("translateY").add(Duration(milliseconds: 500), Tween(begin: end ?? 40.0, end: begin ?? 0.0), curve: Curves.easeOut)
//     ]);
//
//     return ControlledAnimation(
//       delay: Duration(milliseconds: (100 * delay).round()),
//       duration: tween.duration,
//       tween: tween,
//       child: child,
//       builderWithChild: (context, child, animation) => Opacity(
//         opacity: animation["opacity"],
//         child: Transform.translate(offset: Offset(animation["translateX"], animation["translateY"]), child: child),
//       ),
//     );
//   }
// }
//
// /// Move in
// class MoveIn extends StatelessWidget {
//   MoveIn({this.delay = 1, this.child});
//
//   @required
//   Widget child;
//   @required
//   int delay;
//
//   @override
//   Widget build(BuildContext context) {
//     final tween = MultiTrackTween([
//       Track("opacity").add(Duration(milliseconds: 1000), Tween(begin: 0.0, end: 1.0)),
//       Track("translateX").add(Duration(milliseconds: 500), Tween(begin: 50.0, end: 0.0), curve: Curves.easeOut)
//     ]);
//
//     return ControlledAnimation(
//       delay: Duration(milliseconds: (100 * delay).round()),
//       duration: tween.duration,
//       tween: tween,
//       child: child,
//       builderWithChild: (context, child, animation) => Opacity(
//         opacity: animation["opacity"],
//         child: Transform.translate(offset: Offset(animation["translateX"], 0), child: child),
//       ),
//     );
//   }
// }
//
// /// Delay
// class FadeInSlow extends StatelessWidget {
//   FadeInSlow({this.delay = 1, this.child});
//
//   @required
//   Widget child;
//   @required
//   int delay;
//
//   @override
//   Widget build(BuildContext context) {
//     final tween = MultiTrackTween([
//       Track("opacity").add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
//       Track("translateX").add(Duration(milliseconds: 1000), Tween(begin: 0.0, end: 0.0), curve: Curves.easeOut)
//     ]);
//
//     return ControlledAnimation(
//       delay: Duration(milliseconds: (100 * delay).round()),
//       duration: tween.duration,
//       tween: tween,
//       child: child,
//       builderWithChild: (context, child, animation) => Opacity(
//         opacity: animation["opacity"],
//         child: Transform.translate(offset: Offset(animation["translateX"], 0), child: child),
//       ),
//     );
//   }
// }
//
// class FadeInSplash extends StatelessWidget {
//   @required
//   Widget child;
//   @required
//   int delay;
//   double begin;
//   double end;
//
//   FadeInSplash({this.delay, this.child, this.begin, this.end});
//
//   @override
//   Widget build(BuildContext context) {
//     final tween = MultiTrackTween([
//       Track("opacity").add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
//       Track("translateX").add(Duration(milliseconds: 700), Tween(begin: begin ?? 0.0, end: end ?? 40.0), curve: Curves.easeOut),
//       Track("translateY").add(
//           Duration(milliseconds: 500),
// //          Tween(begin: end ?? 0.0, end: begin ?? 0.0),
//           Tween(begin: 0.0, end: 0.0),
//           curve: Curves.easeOut)
//     ]);
//
//     return ControlledAnimation(
//       delay: Duration(milliseconds: (100 * delay).round()),
//       duration: tween.duration,
//       tween: tween,
//       child: child,
//       builderWithChild: (context, child, animation) => Opacity(
//         opacity: animation["opacity"],
//         child: Transform.translate(offset: Offset(animation["translateX"], animation["translateY"]), child: child),
//       ),
//     );
//   }
// }
//
// class FadeInSplash2 extends StatelessWidget {
//   @required
//   Widget child;
//   @required
//   int delay;
//   double begin;
//   double end;
//
//   FadeInSplash2({this.delay, this.child, this.begin, this.end});
//
//   @override
//   Widget build(BuildContext context) {
//     final tween = MultiTrackTween([
//       Track("opacity").add(Duration(milliseconds: 100), Tween(begin: 0.0, end: 1.0)),
//       Track("translateX").add(Duration(milliseconds: 1000), Tween(begin: 0.0, end: 0.0), curve: Curves.easeOut),
//       Track("translateY").add(Duration(milliseconds: 500), Tween(begin: end ?? 0.0, end: begin ?? 0.0), curve: Curves.easeOut)
//     ]);
//
//     return ControlledAnimation(
//       delay: Duration(milliseconds: (100 * delay).round()),
//       duration: tween.duration,
//       tween: tween,
//       child: child,
//       builderWithChild: (context, child, animation) => Opacity(
//         opacity: animation["opacity"],
//         child: Transform.translate(offset: Offset(animation["translateX"], animation["translateY"]), child: child),
//       ),
//     );
//   }
// }
//
// enum ShimmerDirection { ltr, rtl, ttb, btt }
//
// class Shimmer extends StatefulWidget {
//   final Widget child;
//   final Duration period;
//   final ShimmerDirection direction;
//   final Gradient gradient;
//   final int loop;
//   final bool enabled;
//
//   Shimmer({
//     Key key,
//     @required this.child,
//     @required this.gradient,
//     this.direction = ShimmerDirection.ltr,
//     this.period = const Duration(milliseconds: 1500),
//     this.loop = 0,
//     this.enabled = true,
//   }) : super(key: key);
//
//   ///
//   /// A convenient constructor provides an easy and convenient way to create a
//   /// [Shimmer] which [gradient] is [LinearGradient] made up of `baseColor` and
//   /// `highlightColor`.
//   ///
//   Shimmer.fromColors({
//     Key key,
//     @required this.child,
//     @required Color highlightColor,
//     Color baseColor = Colors.transparent,
//     this.period = const Duration(milliseconds: 1500),
//     this.direction = ShimmerDirection.ltr,
//     this.loop = 0,
//     this.enabled = true,
//   })  : gradient = LinearGradient(begin: Alignment.topLeft, end: Alignment.centerRight, colors: [
//     highlightColor.withOpacity(0),
//     highlightColor.withOpacity(0),
//     highlightColor.withOpacity(0.8),
//     highlightColor.withOpacity(0),
//     highlightColor.withOpacity(0),
//   ], stops: [
//     0.0,
//     0.35,
//     0.5,
//     0.65,
//     1.0
//   ]),
//         super(key: key);
//
//   @override
//   _ShimmerState createState() => _ShimmerState();
//
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(new DiagnosticsProperty<Gradient>('gradient', gradient, defaultValue: null));
//     properties.add(new EnumProperty<ShimmerDirection>('direction', direction));
//     properties.add(new DiagnosticsProperty<Duration>('period', period, defaultValue: null));
//     properties.add(new DiagnosticsProperty<bool>('enabled', enabled, defaultValue: null));
//   }
// }
//
// class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
//   AnimationController _controller;
//   int _count;
//
//   @override
//   void initState() {
//     super.initState();
//     _count = 0;
//     _controller = AnimationController(vsync: this, duration: widget.period)
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           _count++;
//           if (widget.loop <= 0) {
//             _controller.repeat();
//           } else if (_count < widget.loop) {
//             _controller.forward(from: 0.0);
//           }
//         }
//       });
//     if (widget.enabled) _controller.forward();
//   }
//
//   @override
//   void didUpdateWidget(Shimmer oldWidget) {
//     if (widget.enabled) {
//       _controller.forward();
//     } else {
//       _controller.stop();
//     }
//     super.didUpdateWidget(oldWidget);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       child: widget.child,
//       builder: (context, child) => _Shimmer(
//         child: child,
//         direction: widget.direction,
//         gradient: widget.gradient,
//         percent: _controller.value,
//         enabled: widget.enabled,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
//
// class _Shimmer extends SingleChildRenderObjectWidget {
//   final double percent;
//   final ShimmerDirection direction;
//   final Gradient gradient;
//   final bool enabled;
//
//   _Shimmer({
//     Widget child,
//     this.percent,
//     this.direction,
//     this.gradient,
//     this.enabled,
//   }) : super(child: child);
//
//   @override
//   _ShimmerFilter createRenderObject(BuildContext context) {
//     return _ShimmerFilter(percent, direction, gradient, enabled);
//   }
//
//   @override
//   void updateRenderObject(BuildContext context, _ShimmerFilter shimmer) {
//     shimmer.percent = percent;
//     shimmer.enabled = enabled;
//   }
// }
//
// class _ShimmerFilter extends RenderProxyBox {
//   final _clearPaint = Paint();
//   final Paint _gradientPaint;
//   final Gradient _gradient;
//   final ShimmerDirection _direction;
//   bool enabled;
//   double _percent;
//   Rect _rect;
//
//   _ShimmerFilter(this._percent, this._direction, this._gradient, this.enabled) : _gradientPaint = Paint()..blendMode = BlendMode.srcIn;
//
//   @override
//   bool get alwaysNeedsCompositing => child != null;
//
//   set percent(double newValue) {
//     if (newValue != _percent) {
//       _percent = newValue;
//       markNeedsPaint();
//     }
//   }
//
//   @override
//   void paint(PaintingContext context, Offset offset) {
//     if (child != null) {
//       assert(needsCompositing);
//
//       context.canvas.saveLayer(offset & child.size, _clearPaint);
//       context.paintChild(child, offset);
//
//       final width = child.size.width;
//       final height = child.size.height;
//       Rect rect;
//       double dx, dy;
//       if (_direction == ShimmerDirection.rtl) {
//         dx = _offset(width, -width, _percent);
//         dy = 0.0;
//         rect = Rect.fromLTWH(offset.dx - width, offset.dy, 3 * width, height);
//       } else if (_direction == ShimmerDirection.ttb) {
//         dx = 0.0;
//         dy = _offset(-height, height, _percent);
//         rect = Rect.fromLTWH(offset.dx, offset.dy - height, width, 3 * height);
//       } else if (_direction == ShimmerDirection.btt) {
//         dx = 0.0;
//         dy = _offset(height, -height, _percent);
//         rect = Rect.fromLTWH(offset.dx, offset.dy - height, width, 3 * height);
//       } else {
//         dx = _offset(-width, width, _percent);
//         dy = 0.0;
//         rect = Rect.fromLTWH(offset.dx - width, offset.dy, 3 * width, height);
//       }
//       if (_rect != rect) {
//         _gradientPaint.shader = _gradient.createShader(rect);
//         _rect = rect;
//       }
//       context.canvas.translate(dx, dy);
//       context.canvas.drawRect(rect, _gradientPaint);
//       context.canvas.restore();
//     }
//   }
//
//   double _offset(double start, double end, double percent) {
//     return start + (end - start) * percent;
//   }
// }
