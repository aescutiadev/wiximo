import 'package:flutter/material.dart';

class IdentityScreenWidgets {
  
  Widget infoText(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30.0),
      child: Text(
        'Ingresa los datos de identidad que se requieren para el usuario',
        overflow: TextOverflow.clip,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget titleText(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
