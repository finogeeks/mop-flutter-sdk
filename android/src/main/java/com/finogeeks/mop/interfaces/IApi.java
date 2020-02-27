package com.finogeeks.mop.interfaces;

import java.util.Map;

/**
 * Api接口，实现相应功能的Api需实现此接口
 */
public interface IApi extends ILifecycle {

    /**
     * @return 支持可调用的api名称的数组
     */
    String[] apis();

    /**
     * 接收到对应的api调用时，会调用此方法，在此方法中处理api调用的功能逻辑
     *
     * @param event    事件名称，即api名称
     * @param param    参数
     * @param callback 回调接口
     */
    void invoke(String event, Map param, ICallback callback);
}