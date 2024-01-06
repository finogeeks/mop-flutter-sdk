package com.finogeeks.mop.api.mop.util;

import com.finogeeks.lib.applet.client.FinAppConfig;
import com.finogeeks.lib.applet.client.FinAppConfigPriority;

import java.util.Map;

public class InitUtils {

    private static float covertNumToFloat(Object obj) {
        if (obj instanceof Float) {
            return ((Float) obj).floatValue();
        } else if (float.class.isInstance(obj)) {
            return (float) obj;
        } else  if (obj instanceof Double) {
            return ((Double) obj).floatValue();
        } else if (double.class.isInstance(obj)) {
            return (float) obj;
        } else if (obj instanceof Integer) {
            return ((Integer) obj).floatValue();
        } else if (int.class.isInstance(obj)) {
            return (float) obj;
        }
        throw new IllegalArgumentException("Unsupported argument type " + obj.getClass().getName());
    }

    public static FinAppConfig.UIConfig createUIConfigFromMap(Map<Object, Object> map) {
        if (map != null) {
            FinAppConfig.UIConfig uiConfig = new FinAppConfig.UIConfig();
            uiConfig.setNavigationBarTitleLightColor((Integer) map.get("navigationBarTitleLightColor"));
            uiConfig.setNavigationBarTitleDarkColor((Integer) map.get("navigationBarTitleDarkColor"));
            uiConfig.setNavigationBarBackBtnLightColor((Integer) map.get("navigationBarBackBtnLightColor"));
            uiConfig.setAlwaysShowBackInDefaultNavigationBar((Boolean) map.get("isAlwaysShowBackInDefaultNavigationBar"));
            uiConfig.setClearNavigationBarNavButtonBackground((Boolean) map.get("isClearNavigationBarNavButtonBackground"));
            uiConfig.setHideFeedbackAndComplaints((Boolean) map.get("isHideFeedbackAndComplaints"));
            uiConfig.setHideBackHome((Boolean) map.get("isHideBackHome"));
            uiConfig.setHideForwardMenu((Boolean) map.get("isHideForwardMenu"));
            uiConfig.setHideRefreshMenu((Boolean) map.get("isHideRefreshMenu"));
            uiConfig.setHideShareAppletMenu((Boolean) map.get("isHideShareAppletMenu"));
            uiConfig.setHideAddToDesktopMenu((Boolean) map.get("isHideAddToDesktopMenu"));
            uiConfig.setHideFavoriteMenu((Boolean) map.get("isHideFavoriteMenu"));
            uiConfig.setHideClearCacheMenu((Boolean) map.get("isHideClearCacheMenu"));
            uiConfig.setHideSettingMenu((Boolean) map.get("isHideSettingMenu"));
            uiConfig.setHideTransitionCloseButton((Boolean) map.get("hideTransitionCloseButton"));
            uiConfig.setUseNativeLiveComponent((Boolean) map.get("useNativeLiveComponent"));
            Map<Object, Object> capsuleConfigMap = (Map<Object, Object>) map.get("capsuleConfig");
            if (capsuleConfigMap != null) {
                FinAppConfig.UIConfig.CapsuleConfig capsuleConfig = new FinAppConfig.UIConfig.CapsuleConfig();
                capsuleConfig.capsuleWidth = covertNumToFloat(capsuleConfigMap.get("capsuleWidth"));
                capsuleConfig.capsuleHeight = covertNumToFloat(capsuleConfigMap.get("capsuleHeight"));
                capsuleConfig.capsuleRightMargin = covertNumToFloat(capsuleConfigMap.get("capsuleRightMargin"));
                capsuleConfig.capsuleCornerRadius = covertNumToFloat(capsuleConfigMap.get("capsuleCornerRadius"));
                capsuleConfig.capsuleBorderWidth = covertNumToFloat(capsuleConfigMap.get("capsuleBorderWidth"));
                capsuleConfig.capsuleBgLightColor = (int) capsuleConfigMap.get("capsuleBgLightColor");
                capsuleConfig.capsuleBgDarkColor = (int) capsuleConfigMap.get("capsuleBgDarkColor");
                capsuleConfig.capsuleBorderLightColor = (int) capsuleConfigMap.get("capsuleBorderLightColor");
                capsuleConfig.capsuleBorderDarkColor = (int) capsuleConfigMap.get("capsuleBorderDarkColor");
                capsuleConfig.capsuleDividerLightColor = (int) capsuleConfigMap.get("capsuleDividerLightColor");
                capsuleConfig.capsuleDividerDarkColor = (int) capsuleConfigMap.get("capsuleDividerDarkColor");
                Integer moreLightImage = (Integer) capsuleConfigMap.get("moreLightImage");
                if (moreLightImage != null) {
                    capsuleConfig.moreLightImage = moreLightImage;
                }
                Integer moreDarkImage = (Integer) capsuleConfigMap.get("moreDarkImage");
                if (moreDarkImage != null) {
                    capsuleConfig.moreDarkImage = moreDarkImage;
                }
                capsuleConfig.moreBtnWidth = covertNumToFloat(capsuleConfigMap.get("moreBtnWidth"));
                capsuleConfig.moreBtnLeftMargin = covertNumToFloat(capsuleConfigMap.get("moreBtnLeftMargin"));
                Integer closeLightImage = (Integer) capsuleConfigMap.get("closeLightImage");
                if (closeLightImage != null) {
                    capsuleConfig.closeLightImage = closeLightImage;
                }
                Integer closeDarkImage = (Integer) capsuleConfigMap.get("closeDarkImage");
                if (closeDarkImage != null) {
                    capsuleConfig.closeDarkImage = closeDarkImage;
                }
                capsuleConfig.closeBtnWidth = covertNumToFloat(capsuleConfigMap.get("closeBtnWidth"));
                capsuleConfig.closeBtnLeftMargin = covertNumToFloat(capsuleConfigMap.get("closeBtnLeftMargin"));
                uiConfig.setCapsuleConfig(capsuleConfig);
            }
            Map<Object, Object> navHomeConfigMap = (Map<Object, Object>) map.get("navHomeConfig");
            if (navHomeConfigMap != null) {
                FinAppConfig.UIConfig.NavHomeConfig navHomeConfig = new FinAppConfig.UIConfig.NavHomeConfig();
                navHomeConfig.width = covertNumToFloat(navHomeConfigMap.get("width"));
                navHomeConfig.height = covertNumToFloat(navHomeConfigMap.get("height"));
                navHomeConfig.leftMargin = covertNumToFloat(navHomeConfigMap.get("leftMargin"));
                navHomeConfig.cornerRadius = covertNumToFloat(navHomeConfigMap.get("cornerRadius"));
                navHomeConfig.borderWidth = covertNumToFloat(navHomeConfigMap.get("borderWidth"));
                navHomeConfig.borderLightColor = (int) navHomeConfigMap.get("borderLightColor");
                navHomeConfig.borderDarkColor = (int) navHomeConfigMap.get("borderDarkColor");
                navHomeConfig.bgLightColor = (int) navHomeConfigMap.get("bgLightColor");
                navHomeConfig.bgDarkColor = (int) navHomeConfigMap.get("bgDarkColor");
                uiConfig.setNavHomeConfig(navHomeConfig);
            }
            Map<Object, Object> authViewConfigMap = (Map<Object, Object>) map.get("authViewConfig");
            if (authViewConfigMap != null) {
                FinAppConfig.UIConfig.AuthViewConfig authViewConfig = new FinAppConfig.UIConfig.AuthViewConfig();
                authViewConfig.appletNameTextSize = covertNumToFloat(authViewConfigMap.get("appletNameTextSize"));
                authViewConfig.appletNameLightColor = (int) authViewConfigMap.get("appletNameLightColor");
                authViewConfig.appletNameDarkColor = (int) authViewConfigMap.get("appletNameDarkColor");
                authViewConfig.authorizeTitleTextSize = covertNumToFloat(authViewConfigMap.get("authorizeTitleTextSize"));
                authViewConfig.authorizeTitleLightColor = (int) authViewConfigMap.get("authorizeTitleLightColor");
                authViewConfig.authorizeTitleDarkColor = (int) authViewConfigMap.get("authorizeTitleDarkColor");
                authViewConfig.authorizeDescriptionTextSize = covertNumToFloat(authViewConfigMap.get("authorizeDescriptionTextSize"));
                authViewConfig.authorizeDescriptionLightColor = (int) authViewConfigMap.get("authorizeDescriptionLightColor");
                authViewConfig.authorizeDescriptionDarkColor = (int) authViewConfigMap.get("authorizeDescriptionDarkColor");
                authViewConfig.agreementTitleTextSize = covertNumToFloat(authViewConfigMap.get("agreementTitleTextSize"));
                authViewConfig.agreementTitleLightColor = (int) authViewConfigMap.get("agreementTitleLightColor");
                authViewConfig.agreementTitleDarkColor = (int) authViewConfigMap.get("agreementTitleDarkColor");
                authViewConfig.agreementDescriptionTextSize = covertNumToFloat(authViewConfigMap.get("agreementDescriptionTextSize"));
                authViewConfig.agreementDescriptionLightColor = (int) authViewConfigMap.get("agreementDescriptionLightColor");
                authViewConfig.agreementDescriptionDarkColor = (int) authViewConfigMap.get("agreementDescriptionDarkColor");
                authViewConfig.linkLightColor = (int) authViewConfigMap.get("linkLightColor");
                authViewConfig.linkDarkColor = (int) authViewConfigMap.get("linkDarkColor");
                Map<Object, Object> allowButtonLightConfig = (Map<Object, Object>) authViewConfigMap.get("allowButtonLightConfig");
                if (allowButtonLightConfig != null) {
                    authViewConfig.allowButtonLightConfig = getAuthButtonConfig(allowButtonLightConfig);
                }
                Map<Object, Object> allowButtonDarkConfig = (Map<Object, Object>) authViewConfigMap.get("allowButtonDarkConfig");
                if (allowButtonDarkConfig != null) {
                    authViewConfig.allowButtonDarkConfig = getAuthButtonConfig(allowButtonDarkConfig);
                }
                Map<Object, Object> rejectButtonLightConfig = (Map<Object, Object>) authViewConfigMap.get("rejectButtonLightConfig");
                if (rejectButtonLightConfig != null) {
                    authViewConfig.rejectButtonLightConfig = getAuthButtonConfig(rejectButtonLightConfig);
                }
                Map<Object, Object> rejectButtonDarkConfig = (Map<Object, Object>) authViewConfigMap.get("rejectButtonDarkConfig");
                if (rejectButtonDarkConfig != null) {
                    authViewConfig.rejectButtonDarkConfig = getAuthButtonConfig(rejectButtonDarkConfig);
                }
                uiConfig.setAuthViewConfig(authViewConfig);
            }
            Map<Object, Object> floatWindowConfigMap = (Map<Object, Object>) map.get("floatWindowConfig");
            if (floatWindowConfigMap != null) {
                FinAppConfig.UIConfig.FloatWindowConfig floatWindowConfig = new FinAppConfig.UIConfig.FloatWindowConfig();
                floatWindowConfig.floatMode = (boolean) floatWindowConfigMap.get("floatMode");
                floatWindowConfig.x = (int) floatWindowConfigMap.get("x");
                floatWindowConfig.y = (int) floatWindowConfigMap.get("y");
                floatWindowConfig.width = (int) floatWindowConfigMap.get("width");
                floatWindowConfig.height = (int) floatWindowConfigMap.get("height");
                uiConfig.setFloatWindowConfig(floatWindowConfig);
            }
            Integer webViewProgressBarColor = (Integer) map.get("webViewProgressBarColor");
            if (webViewProgressBarColor != null) {
                uiConfig.setWebViewProgressBarColor(webViewProgressBarColor);
            }
            uiConfig.setHideWebViewProgressBar((Boolean) map.get("hideWebViewProgressBar"));
            uiConfig.setMoreMenuStyle((Integer) map.get("moreMenuStyle"));
            int isHideBackHomePriorityIndex = (Integer) map.get("isHideBackHomePriority");
            if (isHideBackHomePriorityIndex == 0) {
                uiConfig.setIsHideBackHomePriority(FinAppConfigPriority.GLOBAL);
            } else if (isHideBackHomePriorityIndex == 1) {
                uiConfig.setIsHideBackHomePriority(FinAppConfigPriority.SPECIFIED);
            } else if (isHideBackHomePriorityIndex == 2) {
                uiConfig.setIsHideBackHomePriority(FinAppConfigPriority.APPLET_FILE);
            }
            uiConfig.setAutoAdaptDarkMode((Boolean) map.get("autoAdaptDarkMode"));
            uiConfig.setDisableSlideCloseAppletGesture((Boolean) map.get("disableSlideCloseAppletGesture"));
            String loadingLayoutCls = (String) map.get("loadingLayoutCls");
            if (loadingLayoutCls != null) {
                uiConfig.setLoadingLayoutCls(loadingLayoutCls);
            }
            return uiConfig;
        }
        return null;
    }

    private static FinAppConfig.UIConfig.AuthViewConfig.AuthButtonConfig getAuthButtonConfig(Map<Object, Object> map) {
        return new FinAppConfig.UIConfig.AuthViewConfig.AuthButtonConfig(
                (float) map.get("cornerRadius"),
                (int) map.get("normalBackgroundColor"),
                (int) map.get("pressedBackgroundColor"),
                (int) map.get("normalBorderColor"),
                (int) map.get("pressedBorderColor"),
                (int) map.get("normalTextColor"),
                (int) map.get("pressedTextColor")
        );
    }
}
