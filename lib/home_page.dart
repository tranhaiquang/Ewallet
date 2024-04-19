import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:EWallet/deposit_page.dart';
import 'package:EWallet/transfer_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onNavigateToHome;

  const HomePage({Key? key, this.onNavigateToHome}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// This widget is the root of your application.
class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  Future<double>? _currentBalance;

  @override
  void initState() {
    super.initState();
    updateUI();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateUI();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<double> getUserBalance() async {
    await Future.delayed(Duration(seconds: 1));
    try {
      // Get a reference to the user document in Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      // Get the 'balance' field from the document
      return (userData?['balance'] ?? 0).toDouble();
    } catch (e) {
      print("Error fetching user balance: $e");
      return 0.0;
    }
  }

  Future<void> updateUI() async {
    setState(() {
      _currentBalance = getUserBalance();
    });
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
          child: FutureBuilder(
            future: _currentBalance,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error fetching balance: ${snapshot.error}');
              } else {
                return Column(
                  children: <Widget>[
                    Text(user?.email.toString() ?? 'User email'),
                    Text('Balance:  ${snapshot.data}'),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DepositPage()));
                        },
                        child: Text('Deposit')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TransferPage()));
                        },
                        child: Text('Transfer')),
                    ElevatedButton(
                        onPressed: () {
                          signOut();
                        },
                        child: Text('Log Out'))
                  ],
                );
              }
            },
          ),
        ));
  }
}
