package com.rightpoint.lite_chat

import android.app.Service
import android.content.Intent
import android.os.IBinder
import com.rightpoint.lite_chat.channel.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        ChannelCallNative.connect(flutterEngine, this)
        ChannelUserInfo.connect(flutterEngine, this)
        ChannelFriend.connect(flutterEngine, this)
        ChannelMsg.connect(flutterEngine, this)
        ChannelConversation.connect(flutterEngine, this)
    }
}
