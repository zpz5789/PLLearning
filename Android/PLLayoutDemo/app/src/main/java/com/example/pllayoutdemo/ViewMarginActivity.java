package com.example.pllayoutdemo;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;

public class ViewMarginActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_margin);
        // layout_padding是子视图相对于父视图（父子间距）
        // layout_margin是同级视图（兄弟间距）
        // layout_gravity指定当前视图相对于上级视图的对齐方式
        /* 线性布局LinearLayout权重，指的是线性布局的下级试图各自拥有多大比例的宽高
        权重属性名叫layout_weight，该属性不在LinearLayout节点设置，
        而在线性布局的直接下级试图设置，表示下级试图占据的宽高比例
        layout_width=0dp时，layout_weight表示水平方向的宽度比例
        layout_height=0dp时，layout_weight表示垂直方向的宽度比例

        相对布局RelativeLayout，指的是相对其他视图布局，可以是平级（兄弟），也可以是父级

        网格布局GridLayout支持多行多列的表格排列
        网格布局默认从左往右，从上往下排列
        columnCount，网格的列数
        rowCount，网格的行数
        * */
    }
}