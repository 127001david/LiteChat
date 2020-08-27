package com.rightpoint.lite_chat.channel

import com.hyphenate.chat.EMClient
import com.rightpoint.lite_chat.IM.IResolveConversation
import com.rightpoint.lite_chat.IM.huanxin.HXResolveConversation
import com.rightpoint.lite_chat.MainActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/23 4:00 PM
 */
object ChannelConversation {
    const val CHANNEL_CONVERSATION = "com.rightpoint.litechat/conversation"

    @JvmStatic
    fun connect(flutterEngine: FlutterEngine, activity: MainActivity) {
        val methodChannel = MethodChannel(flutterEngine.dartExecutor,
                CHANNEL_CONVERSATION)
        val iResolveConversation: IResolveConversation = HXResolveConversation()
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getConversations" -> {
                    val conversations = iResolveConversation.conversation
                    activity.runOnUiThread { result.success(conversations) }
                }
                "getMsgList" -> {
                    val username = call.argument<String>("username")
                    val msgList = iResolveConversation.getMsgList(username)
                    activity.runOnUiThread { result.success(msgList) }
                }
                "markAllMessagesAsRead" -> {
                    val username = call.argument<String>("username")
                    val conversation = EMClient.getInstance().chatManager().getConversation(username)
                    conversation?.markAllMessagesAsRead()
                    activity.runOnUiThread { result.success(null) }
                }
            }
        }
    }
}