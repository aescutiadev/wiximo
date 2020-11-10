import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wiximo_aplication/routes/routes.dart';
import 'package:wiximo_aplication/src/utils/custom_color_scheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wiximo',
      routes: getApplicationRoutes(),
      theme: _themeDataligth(),
      // darkTheme: _themeDataDark(),
      initialRoute: _user == null ? 'login' : 'home',
    );
  }

  ThemeData _themeDataligth() {
    return ThemeData.light().copyWith(
      appBarTheme: AppBarTheme(
        color: ColorsCustom().primary,
        centerTitle: true,
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  ThemeData _themeDataDark() {
    return ThemeData.dark();
  }
}
