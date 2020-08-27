package com.rightpoint.lite_chat.IM

import androidx.annotation.StringDef
import java.util.*

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/24 9:31 AM
 */
class Msg : HashMap<String?, Any?>() {
    companion object {
        const val TYPE_TXT = "type_txt"
        const val TYPE_IMG = "type_img"
        const val TYPE_VOICE = "type_voice"
        const val TYPE_VIDEO = "type_video"
        const val TYPE_VIDEO_CALL = "type_video_call"
        const val CMD_ACTION = "videoCall"
    }
    
    @StringDef(TYPE_TXT, TYPE_IMG, TYPE_VOICE, TYPE_VIDEO, TYPE_VIDEO_CALL)
    @Retention(AnnotationRetention.SOURCE)
    annotation class MsgType

    /**
     * 设置所属会话对方用户名
     * @param username 用户名，可为空
     * @return 消息体
     */
    fun setUsername(username: String?): Msg {
        put("username", username)
        return this
    }

    fun getUsername() = get("username") as String?

    fun setType(@MsgType type: String): Msg {
        put("type", type)
        return this
    }

    fun getType() = get("type") as MsgType?

    fun setFrom(from: String?): Msg {
        put("from", from)
        return this
    }

    fun getFrom() = get("from") as String?

    fun setTo(to: String?): Msg {
        put("to", to)
        return this
    }

    fun getTo() = get("to") as String?

    fun setTime(time: Long): Msg {
        put("time", time)
        return this
    }

    fun getTime() = get("time") as Long

    fun setTxt(txt: String?): Msg {
        put("txt", txt)
        return this
    }

    fun getTxt() = get("txt") as String?

    fun setOriginal(original: Boolean): Msg {
        put("original", original)
        return this
    }

    fun getOriginal() = get("original") as Boolean

    fun setThumbUrl(thumbUri: String?): Msg {
        put("thumbUrl", thumbUri)
        return this
    }

    fun getThumbUrl() = get("thumbUrl") as String?

    fun setWidth(width: Int): Msg {
        put("width", width)
        return this
    }

    fun getWidth() = get("width") as Int

    fun setHeight(height: Int): Msg {
        put("height", height)
        return this
    }

    fun getHeight() = get("height") as Int

    fun setImgUrl(imgUri: String?): Msg {
        put("imgUrl", imgUri)
        return this
    }

    fun getImgUrl() = get("imgUrl") as String?

    fun setVoiceUri(voiceUri: String?): Msg {
        put("voiceUri", voiceUri)
        return this
    }

    fun getVoiceUri() = get("voiceUri") as String?

    fun setLength(length: Int): Msg {
        put("length", length)
        return this
    }

    fun getLength() = get("length") as Int

    fun setVideoUri(videoUri: String?): Msg {
        put("videoUri", videoUri)
        return this
    }

    fun getVideoUri() = get("videoUri") as String?

    fun setFileUri(fileUri: String?): Msg {
        put("fileUri", fileUri)
        return this
    }

    fun getFileUri() = get("fileUri") as String?
}