const express = require('express')

// 创建express服务器
const app = express()

// app.post('/login', (req, res) => {
//     // 处理login请求
//     res.end('登录成功，欢迎回来')
// })

// 给express创建的app传入一个回调函数
// 传入的这个回调函数就称之为是中间件(middleware)
// app.post('/login', 回调函数 => 中间件)
app.post('/login', (req, res, next) => {
    // 1.中间件中可以执行任意代码
    console.log('first middleware exec~')
    // 打印
    // 查询数据
    // 判断逻辑
  
    // 2.在中间件中修改req/res对象
    req.age = 99
  
    // 3.可以在中间件中结束响应周期
    // res.json({ message: "登录成功, 欢迎回来", code: 0 })
  
    // 4.执行下一个中间件
    next()
  })

  app.use((req, res, next) => {
    console.log('second middleware exec~')
  })

app.get('/home', (req, res) => {
    res.end('首页列表数据')
})

// 启动服务器
app.listen(9000, ()=>{
    console.log('express服务器启动成功~')
})


var salesOffices = {};    // 定义售楼处

salesOffices.clientList = {};    // 缓存列表，存放订阅者的回调函数

salesOffices.listen = function( key, fn ){
    if ( ! this.clientList[ key ] ){    // 如果还没有订阅过此类消息，给该类消息创建一个缓存列表
      this.clientList[ key ] = [];
    }
    this.clientList[ key ].push( fn );    // 订阅的消息添加进消息缓存列表
};

salesOffices.trigger = function(){    // 发布消息
    var key = Array.prototype.shift.call( arguments ),    // 取出消息类型
      fns = this.clientList[ key ];    // 取出该消息对应的回调函数集合

    if ( ! fns || fns.length === 0 ){    // 如果没有订阅该消息，则返回
      return false;
    }

    for( var i = 0, fn; fn = fns[ i++ ]; ){
      fn.apply( this, arguments );    // (2) // arguments是发布消息时附送的参数
    }
};

salesOffices.listen( 'squareMeter88', function( price ){    // 小明订阅88平方米房子的消息
    console.log( '价格= ' + price );    // 输出： 2000000
});

salesOffices.listen( 'squareMeter110', function( price ){     // 小红订阅110平方米房子的消息
    console.log( '价格= ' + price );    // 输出： 3000000
});

salesOffices.trigger( 'squareMeter88', 2000000 );     // 发布88平方米房子的价格
salesOffices.trigger( 'squareMeter110', 3000000 );    // 发布110平方米房子的价格
