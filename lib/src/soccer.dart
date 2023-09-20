import 'dart:math';

import 'package:flutter/material.dart';

class SoccerDrawn extends StatefulWidget {
  const SoccerDrawn({super.key});

  @override
  State<SoccerDrawn> createState() => _SoccerDrawnState();
}

class _SoccerDrawnState extends State<SoccerDrawn>  with SingleTickerProviderStateMixin  {
  Widget? animation;
  @override
  void initState() {
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    Future.delayed(const Duration(seconds: 1), () {

    });
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Stack(
            children: [
              Positioned(child: Container(
                color: Colors.green,
                width: size.width,
                height: size.width * .5,
                child: LayoutBuilder(
                  builder: (context,constraints) {
                    return Stack(
                      children: [
                        CustomPaint(
                          painter: CustomPaintOne(
                          ),
                          child: Container(
                          ),
                        ),
                        if(animation != null)...[
                         animation!
                        ],
                        
                      ],
                    );
                  }
                ),
              ))
            ],
          ),
          Expanded(child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton(onPressed: (){
                setState(() {
                  animation = PlayerToPlayerAnimation(endOffset:const  Offset(200, 100), 
                        startOffset:const  Offset(250,80), size: Size(size.width,size.width * .5));
                });
              }, child: const Text('Player to Player')),
              ElevatedButton(onPressed: (){
                setState(() {
                  // mudar angulo para 90
                  animation = SizedBox(
                    width: size.width,
                    height: size.width * .5,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 100,
                          top: 0,
                          child: Transform(
                            transform: Matrix4.identity()..rotateZ(315 * pi / 180),
                            child: const RadarAnimation(size: Size(90,90),angle: 90,)),
                        ),
                      ],
                    ),
                  );
                });
              }, child: const Text('Radar')),

            ],
          ))
        ],
      ),
    );
  }
  @override
  void dispose() {

    super.dispose();
  }

}


class CustomPaintOne extends CustomPainter {

