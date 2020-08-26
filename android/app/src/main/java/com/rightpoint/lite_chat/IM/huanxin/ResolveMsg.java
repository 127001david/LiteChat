package com.rightpoint.lite_chat.IM.huanxin;

import android.net.Uri;
import android.text.TextUtils;
import android.util.Log;

import com.hyphenate.chat.EMCmdMessageBody;
import com.hyphenate.chat.EMImageMessageBody;
import com.hyphenate.chat.EMMessage;
import com.hyphenate.chat.EMTextMessageBody;
import com.hyphenate.chat.EMVoiceMessageBody;
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
                EMImageMessageBody msgBody = (EMImageMessageBody) msg.getBody();
                String imgRemoteUrl = msgBody.getRemoteUrl();
                String thumbnailUrl = msgBody.getThumbnailUrl();
                Uri imgLocalUri = msgBody.getLocalUri();
                Uri thumbnailLocalUri = msgBody.thumbnailLocalUri();

                message.setType(Msg.TYPE_IMG)
                        .setImgUrl(null == imgLocalUri ? imgRemoteUrl : imgLocalUri.getPath())
                        .setThumbUrl(null == thumbnailLocalUri ? thumbnailUrl :
                                thumbnailLocalUri.getPath())
                        .setWidth(msgBody.getWidth())
                        .setHeight(msgBody.getHeight())
                        .setOriginal(msgBody.isSendOriginalImage());
                break;
            }
            case VOICE: {
                EMVoiceMessageBody voiceBody = (EMVoiceMessageBody) msg.getBody();
                String voiceRemoteUrl = voiceBody.getRemoteUrl();
                Uri voiceLocalUri = voiceBody.getLocalUri();

                message.setType(Msg.TYPE_VOICE)
                        .setVoiceUri(null == voiceLocalUri ? voiceRemoteUrl :
                                voiceLocalUri.getPath())
                        .setLength(voiceBody.getLength());

                break;
            }
            default:
                break;
        }

        return message;
    }

    public static Msg resolveCmdMsg(EMMessage cmdMsg) {
        if (cmdMsg.getBody() instanceof EMCmdMessageBody) {
            EMCmdMessageBody body = (EMCmdMessageBody) cmdMsg.getBody();

            Msg message = new Msg()
                    .setUsername(cmdMsg.getFrom())
                    .setFrom(cmdMsg.getFrom())
                    .setTo(cmdMsg.getTo())
                    .setTime(cmdMsg.getMsgTime());

            if (Msg.CMD_ACTION.equals(body.action())) {
                message.setType(Msg.TYPE_VIDEO_CALL);
                message.put("channel", body.getParams().get("channel"));
                Log.d("cmdMsg", "resolveCmdMsg: " + body.getParams().get("channel"));

                return message;
            }
        }

        return null;
    }
}
