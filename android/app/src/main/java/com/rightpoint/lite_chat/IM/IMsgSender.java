package com.rightpoint.lite_chat.IM;

import android.net.Uri;

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/22 11:31 AM 
 */
public interface IMsgSender {
    /**
     * 发送文本
     * @param to 接收者
     * @param isGroup 是否是群聊
     * @param txt 文本
     */
    void sendTxt(String to, boolean isGroup, String txt);

    /**
     * 发送图片
     * @param to 接收者
     * @param isGroup 是否是群聊
     * @param original 是否原图，true 为原图，false 压缩图小于100k
     * @param imgUri 图片Uri
     * @param callback 消息发送状态回调
     */
    void sendImg(String to, boolean isGroup, boolean original, Uri imgUri,
                MessageStatusCallback callback);

    /**
     * 发送语音
     * @param to 接收者
     * @param isGroup 是否是群聊
     * @param length 语音时长 秒
     * @param voiceUri 语音文件Uri
     */
    void sendVoice(String to, boolean isGroup, int length, Uri voiceUri);

    /**
     * 发送视频
     * @param to 接收者
     * @param isGroup 是否是群聊
     * @param length 视频时长 秒
     * @param thumbUri 封面图Uri
     * @param videoUri 视频文件Uri
     */
    void sendVideo(String to, boolean isGroup, int length, Uri thumbUri, Uri videoUri);

    /**
     * 发送文件
     * @param to 接收者
     * @param isGroup 是否是群聊
     * @param fileUri 文件Uri
     */
    void sendFile(String to, boolean isGroup, Uri fileUri);

    public interface MessageStatusCallback {
        /**
         *  程序执行成功时执行回调函数。
         * @param msg 成功后的消息
         */
        void onSuccess(Msg msg);

        /**
         *  发生错误时调用的回调函数  @see EMError
         *
         *  @param code           错误代码
         *  @param error          包含文本类型的错误描述。
         */
        void onError(int code, String error);

        /**
         *  刷新进度的回调函数
         *
         *  @param progress       进度信息
         *  @param status         包含文件描述的进度信息, 如果SDK没有提供，结果可能是"", 或者null。
         *
         */
        void onProgress(int progress, String status);
    }
}
