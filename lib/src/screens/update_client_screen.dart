import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wiximo_aplication/src/services/auth_service.dart';
import 'package:wiximo_aplication/src/utils/custom_color_scheme.dart';
import 'package:wiximo_aplication/src/screens/widgets/identity_widgets.dart';

import '../services/auth_service.dart';

class ValidateClientIdentity extends StatefulWidget {
  ValidateClientIdentity({Key key}) : super(key: key);

  @override
  _ValidateClientIdentityState createState() => _ValidateClientIdentityState();
}

class _ValidateClientIdentityState extends State<ValidateClientIdentity> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _identityWidets = IdentityScreenWidgets();

  String _name;
  String _lastNameM;
  String _lastNameP;
  String _phoneNumber;
  String _email;
  String _uuid;

  File _fileINEfront;
  File _fileINEBack;

  @override
  Widget build(BuildContext context) {
    _uuid = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('VALIDAR IDENTIDAD'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getDataClient(_uuid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            print(snapshot.error);
            return Center(child: Text('Ocurrió un error'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          Map<String, dynamic> data = snapshot.data.data();
          String qrData =
              'Nombre: ${data['name']} ${data['last_name_p']} ${data['last_name_p']} Teléfono: ${data['phoneNumber']}';
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            children: [
              data['statusProfile'] == false
                  ? _identityWidets.infoText(context)
                  : Center(
                      child: QrImage(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
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
            initialValue:
                user.data()['email'] != null ? user.data()['email'] : '',
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: '*Email',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Escriba su correo';
              }
              return null;
            },
            onSaved: (newValue) => setState(() {
              _email = newValue;
            }),
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
            keyboardType: TextInputType.number,
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
            _fileINEfront == null
                ? SizedBox()
                : Image.file(_fileINEfront, width: 30, height: 30),
            _fileINEBack == null
                ? SizedBox()
                : Image.file(_fileINEBack, width: 30, height: 30),
            Align(
              alignment: Alignment.bottomLeft,
              child: FlatButton(
                onPressed: () {
                  uploadDNI(data);
                },
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
                onPressed: () {
                  uploadDNI(data);
                },
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

  Widget _actionButton(BuildContext context, DocumentSnapshot user) {
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

          updateClientData(user, {
            'email': _email,
            'name': _name,
            'last_name_p': _lastNameP,
            'last_name_m': _lastNameM,
            'phoneNumber': _phoneNumber,
          }).then((value) {
            if (value.data() != null) {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text('Registado correctamente'),
                ),
              );
            }
          }).catchError((e) {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('Error'),
              ),
            );
          });
          if (user.data()['isINE'] == true) {
            updateClientData(user, {'statusProfile' : true});
          }
        },
      ),
    );
  }

  Future uploadDNI(DocumentSnapshot user) async {
    try {
      UploadTask uploadTask;

      final PickedFile file = await ImagePicker.platform.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
          imageQuality: 100);
      setState(() {
        _fileINEfront = File(file.path);
      });

      var ref = FirebaseStorage.instance
          .ref()
          .child("users")
          .child(_uuid.toString())
          .child("DNIFront");

      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Subiendo')));

      uploadTask = ref.putFile(File(file.path));

      uploadTask.then((e) {
        print("Subiendo");
        print(e.state);
        if (e.state.index == 2) {
          print("SUBIDO CON EXITO");
          updateClientData(user, {
            'isINE': true,
          }).then((value) {
            if (value.data() != null) {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text('Registado correctamente'),
                ),
              );
            }
          }).catchError((e) {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('Error'),
              ),
            );
          });
          print(e.state);
          _scaffoldKey.currentState
              .showSnackBar(SnackBar(content: Text('Subido con éxito')));
        }
      }).catchError((e) {
        print("ERROR");
      });
    } catch (e) {
      print(e);
    }
  }
}
