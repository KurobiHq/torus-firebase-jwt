import 'package:flutter/services.dart';
import 'package:torus_firebase_jwt/interface/index.dart';
import 'package:torus_firebase_jwt/utils.dart';

class DirectSDKNative extends DirectSDK {
  DirectSDKNative._();

  static DirectSDKNative instance = DirectSDKNative._();
  static MethodChannel _channel = MethodChannel('com.peerwaya.kurobi/torus');
  Future<void> init(DirectSDKOptions options) async {
    try {
      await _channel.invokeMethod('init', options.toMap());
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
      final result =
          await _channel.invokeMethod('getTorusKey', options.toMap());
      final currentKeyPair = TorusKeyPair.fromMap(asStringKeyedMap(result));
      setCurrentKeyPair(options, currentKeyPair);
      return currentKeyPair;
    } catch (error) {
      throw TorusDirectException(
          code: TorusExceptionCode.unknown, message: '$error');
    }
  }
}
