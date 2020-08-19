package com.rightpoint.lite_chat.IM.huanxin;

import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMConversation;
import com.hyphenate.chat.EMMessage;
import com.rightpoint.lite_chat.IM.IResolveConversation;
import com.rightpoint.lite_chat.IM.Msg;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.BiConsumer;

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/24 10:29 AM 
 */
public class HXResolveConversation implements IResolveConversation {
    @Override
    public List<Msg> getConversation() {
        List<Msg> list = new ArrayList<>();
        Map<String, EMConversation> conversations =
                EMClient.getInstance().chatManager().getAllConversations();

        conversations.forEach(new BiConsumer<String, EMConversation>() {
            @Override
            public void accept(String username, EMConversation emConversation) {
                Msg msg = ResolveMsg.resolveMsg(username, emConversation.getLastMessage());
                // 未读消息数
                msg.put("unreadMsg", emConversation.getUnreadMsgCount());
                list.add(msg);
            }
        });

        return list;
    }

    @Override
    public List<Msg> getMsgList(String username) {
        EMConversation conversation =
                EMClient.getInstance().chatManager().getConversation(username);
        EMMessage emMessage = conversation.getLastMessage();
        conversation.loadMoreMsgFromDB(emMessage.getMsgId(), 19);
        List<EMMessage> messages = conversation.getAllMessages();

        // 将会话下的所有消息标记为已读
        conversation.markAllMessagesAsRead();

        List<Msg> msgs = new ArrayList<>();
        for (EMMessage message : messages) {
            msgs.add(ResolveMsg.resolveMsg(message));
        }

        return msgs;
    }
}
