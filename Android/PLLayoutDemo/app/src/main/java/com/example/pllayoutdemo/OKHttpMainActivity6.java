package com.example.pllayoutdemo;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import java.io.IOException;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

public class OKHttpMainActivity6 extends AppCompatActivity {

    private OkHttpClient okHttpClient;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_okhttp_main6);

        Button button = (Button) findViewById(R.id.button);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                postRequestASync();
            }
        });
        okHttpClient = new OkHttpClient();
    }



    public void getRequestSync() {
        new Thread(){
            @Override
            public void run() {
                Request request = new Request.Builder().url("https://www.httpbin.org/get?a=1&b=2").build();
                Call call = okHttpClient.newCall(request);
                try {
                    Response response = call.execute();
                    Log.d("TAG", response.body().string());
                } catch (IOException e) {
                    Log.d("TAG", "error exception");
                    e.printStackTrace();
                }
            }
        }.start();


    }
    public void getRequestASync() {
        new Thread(){
            @Override
            public void run() {
                Request request = new Request.Builder().url("https://www.httpbin.org/get?a=1&b=2").build();
                Call call = okHttpClient.newCall(request);
                call.enqueue(new Callback() {
                    @Override
                    public void onFailure(@NonNull Call call, @NonNull IOException e) {

                    }

                    @Override
                    public void onResponse(@NonNull Call call, @NonNull Response response) throws IOException {
                        if (response.isSuccessful()) {
                            Log.d("TAG", response.body().string());
                        }
                    }
                });
            }
        }.start();

    }
    public void postRequestSync() {
        new Thread(){
            @Override
            public void run() {
                FormBody formBody = new FormBody.Builder().add("a","1").add("b","2").build();
                Request request = new Request.Builder().url("https://www.httpbin.org/post").post(formBody).build();
                Call call = okHttpClient.newCall(request);
                try {
                    Response response = call.execute();
                    Log.d("TAG", response.body().string());
                } catch (IOException e) {
                    Log.d("TAG", "error exception");
                    e.printStackTrace();
                }
            }
        }.start();
    }
    public void postRequestASync() {
        new Thread(){
            @Override
            public void run() {
                FormBody formBody = new FormBody.Builder().add("a","1").add("b","2").build();
                Request request = new Request.Builder().url("https://www.httpbin.org/post").post(formBody).build();
                Call call = okHttpClient.newCall(request);
                call.enqueue(new Callback() {
                    @Override
                    public void onFailure(@NonNull Call call, @NonNull IOException e) {

                    }

                    @Override
                    public void onResponse(@NonNull Call call, @NonNull Response response) throws IOException {
                        if (response.isSuccessful()) {
                            Log.d("TAG", response.body().string());
                        }
                    }
                });
            }
        }.start();

    }
}