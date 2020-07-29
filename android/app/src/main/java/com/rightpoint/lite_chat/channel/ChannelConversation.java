package com.rightpoint.lite_chat.channel;

import androidx.annotation.NonNull;

import com.rightpoint.lite_chat.IM.IResolveConversation;
import com.rightpoint.lite_chat.IM.Msg;
import com.rightpoint.lite_chat.IM.huanxin.HXResolveConversation;
import com.rightpoint.lite_chat.MainActivity;

import java.util.List;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/23 4:00 PM 
 */
public class ChannelConversation {
    static final String CHANNEL_CONVERSATION = "com.rightpoint.litechat/conversation";

    public static void connect(FlutterEngine flutterEngine, MainActivity activity) {
        MethodChannel methodChannel = new MethodChannel(flutterEngine.getDartExecutor(),
                CHANNEL_CONVERSATION);

        IResolveConversation iResolveConversation = new HXResolveConversation();

        methodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call,
                                     @NonNull MethodChannel.Result result) {
                if ("getConversations".equals(call.method)) {
                    List<Msg> conversations = iResolveConversation.getConversation();

                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            result.success(conversations);
                        }
                    });
                } else if ("getMsgList".equals(call.method)) {
                    String username = call.argument("username");
                    List<Msg> msgList = iResolveConversation.getMsgList(username);
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            result.success(msgList);
                        }
                    });
                }
            }
        });
    }
}
