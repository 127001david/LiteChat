package com.rightpoint.lite_chat.IM.huanxin

import android.text.TextUtils
import android.util.Log
import com.hyphenate.chat.*
import com.rightpoint.lite_chat.IM.Msg

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/19 10:49 AM
 */
object ResolveHXMsg {
    fun resolveMsg(msg: EMMessage): Msg {
        return resolveMsg(null, msg)
    }

    fun resolveMsg(username: String?, msg: EMMessage): Msg {
        val message = Msg()
                .setUsername(msg.from)
                .setFrom(msg.from)
                .setTo(msg.to)
                .setTime(msg.msgTime)
        if (!TextUtils.isEmpty(username)) {
            message.setUsername(username)
        }
        when (msg.type) {
            EMMessage.Type.TXT -> {
                message.setType(Msg.TYPE_TXT).setTxt((msg.body as EMTextMessageBody).message)
            }
            EMMessage.Type.IMAGE -> {
                val msgBody = msg.body as EMImageMessageBody
                val imgRemoteUrl = msgBody.remoteUrl
                val thumbnailUrl = msgBody.thumbnailUrl
                val imgLocalUri = msgBody.localUri
                val thumbnailLocalUri = msgBody.thumbnailLocalUri()
                message.setType(Msg.TYPE_IMG)
                        .setImgUrl(if (null == imgLocalUri) imgRemoteUrl else imgLocalUri.path)
                        .setThumbUrl(if (null == thumbnailLocalUri) thumbnailUrl else thumbnailLocalUri.path)
                        .setWidth(msgBody.width)
                        .setHeight(msgBody.height).setOriginal(msgBody.isSendOriginalImage)
            }
            EMMessage.Type.VOICE -> {
                val voiceBody = msg.body as EMVoiceMessageBody
                val voiceRemoteUrl = voiceBody.remoteUrl
                val voiceLocalUri = voiceBody.localUri
                message.setType(Msg.TYPE_VOICE)
                        .setVoiceUri(if (null == voiceLocalUri) voiceRemoteUrl else voiceLocalUri.path).setLength(voiceBody.length)
            }
            EMMessage.Type.CUSTOM -> {
                val body = msg.body as EMCustomMessageBody
                when (body.event()) {
                    Msg.TYPE_VIDEO_CALL_CANCEL -> {
                        message.setType(Msg.TYPE_VIDEO_CALL_CANCEL)
                        val channel = body.params["channel"]
                        message["channel"] = channel
                        Log.d("cmdMsg", "resolveCmdMsg: $channel")
                        return message
                    }
                    Msg.TYPE_VIDEO_CALL_REFUSE -> {
                        message.setType(Msg.TYPE_VIDEO_CALL_REFUSE)
                        val channel = body.params["channel"]
                        message["channel"] = channel
                        Log.d("cmdMsg", "resolveCmdMsg: $channel")
                        return message
                    }
                }
            }
            else -> {
            }
        }
        return message
    }

    fun resolveCmdMsg(cmdMsg: EMMessage): Msg? {
        if (cmdMsg.body is EMCmdMessageBody) {
            val body = cmdMsg.body as EMCmdMessageBody
            val message = Msg()
                    .setUsername(cmdMsg.from)
                    .setFrom(cmdMsg.from)
                    .setTo(cmdMsg.to)
                    .setTime(cmdMsg.msgTime)
            when {
                Msg.CMD_ACTION_VIDEO_CALL == body.action() -> {
                    message.setType(Msg.TYPE_VIDEO_CALL)
                    val channel = cmdMsg.getStringAttribute("channel", null) ?: return null
                    message["channel"] = channel
                    Log.d("cmdMsg", "resolveCmdMsg: $channel")
                    return message
                }
            }
        }
        return null
    }
}