package com.finogeeks.mop.interfaces;


import java.util.Map;

public final class Event {

    private String name;
    private Object param;
    private ICallback callback;


    public Event(String name, Object param, ICallback callback) {
        this.name = name;
        this.param = param;
        this.callback = callback;
    }

    public String getName() {
        return name;
    }

    public Map getParam() {
        if (param instanceof Map) {

            return (Map)param;
        }
        return null;
    }

    public ICallback getCallback() {
        return callback;
    }

}