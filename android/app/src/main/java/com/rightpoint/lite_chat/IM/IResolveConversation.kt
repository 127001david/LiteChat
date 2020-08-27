package com.rightpoint.lite_chat.IM

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/24 10:27 AM
 */
interface IResolveConversation {
    /**
     * 获取本地会话列表
     * @return 本地会话列表，每一项都是会话的最新一条消息
     */
    val conversation: List<Msg>

    /**
     * 获取本地聊天记录
     * @param username 聊天对象
     * @return 聊天记录列表
     */
    fun getMsgList(username: String?): List<Msg>
}