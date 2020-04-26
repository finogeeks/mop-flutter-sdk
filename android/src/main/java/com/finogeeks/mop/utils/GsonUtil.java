package com.finogeeks.mop.utils;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.util.Map;

public class GsonUtil {
   public static Gson gson = new Gson();

   public static Map<String, Object> toMap(Object object) {
        String str = gson.toJson(object);
        if (str != null) {
            return gson.fromJson(str, new TypeToken<Map<String, Object>>() {
            }.getType());
        }
        return null;
    }
}
