@JS()
library torus;

import 'package:js/js.dart';

@JS()
@anonymous
class DirectWebSDKArgJsImpl {
  external String get baseUrl;
  external String get network;
  external bool get enableLogging;

  external factory DirectWebSDKArgJsImpl({
    String baseUrl,
    String network,
    bool enableLogging,
  });
}

@JS()
@anonymous
class VerifierParamsJs {
  // ignore: non_constant_identifier_names
  external String get verifier_id;
  external factory VerifierParamsJs({
    // ignore: non_constant_identifier_names
    String verifier_id,
  });
}

@JS()
@anonymous
class KeyOptionsJs {
  external String get verifierId;
  external String get verifier;
  external String get idToken;
  external VerifierParamsJs get verifierParams;

  external factory KeyOptionsJs({
    String verifierId,
    String verifier,
    String idToken,
    VerifierParamsJs verifierParams,
  });
}

@JS()
@anonymous
class TorusKeyPairJs {
  external String get privateKey;
  external String get publicAddress;

  external factory TorusKeyPairJs({
    String privateKey,
    String publicAddress,
  });
}

@JS('DirectWebSdk.default')
class DirectWebSdkJsImpl {
  external DirectWebSdkJsImpl(DirectWebSDKArgJsImpl options);
  external Future<void> init(InitParamsJsImp options);
  external Future<TorusKeyPairJs> getTorusKey(String verifier,
      String verifierId, VerifierParamsJs verifierParams, String idToken);
}

@JS()
@anonymous
class InitParamsJsImp {
  external bool get skipSw;

  external bool get skipInit;

  external bool get skipPrefetch;

  external factory InitParamsJsImp({
    bool skipSw,
    bool skipInit,
    bool skipPrefetch,
  });
}
