// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:js_util';

import 'package:torus_firebase_jwt/interface/index.dart';
import 'package:torus_firebase_jwt/web/torus.dart';

class DirectSDKWeb extends DirectSDK {
  DirectSDKWeb._();

  static DirectSDKWeb instance = DirectSDKWeb._();

  late DirectWebSdkJsImpl _directWebSdkJsImpl;
  Future<void> init(DirectSDKOptions options) async {
    try {
      _directWebSdkJsImpl = DirectWebSdkJsImpl(
        DirectWebSDKArgJsImpl(
            baseUrl: '${window.location.origin}/auth',
            network: options.toNetworkString(),
            enableLogging: options.enableLogging ?? false),
      );
      await _directWebSdkJsImpl.init(InitParamsJsImp(
        skipSw: true,
      ));
    } catch (error) {
      throw TorusDirectException(
          code: TorusExceptionCode.unknown, message: '$error');
    }
  }

  Future<TorusKeyPair?> getTorusKey(KeyOptions options) async {
    try {
      final key = await super.getTorusKey(options);
      if (key != null) {
        return key;
      }
      final torusKeyJs = await promiseToFuture(
        _directWebSdkJsImpl.getTorusKey(options.verifier, options.verifierId,
            VerifierParamsJs(verifier_id: options.verifierId), options.idToken),
      );
      final currentKeyPair = TorusKeyPair(
          privateKey: torusKeyJs.privateKey,
          publicAddress: torusKeyJs.publicAddress);
      setCurrentKeyPair(options, currentKeyPair);
      return currentKeyPair;
    } catch (error) {
      throw TorusDirectException(
          code: TorusExceptionCode.unknown, message: '$error');
    }
  }
}
