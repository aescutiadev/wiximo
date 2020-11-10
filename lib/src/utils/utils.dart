import 'package:flutter/material.dart';

class WidgetsUtils {
  Widget loading({@required bool isStream}) {
    return isStream
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget noConnected({@required bool isStream}) {
    return isStream
        ? Scaffold(
            body: Text('Revise su conexión internet'),
          )
        : Text('Revise su conexión internet');
  }

  Widget error({@required bool isStream, dynamic error}) {
    print(error);
    return isStream
        ? Scaffold(
            body: Text('Ocurrió un error'),
          )
        : Text('Ocurrió un error');
  }
}
