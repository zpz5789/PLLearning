const fs = require('fs')

// 1.一次性读取
// 缺点一: 没有办法精准控制从哪里读取, 读取什么位置.
// 缺点二: 读取到某一个位置的, 暂停读取, 恢复读取.
// 缺点三: 文件非常大的时候, 多次读取.
// fs.readFile('./aaa.txt', (err, data) => {
//   console.log(data)
// })

// 2.通过流读取文件
// 2.1. 创建一个可读流
// start: 从什么位置开始读取
// end: 读取到什么位置后结束(包括end位置字节)

const readStream = fs.createReadStream('./aaa.txt', {
    start: 8,
    end: 22,
    highWaterMark: 3
})

// readStream.on('data', (data) => {
//     console.log(data.toString())

//     readStream.pause()

//     setTimeout(() => {
//         readStream.resume()
//     }, 2000);
// })



// 2.监听读取到的数据
readStream.on('data', (data) => {
    console.log(data.toString())
  })
  
  // 3.补充其他的事件监听
  readStream.on('open', (fd) => {
    console.log('通过流将文件打开~', fd)
  })
  
  readStream.on('end', () => {
    console.log('已经读取到end位置')
  })
  
  readStream.on('close', () => {
    console.log('文件读取结束, 并且被关闭')
  })
  
  // 一次性写入
  fs.writeFile('./bbb.txt', 'hello world', {
    encoding: 'utf-8',
    flag: 'a+'
  }, (err) => {
    console.log('写入错误', err)
  })

  // 创建流写入
  const writeStream = fs.createWriteStream('./ccc.txt', {
    flags: 'a'
  })

  writeStream.on('open', (fd) => {
    console.log('文件被打开', fd)
  })

  writeStream.write('coderwhy')
  writeStream.write('aaaa')
  writeStream.write('bbb', (err) => {
    console.log('写入完成', err)
  })
  writeStream.on('finish', () => {
    console.log('写入完成')
  })

  writeStream.on('close', () => {
    console.log('文件被关闭~')
  })

// 3.写入完成时, 需要手动去掉用close方法
// writeStream.close()

// 4.end方法: 
// 操作一: 将最后的内容写入到文件中, 并且关闭文件
// 操作二: 关闭文件
  writeStream.end('哈哈哈哈')


// 文件拷贝操作
// 1.方式一: 一次性读取和写入文件
fs.readFile('./foo.txt', (err, data) => {
  console.log(data)
  fs.writeFile('./foo_copy01.txt', data, (err) => {
    console.log('写入文件完成', err)
  })
})

// 2.方式二：创建可读流和可写流
const readStream1 = fs.createReadStream('./foo.txt')
const writeStream1 = fs.createWriteStream('./foo_copy02.txt')

readStream1.on('data', (data) => {
    writeStream1.write(data)
})

readStream1.on('end', () => {
    writeStream.close()
})

// 3.在可读可写流之间创建一个管道
const readStream2 = fs.createReadStream('./foo.txt')
const writeStream2 = fs.createWriteStream('./foo_copy03.txt')
readStream2.pipe(writeStream2)