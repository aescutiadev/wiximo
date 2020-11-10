import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:wiximo_aplication/src/services/auth_service.dart';
import 'package:wiximo_aplication/src/utils/custom_color_scheme.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 2, child: _imageLogo(context)),
              Spacer(),
              Flexible(child: _textSignIn(context)),
              Divider(color: Colors.transparent),
              Flexible(child: _buttonlogin(context)),
              Spacer(flex: 2),
              Expanded(child: _infoVersion(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageLogo(BuildContext context) {
    return Align(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/logo.png')
          )
        ),
      ),
    );
  }

  Widget _textSignIn(BuildContext context) {
    return Text(
      'Iniciar Sesión',
      style: TextStyle(fontSize: 16.0, color: ColorsCustom().primary),
    );
  }

  Widget _buttonlogin(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: 50.0,
      child: SignInButton(
        Buttons.Google,
        padding: EdgeInsets.zero,
        text: 'Continuar con Google',
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onPressed: () => login().then(
          (value) {
            switch (value) {
              case 'Success':
                return Navigator.of(context).pushReplacementNamed('home');
              case 'Error':
                logout();
                return _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text('Ocurrió un error'),
                  ),
                );
              default:
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(value),
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  Widget _infoVersion(BuildContext context) {
    return Align(
      alignment: Alignment(0, 0.9),
      child: Text(
        'Versión 0.1.1',
        style: TextStyle(color: ColorsCustom().primary),
      ),
    );
  }
}
