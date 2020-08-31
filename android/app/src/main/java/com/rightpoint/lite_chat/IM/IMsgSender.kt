package com.rightpoint.lite_chat.IM

import android.net.Uri

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/22 11:31 AM
 */
interface IMsgSender {
    /**
     * 发送文本
     * @param to 接收者
     * @param isGroup 是否是群聊
     * @param txt 文本
     */
    fun sendTxt(to: String, isGroup: Boolean, txt: String)

    /**
     * 发送图片
     * @param to 接收者
     * @param isGroup 是否是群聊
     * @param original 是否原图，true 为原图，false 压缩图小于100k
     * @param imgUri 图片Uri
     * @param callback 消息发送状态回调
     */
    fun sendImg(to: String, isGroup: Boolean, original: Boolean, imgUri: Uri,
                callback: MessageStatusCallback)

    /**
     * 发送语音
     * @param to 接收者
     * @param isGroup 是否是群聊
     * @param length 语音时长 秒
     * @param voiceUri 语音文件Uri
     * @param callback 发送状态回调
     */
    fun sendVoice(to: String, isGroup: Boolean, length: Int, voiceUri: Uri,
                  callback: MessageStatusCallback)

    /**
     * 视频通话
     * @param to 接收者
     * @param isGroup 是否是群聊
     * @param channel 视频聊天室频道
     */
    fun videoCall(to: String, isGroup: Boolean, channel: String)

    /**
     * 取消视频通话
     * @param to 接收者
     * @param isGroup 是否是群聊
     * @param channel 视频聊天室频道
     */
    fun videoCallCancel(to: String, isGroup: Boolean, channel: String)

    /**
     * 拒绝视频通话
     * @param to 接收者
     * @param isGroup 是否是群聊
     * @param channel 视频聊天室频道
     */
    fun videoCallRefuse(to: String, isGroup: Boolean, channel: String)

    /**
     * 发送视频
     * @param to 接收者
     * @param isGroup 是否是群聊
     * @param length 视频时长 秒
     * @param thumbUri 封面图Uri
     * @param videoUri 视频文件Uri
     */
    fun sendVideo(to: String, isGroup: Boolean, length: Int, thumbUri: Uri, videoUri: Uri)

    /**
     * 发送文件
     * @param to 接收者
     * @param isGroup 是否是群聊
     * @param fileUri 文件Uri
     */
    fun sendFile(to: String, isGroup: Boolean, fileUri: Uri)
    interface MessageStatusCallback {
        /**
         * 程序执行成功时执行回调函数。
         * @param msg 成功后的消息
         */
        fun onSuccess(msg: Msg)

        /**
         * 发生错误时调用的回调函数  @see EMError
         *
         * @param code           错误代码
         * @param error          包含文本类型的错误描述。
         */
        fun onError(code: Int, error: String)

        /**
         * 刷新进度的回调函数
         *
         * @param progress       进度信息
         * @param status         包含文件描述的进度信息, 如果SDK没有提供，结果可能是"", 或者null。
         */
        fun onProgress(progress: Int, status: String)
    }
}