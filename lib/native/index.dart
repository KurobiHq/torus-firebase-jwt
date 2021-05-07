import 'package:torus_firebase_jwt/interface/index.dart';
import 'package:torus_firebase_jwt/native/direct_sdk_native.dart';

DirectSDK directSDK() {
  return DirectSDKNative.instance;
}
