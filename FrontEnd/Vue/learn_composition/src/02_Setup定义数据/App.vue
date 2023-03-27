<template>
  <div class="app">
    <h2>message:{{ message }}</h2>
    <h2>userName:{{ account.username }}</h2>
    <button @click="changeAccount">修改用户名</button>
    <h2>counter is:{{ counter }}</h2>
    <button @click="increment">修改counter</button>
    <h2>info is:{{ info.counter }}</h2>
    <!-- 修改的时候需要写.value -->
    <button @click="info.counter.value++">+1</button>
    <!-- <button @click=""></button> -->
  </div>
</template>

<script>
import { reactive, ref } from 'vue'

export default {
  setup() {
    // 定义普通数据，可以使用，但不是响应式的
    const message = "helloworld"
    function changeMessage() {
      // eslint-disable-next-line no-const-assign
      message = "hello, message"
      console.log(message)
    }

    // 定义响应式数据
    // 定义复杂类型数据，reactive函数
    const account = reactive({
      username: "zpz",
      password: "123545"
    })

    function changeAccount() {
      console.log('修改用户')
      account.username = "kl"
    }

    // ref函数，定义简单数据类型（也可以定义复杂数据类型）
    // counter定义响应式数据
    // 在模板中引入ref的值时，Vue会自动帮助我们进行解包操作，所以我们并不需要在模板中通过 ref.value 的方式来使用；
    // 但是在 setup 函数内部，它依然是一个 ref引用， 所以对其进行操作时，我们依然需要使用 ref.value的方式；
    const counter = ref(0)
    function increment() {
      counter.value++
    }

    // ref是浅层解包
    const info = {counter}

    return {
      message,
      changeMessage,
      account,
      changeAccount,
      counter,
      increment,
      info
    }
    
  }
}
</script>

<style scoped>

</style>