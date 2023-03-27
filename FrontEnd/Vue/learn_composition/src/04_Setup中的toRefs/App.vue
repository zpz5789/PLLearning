<template>
    <div class="App">
      <h2>info: {{ name }} - {{ age }} - {{ height }}</h2>
      <button @click="age++">修改age</button>
      <button @click="height = 1.89">修改height</button>
    </div>
</template>
 
<script>
import { reactive, toRef, toRefs } from 'vue'

    export default {
       
        setup() {
           const info = reactive({
            name: "zpz",
            age: 18,
            height: 1.8
           })

           // reactive被解构后会变成普通的值, 失去响应式
        //    const {name, age} = info
        
           const { name, age} = toRefs(info)
           const height = toRef(info, "height")
            return {
                name,
                age,
                height
            }
        }
    }
</script>
 
<style lang="less" scoped>
</style>