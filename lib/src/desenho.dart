import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: ClipPath(
              clipper: DrawOne(),
              child: CustomPaint(
                painter: DrawnOnePaint(),
                child: Container(
                  height: 350,
                  width: 320,
                  child:LayoutBuilder(
                    builder: (context,constraints) {
                      return Center(
                        child: Container(
                          width: constraints.maxWidth * .8,
                          height: constraints.maxHeight * .5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(360),
                            color: const Color(0xFFFBC9B1)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(backgroundColor: Colors.black,
                                  radius: constraints.maxWidth * .04,),
                                  CircleAvatar(backgroundColor: Colors.black,
                                  radius: constraints.maxWidth * .04,)
                                ],
                              ),

                              Container(
                                width: constraints.maxWidth * .3,
                                height: constraints.maxHeight * .02,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(360),
                                  color: Colors.black
                                ),

                              )
                            ],
                          ),
              
                        ),
                      );
                    }
                  ),
                ),
              ),
            ),
          )
      ]),
    
    );
  }
}

class DrawOne extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // vertice bottom
    final verticeB = size.height * 0.83;
    // vertice top
    final verticeT = size.height * 0.08;
    // radius circle
    final radius = size.width * 0.22;
    final radiusLarge = radius *.3;
    final spaceBetweenEar= size.width - (radius * 2);
    path.moveTo(0, 0);
    path.lineTo(0, verticeB);
    path.cubicTo(
      size.width * .2, size.height,
       size.width * .8, size.height,
        size.width,verticeB);
    path.lineTo(size.width, verticeB);
    path.lineTo(size.width, verticeT);
    // circle
    path.cubicTo(
      size.width - (radius*.20) ,0, // control point 1
      size.width - (radius*.80) ,0, // control point 2
      size.width - radius, verticeT, // end point
    );
    path.lineTo(size.width - radius, verticeT + radiusLarge);
     path.cubicTo(
      radius + (spaceBetweenEar * .8), verticeT ,
       radius +(spaceBetweenEar * .2), verticeT , 
      radius, verticeT + radiusLarge);

    path.lineTo(radius, verticeT);
     path.cubicTo(
      radius * .8,0,// control point 1
      radius * .2,0,// control point 2
      0, verticeT, // end point
    );
    path.lineTo(0, verticeT);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class DrawnOnePaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth =10
      ..style = PaintingStyle.stroke;
   Path path = Path();
    // vertice bottom
    final verticeB = size.height * 0.83;
    // vertice top
    final verticeT = size.height * 0.08;
    // radius circle
    final radius = size.width * 0.22;
    final radiusLarge = radius *.3;
    final spaceBetweenEar= size.width - (radius * 2);
    path.moveTo(0, 0);
    path.lineTo(0, verticeB);
    path.cubicTo(
      size.width * .2, size.height,
       size.width * .8, size.height,
        size.width,verticeB);
    path.lineTo(size.width, verticeB);
    path.lineTo(size.width, verticeT);
    // circle
    path.cubicTo(
      size.width - (radius*.20) ,0, // control point 1
      size.width - (radius*.80) ,0, // control point 2
      size.width - radius, verticeT, // end point
    );
    path.lineTo(size.width - radius, verticeT + radiusLarge);
     path.cubicTo(
      radius + (spaceBetweenEar * .8), verticeT ,
       radius +(spaceBetweenEar * .2), verticeT , 
      radius, verticeT + radiusLarge);

    path.lineTo(radius, verticeT);
     path.cubicTo(
      radius * .8,0,// control point 1
      radius * .2,0,// control point 2
      0, verticeT, // end point
    );
    path.lineTo(0, verticeT);
    path.lineTo(0, 0);


    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}