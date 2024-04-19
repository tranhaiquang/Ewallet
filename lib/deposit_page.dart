import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EWallet/home_page.dart';
import 'package:flutter/material.dart';

class DepositPage extends StatefulWidget {
  DepositPage({super.key});

  @override
  State<DepositPage> createState() => _DepositPageState();
}

// This widget is the root of your application.
class _DepositPageState extends State<DepositPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _balance = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  late Completer<void> _completer;

  Future<void> updateUserBalance({required double balance}) async {
    String uid = user!.uid;
    double totalBalance = balance + await getUserBalance();
    await _firestore.collection('users').doc(uid).update({
      'balance': totalBalance,
    });
  }

  Future<double> getUserBalance() async {
    try {
      // Get a reference to the user document in Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      // Get the 'balance' field from the document
      double balance = (userData?['balance'] ?? 0).toDouble();

      return balance;
    } catch (e) {
      print("Error fetching user balance: $e");
      return 0;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(35.0, 100.0, 35.0, 0.0),
          child: Column(
            children: <Widget>[
              Image(
                  image: AssetImage(
                'assets/register_img.jpg',
              )),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: _balance,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              hintText: 'Balance'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Balance!';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                          height: 52,
                          width: 352,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                                backgroundColor:
                                    MaterialStatePropertyAll(Color(0xFF372899)),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0))))),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                updateUserBalance(
                                    balance:
                                        double.tryParse(_balance.text) ?? 0.0);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
                              }
                            },
                            child: Text(
                              'Deposit',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          )),
                    ],
                  )),
            ],
          ),
        ));
  }
}
