import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/global.dart';
String Name ='';
final _dformKey = GlobalKey<FormState>();

CollectionReference PetTypes =
FirebaseFirestore.instance.collection('PetTypes');
enum SingingCharacter { companion, exotic  }
SingingCharacter? _character = SingingCharacter.companion;
CollectionReference petType =
FirebaseFirestore.instance.collection('PetTypes');



class addPetType extends StatefulWidget {
  Function initData;
  addPetType(this.initData) ;
  @override
  State<addPetType> createState() => _addPetType();
}

class _addPetType extends State<addPetType> {
  static final RegExp nameRegExp = RegExp('^[a-zA-Z ]+\$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xFFF4E3E3),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation:0,
          leading: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },

              child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
              style: backButton ),// <-- Button color// <-- Splash color

        ),
        body: SingleChildScrollView(
            child:  Form(
              key: _dformKey,
              child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.fromLTRB(44, 5, 44, 45),
                          child: const Text('Add New Pet Type',
                              style: TextStyle(
                                  color: Color(0xffe57285),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold))),

                      SizedBox(height: 100),

                      Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 230, 0),
                          child:  Text('Pet Type name:',
                              style: TextStyle(
                                  color: Color(0xffe57285),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,))),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8,20,8,8),
                        child:  TextFormField(
                          keyboardType: TextInputType.text,
                          inputFormatters:[FilteringTextInputFormatter.singleLineFormatter],

                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey,
                          ),
                          decoration: InputDecoration(

                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Name ",
                            hintStyle: TextStyle(color:Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )
                            ),
                          ),
                          onChanged: (String value) {
                            Name = value;
                          },
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                      return "Please enter Pet type name";
                      }
                            else if(value.length>25){
                              return 'Pet type must be less then 25 characters';
                            }
                            else if(!nameRegExp.hasMatch(value)){
                              return "Pet type name must contain only letters";
                            }


                          },
                        ),

                      ),

                      SizedBox(height: 50),

                      Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 280, 0),
                          child:  Text('Pet Type:',
                              style: TextStyle(
                                color: Color(0xffe57285),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,))),
                      ListTile(
                        title: const Text('Companion animal'),
                        leading: Radio<SingingCharacter>(
                          value: SingingCharacter.companion,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                      ),
                ListTile(
                  title: const Text('Exotic animal'),
                  leading: Radio<SingingCharacter>(
                    value: SingingCharacter.exotic,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                ),

                      SizedBox(height: 50),

                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                ElevatedButton(
                                    child: Text("Add",
                                        style:
                                        TextStyle(
                                            color: primaryColor,
                                            fontSize: 18)),
                                    style: ButtonStyle(
                                      elevation:   MaterialStateProperty.all(0),
                                      backgroundColor:
                                      MaterialStateProperty.all(greenColor),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0))),
                                    ),
                                    onPressed: () async {
    if (_dformKey.currentState!.validate()) {

      String _name = Name[0].toUpperCase() + Name.substring(1).toLowerCase().trim();

      QuerySnapshot<Object?> snapshot = await petType
          .where('petTypeName', isEqualTo: _name)
          .get();

      List<QueryDocumentSnapshot> docs = snapshot.docs;


      if (docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Pet type is already exists'),
                backgroundColor: Colors.red)
        );
      }
      else {
        DocumentReference doc = await PetTypes.add({
          'petTypeID': '',
          'petTypeName': _name,
          'petType': _character
              .toString()
              .split('.')
              .last,


        });
        String _id = doc.id;
        await PetTypes.doc(_id).update({"petTypeID": _id});
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pet type is added successfully'),
                backgroundColor: Colors.green)
        );


        widget.initData();
        Navigator.of(context).pop();
      }
    }

                                    }
                                )),


                          ]
                      )

                    ],
                  )
              ),
            ),
        )
    );


  }

}