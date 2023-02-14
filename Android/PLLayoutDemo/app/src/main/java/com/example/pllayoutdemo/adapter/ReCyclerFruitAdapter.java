package com.example.pllayoutdemo.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.pllayoutdemo.R;
import com.example.pllayoutdemo.bean.Fruit;

import java.util.List;

public class ReCyclerFruitAdapter extends RecyclerView.Adapter<ReCyclerFruitAdapter.ViewHolder> {
    private List<Fruit> mFruitList;

    public ReCyclerFruitAdapter(List<Fruit> fruitList) {
        this.mFruitList = fruitList;
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        ImageView fruitImage;
        TextView fruitName;
        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            fruitImage = (ImageView) itemView.findViewById(R.id.fruit_image);
            fruitName = (TextView) itemView.findViewById(R.id.fruit_name);
        }
    }
    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        // 垂直方向布局
//        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.fruit_item, parent, false);
        // 水平方向布局
//        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.fruit_item2, parent, false);
        // 瀑布流布局
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.fruit_item3, parent, false);


        final ViewHolder holder = new ViewHolder(view);
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int position = holder.getAdapterPosition();
                Fruit fruit = mFruitList.get(position);
                Toast.makeText(v.getContext(), "you clicked view " + fruit.getName(), Toast.LENGTH_SHORT).show();
            }
        });

        holder.fruitImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int position = holder.getAdapterPosition();
                Fruit fruit = mFruitList.get(position);
                Toast.makeText(v.getContext(), "you clicked image " + fruit.getName(), Toast.LENGTH_SHORT).show();
            }
        });

        return holder;
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        Fruit fruit = mFruitList.get(position);
        holder.fruitImage.setImageResource(fruit.getImageId());
        holder.fruitName.setText(fruit.getName());
    }

    @Override
    public int getItemCount() {
        return mFruitList.size();
    }

}
