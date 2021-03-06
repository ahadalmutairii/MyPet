import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../appointment_object.dart';
import 'notifaction_service.dart';

class fbHelper {

  FirebaseFirestore fb = FirebaseFirestore.instance;

  String getuser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user!.uid.toString();
  }

  CollectionReference appointments() {
    return fb.collection("appointment");
  }

  CollectionReference workShifts() {
    return fb.collection("Work Shift");
  }
  Future<void> saveData(appointment a) async {
    DocumentReference doc =
    await FirebaseFirestore.instance.collection('appointment').add({
      'workshiftID': a.appointID,
      'service': a.desc!,
      'petID': a.petId,
      'petOwnerID': getuser(),
      'totalPrice': a.total
    });

    await FirebaseFirestore.instance
        .collection("appointment")
        .doc(doc.id)
        .update({"appointmentID": doc.id});

    NotificationService.showScheduledNotifaction(
        id: doc.id.hashCode,
        title: 'Reminder',
        t: a.getStart()
    );


    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Work Shift')
        .where('appointmentID', isEqualTo: a.appointID)
        .get();

    List<QueryDocumentSnapshot> docs = snapshot.docs;
    for (var doc in docs) {
      if (doc.data() != null) {

        doc.reference.update({"status": "Booked"});
      }
    }
  }

  Future<DateTime> getStartDateTime(String workshiftID) async {
       await workShifts()
        .where('appointmentID', isEqualTo: workshiftID)
        .get().then((snapshot)
        {
    for (var doc in snapshot.docs) {
      if (doc.data() != null) {
        DateTime _date = DateFormat("dd/MM/yyyy").parse(doc['date'].toString());

        DateTime _startTimeFormat = DateFormat("hh:mm").parse(
            doc['startTime'].toString());
        TimeOfDay _start = TimeOfDay.fromDateTime(_startTimeFormat);

        DateTime _startDateTime = DateTime(
            _date.year,
            _date.month,
            _date.day,
            _start.hour,
            _start.minute,
            0);

        return _date;

      }

  }
          });
           return DateTime(1900);
           }

           void deleteDoc( DocumentReference doc){
           doc.delete();
           }

  Future<void> saveBoarding(appointment a) async {

    DocumentReference doc =
        await FirebaseFirestore.instance.collection('boarding').add({
      'notes': a.desc!,
      'petID': a.petId,
      'petOwnerID': getuser(),
      'totalPrice': a.total,
      'startDate': a.date,
      'endDate': a.time
    });

    await FirebaseFirestore.instance
        .collection("boarding")
        .doc(doc.id)
        .update({"boardingID": doc.id});


    //  drop off
    NotificationService.showScheduledBoardingNotifaction(
        id: doc.id.hashCode+1,
        title: 'Reminder',
      body: 'Your Pet Boarding Appointment is in 1 day',
        t: a.getBoardingTime(a.date!),
        //t2: a.getBoardingTime(a.time!)
    );

// pick up
    NotificationService.showScheduledBoardingNotifaction(
      id: doc.id.hashCode+2,
      title: 'Reminder',
      body: 'Your Pet Boarding Appointment is in 1 day',
      t: a.getBoardingTime(a.time!),
      //t2: a.getBoardingTime(a.time!)
    );

  }



}


