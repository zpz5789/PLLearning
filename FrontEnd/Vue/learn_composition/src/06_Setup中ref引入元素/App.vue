<template>
    <div class="home">
          <!-- 1.获取元素 -->
        <h2 ref="titleRef">我是标题</h2>
        <button ref="btnRef">按钮</button>

        <!-- 2.获取组件实例 -->
        <show-info ref="showInfoRef"></show-info>

        <button @click="getElements">获取元素</button>
    </div>
</template>
 
<script>
    import { ref, onMounted} from 'vue'
    import ShowInfo from './ShowInfo.vue';

    export default {
        components: {
            ShowInfo
        },
        setup() {
            const titleRef = ref()
            const btnRef = ref()
            const showInfoRef = ref()

            onMounted(()=>{
                console.log(titleRef.value)
                console.log(btnRef.value)
                console.log(showInfoRef.value)
                
                showInfoRef.value.showInfoFoo()
            })

            function getElements() {
                console.log(titleRef.value)
            }

            return {
                titleRef,
                btnRef,
                showInfoRef,
                getElements
            }
        }
    }

</script>
 
<style lang="less" scoped>
</style>