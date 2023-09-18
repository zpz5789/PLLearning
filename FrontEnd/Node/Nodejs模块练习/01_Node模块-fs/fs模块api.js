const fs = require('fs')

// ------- 文件的读取 --------
// 1.同步读取  node命令执行的cd 到当前文件目录才能执行
const res1 = fs.readFileSync('./aaa.txt', {encoding: 'utf-8'})
console.log(res1)

// 2. 异步读取 回调函数
fs.readFile('./aaa.txt', {encoding: 'utf-8'},(err, data) => {
    if (err) {
        console.log("读取文件错误", err)
    } 
    console.log("读取的结果是：", data)
})
console.log("后续的代码")

// 3 异步读取： promise
fs.promises.readFile('./aaa.txt', {encoding: 'utf-8'}).then(res => {
    console.log("promise 获取的结果是：", res)
}).catch(err => {
    console.log("发生了错误", res)
})

// ------- 文件描述符的使用 --------
// 打开一个文件
fs.open('./bbb.txt', (err, fd) => {
    if(err) {
        console.log("打开文件错误", err)
        return
    }

    // 读取文件描述符
    console.log(fd)
    // 读取文件的信息
    fs.fstat(fd, (err, stats) => {
        if (err) return
        console.log(stats)
        // 手动关闭文件
        fs.close(fd)
    })
})

// ------- 文件的写入 --------
// 待写入内容
const content = "hello world, write data"

// 写入文件操作
fs.writeFile('./ccc.txt', content, {
    encoding: 'utf-8', flag: 'a'
}, (err) => {
    if (err) {
        console.log("文件写入错误", err)
    } else {
        console.log("文件写入成功")
    }
})

// ------- 创建文件夹 --------
// 创建文件夹 directory
// fs.mkdir('./zpz', (err) => {
//     console.log(err)
// })


// ------ 文件夹操作 --------

// fs.readdir('./zpz', (err, files) => {
//     console.log("读取文件夹",files)
// })

// 读取文件夹, 获取到文件夹中文件的信息
// fs.readdir('./zpz', { withFileTypes: true }, (err, files) => {
//   files.forEach(item => {
//     if (item.isDirectory()) {
//       console.log("item是一个文件夹:", item.name)

//       fs.readdir(`./zpz/${item.name}`, { withFileTypes: true }, (err, files) => {
//         console.log(files)
//       })
//     } else {
//       console.log("item是一个文件:", item.name)
//     }
//   })
// })

// 递归方式读取文件夹中所有文件
function readDirectory(path) {
    console.log("readDirectory be call")
    fs.readdir(path, {withFileTypes: true}, (err, files) => {
        if(err) {
            console.log("readDirectory err is", err)
            return
        }
        console.log('files is', files)
        files.forEach(item => {
            if (item.isDirectory) {
                readDirectory(`${path}/${item.name}`)
            } else {
                console.log("递归方式获取文件：", item.name)
            }
        })
    })
}

readDirectory('./zpz')

// 对文件重命名
fs.rename('./ccc.txt', './ddd.txt', (err) => {
    console.log("重命名结果:", err)
})

