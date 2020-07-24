package com.rightpoint.lite_chat.IM.huanxin;

import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMConversation;
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
                list.add(msg);
            }
        });

        return list;
    }
}
