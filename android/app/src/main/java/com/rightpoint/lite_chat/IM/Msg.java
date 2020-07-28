package com.rightpoint.lite_chat.IM;

import androidx.annotation.StringDef;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.HashMap;

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/24 9:31 AM 
 */
public class Msg extends HashMap<String, Object> {
    public static final String TYPE_TXT = "type_txt";
    public static final String TYPE_IMG = "type_img";
    public static final String TYPE_VOICE = "type_voice";
    public static final String TYPE_VIDEO = "type_video";

    @StringDef({TYPE_TXT, TYPE_IMG, TYPE_VOICE, TYPE_VIDEO})
    @Retention(RetentionPolicy.SOURCE)
    public @interface MsgType {

    }

    /**
     * 设置所属会话对方用户名
     * @param username 用户名，可为空
     * @return 消息体
     */
    public Msg setUsername(String username) {
        put("username", username);
        return this;
    }

    public String getUsername() {
        return (String) get("username");
    }

    public Msg setType(@MsgType String type) {
        put("type", type);
        return this;
    }

    public MsgType getType() {
        return (MsgType) get("type");
    }

    public Msg setFrom(String from) {
        put("from", from);
        return this;
    }

    public String getFrom() {
        return (String) get("from");
    }

    public Msg setTo(String to) {
        put("to", to);
        return this;
    }

    public String getTo() {
        return (String) get("to");
    }

    public Msg setTime(long time) {
        put("time", time);
        return this;
    }

    public long getTime() {
        return (long) get("time");
    }

    public Msg setTxt(String txt) {
        put("txt", txt);
        return this;
    }

    public String getTxt() {
        return (String) get("txt");
    }

    public Msg setOriginal(boolean original) {
        put("original", original);
        return this;
    }

    public boolean getOriginal() {
        return (boolean) get("original");
    }

    public Msg setThumbUri(String thumbUri) {
        put("thumbUri", thumbUri);
        return this;
    }

    public String getThumbUri() {
        return (String) get("thumbUri");
    }

    public Msg setImgUri(String imgUri) {
        put("imgUri", imgUri);
        return this;
    }

    public String getImgUri() {
        return (String) get("imgUri");
    }

    public Msg setVoiceUri(String voiceUri) {
        put("voiceUri", voiceUri);
        return this;
    }

    public String getVoiceUri() {
        return (String) get("voiceUri");
    }

    public Msg setLength(int length) {
        put("length", length);
        return this;
    }

    public int getLength() {
        return (int) get("length");
    }

    public Msg setVideoUri(String videoUri) {
        put("videoUri", videoUri);
        return this;
    }

    public String getVideoUri() {
        return (String) get("videoUri");
    }

    public Msg setFileUri(String fileUri) {
        put("fileUri", fileUri);
        return this;
    }

    public String getFileUri() {
        return (String) get("fileUri");
    }
}
