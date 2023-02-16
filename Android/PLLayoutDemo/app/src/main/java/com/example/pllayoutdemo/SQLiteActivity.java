package com.example.pllayoutdemo;

import androidx.appcompat.app.AppCompatActivity;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import com.example.pllayoutdemo.database.MyDatabaseHelper;

public class SQLiteActivity extends AppCompatActivity {

    protected MyDatabaseHelper dbHelper;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sqlite);
        dbHelper = new MyDatabaseHelper(this, "BookStore.db", null, 2);
        Button createDatabase = (Button) findViewById(R.id.create_database);
        createDatabase.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dbHelper.getWritableDatabase();
            }
        });

        Button addData = (Button) findViewById(R.id.add_data);
        addData.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                addData();
            }
        });

        Button updataData = (Button) findViewById(R.id.update_data);
        updataData.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                updateData();
            }
        });

        Button deleteData = (Button) findViewById(R.id.delete_data);
        deleteData.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                deleteData();
            }
        });

        Button queryData = (Button) findViewById(R.id.query_Data);
        queryData.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                queryData();
            }
        });
    }

    private void addData() {
        SQLiteDatabase db = dbHelper.getWritableDatabase();
        ContentValues values = new ContentValues();
        // 开始组装第一条数据
        values.put("name", "The Da Vinci Code");
        values.put("author", "Dan Brown");
        values.put("pages", 454);
        values.put("price", 16.96);
        db.insert("Book", null, values);// 插入第一条数据

        values.clear();
        // 开始组装第二条数据
        values.put("name", "The Lost Symbol");
        values.put("author", "Dan Brown");
        values.put("pages", 510);
        values.put("price", 19.15);
        db.insert("Book", null, values);
    }

    private void updateData() {
        SQLiteDatabase db = dbHelper.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put("price", 10.99);;
        db.update("Book", values, "name = ?", new String[] {"The Da Vinci Code"});
    }

    private void deleteData() {
        SQLiteDatabase db = dbHelper.getWritableDatabase();
        db.delete("Book", "pages > ?", new String[] {"500"});
    }

    private void queryData() {
        SQLiteDatabase db = dbHelper.getWritableDatabase();
        // 查询Book中所有数据
        Cursor cursor = db.query("Book", null, null, null, null, null, null);
        if (cursor.moveToFirst()) {
            do {
                // 遍历Cursor 对象，取出数据并打印
                String name = cursor.getString((int) cursor.getColumnIndex("name"));
                String author = cursor.getString((int) cursor.getColumnIndex("author"));
                int pages = cursor.getInt((int) cursor.getColumnIndex("pages"));
                double price = cursor.getDouble((int) cursor.getColumnIndex("price"));
                Log.d("DataBase", "book name is" + name);
                Log.d("DataBase", "book author is" + author);
                Log.d("DataBase", "book pages is" + pages);
                Log.d("DataBase", "book price is" + price);

            } while (cursor.moveToNext());
        }
        cursor.close();
    }
}