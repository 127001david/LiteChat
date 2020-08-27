package com.rightpoint.lite_chat.channel

import android.util.Log
import com.hyphenate.chat.EMClient
import com.hyphenate.exceptions.HyphenateException
import com.rightpoint.lite_chat.MainActivity
import com.rightpoint.lite_chat.ThreadPoolProvider
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/11 3:27 PM
 */
object ChannelFriend {
    const val CHANNEL_CALL_NATIVE = "com.rightpoint.litechat/friend"
    @JvmStatic
    fun connect(flutterEngine: FlutterEngine, activity: MainActivity) {
        MethodChannel(flutterEngine.dartExecutor, CHANNEL_CALL_NATIVE).setMethodCallHandler { call, result ->
            if ("addFriend" == call.method) {
                val username = call.argument<String>("username")
                val reason = call.argument<String>("reason")
                ThreadPoolProvider.execute {
                    try {
                        EMClient.getInstance().contactManager().addContact(username,
                                reason)
                        Log.d("addContact", "addContact: success")
                        activity.runOnUiThread { result.success(true) }
                    } catch (e: HyphenateException) {
                        e.printStackTrace()
                        activity.runOnUiThread { result.error("loginError", e.message, null) }
                    }
                }
            } else if ("getFriends" == call.method) {
                ThreadPoolProvider.execute {
                    try {
                        val friends = EMClient.getInstance().contactManager().allContactsFromServer
                        Log.d("getFriends", "run: $friends")
                        activity.runOnUiThread { result.success(friends) }
                    } catch (e: HyphenateException) {
                        e.printStackTrace()
                        activity.runOnUiThread { result.error("loginError", e.message, null) }
                    }
                }
            }
        }
    }
}