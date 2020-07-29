package com.rightpoint.lite_chat.IM;

import java.lang.ref.WeakReference;

import io.flutter.embedding.android.FlutterActivity;

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/22 11:46 AM 
 */
public abstract class BaseMsgReceiver {
    protected MsgReceiverListener listener;

    /**
     * 开启接收消息
     * @param activity 用于获取 MethodChannel 和上下文切换
     */
    public abstract void startListening(WeakReference<FlutterActivity> activity);

    public void registerMsgListener(MsgReceiverListener listener) {
        this.listener = listener;
    }

    public void unRegisterMsgListener() {
        listener = null;
    }

    public interface MsgReceiverListener {
        /**
         * 消息
         * @param msg 消息体，是一个 HashMap<String, Object>
         */
        void receive(Msg msg);
    }
}
