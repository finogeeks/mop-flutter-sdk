package com.finogeeks.mop;

import android.app.Activity;
import android.content.Intent;

import com.finogeeks.mop.constants.Constants;
import com.finogeeks.mop.interfaces.Event;
import com.finogeeks.mop.service.MopPluginService;

import io.flutter.plugin.common.PluginRegistry;


public class MopPluginDelegate implements PluginRegistry.ActivityResultListener {

    private Event mEvent;
    private final Activity activity;

    public Event getEvent() {
        return mEvent;
    }

    public void setEvent(Event event) {
        this.mEvent = event;
    }

    public MopPluginDelegate(final Activity activity) {
        this.activity = activity;

    }
    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == Constants.REQUEST_CODE_CHOOSE
                || requestCode == Constants.REQUEST_CODE_LOCATION_CHOOSE
        ) {
            MopPluginService.getInstance().getApisManager().getApiInstance(mEvent).onActivityResult(requestCode, resultCode, data, mEvent.getCallback());
        }
        return true;
    }

}