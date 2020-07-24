package com.rightpoint.lite_chat;

import android.os.Bundle;

import androidx.annotation.Nullable;

import com.rightpoint.lite_chat.channel.ChannelConversation;
import com.rightpoint.lite_chat.channel.ChannelFriend;
import com.rightpoint.lite_chat.channel.ChannelMsg;
import com.rightpoint.lite_chat.channel.ChannelUserInfo;

import io.flutter.app.FlutterActivity;

public class MainActivity extends FlutterActivity {
    static final String CHANNEL_NATIVE_CALL = "com.rightpoint.litechat/nativecall";

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ChannelUserInfo.connect(this);
        ChannelFriend.connect(this);
        ChannelMsg.connect(this);
        ChannelConversation.connect(this);
    }
}
