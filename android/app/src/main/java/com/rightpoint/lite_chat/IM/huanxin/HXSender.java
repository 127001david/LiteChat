package com.rightpoint.lite_chat.IM.huanxin;

import android.net.Uri;
import android.util.Log;

import com.hyphenate.EMCallBack;
import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMImageMessageBody;
import com.hyphenate.chat.EMMessage;
import com.hyphenate.chat.EMVoiceMessageBody;
import com.rightpoint.lite_chat.IM.IMsgSender;
import com.rightpoint.lite_chat.IM.Msg;

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/22 11:45 AM 
 */
public class HXSender implements IMsgSender {
    private final String TAG = "HXSender";

    @Override
    public void sendTxt(String to, boolean isGroup, String txt) {
        EMMessage message = EMMessage.createTxtSendMessage(txt, to);
        if (isGroup) {
            message.setChatType(EMMessage.ChatType.GroupChat);
        }
        EMClient.getInstance().chatManager().sendMessage(message);
    }

    @Override
    public void sendImg(String to, boolean isGroup, boolean original, Uri imgUri,
                        MessageStatusCallback callback) {
        EMMessage message = EMMessage.createImageSendMessage(imgUri, original, to);
        if (isGroup) {
            message.setChatType(EMMessage.ChatType.GroupChat);
        }

        message.setMessageStatusCallback(new EMCallBack() {
            @Override
            public void onSuccess() {
                Log.d(TAG, "onSuccess: ");

                EMImageMessageBody imgBody = (EMImageMessageBody) message.getBody();
                String imgRemoteUrl = imgBody.getRemoteUrl();
                String thumbnailUrl = imgBody.getThumbnailUrl();
                Uri imgLocalUri = imgBody.getLocalUri();
                Uri thumbnailLocalUri = imgBody.thumbnailLocalUri();

                if (null != callback) {
                    callback.onSuccess(new Msg()
                            .setType(Msg.TYPE_IMG)
                            .setUsername(to)
                            .setFrom(message.getFrom())
                            .setTo(to)
                            .setTime(message.getMsgTime())
                            .setImgUrl(imgLocalUri.getPath())
                            .setThumbUrl(thumbnailLocalUri.getPath())
                            .setWidth(imgBody.getWidth())
                            .setHeight(imgBody.getHeight())
                    );
                }
            }

            @Override
            public void onError(int code, String error) {
                Log.d(TAG, "onError: " + error);
            }

            @Override
            public void onProgress(int progress, String status) {
                Log.d(TAG, "onProgress: " + progress);
            }
        });

        EMClient.getInstance().chatManager().sendMessage(message);

    }

    @Override
    public void sendVoice(String to, boolean isGroup, int length, Uri voiceUri,
                          MessageStatusCallback callback) {
        EMMessage message = EMMessage.createVoiceSendMessage(voiceUri, length, to);
        if (isGroup) {
            message.setChatType(EMMessage.ChatType.GroupChat);
        }

        message.setMessageStatusCallback(new EMCallBack() {
            @Override
            public void onSuccess() {
                Log.d(TAG, "onSuccess: ");
                EMVoiceMessageBody voiceBody = (EMVoiceMessageBody) message.getBody();
                String voiceRemoteUrl = voiceBody.getRemoteUrl();
                Uri voiceLocalUri = voiceBody.getLocalUri();

                if (null != callback) {
                    callback.onSuccess(new Msg()
                            .setType(Msg.TYPE_VOICE)
                            .setUsername(to)
                            .setTo(to)
                            .setFrom(message.getFrom())
                            .setTime(message.getMsgTime())
                            .setVoiceUri(voiceLocalUri.getPath())
                            .setLength(length)
                    );
                }
            }

            @Override
            public void onError(int code, String error) {
                Log.d(TAG, "onError: " + error);
            }

            @Override
            public void onProgress(int progress, String status) {
                Log.d(TAG, "onProgress: " + progress);
            }
        });

        EMClient.getInstance().chatManager().sendMessage(message);
    }

    @Override
    public void sendVideo(String to, boolean isGroup, int length, Uri thumbUri, Uri videoUri) {

    }

    @Override
    public void sendFile(String to, boolean isGroup, Uri fileUri) {

    }
}
