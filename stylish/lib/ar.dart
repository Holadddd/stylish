import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart';

class ARView extends StatefulWidget {
  @override
  _ARView createState() => _ARView();
}

class _ARView extends State<ARView> {
  late ARKitController arkitController;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        title: Container(
          padding: EdgeInsets.all(5),
          height: 50,
          child: Image(image: AssetImage('assets/bar_image.png')),
        ),
      ),
      body: ARKitSceneView(onARKitViewCreated: onARKitViewCreated));

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    final node = ARKitNode(
        geometry: ARKitSphere(radius: 0.1), position: Vector3(0, 0, -0.5));

    // final node1 = ARKitReferenceNode(
    //   url: 'assets/toy.usdz',
    //   scale: Vector3.all(0.1), // Scale it down to fit well in AR space
    //   position: Vector3(0, 0.5, -0.5),
    // );

    this.arkitController.add(node);
    // this.arkitController.add(node1);
  }
}
