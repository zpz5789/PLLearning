package com.example.pllayoutdemo;

import androidx.appcompat.app.AppCompatActivity;

import android.app.ListActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;

import com.example.pllayoutdemo.adapter.FruitAdapter;
import com.example.pllayoutdemo.bean.Fruit;

import java.util.ArrayList;
import java.util.List;

public class ListViewActivity extends AppCompatActivity {

    private String[] data = {
      "apple", "bananer", "Origin", "watermelon", "pear",
            "apple", "bananer", "Origin", "watermelon", "pear",
            "apple", "bananer", "Origin", "watermelon", "pear",
            "apple", "bananer", "Origin", "watermelon", "pear"
    };

    private List<Fruit> fruitList = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_list_view);
        ListView listView = findViewById(R.id.list_view);

//        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, data);
//        listView.setAdapter(adapter);

        FruitAdapter adapter = new FruitAdapter(this, R.layout.fruit_item, fruitList);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Fruit fruit = fruitList.get(position);
                Toast.makeText(ListViewActivity.this, fruit.getName(), Toast.LENGTH_SHORT).show();
            }
        });


        initFruits();
    }

    private void initFruits() {
        for (int i = 0; i < 5; i++) {
            Fruit apple = new Fruit("apple", R.drawable.ic_launcher_foreground);
            fruitList.add(apple);
            Fruit bananer = new Fruit("bananer", R.drawable.ic_launcher_background);
            fruitList.add(bananer);
            Fruit orange = new Fruit("orange", R.drawable.image_20210714212945164);
            fruitList.add(orange);
        }
    }
}