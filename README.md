# Flutter Torus Firebase JWT.

A simple plugin to get a torus key from a firebase JWT idtoken

## Example

```
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

import 'package:torus_firebase_jwt/torus_firebase_jwt.dart';

const firebaseVerifierName = 'MY_FIREBASE_VERIFIER';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final torusDirectSdk = directSDK();
  await torusDirectSdk.init(DirectSDKOptions(
      network: Network.testnet,
      verifier: firebaseVerifierName,
      enableLogging: true));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _doFirebaseLogin() async {
    try {
      final sdk = directSDK();
      final credential = await FirebaseAuth.instance.signInAnonymously();
      final token = await FirebaseAuth.instance.currentUser
          ?.getIdToken(true); //refresh token eveytime you call torus to get key
      final keyPair = await sdk.getTorusKey(
        KeyOptions(
            verifier: firebaseVerifierName,
            verifierId: credential.user!.uid,
            verifierParams: VerifierParams(verifierId: credential.user!.uid),
            idToken: token!),
      );
      print("KEYS: ${keyPair!.toMap()}");
    } catch (error) {
      print("Got torus error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Firebase Torus'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('Login Anonymous'),
            onPressed: _doFirebaseLogin,
          ),
        ),
      ),
    );
  }
}

```
