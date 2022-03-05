import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class DrawPage extends StatefulWidget {
  const DrawPage({Key? key}) : super(key: key);

  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage>
    with SingleTickerProviderStateMixin {
  List<DrawingArea> points = [];
  Color? selectedColor;
  double? strokeWidth;
  AnimationController? animationController;
  Animation? degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;
  Animation? rotationAnimation;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedColor = Colors.black;
    strokeWidth = 2.0;
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController!);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController!);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController!);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController!, curve: Curves.easeOut));
    super.initState();
    animationController!.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    void selectColor() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: selectedColor!,
                  onColorChanged: (color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close"))
              ],
            );
          });
    }

    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color.fromRGBO(138, 35, 135, 1.0),
                    Color.fromRGBO(233, 64, 87, 1.0),
                    Color.fromRGBO(242, 113, 33, 1.0),
                  ])),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: width * 0.80,
                      height: height * 0.80,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                            )
                          ]),
                      child: GestureDetector(
                        onPanDown: (details) {
                          setState(() {
                            points.add(
                              DrawingArea(
                                isLast: true,
                                point: details.localPosition,
                                areaPaint: Paint()
                                  ..strokeCap = StrokeCap.round
                                  ..isAntiAlias = true
                                  ..color = selectedColor!
                                  ..strokeWidth = strokeWidth!,
                              ),
                            );
                          });
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            points.add(
                              DrawingArea(
                                isLast: true,
                                point: details.localPosition,
                                areaPaint: Paint()
                                  ..strokeCap = StrokeCap.round
                                  ..isAntiAlias = true
                                  ..color = selectedColor!
                                  ..strokeWidth = strokeWidth!,
                              ),
                            );
                          });
                        },
                        onPanEnd: (details) {
                          setState(() {
                            points.add(
                              DrawingArea(
                                isLast: false,
                                point: Offset.zero,
                                areaPaint: Paint()
                                  ..strokeCap = StrokeCap.round
                                  ..isAntiAlias = true
                                  ..color = selectedColor!
                                  ..strokeWidth = strokeWidth!,
                              ),
                            );
                          });
                        },
                        child: SizedBox.expand(
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            child: CustomPaint(
                              painter: MyCustomPainter(points: points),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   width: width * 0.80,
                  //   decoration: const BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  //   child: Row(
                  //     children: <Widget>[
                  //       IconButton(
                  //           icon: Icon(
                  //             Icons.color_lens,
                  //             color: selectedColor,
                  //           ),
                  //           onPressed: () {
                  //             selectColor();
                  //           }),
                  //       Expanded(
                  //         child: Slider(
                  //           min: 1.0,
                  //           max: 5.0,
                  //           label: "Stroke $strokeWidth",
                  //           activeColor: selectedColor,
                  //           value: strokeWidth!,
                  //           onChanged: (double value) {
                  //             setState(() {
                  //               strokeWidth = value;
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //       IconButton(
                  //           icon: const Icon(
                  //             Icons.layers_clear,
                  //             color: Colors.black,
                  //           ),
                  //           onPressed: () {
                  //             setState(() {
                  //               points.clear();
                  //             });
                  //           }),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
            Positioned(
              right: 30,
              bottom: 30,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  IgnorePointer(
                    child: Container(
                      color: Colors.transparent,
                      height: 150.0,
                      width: 150.0,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(270),
                        degOneTranslationAnimation!.value * 100),
                    child: Transform(
                      transform: Matrix4.rotationZ(
                          getRadiansFromDegree(rotationAnimation!.value))
                        ..scale(degOneTranslationAnimation!.value),
                      alignment: Alignment.center,
                      child: CircularButton(
                        color: selectedColor!,
                        width: 50,
                        height: 50,
                        icon: const Icon(
                          Icons.color_lens,
                          color: Colors.white,
                        ),
                        onClick: () {
                          selectColor();
                        },
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(225),
                        degTwoTranslationAnimation!.value * 100),
                    child: Transform(
                      transform: Matrix4.rotationZ(
                          getRadiansFromDegree(rotationAnimation!.value))
                        ..scale(degTwoTranslationAnimation!.value),
                      alignment: Alignment.center,
                      child: CircularButton(
                        color: Colors.orange,
                        width: 50,
                        height: 50,
                        icon: const Icon(
                          Icons.layers_clear,
                          color: Colors.black,
                        ),
                        onClick: () {
                          points.clear();
                        },
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(180),
                        degThreeTranslationAnimation!.value * 100),
                    child: Transform(
                      transform: Matrix4.rotationZ(
                          getRadiansFromDegree(rotationAnimation!.value))
                        ..scale(degThreeTranslationAnimation!.value),
                      alignment: Alignment.center,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: Colors.white,
                        ),
                        width: width * 0.4,
                        child: Slider(
                          min: 1.0,
                          max: 5.0,
                          label: "Stroke $strokeWidth",
                          activeColor: selectedColor,
                          value: strokeWidth!,
                          onChanged: (double value) {
                            setState(() {
                              strokeWidth = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Transform(
                    transform: Matrix4.rotationZ(
                        getRadiansFromDegree(rotationAnimation!.value)),
                    alignment: Alignment.center,
                    child: CircularButton(
                      color: Colors.red,
                      width: 60,
                      height: 60,
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      onClick: () {
                        if (animationController!.isCompleted) {
                          animationController!.reverse();
                        } else {
                          animationController!.forward();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawingArea {
  bool isLast;
  Offset point;
  Paint areaPaint;

  DrawingArea(
      {required this.point, required this.areaPaint, required this.isLast});
}

class MyCustomPainter extends CustomPainter {
  List<DrawingArea> points;

  MyCustomPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    canvas.clipRect(rect);

    for (int x = 0; x < points.length - 1; x++) {
      if (points[x].isLast && points[x + 1].isLast) {
        canvas.drawLine(
            points[x].point, points[x + 1].point, points[x].areaPaint);
      } else if (points[x].isLast && points[x + 1].isLast == false) {
        canvas.drawPoints(
            PointMode.points, [points[x].point], points[x].areaPaint);
      }
    }
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return oldDelegate.points == points;
  }
}

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final Function() onClick;
  const CircularButton({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
    required this.icon,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
            color: Colors.grey,
            spreadRadius: 2.0,
          ),
        ],
        color: color,
        shape: BoxShape.circle,
      ),
      width: width,
      height: height,
      child: IconButton(icon: icon, enableFeedback: true, onPressed: onClick),
    );
  }
}
