package com.rightpoint.lite_chat.channel

import android.net.Uri
import android.text.TextUtils
import com.rightpoint.lite_chat.IM.BaseMsgReceiver
import com.rightpoint.lite_chat.IM.BaseMsgReceiver.MsgReceiverListener
import com.rightpoint.lite_chat.IM.IMsgSender
import com.rightpoint.lite_chat.IM.IMsgSender.MessageStatusCallback
import com.rightpoint.lite_chat.IM.Msg
import com.rightpoint.lite_chat.IM.huanxin.HXReceiver
import com.rightpoint.lite_chat.IM.huanxin.HXSender
import com.rightpoint.lite_chat.MainActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.lang.ref.WeakReference

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/18 7:49 AM
 */
object ChannelMsg {
    const val CHANNEL_CALL_NATIVE = "com.rightpoint.litechat/msg"
    const val CHANNEL_NATIVE_CALL = "com.rightpoint.litechat/receive_msg"

    @JvmStatic
    fun connect(flutterEngine: FlutterEngine, activity: MainActivity) {
        receiveMsg(flutterEngine, activity)
        resolveSendMsg(flutterEngine, activity)
    }

    private fun resolveSendMsg(flutterEngine: FlutterEngine, activity: MainActivity) {
        val sender: IMsgSender = HXSender()
        MethodChannel(flutterEngine.dartExecutor, CHANNEL_CALL_NATIVE).setMethodCallHandler(MethodCallHandler { call, result ->
            when (call.method) {
                "sendTxt" -> {
                    val txt = call.argument<String>("txt")
                    val username = call.argument<String>("username")
                    val isGroup = call.argument<String>("isGroup")
                    if (TextUtils.isEmpty(txt) || TextUtils.isEmpty(username)) {
                        return@MethodCallHandler
                    }
                    if (username != null && txt != null) {
                        sender.sendTxt(username, !TextUtils.isEmpty(isGroup), txt)
                    }
                    activity.runOnUiThread { result.success("success") }
                }
                "sendImg" -> {
                    val imgPath = call.argument<String>("imgPath")
                    val username = call.argument<String>("username")
                    val isGroup = call.argument<String>("isGroup")
                    if (TextUtils.isEmpty(imgPath) || TextUtils.isEmpty(username)) {
                        result.error("404", "imgPath or username is null", null)
                        return@MethodCallHandler
                    }
                    if (username != null) {
                        sender.sendImg(username, !TextUtils.isEmpty(isGroup),
                                !TextUtils.isEmpty(isGroup), Uri.parse(imgPath),
                                object : MessageStatusCallback {
                                    override fun onSuccess(msg: Msg) {
                                        activity.runOnUiThread { result.success(msg) }
                                    }

                                    override fun onError(code: Int, error: String) {}
                                    override fun onProgress(progress: Int, status: String) {}
                                })
                    }
                }
                "sendVoice" -> {
                    val voicePath = call.argument<String>("voicePath")
                    val username = call.argument<String>("username")
                    val isGroup = call.argument<String>("isGroup")
                    val length = call.argument<String>("length")
                    if (TextUtils.isEmpty(voicePath) || TextUtils.isEmpty(username) || TextUtils.isEmpty(length)) {
                        result.error("404", "voicePath length or username is null", null)
                        return@MethodCallHandler
                    }
                    if (username != null) {
                        sender.sendVoice(username, !TextUtils.isEmpty(isGroup), length!!.toInt(), Uri.parse(voicePath),
                                object : MessageStatusCallback {
                                    override fun onSuccess(msg: Msg) {
                                        activity.runOnUiThread { result.success(msg) }
                                    }

                                    override fun onError(code: Int, error: String) {}
                                    override fun onProgress(progress: Int, status: String) {}
                                })
                    }
                }
                "videoCall" -> {
                    val channel = call.argument<String>("channel")
                    val username = call.argument<String>("username")
                    val isGroup = call.argument<String>("isGroup")
                    if (username != null && channel != null) {
                        sender.videoCall(username, !TextUtils.isEmpty(isGroup), channel)
                    }
                    activity.runOnUiThread { result.success(true) }
                }
                "videoCallEnd" -> {
                    // TODO: 2020/8/28 插入一条视频通话时长消息
                    val channel = call.argument<String>("channel")
                    val username = call.argument<String>("username")
                    val isGroup = call.argument<String>("isGroup")
                    activity.runOnUiThread { result.success(true) }
                }
                "videoCallCancel" -> {
                    val channel = call.argument<String>("channel")
                    val username = call.argument<String>("username")
                    val isGroup = call.argument<String>("isGroup")
                    if (username != null && channel != null) {
                        sender.videoCallCancel(username, !TextUtils.isEmpty(isGroup), channel)
                    }
                    activity.runOnUiThread { result.success(true) }
                }
                "videoCallRefuse" -> {
                    val channel = call.argument<String>("channel")
                    val username = call.argument<String>("username")
                    val isGroup = call.argument<String>("isGroup")
                    if (username != null && channel != null) {
                        sender.videoCallRefuse(username, !TextUtils.isEmpty(isGroup), channel)
                    }
                    activity.runOnUiThread { result.success(true) }
                }
            }
        })
    }

    private fun receiveMsg(flutterEngine: FlutterEngine, activity: MainActivity) {
        val methodChannel = MethodChannel(flutterEngine.dartExecutor,
                CHANNEL_NATIVE_CALL)
        val msgReceiver: BaseMsgReceiver = HXReceiver()
        msgReceiver.registerMsgListener(object : MsgReceiverListener {
            override fun receive(msg: Msg) {
                activity.runOnUiThread { methodChannel.invokeMethod("receiveMsg", msg) }
            }

            override fun receiveCmd(msg: Msg) {
                activity.runOnUiThread { methodChannel.invokeMethod("receiveCmd", msg) }
            }
        })
        val reference = WeakReference<FlutterActivity>(activity)
        msgReceiver.startListening(reference)
    }
}