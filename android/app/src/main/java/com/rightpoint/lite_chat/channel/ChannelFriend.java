package com.rightpoint.lite_chat.channel;

import android.util.Log;

import androidx.annotation.NonNull;

import com.hyphenate.chat.EMClient;
import com.hyphenate.exceptions.HyphenateException;
import com.rightpoint.lite_chat.MainActivity;
import com.rightpoint.lite_chat.ThreadPoolProvider;

import java.util.List;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/11 3:27 PM 
 */
public class ChannelFriend {
    static final String CHANNEL_CALL_NATIVE = "com.rightpoint.litechat/friend";

    public static void connect(FlutterEngine flutterEngine, MainActivity activity) {
        new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL_CALL_NATIVE).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call,
                                     @NonNull MethodChannel.Result result) {
                if ("addFriend".equals(call.method)) {
                    String username = call.argument("username");
                    String reason = call.argument("reason");

                    ThreadPoolProvider.extute(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                EMClient.getInstance().contactManager().addContact(username,
                                        reason);

                                Log.d("addContact", "addContact: success");

                                activity.runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        result.success(true);
                                    }
                                });
                            } catch (HyphenateException e) {
                                e.printStackTrace();

                                activity.runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        result.error("loginError", e.getMessage(), null);
                                    }
                                });
                            }
                        }
                    });
                } else if ("getFriends".equals(call.method)) {
                    ThreadPoolProvider.extute(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                List<String> friends =
                                        EMClient.getInstance().contactManager().getAllContactsFromServer();

                                Log.d("getFriends", "run: "+friends.toString());

                                activity.runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        result.success(friends);
                                    }
                                });
                            } catch (HyphenateException e) {
                                e.printStackTrace();

                                activity.runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        result.error("loginError", e.getMessage(), null);
                                    }
                                });
                            }
                        }
                    });
                }
            }
        });
    }
}
