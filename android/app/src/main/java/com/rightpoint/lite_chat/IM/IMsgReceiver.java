package com.rightpoint.lite_chat.IM;

import android.net.Uri;

import java.lang.ref.WeakReference;

import io.flutter.app.FlutterActivity;

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/22 11:46 AM 
 */
public abstract class IMsgReceiver {
    protected MsgReceiverListener listener;

    /**
     * 开启接收消息
     * @param activity 用于获取 MethodChannel 和上下文切换
     */
    public abstract void startListening(WeakReference<FlutterActivity> activity);

    public void registerMsgListener(MsgReceiverListener listener) {
        this.listener = listener;
    }

    public void unRegisterMsgListener() {
        listener = null;
    }

    public interface MsgReceiverListener {
        /**
         * 文本消息
         * @param from 发送者
         * @param txt 文本
         */
        void receiveTxt(String from, String txt);

        /**
         * 图片消息
         * @param from 发送者
         * @param original 是否是原图，true 是
         * @param thumbUri 封面图Uri
         * @param imgUri 图片文件Uri
         */
        void receiveImg(String from, boolean original, Uri thumbUri, Uri imgUri);

        /**
         * 语音消息
         * @param from 发送者
         * @param length 语音时长 秒
         * @param voiceUri 语音文件Uri
         */
        void receiveVoice(String from, int length, Uri voiceUri);

        /**
         * 视频消息
         * @param from 发送者
         * @param length 视频长度 秒
         * @param thumbUri 封面图Uri
         * @param videoUri 视频文件Uri
         */
        void receiveVideo(String from, int length, Uri thumbUri, Uri videoUri);

        /**
         * 文件消息
         * @param from 发送者
         * @param fileUri 文件Uri
         */
        void receiveFile(String from, Uri fileUri);
    }
}
