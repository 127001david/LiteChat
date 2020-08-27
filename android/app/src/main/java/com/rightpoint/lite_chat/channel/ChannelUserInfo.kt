package com.rightpoint.lite_chat.channel

import android.app.Activity
import android.text.TextUtils
import android.util.Log
import com.hyphenate.EMCallBack
import com.hyphenate.chat.EMClient
import com.hyphenate.exceptions.HyphenateException
import com.rightpoint.lite_chat.MainActivity
import com.rightpoint.lite_chat.ThreadPoolProvider
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/**
 * Description：
 * @author Wonder Wei
 * Create date：2020/7/10 3:41 PM
 */
object ChannelUserInfo {
    const val CHANNEL_CALL_NATIVE = "com.rightpoint.litechat/userInfo"
    @JvmStatic
    fun connect(flutterEngine: FlutterEngine, activity: MainActivity) {
        MethodChannel(flutterEngine.dartExecutor, CHANNEL_CALL_NATIVE).setMethodCallHandler(MethodCallHandler { call, result ->
            if ("checkLogin" == call.method) {
                val sp = activity.getSharedPreferences("userInfo",
                        Activity.MODE_PRIVATE)
                val username = sp.getString("username", null)
                activity.runOnUiThread { result.success(username) }
            } else if ("login" == call.method) {
                val username = call.argument<String>("username")
                val pwd = call.argument<String>("pwd")
                if (TextUtils.isEmpty(username) || TextUtils.isEmpty(pwd)) {
                    result.error("loginError", "用户名或密码为空", null)
                    return@MethodCallHandler
                }
                assert(username != null)
                assert(pwd != null)
                EMClient.getInstance().login(username, pwd, object : EMCallBack {
                    override fun onSuccess() {
                        Log.d("main", "登录聊天服务器成功！")
                        val sp = activity.getSharedPreferences("userInfo",
                                Activity.MODE_PRIVATE)
                        val edit = sp.edit()
                        val key = call.argument<String>("key")
                        val value = call.argument<String>("value")
                        edit.putString("username", username)
                        edit.apply()
                        activity.runOnUiThread {
                            EMClient.getInstance().groupManager().loadAllGroups()
                            EMClient.getInstance().chatManager().loadAllConversations()
                            result.success("success")
                        }
                    }

                    override fun onProgress(progress: Int, status: String) {}
                    override fun onError(code: Int, message: String) {
                        Log.d("main", "登录聊天服务器失败！")
                        activity.runOnUiThread { result.error("loginError", message, null) }
                    }
                })
            } else if ("register" == call.method) {
                val username = call.argument<String>("username")
                val pwd = call.argument<String>("pwd")
                ThreadPoolProvider.execute {
                    try {
                        EMClient.getInstance().createAccount(username, pwd)
                        Log.d("main", "注册成功！")
                        val sp = activity.getSharedPreferences("userInfo",
                                Activity.MODE_PRIVATE)
                        val edit = sp.edit()
                        edit.putString("username", username)
                        edit.apply()
                        activity.runOnUiThread { result.success("success") }
                    } catch (e: HyphenateException) {
                        e.printStackTrace()
                        Log.d("main", "注册失败！")
                        activity.runOnUiThread { result.error("loginError", e.message, null) }
                    }
                }
            } else if ("logout" == call.method) {
                val sp = activity.getSharedPreferences("userInfo",
                        Activity.MODE_PRIVATE)
                val edit = sp.edit()
                edit.putString("username", "")
                edit.apply()
                activity.runOnUiThread { result.success(true) }
            }
        })
    }
}