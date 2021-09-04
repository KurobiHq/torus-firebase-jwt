import Flutter
import UIKit
import TorusSwiftDirectSDK

public class SwiftTorusFirebaseJwtPlugin: NSObject, FlutterPlugin {
  var torusSwiftDirectSDK: TorusSwiftDirectSDK? = nil
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.peerwaya.kurobi/torus", binaryMessenger: registrar.messenger())
    let instance = SwiftTorusFirebaseJwtPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "init":
            guard let args = call.arguments as? Dictionary<String, Any> else {
              result("iOS could not recognize flutter arguments in method: (sendParams)")
              break
            }
            let network : String  =  args["network"]! as! String
            let verifier : String  =  args["verifier"]! as! String
            let enableLogging : Bool  =  args["enableLogging"]! as! Bool
            self.torusSwiftDirectSDK = TorusSwiftDirectSDK(aggregateVerifierType:.singleIdVerifier,
                                                            aggregateVerifierName: verifier,
                                                            subVerifierDetails: [],
                                                            network: network == "mainnet" ? .MAINNET : .ROPSTEN,
                                                            loglevel: enableLogging ? .trace : .none)
            result(true)

        case "getTorusKey":
            guard let args = call.arguments as? Dictionary<String, Any> else {
              result("iOS could not recognize flutter arguments in method: (sendParams)")
              break
            }
            let verifier : String  =  args["verifier"] as! String
            let verifierId : String =  args["verifierId"] as! String
            let idToken : String  =  args["idToken"] as! String
            self.torusSwiftDirectSDK!.getTorusKey(verifier: verifier, verifierId:verifierId,  idToken:idToken).done{ data in
              result(data)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
  
}
