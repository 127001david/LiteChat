package com.rightpoint.lite_chat.IM.huanxin;

import android.text.TextUtils;

import com.hyphenate.chat.EMMessage;
import com.hyphenate.chat.EMTextMessageBody;
import com.rightpoint.lite_chat.IM.Msg;

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/19 10:49 AM 
 */
public class ResolveMsg {
    public static Msg resolveMsg(EMMessage msg) {
        return resolveMsg(null, msg);
    }

    public static Msg resolveMsg(String username, EMMessage msg) {
        Msg message = new Msg()
                .setUsername(msg.getFrom())
                .setFrom(msg.getFrom())
                .setTo(msg.getTo())
                .setTime(msg.getMsgTime());

        if (!TextUtils.isEmpty(username)) {
            message.setUsername(username);
        }

        switch (msg.getType()) {
            case TXT: {
                message.setType(Msg.TYPE_TXT).setTxt(((EMTextMessageBody) msg.getBody()).getMessage());

                break;
            }
            case IMAGE: {
                break;
            }
            default:
                break;
        }

        return message;
    }
}
