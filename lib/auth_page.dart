import 'package:flutter/material.dart';
import 'package:EWallet/register_page.dart';
import 'login_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showEWalletPage = true;

  void toggleScreens() {
    setState(() {
      showEWalletPage = !showEWalletPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showEWalletPage) {
      return LoginPage(showRegisterPage: toggleScreens);
    } else {
      return RegisterPage(showEWalletPage: toggleScreens);
    }
  }
}
