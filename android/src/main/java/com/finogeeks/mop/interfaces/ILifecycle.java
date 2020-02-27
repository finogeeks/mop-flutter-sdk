package com.finogeeks.mop.interfaces;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

/**
 * 绑定{@link Activity}生命周期的回调接口
 */
public interface ILifecycle {

    /**
     * 当{@link Activity#onCreate(Bundle)}方法调用时回调.
     */
    void onCreate();

    /**
     * 当{@link Activity#onDestroy()}方法调用时回调.
     */
    void onDestroy();

    /**
     * 当{@link Activity#onActivityResult(int, int, Intent)}方法调用时回调.
     */
    void onActivityResult(int requestCode, int resultCode, Intent data, ICallback callback);

    /**
     * 当{@link Activity#onNewIntent(Intent)}方法调用时回调.
     */
    void onNewIntent(Intent intent);
    /**
     * 当{@link Activity#onResume()}方法调用时回调.
     */
    void onResume();
    /**
     * 当{@link Activity#onResume()}方法调用时回调.
     */
    void onPause();
}