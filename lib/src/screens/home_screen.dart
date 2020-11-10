import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:wiximo_aplication/src/utils/custom_color_scheme.dart';
import 'package:wiximo_aplication/src/utils/utils.dart';

import 'package:wiximo_aplication/src/screens/widgets/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _utils = WidgetsUtils();
  final _homeWidgets = HomeScreenWidgets();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Si el usuario es correcto
        if (snapshot.data != null) {
          return DefaultTabController(
            length: 2,
            initialIndex: 1,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Wiximo'),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: Material(
                    color: Colors.white,
                    child: TabBar(
                      indicator: UnderlineTabIndicator(
                        insets: EdgeInsets.only(right: 35, left: 35),
                        borderSide: BorderSide(
                          width: 4.0,
                          color: ColorsCustom().primary,
                        ),
                      ),
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: Colors.blueGrey,
                      indicatorColor: ColorsCustom().primary,
                      labelColor: ColorsCustom().primary,
                      tabs: [
                        Tab(text: 'DASHBOARD'),
                        Tab(text: 'AGENDA'),
                      ],
                    ),
                  ),
                ),
              ),
              drawer: _homeWidgets.drawer(context, snapshot.data),
              body: TabBarView(
                children: [
                  // Tab 1
                  ListView(
                    children: [
                      _homeWidgets.cardOne(context, snapshot.data),
                      _homeWidgets.cardTwo(context, snapshot.data),
                    ],
                  ),
                  // Tab 2
                  ListView(
                    children: [
                      _homeWidgets.usersList(),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return _utils.loading(isStream: true);
      },
    );
  }
}
