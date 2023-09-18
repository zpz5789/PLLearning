// evnets 模块中的事件总线
const EventEmitter = require('events')

// 创建EventEmitter实例
const emitter = new EventEmitter()

// 监听事件
emitter.on('zpz', () => {
    console.log('监听zpz事件')
})

// 发射事件
setTimeout(() => {
    emitter.emit('zpz')
}, 2000);

function handleZpzFn() {
    console.log('zpz1事件被触发')
}

// 取消事件
emitter.on('zpz1', handleZpzFn)
setTimeout(() => {
    emitter.emit('zpz1')

    // 取消事件监听
    emitter.off('zpz1', handleZpzFn)

    setTimeout(() => {
        emitter.emit('zpz1')
    }, 1000);
}, 2000);

// 事件传参
function handleZpzFn1(name, age, height) {
    console.log('handleZpzFn1', name, age, height)
}

emitter.on('player', handleZpzFn1)

// 发射事件
setTimeout(() => {
    emitter.emit('player', "wade", 30 ,1.88)
}, 2000);


// 1.获取所有监听事件的名称
console.log(emitter.eventNames())

// 2.获取监听最大的监听个数
console.log(emitter.getMaxListeners())

// 3.获取某一个事件名称对应的监听器个数
console.log(emitter.listenerCount('why'))

// 4.获取某一个事件名称对应的监听器函数(数组)
console.log(emitter.listeners('why'))

const ee = new EventEmitter()

// ee.on("why", () => {
//   console.log("on监听why")
// })

// 1.once: 事件监听只监听一次(第一次发射事件的时候进行监听)
ee.once("why", () => {
  console.log("on监听why")
})

// 2.prependListener: 将事件监听添加到最前面
ee.prependListener('why', () => {
  console.log('on监听why2')
})

ee.emit('why')

// 3.移除所有的事件监听
// 不传递参数的情况下, 移除所有事件名称的所有事件监听
// 在传递参数的情况下, 只会移除传递的事件名称的事件监听
ee.removeAllListeners('why')


function foo() {
    console.log(this.a);
}
let a = 2;
var o = { a: 3, foo: foo };
var p = { a: 4 };

o.foo(); // 3
(p.foo = o.foo)(); // 2
console.log('ssss',(p.foo = o.foo), o.foo, p.foo)

console.log('43.9933.toFixed(2) is', 43.9933.toFixed(2))