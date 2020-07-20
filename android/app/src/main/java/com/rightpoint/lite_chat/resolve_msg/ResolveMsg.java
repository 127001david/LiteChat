package com.rightpoint.lite_chat.resolve_msg;

import com.hyphenate.chat.EMMessage;
import com.hyphenate.chat.EMTextMessageBody;

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/19 10:49 AM 
 */
public class ResolveMsg {
    public static String resolveTxt(EMMessage msg) {
        StringBuilder sb = new StringBuilder("{");
        sb.append("\"from\":\"").append(msg.getFrom()).append("\",");
        sb.append("\"to\":\"").append(msg.getTo()).append("\",");
        sb.append("\"txt\":\"").append(((EMTextMessageBody) msg.getBody()).getMessage()).append("\"}");

        return sb.toString();
    }
}
