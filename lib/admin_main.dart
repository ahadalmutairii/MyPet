import 'package:MyPet/PetType_model.dart';
import 'package:MyPet/admin_screen.dart';
import 'package:MyPet/models/global.dart';
import 'package:MyPet/view_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:MyPet/admin_calender.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:MyPet/add_dr.dart';
import 'package:MyPet/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyPet/admin_newServices.dart';
import 'package:MyPet/admin_viewSchedule.dart';

import 'ManagePetType.dart';
import 'PetType_tile.dart';
import 'PetType_view.dart';
import 'admin_viewappts.dart';
import 'inBoarding.dart';


class AdminHomePage extends StatefulWidget {

  AdminHomePage();

  State<AdminHomePage> createState() => _adminHomePageState();
}

class _adminHomePageState extends State<AdminHomePage> {
  GlobalKey _globalKey = navKeys.globalKeyAdmin;
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: const Color(0xFFF4E3E3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            iconSize: 35.0,
            icon: Icon(
              Icons.logout,
              color: Color(0xFF2F3542),
            ),
            onPressed: () async {
    await FirebaseAuth.instance.signOut().catchError((error){
    print(error.toString());
    });
    Navigator.of(context,rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new  LoginPage()));
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
            child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                    width: 120,
                    height: 110,
                    fit: BoxFit.fill,
                    image: new AssetImage('images/logo.jpeg'))
              ],
            ),

            SizedBox(height: 20),
            Container(
              width: 344,
              height: 100,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => new AdminAppointments()),
                    );
                  },
                  child: Text('View Appointments',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Color(0XFF2F3542)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                  )),
            ),


            SizedBox(height: 20),
            Container(
              width: 344,
              height: 100,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => new ServiceList()),);
                  },
                  child: Text('Manage Services',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Color(0XFFFF6B81)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                  )),






            ),


            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: 344,
              height: 100,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              PetTypeList(
                                  title: 'Pet Types', type: 0)),
                    );
    },

                  child: Text('Manage Pet Types',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Color(0XFF2F3542)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                  )),






            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              width: 344,
              height: 100,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => inHousePets()
),
                    );
                  },

                  child: Text('Pets In House',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Color(0XFFFF6B81)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                  )),






            ),
          SizedBox(height: 50),
//
//
// )

            ],
        )),
      ),
    );
  }
}