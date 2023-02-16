package com.example.pllayoutdemo;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class CallPhoneActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_call_phone);

        Button makeCall = findViewById(R.id.make_call);
        makeCall.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (ContextCompat.checkSelfPermission(CallPhoneActivity.this, Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
                    ActivityCompat.requestPermissions(CallPhoneActivity.this, new String[]{Manifest.permission.CALL_PHONE}, 1);
                } else {
                    openCallPageWithNumber("13424351256");
                }
            }
        });

    }

    // 直接打电话
    private void call() {
        try {
            Intent intent = new Intent(Intent.ACTION_CALL);
            intent.setData(Uri.parse("tel:10086"));
            startActivity(intent);
        } catch (SecurityException e) {
            e.printStackTrace();
        }
    }

    // 打开拨号界面
    private void openCallPage() {
        try {
            Intent intent = new Intent(Intent.ACTION_CALL_BUTTON);
            startActivity(intent);
        } catch (SecurityException e) {
            e.printStackTrace();
        }
    }


    // 打开拨号界面，同时传递电话号码
    private void openCallPageWithNumber(String phoneNum) {
        try {
            Intent intent = new Intent(Intent.ACTION_DIAL, Uri.parse("tel:" + phoneNum));
            startActivity(intent);
        } catch (SecurityException e) {
            e.printStackTrace();
        }
    }
}

// ================== 权限申请相关代码 ==================

//public static final int REQUEST_CALL_PERMISSION = 10111; //拨号请求码

    /**
     * 判断是否有某项权限
     * @param string_permission 权限
     * @param request_code 请求码
     * @return
     */
//public boolean checkReadPermission(String string_permission,int request_code) {
//    boolean flag = false;
//    if (ContextCompat.checkSelfPermission(this, string_permission) == PackageManager.PERMISSION_GRANTED) {//已有权限
//        flag = true;
//    } else {//申请权限
//        ActivityCompat.requestPermissions(this, new String[]{string_permission}, request_code);
//    }
//    return flag;
//}

    /**
     * 检查权限后的回调
     * @param requestCode 请求码
     * @param permissions  权限
     * @param grantResults 结果
     */
//    @Override
//    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
//        switch (requestCode) {
//            case REQUEST_CALL_PERMISSION: //拨打电话
//                if (permissions.length != 0 && grantResults[0] != PackageManager.PERMISSION_GRANTED) {//失败
//                    Toast.makeText(this,"请允许拨号权限后再试",Toast.LENGTH_SHORT).show();
//                } else {//成功
//                    call("tel:"+"10086");
//                }
//                break;
//        }
//    }

    /**
     * 拨打电话（直接拨打）
     * @param telPhone 电话
     */
//    public void call(String telPhone){
//        if(checkReadPermission(Manifest.permission.CALL_PHONE,REQUEST_CALL_PERMISSION)){
//            Intent intent = new Intent(Intent.ACTION_CALL,Uri.parse(telPhone));
//            startActivity(intent);
//        }
//    }
