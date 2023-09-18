const fs = require('fs')

/* 
 * 1. 创建buffer  DeprecationWarning: Buffer() is deprecated due to security and usability issues.
 * Please use the Buffer.alloc(), Buffer.allocUnsafe(), or Buffer.from() methods instead. 
 */
// const buf = new Buffer('hello')
// console.log(buf)
// 2. 创建buffer
const buf2 = Buffer.from('world')
console.log(buf2)
// 3. 创建buffer（字符串包含中文）
const buf3 = Buffer.from('I am from 中国')
console.log(buf3)
console.log(buf3.toString())
// 4. 手动指定的buffer创建过程编码
const buf4 = Buffer.from('哈哈哈', 'utf16le')
console.log(buf4)
// 解码操作
console.log(buf4.toString('utf16le'))

// 5.创建一个8字节大小的buffer
const buf5 = Buffer.alloc(8)
console.log(buf5)

// 6.手动对每个字节进行访问
console.log(buf5[0])
console.log(buf5[1])

buf5[0] = 100 // 转换成二进制位0x64
buf5[1] = 0x66
console.log(buf5) // 打印结果： <Buffer 64 66 00 00 00 00 00 00>
console.log(buf5.toString()) // df 64->d 65->f

buf5[2] = 'm'.charCodeAt()
console.log(buf5)

// 7.从文件中读取buffer
fs.readFile('./aaa.txt', {encoding: 'utf-8'}, (err, data) => {
    console.log('readFile')
    if (err) {
        console.log('err is', err)
        return
    }
    console.log('data is', data)
   
})

fs.readFile('./aaa.txt', (err, data) => {
    console.log('data to string is', data.toString())
    data[0] = 0x66
    console.log(data.toString())
})

fs.readFile('./kobe02.png', (err, data) => {
    console.log(data)
})