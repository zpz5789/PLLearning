const http = require('http')

// 创建一个http对应的服务器
const server = http.createServer((req, res) => {
  // request对象中包含本次客户端请求的所有信息
  // 请求的url
  // 请求的method
  // 请求的headers
  // 请求携带的数据
  // response对象用于给客户端返回结果的
  console.log('服务器被访问~')
  // request对象中包含哪些信息?
  // 1.url信息
  console.log(req.url)
  // 2.method信息(请求方式)
  console.log(req.method)
  // 3.headers信息(请求信息)
  console.log(req.headers)
  const url = req.url
  const method = req.method
//   console.log('req is', request, 'rep is', response)
if (url === '/login') {
    if (method === 'POST') {
        res.end('登录成功~')
    } else {
        res.end('不支持的请求方式~，请用post')
    }
  } else if (url === '/products') {
    res.end('商品列表~')
  } else if (url === '/lyric') {
    res.end('天空好想下雨, 我好想住你隔壁!')
  } else {
    res.end('Hello World')
  }
})

// 开启对应的服务器, 并且告知需要监听的端口
// 监听端口时, 监听1024以上的端口, 666535以下的端口
// 1025~65535之间的端口
// 2个字节 => 256*256 => 65536 => 0~65535
server.listen(8989, ()=> {
    console.log('服务器已经开启成功~')
})