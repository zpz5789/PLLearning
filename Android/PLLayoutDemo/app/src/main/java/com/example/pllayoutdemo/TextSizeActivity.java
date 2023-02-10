package com.example.pllayoutdemo;

import androidx.appcompat.app.AppCompatActivity;

import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.example.pllayoutdemo.utils.Utils;

public class TextSizeActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_text_view);
        TextView tv_px = findViewById(R.id.tv_hellold_dp);
        // 设置文本内容
//        tv_hello.setText(R.string.hello);
        // 设置字体大小,这里默认是 sp
        tv_px.setTextSize(20);
        /* *
         *  理解px/dp
         * */


        TextView tv_code_system = findViewById(R.id.tv_text);
//        tv_code_system.setTextColor(Color.GREEN);
//        tv_code_system.setTextColor(0xff00ff00);
        // 不生效
//        tv_code_system.setBackgroundColor(R.color.white);
        tv_code_system.setBackgroundColor(getResources().getColor(R.color.green, null));

        TextView tv_text1 = findViewById(R.id.tv_text1);
        tv_text1.setBackgroundColor(getResources().getColor(R.color.purple_200, null));
        ViewGroup.LayoutParams params = tv_text1.getLayoutParams();
        // 修改布局参数中的宽度数值，注意默认px单位，需要把dp数值转成px数值
        params.width = Utils.dip2px(this, 100);
        params.height = 200;
        tv_text1.setLayoutParams(params);
    }

}