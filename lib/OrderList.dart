//import 'package:MyPet/Mypets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Payment.dart';
import 'package:intl/intl.dart';
import 'appointment_object.dart';
import 'models/global.dart';
import 'models/data.dart';

class OrderList extends StatefulWidget {
  final appointment? appoint;

  const OrderList(
      {this.appoint,
});

  @override
  OrderListState createState() => OrderListState();
}

class OrderListState extends State<OrderList> {
  fbHelper fb = fbHelper();

appointment? a;
  String? aa;

  void initState() {
    super.initState();
    a = widget.appoint;//here var is call and set to
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF4E3E3),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios, color: Color(0xFF2F3542)),
              style: backButton), // <-- Button color// <-- Splash color
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Text(
              'Order List',
              style: TextStyle(
                  color: Color(0XFFFF6B81),
                  fontSize: 34,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 20, 0, 30),
            alignment: Alignment.topLeft,
            child: Text(
              'Appointments',
              style: TextStyle(
                  color: Color(0XFF52648B),
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(25, 10, 25, 70),
            height: 350,
            width: double.infinity,
            decoration: new BoxDecoration(
              color: Color(0xffF4F4F4),
              borderRadius: new BorderRadius.all(Radius.circular(25.0)),
            ),
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                        child: Text(
                          'Service: ',
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 40, 20, 30),
                        child: Text(
                          a!.desc!,
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text(
                          'Pet: ',
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(35, 0, 20, 0),
                        child: Text(
                          a!.petName.toString(),
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                        child: Text(
                          'Time: ',
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                        child: Text(
                          a!.time.toString(),
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                        child: Text(
                          'Date: ',
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                        child: Text(
                          a!.date.toString(),
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text(
                          'Total: ',
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text(
                          totalss(a!.type)! + '\$',
                          style: TextStyle(
                              color: Color(0XFF52648B),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 80),
            width: 193,
            height: 73,
            child: ElevatedButton(
                onPressed: () {
                  fb.saveData(a!);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Payment(appoint: a)),
                  );
                },
                child: Text('Confirm',
                    style:
                        TextStyle(fontStyle: FontStyle.italic, fontSize: 25)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0XFF2F3542)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0))),
                )),
          ),
        ]))));
  }

  String? totalss(String? m) {
    if (m == "Check-Up") {
      a!.total =50.0;
      aa = "50";
    } else {
      aa = a!.total.toString();
    }
    return aa;
  }


}
