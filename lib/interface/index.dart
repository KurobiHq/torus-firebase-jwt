import 'package:flutter/material.dart';
import 'package:torus_firebase_jwt/utils.dart';

enum Network { testnet, mainnet }

class DirectSDKOptions {
  const DirectSDKOptions(
      {this.network = Network.testnet,
      this.verifier,
      this.enableLogging = false});

  factory DirectSDKOptions.fromMap(Map<String, dynamic> map) =>
      DirectSDKOptions(
        network:
            map['network'] == 'mainnet' ? Network.mainnet : Network.testnet,
        verifier: map['verifier'],
        enableLogging: map['enableLogging'],
      );

  final Network? network;
  final String? verifier;
  final bool? enableLogging;

  @override
  bool operator ==(Object other) =>
      other is DirectSDKOptions &&
      other.network == network &&
      other.verifier == verifier &&
      other.enableLogging == enableLogging;

  @override
  int get hashCode => hashValues(network, verifier, enableLogging);

  Map<String, dynamic> toMap() => <String, dynamic>{
        'network': toNetworkString(),
        'enableLogging': enableLogging,
        'verifier': verifier,
      };

  String toNetworkString() {
    switch (network) {
      case Network.testnet:
        return 'testnet';
      case Network.mainnet:
        return 'mainnet';
      default:
        return 'testnet';
    }
  }
}

class VerifierParams {
  const VerifierParams({required this.verifierId});

  factory VerifierParams.fromMap(Map<String, dynamic> map) => VerifierParams(
        verifierId: map['verifier_id'],
      );

  final String? verifierId;

  @override
  bool operator ==(Object other) =>
      other is VerifierParams && other.verifierId == verifierId;

  @override
  int get hashCode => verifierId.hashCode;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'verifier_id': verifierId,
      };
}

class TorusKeyPair {
  const TorusKeyPair({required this.privateKey, required this.publicAddress});

  factory TorusKeyPair.fromMap(Map<String, dynamic> map) => TorusKeyPair(
        privateKey: map['privateKey'],
        publicAddress: map['publicAddress'],
      );

  final String privateKey;
  final String publicAddress;

  @override
  bool operator ==(Object other) =>
      other is TorusKeyPair &&
      other.privateKey == privateKey &&
      other.publicAddress == publicAddress;

  @override
  int get hashCode => hashValues(privateKey, publicAddress);

  Map<String, dynamic> toMap() => <String, dynamic>{
        'privateKey': privateKey,
        'publicAddress': publicAddress,
      };
}

class KeyOptions {
  const KeyOptions(
      {required this.verifierId,
      required this.verifier,
      required this.idToken,
      this.verifierParams});

  factory KeyOptions.fromMap(Map<String, dynamic> map) => KeyOptions(
      verifierId: map['verifierId'],
      verifier: map['verifier'],
      idToken: map['idToken'],
      verifierParams: map['verifierParams'] != null
          ? VerifierParams.fromMap(asStringKeyedMap(map['verifierParams']))
          : null);

  final String verifierId;
  final String verifier;
  final String idToken;
  final VerifierParams? verifierParams;

  @override
  bool operator ==(Object other) =>
      other is KeyOptions &&
      other.verifier == verifier &&
      other.verifierId == verifierId &&
      other.idToken == idToken &&
      other.verifierParams == verifierParams;

  @override
  int get hashCode => hashValues(verifier, verifierId, idToken);

  Map<String, dynamic> toMap() => <String, dynamic>{
        'verifierId': verifierId,
        'verifier': verifier,
        'idToken': idToken,
        'verifierParams': verifierParams?.toMap(),
      };
}

abstract class DirectSDK {
  KeyOptions? _keyOptions;
  TorusKeyPair? _currentKeyPair;

  Future<void> init(DirectSDKOptions options);
  void setCurrentKeyPair(KeyOptions keyOptions, TorusKeyPair currentKeyPair) {
    _keyOptions = keyOptions;
    _currentKeyPair = currentKeyPair;
  }

  Future<TorusKeyPair?> getTorusKey(KeyOptions options) async {
    if (_keyOptions == options && _keyOptions != null) {
      return _currentKeyPair!;
    }
    return null;
  }
}

class TorusDirectException implements Exception {
  final TorusExceptionCode code;
  final String message;
  TorusDirectException({required this.code, required this.message});
}

enum TorusExceptionCode { unknown, network, alreadyInitialized, notInitialized }
