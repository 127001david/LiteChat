package com.rightpoint.lite_chat.channel

import android.content.Intent
import com.rightpoint.lite_chat.MainActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/8/17 10:15 AM
 */
object ChannelCallNative {
    const val CHANNEL_CALL_NATIVE = "com.rightpoint.litechat/call_native"
    @JvmStatic
    fun connect(flutterEngine: FlutterEngine, activity: MainActivity) {
        MethodChannel(flutterEngine.dartExecutor, CHANNEL_CALL_NATIVE).setMethodCallHandler { call, result ->
            when (call.method) {
                "simulate_home" -> {
                    val intent = Intent(Intent.ACTION_MAIN)
                    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    intent.addCategory(Intent.CATEGORY_HOME)
                    activity.runOnUiThread { activity.startActivity(intent) }
                }
            }
        }
    }
}