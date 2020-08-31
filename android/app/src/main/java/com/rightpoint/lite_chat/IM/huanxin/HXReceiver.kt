package com.rightpoint.lite_chat.IM.huanxin

import com.hyphenate.EMMessageListener
import com.hyphenate.chat.EMClient
import com.hyphenate.chat.EMMessage
import com.rightpoint.lite_chat.IM.BaseMsgReceiver
import io.flutter.embedding.android.FlutterActivity
import java.lang.ref.WeakReference

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/22 1:35 PM
 */
class HXReceiver : BaseMsgReceiver() {
    override fun startListening(activityReference: WeakReference<FlutterActivity>) {
        if (null == activityReference.get()) {
            return
        }
        val msgListener: EMMessageListener = object : EMMessageListener {
            override fun onMessageReceived(messages: List<EMMessage>) {
                // 收到消息
                if (null == activityReference.get()) {
                    return
                }
                val activity = activityReference.get()
                activity!!.runOnUiThread {
                    for (message in messages) {
                        val msg = ResolveHXMsg.resolveMsg(message)
                        listener?.receive(msg)
                    }
                }
            }

            override fun onCmdMessageReceived(messages: List<EMMessage>) {
                // 收到透传消息
                for (message in messages) {
                    val msg = ResolveHXMsg.resolveCmdMsg(message)
                    if (null != msg) {
                        listener?.receiveCmd(msg)
                    }
                }
            }

            override fun onMessageRead(messages: List<EMMessage>) {
                // 收到已读回执
            }

            override fun onMessageDelivered(message: List<EMMessage>) {
                // 收到已送达回执
            }

            override fun onMessageRecalled(messages: List<EMMessage>) {
                // 消息被撤回
            }

            override fun onMessageChanged(message: EMMessage, change: Any) {
                // 消息状态变动
            }
        }
        EMClient.getInstance().chatManager().addMessageListener(msgListener)
    }
}