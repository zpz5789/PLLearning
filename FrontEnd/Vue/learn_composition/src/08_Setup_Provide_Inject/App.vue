<template>
    <div class="">
        <div>AppContent: {{ name }}</div>
        <button @click="name = 'james'">app btn</button>
        <show-info></show-info>
    </div>
</template>
 
<script>
    import { provide, ref } from 'vue'
    import ShowInfo from './ShowInfo.vue'    
    export default {
        components: {
            ShowInfo
        },
        setup() {
            const name = ref("zpz")

            provide("name", name)
            provide("age", 18)
            return {
                name
            }
        }
    }
</script>
 
<style lang="less" scoped>
</style>