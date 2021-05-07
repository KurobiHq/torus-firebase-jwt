import 'package:torus_firebase_jwt/interface/index.dart';
import 'package:torus_firebase_jwt/web/direct_sdk_web.dart';

DirectSDK directSDK() {
  return DirectSDKWeb.instance;
}