  CustomPaintOne();
  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..color = Colors.white.withOpacity(.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
      final quadratic = size.width * .03;
      final quadraticAreaLarge = size.height * .5;
      final quadraticAreaSmall = quadraticAreaLarge * .5;
    // vertice superior esquerdo
    final vTopLeft = Path()
      ..moveTo(quadratic, 0)
      ..quadraticBezierTo(
        quadratic * .9, quadratic *.9, //control point
         0, quadratic);
    canvas.drawPath(vTopLeft, paint);
    // vertice superior direito
    final vTopRight = Path()
      ..moveTo(size.width - quadratic, 0)
      ..quadraticBezierTo(
        size.width - (quadratic * .9), quadratic *.9, //control point
         size.width, quadratic);
    canvas.drawPath(vTopRight, paint);
    // vertice inferior esquerdo
    final vBottomLeft = Path()
      ..moveTo(quadratic, size.height)
      ..quadraticBezierTo(
        quadratic * .9, size.height - (quadratic *.9), //control point
         0, size.height - quadratic);
    canvas.drawPath(vBottomLeft, paint);
    // vertice inferior direito
    final vBottomRight = Path()
      ..moveTo(size.width - quadratic, size.height)
      ..quadraticBezierTo(
        size.width - (quadratic * .9), size.height - (quadratic *.9), //control point
         size.width, size.height - quadratic);
    canvas.drawPath(vBottomRight, paint);
    // center
    final centerLine = Path()
      ..moveTo(size.width * .5, 0)
      ..lineTo(size.width * .5, size.height)
      ;
    canvas.drawPath(centerLine, paint);
    // center circle
    final centerCircle = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width * .5, size.height * .5),
        radius: size.width * .08,
      ));
    canvas.drawPath(centerCircle, paint);
    // circle in center circle fill
    final circleInCenterCircle = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width * .5, size.height * .5),
        radius: size.width * .02,
      ));
    canvas.drawPath(circleInCenterCircle, paint..style = PaintingStyle.fill);
    // area large left
    final areaLargeLeft = Path()
      ..moveTo(0, (size.height -quadraticAreaLarge)/2   )
      ..lineTo(quadraticAreaLarge * .5, (size.height -quadraticAreaLarge)/2 )
      ..lineTo(quadraticAreaLarge* .5, (size.height -quadraticAreaLarge)/2 +quadraticAreaLarge )
      ..lineTo(0,  (size.height -quadraticAreaLarge)/2 +quadraticAreaLarge)
      ;
    canvas.drawPath(areaLargeLeft, paint..style = PaintingStyle.stroke);
    // area small in area large left
    
    final areaSmallLeft = Path()
  ..moveTo(0, (size.height -quadraticAreaSmall)/2   )
      ..lineTo(quadraticAreaSmall * .5, (size.height -quadraticAreaSmall)/2 )
      ..lineTo(quadraticAreaSmall* .5, (size.height -quadraticAreaSmall)/2 +quadraticAreaSmall )
      ..lineTo(0,  (size.height -quadraticAreaSmall)/2 +quadraticAreaSmall);
    canvas.drawPath(areaSmallLeft, paint..style = PaintingStyle.stroke);


    // area large rigth
    final areaLargeRight = Path()
      ..moveTo(size.width, (size.height -quadraticAreaLarge)/2)
      ..lineTo(size.width  - quadraticAreaLarge * .5, (size.height -quadraticAreaLarge)/2)
      ..lineTo(size.width - quadraticAreaLarge * .5, (size.height -quadraticAreaLarge)/2 + quadraticAreaLarge  )
      ..lineTo(size.width ,  (size.height -quadraticAreaLarge)/2 +quadraticAreaLarge)
      ;
    canvas.drawPath(areaLargeRight, paint..style = PaintingStyle.stroke);

    // area small in area large right
    final areaSmallRight = Path()
      ..moveTo(size.width, (size.height -quadraticAreaSmall)/2)
      ..lineTo(size.width  - quadraticAreaSmall * .5, (size.height -quadraticAreaSmall)/2)
      ..lineTo(size.width - quadraticAreaSmall * .5, (size.height -quadraticAreaSmall)/2 + quadraticAreaSmall  )
      ..lineTo(size.width ,  (size.height -quadraticAreaSmall)/2 +quadraticAreaSmall)
      ;
    canvas.drawPath(areaSmallRight, paint..style = PaintingStyle.stroke);

    // area circle left
    final areaCircleLeft = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(quadraticAreaLarge * .375, (size.height -quadraticAreaSmall)/2 +(quadraticAreaSmall/2)),
        radius: quadraticAreaLarge * .04,
      ));
    canvas.drawPath(areaCircleLeft, paint..style = PaintingStyle.fill);
    // area circle right
    final areaCircleRight = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width - (quadraticAreaLarge * .375), (size.height -quadraticAreaSmall)/2 +(quadraticAreaSmall/2)),
        radius: quadraticAreaLarge * .04,
      ));
    canvas.drawPath(areaCircleRight, paint..style = PaintingStyle.fill);
    // area semi circle left
    final areaSemiCircleLeft = Path()
      ..moveTo(quadraticAreaSmall,  (size.height -quadraticAreaSmall)/2)
      ..cubicTo(
        quadraticAreaSmall * 1.25, (size.height -quadraticAreaSmall)/2 + quadraticAreaSmall * .25,
        quadraticAreaSmall * 1.25, (size.height -quadraticAreaSmall)/2 + quadraticAreaSmall * .75,
        quadraticAreaSmall, (size.height -quadraticAreaSmall)/2 + quadraticAreaSmall )
      ;
    canvas.drawPath(areaSemiCircleLeft, paint..style = PaintingStyle.stroke);
    // area semi circle right
    final areaSemiCircleRight = Path()
      ..moveTo(size.width - quadraticAreaSmall,  (size.height -quadraticAreaSmall)/2)
      ..cubicTo(
        size.width - (quadraticAreaSmall * 1.25), (size.height -quadraticAreaSmall)/2 + quadraticAreaSmall * .25,
        size.width - (quadraticAreaSmall * 1.25), (size.height -quadraticAreaSmall)/2 + quadraticAreaSmall * .75,
        size.width - quadraticAreaSmall, (size.height -quadraticAreaSmall)/2 + quadraticAreaSmall )
      ;
    canvas.drawPath(areaSemiCircleRight, paint..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}



