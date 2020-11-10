import 'package:flutter/material.dart';

class ImageCapture extends StatefulWidget {
  ImageCapture({Key key}) : super(key: key);

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capturar imagen'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            _ponerINE(context),
            Text(
              'FRENTE DE CREDENCIAL',
              style: TextStyle(color: Colors.white),
            ),
            Text('Cuida que la fotográfia abarque todo el espacio')
          ],
        ),
      ),
    );
  }

  Widget _ponerINE(BuildContext context) {
    return Container();
  }
}
