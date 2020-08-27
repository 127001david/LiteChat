package com.rightpoint.lite_chat.IM.huanxin

import android.net.Uri
import android.util.Log
import com.hyphenate.EMCallBack
import com.hyphenate.chat.*
import com.rightpoint.lite_chat.IM.IMsgSender
import com.rightpoint.lite_chat.IM.IMsgSender.MessageStatusCallback
import com.rightpoint.lite_chat.IM.Msg

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/22 11:45 AM
 */
class HXSender : IMsgSender {
    private val TAG = "HXSender"
    
    override fun sendTxt(to: String, isGroup: Boolean, txt: String) {
        val message = EMMessage.createTxtSendMessage(txt, to)
        if (isGroup) {
            message.chatType = EMMessage.ChatType.GroupChat
        }
        EMClient.getInstance().chatManager().sendMessage(message)
    }

    override fun sendImg(to: String, isGroup: Boolean, original: Boolean, imgUri: Uri,
                         callback: MessageStatusCallback) {
        val message = EMMessage.createImageSendMessage(imgUri, original, to)
        if (isGroup) {
            message.chatType = EMMessage.ChatType.GroupChat
        }
        message.setMessageStatusCallback(object : EMCallBack {
            override fun onSuccess() {
                Log.d(TAG, "onSuccess: ")
                val imgBody = message.body as EMImageMessageBody
                val imgRemoteUrl = imgBody.remoteUrl
                val thumbnailUrl = imgBody.thumbnailUrl
                val imgLocalUri = imgBody.localUri
                val thumbnailLocalUri = imgBody.thumbnailLocalUri()
                callback?.onSuccess(Msg()
                        .setType(Msg.TYPE_IMG)
                        .setUsername(to)
                        .setFrom(message.from)
                        .setTo(to)
                        .setTime(message.msgTime)
                        .setImgUrl(imgLocalUri.path)
                        .setThumbUrl(thumbnailLocalUri.path)
                        .setWidth(imgBody.width)
                        .setHeight(imgBody.height)
                )
            }

            override fun onError(code: Int, error: String) {
                Log.d(TAG, "onError: $error")
            }

            override fun onProgress(progress: Int, status: String) {
                Log.d(TAG, "onProgress: $progress")
            }
        })
        EMClient.getInstance().chatManager().sendMessage(message)
    }

    override fun sendVoice(to: String, isGroup: Boolean, length: Int, voiceUri: Uri,
                           callback: MessageStatusCallback) {
        val message = EMMessage.createVoiceSendMessage(voiceUri, length, to)
        if (isGroup) {
            message.chatType = EMMessage.ChatType.GroupChat
        }
        message.setMessageStatusCallback(object : EMCallBack {
            override fun onSuccess() {
                Log.d(TAG, "onSuccess: ")
                val voiceBody = message.body as EMVoiceMessageBody
                val voiceRemoteUrl = voiceBody.remoteUrl
                val voiceLocalUri = voiceBody.localUri
                callback?.onSuccess(Msg()
                        .setType(Msg.TYPE_VOICE)
                        .setUsername(to)
                        .setTo(to)
                        .setFrom(message.from)
                        .setTime(message.msgTime)
                        .setVoiceUri(voiceLocalUri.path)
                        .setLength(length)
                )
            }

            override fun onError(code: Int, error: String) {
                Log.d(TAG, "onError: $error")
            }

            override fun onProgress(progress: Int, status: String) {
                Log.d(TAG, "onProgress: $progress")
            }
        })
        EMClient.getInstance().chatManager().sendMessage(message)
    }

    override fun videoCall(to: String, isGroup: Boolean, channel: String) {
        val cmdMsg = EMMessage.createSendMessage(EMMessage.Type.CMD)
        if (isGroup) {
            cmdMsg.chatType = EMMessage.ChatType.GroupChat
        }
        val cmdBody = EMCmdMessageBody(Msg.CMD_ACTION)
        cmdMsg.setAttribute("channel", channel)
        Log.d("cmdMsg", "videoCall: $channel")
        cmdMsg.to = to
        cmdMsg.addBody(cmdBody)
        EMClient.getInstance().chatManager().sendMessage(cmdMsg)
    }

    override fun sendVideo(to: String, isGroup: Boolean, length: Int, thumbUri: Uri, videoUri: Uri) {}
    override fun sendFile(to: String, isGroup: Boolean, fileUri: Uri) {}
}