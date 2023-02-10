package com.example.pllayoutdemo.utils;

import android.content.Context;

public class Utils {
    // 根据手机的分辨率从dp的单位转成为px
    public static int dip2px(Context context, float dpValue) {
        // 获取当前手机的像素密度（1个dp对应几个px）
        float scala = context.getResources().getDisplayMetrics().density;
        // 四舍五入取整
        return (int) (dpValue * scala + 0.5f);
    }
}
