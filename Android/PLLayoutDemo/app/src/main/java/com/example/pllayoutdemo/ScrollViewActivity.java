package com.example.pllayoutdemo;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.example.pllayoutdemo.utils.DateUtil;

public class ScrollViewActivity extends AppCompatActivity implements View.OnClickListener, View.OnLongClickListener {

    protected View btn1;
    private TextView tv_result;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_scroll_view);

        tv_result = findViewById(R.id.btnText);

        // 代码方法一
        btn1 = findViewById(R.id.btn_one);
        btn1.setOnClickListener(new MyOnClickListener(tv_result));

        // 长按点击方法1
//        btn1.setOnLongClickListener(this);

        // 长按点击方法
//        btn1.setOnLongClickListener(new View.OnLongClickListener() {
//            @Override
//            public boolean onLongClick(View v) {
//                return false;
//            }
//        });

        // lambda
        btn1.setOnLongClickListener(v -> {
            String nowData = DateUtil.getNowTime();
            String desc = String.format("%s 您长按了按钮：%s", nowData, ((Button) v).getText());
            this.tv_result.setText(desc);
            // 设置按钮禁用
            v.setEnabled(false);
            return false;
        });


        // 代码方法二
        Button btn = findViewById(R.id.btn_two);
        btn.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        String nowData = DateUtil.getNowTime();
        String desc = String.format("%s 您点击了按钮：%s", nowData, ((Button) v).getText());
        this.tv_result.setText(desc);
    }

    @Override
    public boolean onLongClick(View v) {
        return false;
    }

    static class MyOnClickListener implements View.OnClickListener {

        private final TextView tv_result;

        public MyOnClickListener(TextView tv_result) {
            this.tv_result = tv_result;
        }

        @Override
        public void onClick(View v) {
            String nowData = DateUtil.getNowTime();
            String desc = String.format("%s 您点击了按钮：%s", nowData, ((Button) v).getText());
            this.tv_result.setText(desc);
        }
    }

    // xml文件中定义的方法
    public void btnClick(View view) {
        String nowData = DateUtil.getNowTime();
        String desc = String.format("%s 您点击了按钮：%s", nowData, ((Button) view).getText());
        tv_result.setText(desc);
    }
}