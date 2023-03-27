<template>
    <div>ShowInfo: {{ name }}-{{ age }}</div>
    <button @click="showInfoBtnClick">showInfoButton</button>
</template>

<script setup> 
    const props = defineProps({
        name: {
            type: String,
            default: "默认值"
        },
        age: {
            type: Number,
            default: 0
        }
    })

    const emits = defineEmits(["infoBtnClick"])
    function showInfoBtnClick() {
        emits('infoBtnClick', "showInfo被点击了")
    }

    // 定义foo的函数
    function foo() {
        console.log("foo function")
    }
    defineExpose({
      foo
    })
</script>

<style>
</style>

