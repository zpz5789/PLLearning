<template>
    <div>AppContent: {{ message }}</div>
    <button @click="changeMessage">修改message</button>
    <show-info name="why" 
               :age="18"
               @info-btn-click="infoBtnClick"
               ref="showInfoRef">
    </show-info>
    <show-info></show-info>
    <show-info></show-info>
</template>

<script setup>
    import {ref, onMounted} from 'vue'
    import ShowInfo from './ShowInfo.vue'

    const message = ref('hello world')
    console.log(message.value)

    function changeMessage() {
        message.value = "你好啊，master"
    }

    function infoBtnClick(payload) {
        console.log('监听到show被点击了：', payload)
    }

    const showInfoRef = ref()

    // onmounted(()=>{

    // })

    onMounted(()=>{
        showInfoRef.value.foo()
    })
</script>

<style scoped>

</style>