class PlayerToPlayerAnimation extends StatefulWidget {
  final Size size;
  final Offset startOffset;
  final Offset endOffset;
  const PlayerToPlayerAnimation({super.key,required this.endOffset,required this.startOffset,required this.size});
  @override
  _PlayerToPlayerAnimationState createState() => _PlayerToPlayerAnimationState();
}

class _PlayerToPlayerAnimationState extends State<PlayerToPlayerAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  bool isLeft = true;
  @override
  void initState() {
    super.initState();
    isLeft = widget.startOffset.dx < widget.size.width * .5;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        return Stack(
          children: [
            CustomPaint(
              size: Size(widget.size.width, widget.size.height),
              painter: LinePainter(_controller!.value,widget.startOffset,widget.endOffset),
            ),
            Positioned(
              left: widget.startOffset.dx  - 10,
              top:  widget.startOffset.dy - 28 ,
              child: Text('Player 1',style: TextStyle(color: Colors.white),),
            ),
             if(_controller!.isCompleted)...[
              Positioned(
              left: widget.endOffset.dx  + 10,
              top:  widget.endOffset.dy  ,
              child: Text('Player 2',style: TextStyle(color: Colors.white),),
            )
             ]
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
  
}
class LinePainter extends CustomPainter {
  final double progress;
  final Offset startOffset;
  final Offset endOffset;
  LinePainter(this.progress,this.startOffset,this.endOffset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0;
    paint.style = PaintingStyle.fill;
    final radius = 7.0;
    canvas.drawCircle(startOffset, radius, paint);
    paint.style = PaintingStyle.stroke;
    final currentEndOffset = Offset(
      startOffset.dx + (endOffset.dx - startOffset.dx) * progress,
      startOffset.dy + (endOffset.dy - startOffset.dy) * progress,
    );

    canvas.drawLine(startOffset, currentEndOffset, paint);
    if(currentEndOffset.dx == endOffset.dx && currentEndOffset.dy == endOffset.dy) {
      canvas.drawCircle(endOffset, radius, paint..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class RadarAnimation extends StatefulWidget {
  final Size size;
  final double angle;
  const RadarAnimation({super.key, required this.size,required this.angle});
  @override
  _RadarAnimationState createState() => _RadarAnimationState();
}

class _RadarAnimationState extends State<RadarAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return CustomPaint(
              size: widget.size,
              painter: RadarPainter(progress:_progressAnimation.value,angle:widget.angle),
            );
          },
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class RadarPainter extends CustomPainter {
  final double progress;
  final double angle;

  RadarPainter({required this.progress, required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black38
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    final pointB = Offset(
      center.dx + (size.width / 2) * cos(angle),
      center.dy + (size.width / 2) * sin(angle),
    );

    final pointC = Offset(
      center.dx - (size.width / 2) * cos(angle),
      center.dy + (size.width / 2) * sin(angle),
    );

    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(pointB.dx, pointB.dy)
      ..lineTo(pointC.dx, pointC.dy)
      ..close();

    canvas.drawPath(path, paint..color = Colors.black38.withOpacity(0.2));

    final progressPointB = Offset(
      center.dx + (size.width / 2) * progress * cos(angle),
      center.dy + (size.width / 2) * progress * sin(angle),
    );

    final progressPointC = Offset(
      center.dx - (size.width / 2) * progress * cos(angle),
      center.dy + (size.width / 2) * progress * sin(angle),
    );

    final progressPath = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(progressPointB.dx, progressPointB.dy)
      ..lineTo(progressPointC.dx, progressPointC.dy)
      ..close();

    canvas.drawPath(progressPath, paint..color = Colors.black45);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}