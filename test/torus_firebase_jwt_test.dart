import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:torus_firebase_jwt/torus_firebase_jwt.dart';

void main() {
  const MethodChannel channel = MethodChannel('torus_firebase_jwt');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await TorusFirebaseJwt.platformVersion, '42');
  });
}
