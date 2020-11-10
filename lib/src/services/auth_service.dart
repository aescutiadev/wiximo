import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _signIn = GoogleSignIn(scopes: ['email']);
FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> logout() async {
  await _signIn.signOut();
  await FirebaseAuth.instance.signOut();
}

Future<String> login() async {
  try {
    GoogleSignInAccount account = await _signIn.signIn();

    GoogleSignInAuthentication authentication = await account.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );

    print(credential);

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    User user = userCredential.user;

    DocumentReference _userRef =
        FirebaseFirestore.instance.collection('admins').doc(user.uid);
    if (_userRef.path == null) {
      print('El usuario NO existe');
      await _userRef.set({
        'uid': user.uid.toString(),
        'email': user.email.toString(),
        'lastSing': DateTime.now(),
        'photoURL': user.photoURL.toString(),
        'displayName': user.displayName.toString(),
        'phoneNumber': user.phoneNumber.toString(),
        'emailVerified': user.emailVerified,
        'statusProfile': false,
      });
    } else {
      print('El usuario SI existe');
      await _userRef.update({'lastSing': DateTime.now()});
    }
    // await setDataUser(user, {
    //   'uid': user.uid.toString(),
    //   'email': user.email.toString(),
    //   'lastSing': DateTime.now(),
    //   'photoURL': user.photoURL.toString(),
    //   'displayName': user.displayName.toString(),
    //   'phoneNumber': user.phoneNumber.toString(),
    //   'emailVerified': user.emailVerified,
    //   'statusProfile': false,
    // });

    return 'Success';
  } on FirebaseAuthException catch (e) {
    print(e.code);
    return 'Error';
  } catch (e) {
    print('======= ERROR ========');
    print(e);
    logout();
    return 'Error';
  }
}

/// Llama a CollectionReference del usuario para verificar y/o
/// actualizar datos de usuario ya registrado \
/// Datos admitidos  \
/// { 'uid'    \
/// 'email'    \
/// 'lastSing'  \
/// 'photoURL'   \
/// 'displayName' \
/// 'phoneNumber'  \
/// 'emailVerified' \
/// statusProfile }
Future<DocumentSnapshot> setDataUser(
    User user, Map<String, dynamic> model) async {
  DocumentReference _userRef = _firestore.collection('users').doc(user.uid);
  if (_userRef.path.isEmpty) {
    print('El usuario NO existe');
    _userRef.set(model);
  } else {
    print('El usuario SI existe');
    _userRef.update({'lastSing': DateTime.now()});
  }

  DocumentSnapshot _userData = await _userRef.get();

  return _userData;
}

/// Obtiene los datos del usuario
Future<DocumentSnapshot> getDataUser(User user) async {
  DocumentReference _userRef = _firestore.collection('admins').doc(user.uid);

  DocumentSnapshot _userData = await _userRef.get();

  return _userData;
}

/// Actualiza la información proporcionada \
/// Si existe actualiza el valor, Si no existe crea el campo especificado
Future<DocumentSnapshot> updateUserData(
    DocumentSnapshot user, Map<String, dynamic> model) async {
  DocumentReference _userRef =
      _firestore.collection('admins').doc(user.data()['uid']);

  _userRef.update(model);

  DocumentSnapshot _userData = await _userRef.get();

  return _userData;
}

Future<DocumentSnapshot> updateClientData(
    DocumentSnapshot user, Map<String, dynamic> model) async {
  DocumentReference _userRef =
      FirebaseFirestore.instance.collection('users').doc(user.data()['uid']);

  _userRef.update(model);

  DocumentSnapshot _userData = await _userRef.get();

  return _userData;
}
/// Obtiene los datos del usuario
Future<DocumentSnapshot> getDataClient(String user) async {
  DocumentReference _userRef = _firestore.collection('users').doc(user);

  DocumentSnapshot _userData = await _userRef.get();

  return _userData;
}
