import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'models/global.dart';
import 'petProfile_ownerProfile.dart';
import 'editOwnerProfile.dart';
import 'addPet.dart';


int myPets = 0;


class Profile extends StatelessWidget {

  GlobalKey _globalKey = navKeys.globalKey;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFF4E3E3),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation:0,
        actions: [

          ElevatedButton(
              onPressed: () {
                BottomNavigationBar navigationBar =  _globalKey.currentWidget as BottomNavigationBar;
                navigationBar.onTap!(0);
              },
              child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
              style: backButton ),
        Container(
          padding: EdgeInsets.only( left: 290, right: 0),

        ),
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
    ],),
      body:SingleChildScrollView(

        child:  Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 5),
                  width: 120,
                  height: 110,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('pet owners')
                          .where('ownerID', isEqualTo: getuser())
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Text('loading');
                        return
                          //card pets method
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: new AssetImage(
                                (snapshot.data!).docs[0]['gender'] == "Female"
                                    ? "images/owner.png"
                                    : "images/maleProfile.jpg"),
                          );
                      }),
                ),
              ],
            ),



            Container(
              margin: EdgeInsets.only(top: 5,bottom: 10),
                child: Text(
                  'Profile Information',
                  style: TextStyle(
                      color: Color(0xffe57285),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

            ),
 Container(
            padding: EdgeInsets.only(top:10,left:10,right: 10,bottom: 30),
            height:260,
            child: StreamBuilder<QuerySnapshot>(
 stream: FirebaseFirestore.instance.collection('pet owners').where('ownerID', isEqualTo: getuser()).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('loading');
            return
              //card pets method
              _buildOwnerCard(context, (snapshot.data!).docs[0]);

          }
      ),
          ),




          Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only( left:30),
                  child: Text(
                    'My Pets',
                    style: TextStyle(
                        color: Color(0xffe57285),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left:  MediaQuery.of(context).size.width * 0.45,),
                  child:
                  //Add button
                  MaterialButton(
                    minWidth: 50,
                    height: 25,
                    padding: const EdgeInsets.all(5),
                    color: primaryColor,
                    textColor: Colors.white,
                    child: const Text('+', style: TextStyle(
                      fontSize: 28, ),),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),onPressed:(){
                    print(user!.email.toString());
                    Navigator.push(context,MaterialPageRoute(builder: (_) =>addPet(getuser()))) .catchError((error) => print('Delete failed: $error'));;
                  },



                  ),),]),

          //pest cards
          Container(
            height: 220,

            padding: EdgeInsets.only(left: 15, bottom: 5),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("pets")
                    .where('ownerId', isEqualTo: (getuser()))
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('loading');
                  if (snapshot.data!.docs.isEmpty)
                    return Padding(
                        padding: EdgeInsets.all(20),
                        child: const Text('You do not have Any Pets yet!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.grey),
                            textAlign: TextAlign.center));
                  return ListView.builder(scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) =>

                    //card pets method
                    _buildPetsCard(context, (snapshot.data!).docs[index]),
                  );
                }
            ),
          ),


    ],  ),
    ),);
  }


  Widget _buildOwnerCard(BuildContext context, DocumentSnapshot document ) {
    if (document['ownerID'].toString() == getuser()){
     // ownerID = document['ownerID'].toString();
      return Card(
      //  elevation:0,
        //color: Color(0xFFF4E3E3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(

          padding: EdgeInsets.only(left: 10, top: 5),

          width: 300,

          child:
          Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: ListTile(
                    title: Text(document['fname'] +" " +
                            document['lname'] + "\n" +
                            document['mobile'] + "\n" + document['email'],
                        style: petCardTitleStyle,textAlign: TextAlign.center),

                  ),),

                //Edit button
                Container(
                  margin: EdgeInsets.only(left: 15,right: 15,bottom: 20),
                ),


                //Edit button
                MaterialButton(

                  minWidth: 130,
                  height: 35,
                  padding: const EdgeInsets.all(10),

                  color: primaryColor,
                  textColor: Colors.white,
                  child: const Text('Edit'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => editProfile(document)))
                        .catchError((error) => print('Delete failed: $error'));
                    ;
                  },
                ),
              ]),),);
    }   else  return Card();

  }
  Widget _buildPetsCard(BuildContext context, DocumentSnapshot document ) {
    String img ="";

    if (document['ownerId'].toString()==getuser()){
      myPets--;
      if (document['species'] == "Dog")
        img = "images/dog.png";
      else if (document['species'] == "Cat")
        img = "images/cat.png";
      else if (document['species'] == "Bird")
        img = "images/Bird.png";
      else if (document['species'] == "Rabbit")
        img = "images/Rabbit.png";
      else if (document['species'] == "Snake")
        img = "images/Snake.png";
      else if (document['species'] == "Turtle")
        img = "images/Turtle.png";
      else if (document['species'] == "Hamster")
        img = "images/Hamster.png";
      else
        img = "images/logo4.png";

      String? url;
      Map<String, dynamic> dataMap = document.data() as Map<String, dynamic>;

      if(dataMap.containsKey('img'))
        url = document['img']['imgURL'];
      else
        url = null;

      return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),

          child: Container(

            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(left: 20,right:20),
            width: 160,

            child:
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      width: 100,
                      height: 100,
                      child: CircleAvatar(
                          radius: 80,
                          backgroundImage: url == null ? new AssetImage(img) : Image.network(url).image),
                    ),

                  ],
                ),
                Container(
                  child:Center(
                  child: ListTile(
                      title: Text(document['name'],style: PetStyle,   textAlign: TextAlign.center,),
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder:(context) {
                          return pet(document['petId']);

                        } ));}),
                ),),],
            ),));
    }
    else return Card();
  }

  String getuser(){
    User? user = FirebaseAuth.instance.currentUser;
    return user!.uid.toString();
  }

}
