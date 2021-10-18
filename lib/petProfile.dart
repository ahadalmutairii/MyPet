import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_pet_profile.dart';

import 'models/global.dart';
import 'package:MyPet/MyPets.dart';

final  primaryColor = const Color(0xff313540);
GlobalKey _globalKey = navKeys.globalKey;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(Pet());
}
class Pet extends StatelessWidget {

  final Future<FirebaseApp> fbApp =  Firebase.initializeApp();


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: fbApp,
          builder:(context,snapshot) {
            if (snapshot.hasError){
              print("An error has occured ${snapshot.error.toString()}");
              return const Text("Something went wrong");}
            else if (snapshot.hasData) {
              return pet("");
            }
            else{return const Center(child:CircularProgressIndicator());}
          },
        )

    );
  }
}
class pet extends StatelessWidget {
  final String petID;
  pet(this.petID);


  @override
  Widget build(BuildContext context) {
    var primaryColor = const Color(0xff313540);
    GlobalKey _globalKey = navKeys.globalKey;
    return Scaffold(

      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFF4E3E3),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation:0,
          leading: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            //  Navigator.push(context,MaterialPageRoute(builder: (_) =>MyPets()));

            },

              child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
              style: backButton ),// <-- Button color// <-- Splash color

      ),
      body: Stack(


children: <Widget>[

          Container(
        //  padding: EdgeInsets.only(bottom: 380,),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('pets').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('loading');
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) =>
                  //card pets method
                  _buildPicCard(context, (snapshot.data!).docs[index]),
                );
              }
          ),
        ),



    Container(
        padding: EdgeInsets.only(top: 200, left: 20, right: 20),

            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('pets')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('loading');
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) =>
                    //card pets method
                    _buildPetCard(context, (snapshot.data!).docs[index]),
                  );
                }
            ),
          ),

           ], ),);
  }


  Widget _buildPetCard(BuildContext context, DocumentSnapshot document) {

    if (document['petId'] == petID)
      return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)),
        child: Container(

          padding: EdgeInsets.only(left: 20, top: 20),

          width: 250,
          height: 380,

          //i dont know why this cammand does not work
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),

            color: Colors.white,
          ),
          child:
          Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                ),
                Container(

                  child: ListTile(
                    title: Text(
                        "name:  " + document['name'] + "\nspecies:  " +
                            document['species'] + "\ngender:  " +
                            document['gender'] + "\nbirth date:  " +
                            document['birthDate'] , style: petCardTitleStyle),

                  ),),

                Container(
                  margin: EdgeInsets.only(left: 15,right: 15,bottom: 60),
                ),


                //Edit button
                FlatButton(

                  minWidth: 200,
                  height: 60,
                  padding: const EdgeInsets.all(20),
                  color: greenColor,
                  textColor: primaryColor,
                  child: const Text('Edit',style: TextStyle( fontSize: 18,
                  ),),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => editPet(document)))
                        .catchError((error) => print('Delete failed: $error'));
                  }
                  ,

                ),
                Container(
                  margin: EdgeInsets.only(left: 15,right: 15,bottom: 20),
                ),

                //delete button
                FlatButton(

                  minWidth: 200,
                  height: 60,
                  padding: const EdgeInsets.all(20),
                  color: redColor,
                  textColor: primaryColor,
                  child: const Text('Delete',style: TextStyle( fontSize: 18,
                  ),),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: () => showAlert(context,"Delete my pet",document),


                ),




              ]),),);
    else
      return Card();
  }

  Widget _buildPicCard(BuildContext context, DocumentSnapshot document) {
    String img = "";
    if (document['petId'] == petID) {
      if (document['species'] == "Dog")
        img = "images/dog.png";
      else
        img = "images/cat.png";
      return Column(

        children: <Widget>[

      Container(
      margin: EdgeInsets.only(top: 5),
    width: 120,
    height: 110,
    child:    CircleAvatar(
        backgroundImage: new AssetImage(img),
      ),),
        Container(
          padding: EdgeInsets.only(bottom: 350),

            child: Text(
              'Pet Information', style: TextStyle(
    color: Color(0xffe57285),
    fontSize: 30,
    fontWeight: FontWeight.bold),
    textAlign: TextAlign.center,
            ),

        ),
        ]
      );
    } else
      return Card();
  }

  Map statusStyles = {
    'Cat': statusCatStyle,
    'Dog': statusDogStyle
  };

  showAlert(BuildContext context,String message,DocumentSnapshot document) {
    showDialog(

      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("YES"),
              onPressed: () {
                document.reference.delete().then((_){

                Navigator.pop(context, true);
        }   );

               // Navigator.push(context,MaterialPageRoute(builder: (_) =>MyPets())) .catchError((error) => print('Delete failed: $error'));;
                //Put your code here which you want to execute on Yes button click.

              },
            ),


            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {

                //Put your code here which you want to execute on Cancel button click.
                Navigator.pop(context, false);

              },
            ),
          ],
        );
      },
    ).then((exit) {
          if (exit == null) return;

          if (exit) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Pet deleted successfully"),
              backgroundColor:Colors.green,),);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Pet has not been deleted "),
              backgroundColor:Colors.orange,),);
          }
      },
    );
  }

}
