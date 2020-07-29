package com.rightpoint.lite_chat.channel;

import android.app.Activity;
import android.content.SharedPreferences;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;

import com.hyphenate.EMCallBack;
import com.hyphenate.chat.EMClient;
import com.hyphenate.exceptions.HyphenateException;
import com.rightpoint.lite_chat.MainActivity;
import com.rightpoint.lite_chat.ThreadPoolProvider;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/10 3:41 PM 
 */
public class ChannelUserInfo {
    static final String CHANNEL_CALL_NATIVE = "com.rightpoint.litechat/userInfo";

    public static void connect(FlutterEngine flutterEngine, MainActivity activity) {
        new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL_CALL_NATIVE).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call,
                                     @NonNull MethodChannel.Result result) {
                if ("checkLogin".equals(call.method)) {
                    SharedPreferences sp = activity.getSharedPreferences("userInfo",
                            Activity.MODE_PRIVATE);

                    String username = sp.getString("username", null);

                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            result.success(username);
                        }
                    });
                } else if ("login".equals(call.method)) {
                    String username = call.argument("username");
                    String pwd = call.argument("pwd");

                    if (TextUtils.isEmpty(username) || TextUtils.isEmpty(pwd)) {
                        result.error("loginError", "用户名或密码为空", null);
                        return;
                    }

                    assert username != null;
                    assert pwd != null;
                    EMClient.getInstance().login(username, pwd, new EMCallBack() {
                        @Override
                        public void onSuccess() {
                            Log.d("main", "登录聊天服务器成功！");

                            SharedPreferences sp = activity.getSharedPreferences("userInfo",
                                    Activity.MODE_PRIVATE);
                            SharedPreferences.Editor edit = sp.edit();

                            String key = call.argument("key");
                            String value = call.argument("value");

                            edit.putString("username", username);
                            edit.apply();

                            activity.runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    EMClient.getInstance().groupManager().loadAllGroups();
                                    EMClient.getInstance().chatManager().loadAllConversations();

                                    result.success("success");
                                }
                            });
                        }

                        @Override
                        public void onProgress(int progress, String status) {

                        }

                        @Override
                        public void onError(int code, String message) {
                            Log.d("main", "登录聊天服务器失败！");

                            activity.runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    result.error("loginError", message, null);
                                }
                            });
                        }
                    });
                } else if ("register".equals(call.method)) {
                    String username = call.argument("username");
                    String pwd = call.argument("pwd");

                    ThreadPoolProvider.extute(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                EMClient.getInstance().createAccount(username, pwd);

                                Log.d("main", "注册成功！");

                                SharedPreferences sp = activity.getSharedPreferences("userInfo",
                                        Activity.MODE_PRIVATE);
                                SharedPreferences.Editor edit = sp.edit();

                                String key = call.argument("key");
                                String value = call.argument("value");

                                edit.putString("username", username);
                                edit.apply();

                                activity.runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        result.success("success");
                                    }
                                });
                            } catch (HyphenateException e) {
                                e.printStackTrace();
                                Log.d("main", "注册失败！");

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
