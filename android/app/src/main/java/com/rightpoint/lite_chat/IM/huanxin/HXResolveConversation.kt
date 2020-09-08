package com.rightpoint.lite_chat.IM.huanxin

import com.hyphenate.chat.EMClient
import com.rightpoint.lite_chat.IM.IResolveConversation
import com.rightpoint.lite_chat.IM.Msg
import java.util.*

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/24 10:29 AM
 */
class HXResolveConversation : IResolveConversation {
    // 未读消息数
    override val conversation: List<Msg>
        get() {
            val list: MutableList<Msg> = ArrayList()
            val conversations = EMClient.getInstance().chatManager().allConversations
            conversations.forEach { (username, emConversation) ->
                val msg = ResolveHXMsg.resolveMsg(username, emConversation.lastMessage)
                // 未读消息数
                msg["unreadMsg"] = emConversation.unreadMsgCount
                list.add(msg)
            }
            return list
        }

    override fun getMsgList(username: String?): List<Msg> {
        val conversation = EMClient.getInstance().chatManager().getConversation(username)
        val emMessage = conversation.lastMessage
        conversation.loadMoreMsgFromDB(emMessage.msgId, 19)
        val messages = conversation.allMessages

        // 将会话下的所有消息标记为已读
        conversation.markAllMessagesAsRead()
        val msgs: MutableList<Msg> = ArrayList()
        for (message in messages) {
            msgs.add(ResolveHXMsg.resolveMsg(message))
        }
        return msgs
    }
}