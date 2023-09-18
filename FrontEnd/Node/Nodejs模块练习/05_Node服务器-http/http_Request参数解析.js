const http = require('http')
const url = require('url')
const qs = require('querystring')
const fs = require('fs')

// 1.创建server服务器
// const server = http.createServer((req, res) => {
//     // 1.参数一: query类型参数
//     // /home/list?offset=100&size=20
//     // 1.1.解析url
//     const urlString = req.url
//     const urlInfo = url.parse(urlString)
//     // 1.2.解析query: offset=100&size=20
//     const queryString = urlInfo.query
//     const queryInfo = qs.parse(queryString)
//     console.log(queryInfo.offset, queryInfo.size)
//     res.end('hello world aaaa bbb')
//   })

// 1.创建server服务器
// const server = http.createServer((req, res) => {
//     // 获取参数: body参数
//     req.setEncoding('utf-8')
  
//     // request对象本质是上一个readable可读流
//     let isLogin = false
//     req.on('data', (data) => {
//       const dataString = data
//       const loginInfo = JSON.parse(dataString)
//       console.log('data is', dataString, loginInfo)
//       if (loginInfo.name === 'coderwhy' && loginInfo.password === '123456') {
//         isLogin = true
//       } else {
//         isLogin = false
//       }
//     })


//     req.on('end', () => {
//       if (isLogin) {
//         res.end('登录成功, 欢迎回来~')
//       } else {
//         res.end('账号或者密码错误, 请检测登录信息111~')
//       }
//     })
//   })

// 1.创建server服务器
// const server = http.createServer((req, res) => {
//     // res: response对象 => Writable可写流
//     // 1.响应数据方式一: write
//     // res.statusCode = 403
//       // 2.方式二: setHead 响应头
//     res.writeHead(401)

//     res.write("Hello World")
//     res.write("哈哈哈哈")

//      // 2.方式二: setHead 响应头
  
//     // // 2.响应数据方式二: end
//     res.end("本次写出已经结束")

//   })
  
// // 1.创建server服务器
// const server = http.createServer((req, res) => {

//     // 设置header信息: 数据的类型以及数据的编码格式
//     // 1.单独设置某一个header
//     // res.setHeader('Content-Type', 'text/plain;charset=utf8;')
  
//     // 2.和http status code一起设置
//     res.writeHead(200, {
//       'Content-Type': 'application/json;charset=utf8;'
//     })
  
//     const list = [
//       { name: "why", age: 18 },
//       { name: "kobe", age: 30 },
//     ]
//     res.end(JSON.stringify(list))
//   })

// 文件上传错误用法(这种方法有问题，相当于是把body form-data数据全部存入foo1.png了)
// 1.创建server服务器
// const server = http.createServer((req, res) => {
//     // 创建writable的stream
//     const writeStream = fs.createWriteStream('./foo1.png', {
//       flags: 'a+'
//     })
  
//     // req.pipe(writeStream)
  
//     // 客户端传递的数据是表单数据(请求体)
//     req.on("data", (data) => {
//       console.log(data);
//       writeStream.write(data)
//     });
  

//     req.on("end", () => {
//       console.log("数据传输完成~");
//       // writeStream.close()
//       res.end("文件上传成功~");
//     });
//   });
  

// 1.创建server服务器
const server = http.createServer((req, res) => {
    req.setEncoding('binary')
  
    const boundary = req.headers['content-type'].split('; ')[1].replace('boundary=', '')
    console.log(boundary)
  
    // 客户端传递的数据是表单数据(请求体)
    let formData = ''
    req.on("data", (data) => {
      formData += data
    });
  
    req.on("end", () => {
      console.log(formData)
      // 1.截图从image/jpeg位置开始后面所有的数据
      const imgType = 'image/jpeg'
      const imageTypePosition = formData.indexOf(imgType) + imgType.length
      let imageData = formData.substring(imageTypePosition)
  
      // 2.imageData开始位置会有两个空格
      imageData = imageData.replace(/^\s\s*/, '')
  
      // 3.替换最后的boundary
      imageData = imageData.substring(0, imageData.indexOf(`--${boundary}--`))
  
      // 4.将imageData的数据存储到文件中
      fs.writeFile('./bar.png', imageData, 'binary', () => {
        console.log('文件存储成功')
        res.end("文件上传成功~");
      })
    });
  });
  
  // 2.开启server服务器
  server.listen(8000, () => {
    console.log('服务器开启成功~')
  })
  