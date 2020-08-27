package com.rightpoint.lite_chat.IM

import io.flutter.embedding.android.FlutterActivity
import java.lang.ref.WeakReference

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/22 11:46 AM
 */
abstract class BaseMsgReceiver {
    protected var listener: MsgReceiverListener? = null

    /**
     * 开启接收消息
     * @param activityReference 用于获取 MethodChannel 和上下文切换
     */
    abstract fun startListening(activityReference: WeakReference<FlutterActivity>)
    fun registerMsgListener(listener: MsgReceiverListener) {
        this.listener = listener
    }

    fun unRegisterMsgListener() {
        listener = null
    }

    interface MsgReceiverListener {
        /**
         * 消息
         * @param msg 消息体，是一个 HashMap<String></String>, Object>
         */
        fun receive(msg: Msg)

        /**
         * 透传消息
         * @param msg 消息体，是一个 HashMap<String></String>, Object> 里面包含会话双方信息及一条指令和多条参数
         */
        fun receiveCmd(msg: Msg)
    }
}