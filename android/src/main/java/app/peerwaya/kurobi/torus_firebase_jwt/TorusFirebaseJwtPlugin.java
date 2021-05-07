package app.peerwaya.kurobi.torus_firebase_jwt;

import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import org.torusresearch.torusdirect.TorusDirectSdk;
import org.torusresearch.torusdirect.types.DirectSdkArgs;
import org.torusresearch.torusdirect.types.TorusNetwork;

import java.util.HashMap;

/**
 * TorusFirebaseJwtPlugin
 */
public class TorusFirebaseJwtPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private TorusDirectSdk torusDirectSDK;
    private Context context;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.peerwaya.kurobi/torus");
        this.context = flutterPluginBinding.getApplicationContext();
        channel.setMethodCallHandler(this);
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("init")) {
            String baseUrl = call.argument("baseUrl");
            String network = call.argument("network");
            DirectSdkArgs directSdkArgs = new DirectSdkArgs(baseUrl, TorusNetwork.TESTNET);
            this.torusDirectSDK = new TorusDirectSdk(directSdkArgs, this.context);
            result.success(null);
        } else if (call.method.equals("getTorusKey")) {
            String verifier = call.argument("verifier");
            String verifierId = call.argument("verifierId");
            HashMap<String, Object> verifierParams = call.argument("verifierParams");
            String idToken = call.argument("idToken");
            HashMap<String, String> torusKeyMap = new HashMap();
            this.torusDirectSDK.getTorusKey(verifier, verifierId, verifierParams, idToken).whenComplete((torusLoginResponse, error) -> {
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        if (error != null) {
                            result.error("getTorusKeyFailed", error.getMessage(), "");
                        } else {
                            torusKeyMap.put("privateKey", torusLoginResponse.getPrivateKey());
                            torusKeyMap.put("publicAddress", torusLoginResponse.getPublicAddress());
                            result.success(torusKeyMap);
                        }
                    }
                });
            });
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
