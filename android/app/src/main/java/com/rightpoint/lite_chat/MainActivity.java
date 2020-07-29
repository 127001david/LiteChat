package com.rightpoint.lite_chat;

import androidx.annotation.NonNull;

import com.rightpoint.lite_chat.channel.ChannelConversation;
import com.rightpoint.lite_chat.channel.ChannelFriend;
import com.rightpoint.lite_chat.channel.ChannelMsg;
import com.rightpoint.lite_chat.channel.ChannelUserInfo;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    static final String CHANNEL_NATIVE_CALL = "com.rightpoint.litechat/nativecall";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        ChannelUserInfo.connect(flutterEngine, this);
        ChannelFriend.connect(flutterEngine, this);
        ChannelMsg.connect(flutterEngine, this);
        ChannelConversation.connect(flutterEngine, this);
    }
}
