package com.finogeeks.mop;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;

public class MopEventStream implements EventChannel.StreamHandler {
    EventChannel.EventSink mEventSlink;

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        mEventSlink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        mEventSlink = null;
    }

    public void send(String channel, String event, Object body) {
        if (mEventSlink != null) {
            Map<String, Object> map = new HashMap<>();
            map.put("channel", channel);
            map.put("event", event);
            map.put("body", body);
            mEventSlink.success(map);
        }
    }
}
