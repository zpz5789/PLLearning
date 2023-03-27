<template>
    <div>
      <h2>当前计数: {{ counter }}</h2>
      <button @click="counter++">+1</button>
      <button @click="name = 'kobe'">修改name</button>
    </div>
</template>
<script>
    import { watchEffect, watch ,ref} from 'vue'

    export default {
        setup() {
            const counter = ref(0)
            const name = ref("zpz")

            // watch(counter, (newValue, oldValue)=>{
            //     console.log(newValue, oldValue)
            // })

            // 1.watchEffect传入的函数默认会直接被执行
            // 2.在执行的过程中, 会自动的收集依赖(依赖哪些响应式的数据)
            const stopWatch = watchEffect(()=>{
                console.log("111111", counter.value, name.value)
                if (counter.value >= 10) {
                    stopWatch()
                }
            })

            return {
                counter,
                name
            }
        }
    }
</script>

<style scoped>

</style>