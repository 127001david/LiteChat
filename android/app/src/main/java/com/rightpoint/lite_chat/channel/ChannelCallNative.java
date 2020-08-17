package com.rightpoint.lite_chat.channel;

import android.content.Intent;

import androidx.annotation.NonNull;

import com.rightpoint.lite_chat.MainActivity;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/8/17 10:15 AM 
 */
public class ChannelCallNative {
    static final String CHANNEL_CALL_NATIVE = "com.rightpoint.litechat/call_native";

    public static void connect(FlutterEngine flutterEngine, MainActivity activity) {
        new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL_CALL_NATIVE).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call,
                                     @NonNull MethodChannel.Result result) {
                if ("simulate_home".equals(call.method)) {
                    Intent intent = new Intent(Intent.ACTION_MAIN);
                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    intent.addCategory(Intent.CATEGORY_HOME);

                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            activity.startActivity(intent);
                        }
                    });
                }
            }
        });
    }
}
