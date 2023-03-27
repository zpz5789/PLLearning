<template>
    <div class="app">
        <form>
            账号: <input type="text" v-model="account.username">
            密码: <input type="password" v-model="account.password">
        </form>

        <form>
             账号: <input type="text" v-model="username">
             密码: <input type="password" v-model="password">
        </form>

        <ShowInfo :age="age" :name="username"/>
    </div>
</template>
 
<script>
import { onMounted, ref, reactive} from 'vue';
import ShowInfo from './ShowInfo.vue';

export default {
    components: {
        ShowInfo
    },
    data() {
        return {
            message: "Hello World"
        }
    },
    setup() {
       // 定义响应式数据: reactive/ref
       // 强调: ref也可以定义复杂的数据
        const info = ref({})
        console.log(info.value)

      // 1.reactive的应用场景
      // 1.1.条件一: reactive应用于本地的数据
      // 1.2.条件二: 多个数据之间是有关系/联系(聚合的数据, 组织在一起会有特定的作用)
      const account = reactive({
        username: "zpz",
        password: "123456"
      })

      const username = ref("zpz")
      const password = ref("123456")

      // 2.ref的应用场景: 其他的场景基本都用ref(computed)
      // 2.1.定义本地的一些简单数据
      const name = ref("zpz")
      const age = ref(18)

      const musics = ref([])
      onMounted(() => {
        const serverMusics = ["海阔天空", "甜蜜蜜", "晴天"]
        musics.value = serverMusics
      })

      return {
        account,
        username,
        password,
        name,
        age
      }

    }
}

</script>
 
<style lang="less" scoped>

</style>