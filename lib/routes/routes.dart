import 'package:flutter/material.dart';

import 'package:wiximo_aplication/src/screens/home_screen.dart';
import 'package:wiximo_aplication/src/screens/identity_screens.dart';
import 'package:wiximo_aplication/src/screens/login_screen.dart';
import 'package:wiximo_aplication/src/screens/update_client_screen.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    'login': (context) => LoginScreen(),
    'home': (context) => HomeScreen(),
    'identity' : (context) => IdentityScreen(),
    'validateClient' : (context) => ValidateClientIdentity(),
  };
}
