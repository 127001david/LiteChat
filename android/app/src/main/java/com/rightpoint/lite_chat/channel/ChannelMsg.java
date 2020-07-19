package com.rightpoint.lite_chat.channel;

import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.hyphenate.EMMessageListener;
import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMMessage;
import com.rightpoint.lite_chat.MainActivity;

import java.util.List;

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

    public static void connect(MainActivity activity) {
        receiveMsg(activity);

        new MethodChannel(activity.getFlutterView(), CHANNEL_CALL_NATIVE).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
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

                    assert txt != null;
                    assert username != null;

                    EMMessage message = EMMessage.createTxtSendMessage(txt, username);
                    if (!TextUtils.isEmpty(isGroup)) {
                        message.setChatType(EMMessage.ChatType.GroupChat);
                    }
                    EMClient.getInstance().chatManager().sendMessage(message);

                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            result.success("success");
                        }
                    });
                }
            }
        });
    }

    private static void receiveMsg(MainActivity activity) {
        MethodChannel methodChannel = new MethodChannel(activity.getFlutterView(),
                CHANNEL_NATIVE_CALL);

        EMMessageListener msgListener = new EMMessageListener() {

            @Override
            public void onMessageReceived(List<EMMessage> messages) {
                //收到消息
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        methodChannel.invokeMethod("receiveTxtMsg", messages.get(0).toString());
                    }
                });
            }

            @Override
            public void onCmdMessageReceived(List<EMMessage> messages) {
                //收到透传消息
            }

            @Override
            public void onMessageRead(List<EMMessage> messages) {
                //收到已读回执
            }

            @Override
            public void onMessageDelivered(List<EMMessage> message) {
                //收到已送达回执
            }

            @Override
            public void onMessageRecalled(List<EMMessage> messages) {
                //消息被撤回
            }

            @Override
            public void onMessageChanged(EMMessage message, Object change) {
                //消息状态变动
            }
        };
        EMClient.getInstance().chatManager().addMessageListener(msgListener);
    }
}
