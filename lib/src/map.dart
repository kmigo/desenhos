import 'package:flutter/material.dart';

class AdvancedOcclusionCulling extends StatefulWidget {
  @override
  _AdvancedOcclusionCullingState createState() =>
      _AdvancedOcclusionCullingState();
}

class _AdvancedOcclusionCullingState extends State<AdvancedOcclusionCulling> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Advanced Occlusion Culling')),
      body: GridView.builder(
        controller: _controller,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
        ),
        itemBuilder: (context, index) {
          print('Render item $index'); // Apenas para fins de demonstração
          return Container(
            margin: EdgeInsets.all(4),
            color: Colors.amber,
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(fontSize: 24),
              ),
            ),
          );
        },
        itemCount: 500, // Apenas um número arbitrário para demonstração
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}