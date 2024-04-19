import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransferPage extends StatefulWidget {
  TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

// This widget is the root of your application.
class _TransferPageState extends State<TransferPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _balance = TextEditingController();
  final _email = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  String _errorEmailMsg = '';
  String _errorBalanceMsg = '';

  Future<void> updateUserBalance({required double balance}) async {
    String uid = user!.uid;
    double totalBalance = balance + await getUserBalance();
    await db.collection('users').doc(uid).update({
      'balance': totalBalance,
    });
  }

  Future<void> checkUserExist({required String email}) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: email)
          .get();

      if (!querySnapshot.docs.isNotEmpty) {
        setState(() {
          _errorEmailMsg = 'User is invalid';
        });
      } else {
        setState(() {
          _errorEmailMsg = '';
        });
      }
    } catch (e) {
      print("Error completing: $e");
    }
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

  Future<void> checkValidBalance({required double balance}) async {
    try {
      double currentBalance = await getUserBalance();
      if (balance > currentBalance) {
        setState(() {
          _errorBalanceMsg = 'Balance is insufficient';
        });
      } else {
        setState(() {
          _errorBalanceMsg = '';
        });
      }
    } catch (e) {
      print("Error completing: $e");
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
                        controller: _email,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          hintText: 'Email',
                          errorText:
                              _errorEmailMsg.isNotEmpty ? _errorEmailMsg : null,
                        ),
                        onChanged: (value) {
                          setState(() {
                            checkUserExist(email: _email.text);
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email!';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                          controller: _balance,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              errorText: _errorBalanceMsg.isNotEmpty ? _errorBalanceMsg : null,
                              hintText: 'Balance'),
                          onChanged: (value) {
                            setState(() {
                              checkValidBalance(balance: 99999999.9);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Balance!';
                            }
                            return null;
                          }),
                      SizedBox(height: 15),
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
                              }
                            },
                            child: Text(
                              'Transfer',
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
