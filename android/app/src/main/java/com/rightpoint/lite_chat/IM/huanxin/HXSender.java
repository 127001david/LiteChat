package com.rightpoint.lite_chat.IM.huanxin;

import android.net.Uri;

import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMMessage;
import com.rightpoint.lite_chat.IM.IMsgSender;

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/22 11:45 AM 
 */
public class HXSender implements IMsgSender {
    @Override
    public void sendTxt(String to, boolean isGroup, String txt) {
        EMMessage message = EMMessage.createTxtSendMessage(txt, to);
        if (isGroup) {
            message.setChatType(EMMessage.ChatType.GroupChat);
        }
        EMClient.getInstance().chatManager().sendMessage(message);
    }

    @Override
    public void sendImg(String to, boolean isGroup, boolean original, Uri imgUri) {

    }

    @Override
    public void sendVoice(String to, boolean isGroup, int length, Uri voiceUri) {

    }

    @Override
    public void sendVideo(String to, boolean isGroup, int length, Uri thumbUri, Uri videoUri) {

    }

    @Override
    public void sendFile(String to, boolean isGroup, Uri fileUri) {

    }
}
