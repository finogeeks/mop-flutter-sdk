package com.finogeeks.mop.interfaces;

import android.content.Intent;

/**
 * Api回调接口
 */
public interface ICallback<T> {

    /**
     * Api调用成功
     *
     * @param data Api调用返回的结果
     */
    void onSuccess(T data);

    /**
     * Api调用失败
     */
    void onFail(T error);

    /**
     * Api调用取消
     */
    void onCancel(T cancel);

    /**
     * 回调{@link android.app.Activity#startActivityForResult(Intent, int)}方法
     *
     * @param intent
     * @param requestCode
     */
    void startActivityForResult(Intent intent, int requestCode);

}