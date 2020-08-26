package com.rightpoint.lite_chat.IM.huanxin;

import androidx.annotation.NonNull;

import com.hyphenate.EMMessageListener;
import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMMessage;
import com.rightpoint.lite_chat.IM.BaseMsgReceiver;

import java.lang.ref.WeakReference;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/22 1:35 PM 
 */
public class HXReceiver extends BaseMsgReceiver {

    @Override
    public void startListening(@NonNull WeakReference<FlutterActivity> activityReference) {
        if (null == activityReference.get()) {
            return;
        }

        EMMessageListener msgListener = new EMMessageListener() {

            @Override
            public void onMessageReceived(List<EMMessage> messages) {
                // 收到消息

                if (null == activityReference.get()) {
                    return;
                }

                FlutterActivity activity = activityReference.get();
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        for (EMMessage message : messages) {
                            listener.receive(ResolveMsg.resolveMsg(message));
                        }
                    }
                });
            }

            @Override
            public void onCmdMessageReceived(List<EMMessage> messages) {
                // 收到透传消息
                for (EMMessage message : messages) {
                    listener.receiveCmd(ResolveMsg.resolveCmdMsg(message));
                }
            }

            @Override
            public void onMessageRead(List<EMMessage> messages) {
                // 收到已读回执
            }

            @Override
            public void onMessageDelivered(List<EMMessage> message) {
                // 收到已送达回执
            }

            @Override
            public void onMessageRecalled(List<EMMessage> messages) {
                // 消息被撤回
            }

            @Override
            public void onMessageChanged(EMMessage message, Object change) {
                // 消息状态变动
            }
        };

        EMClient.getInstance().chatManager().addMessageListener(msgListener);
    }
}
