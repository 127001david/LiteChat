package com.rightpoint.lite_chat.channel;

import android.net.Uri;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.rightpoint.lite_chat.IM.BaseMsgReceiver;
import com.rightpoint.lite_chat.IM.IMsgSender;
import com.rightpoint.lite_chat.IM.Msg;
import com.rightpoint.lite_chat.IM.huanxin.HXReceiver;
import com.rightpoint.lite_chat.IM.huanxin.HXSender;
import com.rightpoint.lite_chat.MainActivity;

import java.lang.ref.WeakReference;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/18 7:49 AM 
 */
public class ChannelMsg {
    static final String CHANNEL_CALL_NATIVE = "com.rightpoint.litechat/msg";
    static final String CHANNEL_NATIVE_CALL = "com.rightpoint.litechat/receive_msg";

    public static void connect(FlutterEngine flutterEngine, MainActivity activity) {
        receiveMsg(flutterEngine, activity);
        resolveSendMsg(flutterEngine, activity);
    }

    private static void resolveSendMsg(FlutterEngine flutterEngine, MainActivity activity) {
        IMsgSender sender = new HXSender();

        new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL_CALL_NATIVE).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call,
                                     @NonNull MethodChannel.Result result) {
                if ("sendTxt".equals(call.method)) {
                    String txt = call.argument("txt");
                    String username = call.argument("username");
                    String isGroup = call.argument("isGroup");

                    if (TextUtils.isEmpty(txt) || TextUtils.isEmpty(username)) {
                        return;
                    }

                    sender.sendTxt(username, !TextUtils.isEmpty(isGroup), txt);

                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            result.success("success");
                        }
                    });
                } else if ("sendImg".equals(call.method)) {
                    String imgPath = call.argument("imgPath");
                    String username = call.argument("username");
                    String isGroup = call.argument("isGroup");

                    if (TextUtils.isEmpty(imgPath) || TextUtils.isEmpty(username)) {
                        result.error("404", "imgPath or username is null", null);
                        return;
                    }

                    sender.sendImg(username, !TextUtils.isEmpty(isGroup),
                            !TextUtils.isEmpty(isGroup), Uri.parse(imgPath),
                            new IMsgSender.MessageStatusCallback() {
                                @Override
                                public void onSuccess(Msg msg) {
                                    activity.runOnUiThread(new Runnable() {
                                        @Override
                                        public void run() {
                                            result.success(msg);
                                        }
                                    });
                                }

                                @Override
                                public void onError(int code, String error) {

                                }

                                @Override
                                public void onProgress(int progress, String status) {

                                }
                            });
                } else if ("sendVoice".equals(call.method)) {
                    String voicePath = call.argument("voicePath");
                    String username = call.argument("username");
                    String isGroup = call.argument("isGroup");
                    String length = call.argument("length");

                    if (TextUtils.isEmpty(voicePath) || TextUtils.isEmpty(username) || TextUtils.isEmpty(length)) {
                        result.error("404", "voicePath length or username is null", null);
                        return;
                    }

                    assert length != null;
                    sender.sendVoice(username, !TextUtils.isEmpty(isGroup),
                            Integer.parseInt(length), Uri.parse(voicePath),
                            new IMsgSender.MessageStatusCallback() {
                        @Override
                        public void onSuccess(Msg msg) {
                            activity.runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    result.success(msg);
                                }
                            });
                        }

                        @Override
                        public void onError(int code, String error) {

                        }

                        @Override
                        public void onProgress(int progress, String status) {

                        }
                    });
                }
            }
        });
    }

    private static void receiveMsg(FlutterEngine flutterEngine, MainActivity activity) {
        MethodChannel methodChannel = new MethodChannel(flutterEngine.getDartExecutor(),
                ChannelMsg.CHANNEL_NATIVE_CALL);

        BaseMsgReceiver msgReceiver = new HXReceiver();

        msgReceiver.registerMsgListener(new BaseMsgReceiver.MsgReceiverListener() {

            @Override
            public void receive(Msg msg) {
                methodChannel.invokeMethod("receiveMsg", msg);
            }
        });

        WeakReference<FlutterActivity> reference = new WeakReference<>(activity);

        msgReceiver.startListening(reference);
    }
}
