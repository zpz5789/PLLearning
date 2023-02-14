package com.example.pllayoutdemo;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.recyclerview.widget.StaggeredGridLayoutManager;

import android.app.ListActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;

import com.example.pllayoutdemo.adapter.FruitAdapter;
import com.example.pllayoutdemo.adapter.ReCyclerFruitAdapter;
import com.example.pllayoutdemo.bean.Fruit;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

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

        initFruits();

        ListView listView = findViewById(R.id.list_view);
        FruitAdapter adapter = new FruitAdapter(this, R.layout.fruit_item, fruitList);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Fruit fruit = fruitList.get(position);
                Toast.makeText(ListViewActivity.this, fruit.getName(), Toast.LENGTH_SHORT).show();
            }
        });

//        RecyclerView recyclerView = (RecyclerView)findViewById(R.id.recyclerView);
//        LinearLayoutManager layoutManager = new LinearLayoutManager(this);
//        layoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
//        recyclerView.setLayoutManager(layoutManager);
//        ReCyclerFruitAdapter adapter1 = new ReCyclerFruitAdapter(fruitList);
//        recyclerView.setAdapter(adapter1);


        RecyclerView recyclerView = (RecyclerView)findViewById(R.id.recyclerView);
        StaggeredGridLayoutManager layoutManager = new StaggeredGridLayoutManager(3, StaggeredGridLayoutManager.VERTICAL);
        recyclerView.setLayoutManager(layoutManager);
        ReCyclerFruitAdapter adapter1 = new ReCyclerFruitAdapter(fruitList);
        recyclerView.setAdapter(adapter1);
    }

    private void initFruits() {
        for (int i = 0; i < 5; i++) {
            Fruit apple = new Fruit(getRandomLengthName("apple"), R.drawable.ic_launcher_foreground);
            fruitList.add(apple);
            Fruit bananer = new Fruit(getRandomLengthName("bananer"), R.drawable.ic_launcher_background);
            fruitList.add(bananer);
//            Fruit orange = new Fruit("orange", R.drawable.image_20210714212945164);
//            fruitList.add(orange);
        }
    }

    private String getRandomLengthName(String name) {
        Random random = new Random();
        int length = random.nextInt(20) + 1;
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < length; i++) {
            builder.append(name);
        }
        return builder.toString();
    }
}