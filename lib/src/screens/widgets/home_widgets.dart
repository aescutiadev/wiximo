import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wiximo_aplication/src/services/auth_service.dart';
import 'package:wiximo_aplication/src/utils/custom_color_scheme.dart';

class HomeScreenWidgets {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Drawer drawer(BuildContext context, User snapshot) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Flexible(
                  flex: 3,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(snapshot.photoURL),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          snapshot.displayName,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      Divider(color: Colors.transparent),
                      Container(
                        child: Text(
                          snapshot.email,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            title: Text('Cerrar sesión'),
            trailing: Icon(Icons.exit_to_app),
            onTap: () => logout().whenComplete(
              () => Navigator.of(context).pushNamedAndRemoveUntil(
                'login',
                (route) => false,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget cardOne(BuildContext context, User user) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
      shadowColor: Colors.grey.withOpacity(0.3),
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Validar mi identidad",
              style: TextStyle(
                fontSize: 18,
                color: ColorsCustom().primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.navigate_next,
              color: ColorsCustom().primary,
              size: 24,
            )
          ],
        ),
        onTap: () =>
            Navigator.of(context).pushNamed('identity', arguments: user),
      ),
    );
  }

  Widget cardTwo(context, User user) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      shadowColor: Colors.grey.withOpacity(0.3),
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Validación de identidad",
                  style: TextStyle(
                    fontSize: 18,
                    color: ColorsCustom().primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.navigate_next,
                  color: ColorsCustom().primary,
                  size: 24,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pendientes(),
                Text(
                  "Pendientes",
                  style: TextStyle(color: Colors.blueGrey[200]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget pendientes() {
    return StreamBuilder<QuerySnapshot>(
      stream: users
          .where('statusProfile', isEqualTo: false)
          .snapshots(includeMetadataChanges: true),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Ocurrió un error'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return Text(
          "${snapshot.data.docs.length}",
          style: TextStyle(fontSize: 100, color: ColorsCustom().primary),
        );
      },
    );
  }

  Widget usersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: users
          .orderBy('statusProfile')
          .snapshots(includeMetadataChanges: true),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Ocurrió un error'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            Map result = document.data();
            return ListTile(
              contentPadding: EdgeInsets.all(10.0),
              leading: Container(
                width: 50,
                height: 50,
                decoration: result['photoURL'] != null
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        color: result['photoURL'] != null
                            ? Colors.transparent
                            : Colors.grey,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            '${result['photoURL']}',
                          ),
                        ),
                      )
                    : BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
              ),
              title: Text(
                result['name'] != null
                    ? '${result['name']} ${result['last_name_p']} ${result['last_name_m']}'
                    : 'Aún no difinido',
              ),
              subtitle: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: result['statusProfile'] != true
                          ? Colors.redAccent
                          : Colors.green,
                    ),
                    child: Text(
                      result['statusProfile'] != true
                          ? "No Validado"
                          : "Validado",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.phone,
                    color: result['statusProfile'] != true
                        ? Colors.grey
                        : Colors.black),
                onPressed: result['statusProfile'] != true
                    ? null
                    : () => _makePhoneCall('tel://${result['phoneNumber']}'),
              ),
              onTap: () => Navigator.of(context)
                  .pushNamed('validateClient', arguments: result['uid']),
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
