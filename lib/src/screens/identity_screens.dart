import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wiximo_aplication/src/services/auth_service.dart';
import 'package:wiximo_aplication/src/utils/custom_color_scheme.dart';
import 'package:wiximo_aplication/src/screens/widgets/identity_widgets.dart';
import 'package:wiximo_aplication/src/screens/image_capture.dart';

class IdentityScreen extends StatefulWidget {
  IdentityScreen({Key key}) : super(key: key);

  @override
  _IdentityScreenState createState() => _IdentityScreenState();
}

class _IdentityScreenState extends State<IdentityScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _identityWidets = IdentityScreenWidgets();

  String _name;
  String _lastNameM;
  String _lastNameP;
  String _phoneNumber;

  @override
  Widget build(BuildContext context) {
    User _user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('VALIDAR MI IDENTIDAD'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getDataUser(_user),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            print(snapshot.error);
            return Center(child: Text('Ocurrió un error'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            children: [
              _identityWidets.infoText(context),
              _identityWidets.titleText(context, 'DATOS PERSONALES'),
              _formUserIndo(context, snapshot.data),
              _identityWidets.titleText(context, 'VALIDACIÓN DE INDENTIDAD'),
              _cardINE(context, snapshot.data),
              _cardVideoCapture(context, snapshot.data),
              _actionButton(context, snapshot.data),
            ],
          );
        },
      ),
    );
  }

  Widget _formUserIndo(BuildContext context, DocumentSnapshot user) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: user.data()['email'],
              enabled: false,
            ),
          ),
          TextFormField(
            initialValue:
                user.data()['name'] != 'null' ? user.data()['name'] : '',
            decoration: InputDecoration(
              labelText: '*Nombre',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Escriba su nombre';
              }
              return null;
            },
            onSaved: (newValue) => setState(() {
              _name = newValue;
            }),
          ),
          TextFormField(
            initialValue: user.data()['last_name_p'] != 'null'
                ? user.data()['last_name_p']
                : '',
            decoration: InputDecoration(
              labelText: '*Apellido Paterno',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Escriba su apellido paterno';
              }
              return null;
            },
            onSaved: (newValue) => setState(() {
              _lastNameP = newValue;
            }),
          ),
          TextFormField(
            initialValue: user.data()['last_name_m'] != 'null'
                ? user.data()['last_name_m']
                : '',
            decoration: InputDecoration(
              labelText: '*Apellido Materno',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Escriba su nombre';
              }
              return null;
            },
            onSaved: (newValue) => setState(() {
              _lastNameM = newValue;
            }),
          ),
          TextFormField(
            initialValue: user.data()['phoneNumber'] != 'null'
                ? user.data()['phoneNumber']
                : '',
            decoration: InputDecoration(
              labelText: '*Teléfono',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Escriba su número de teléfono';
              }
              return null;
            },
            onSaved: (newValue) => setState(() {
              _phoneNumber = newValue;
            }),
          ),
        ],
      ),
    );
  }

  Widget _cardINE(BuildContext context, DocumentSnapshot data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      shadowColor: Colors.grey.withOpacity(0.2),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Identificación oficial (INE / IFE)'),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: data['statusProfile'] != true
                        ? Colors.redAccent
                        : Colors.green,
                  ),
                  child: Text(
                    data['statusProfile'] != true ? "Pendiente" : "Completo",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: FlatButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=> ImageCapture()),
                ),
                padding: EdgeInsets.zero,
                child: Text(
                  'CAPTURAR',
                  style: TextStyle(
                    color: ColorsCustom().primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardVideoCapture(BuildContext context, DocumentSnapshot data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      shadowColor: Colors.grey.withOpacity(0.2),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Capturar video de la persona'),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: data['statusProfile'] != true
                        ? Colors.redAccent
                        : Colors.green,
                  ),
                  child: Text(
                    data['statusProfile'] != true ? "Pendiente" : "Completo",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: FlatButton(
                onPressed: () {},
                padding: EdgeInsets.zero,
                child: Text(
                  'CAPTURAR',
                  style: TextStyle(
                    color: ColorsCustom().primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext context, DocumentSnapshot  user) {
    return Container(
      child: RaisedButton(
        color: Colors.white,
        textColor: ColorsCustom().primary,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Text('GUARDAR'),
        onPressed: () {
          // Activa la función de Validator en los campos del form
          if (!_formKey.currentState.validate()) return;
          // Activa la función OnSaved
          _formKey.currentState.save();

          updateUserData(user, {
            'name': _name,
            'last_name_p': _lastNameP,
            'last_name_m': _lastNameM,
            'phoneNumber': _phoneNumber,
          });
          _scaffoldKey.currentState
              .showSnackBar(SnackBar(content: Text('Registado correctamente')));
        },
      ),
    );
  }
}
