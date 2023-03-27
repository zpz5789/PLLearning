<template>
    <div class="App">
        <h2>App: {{ info }}</h2>
        <show-info 
        :info="info"
        :roInfo="roInfo"
        @changeInfoName="changeInfoName" 
        @changeRoInfoName="changeRoInfoName"/>
    </div>
</template>
 
<script>
    import { reactive, readonly } from 'vue';
    import ShowInfo from './ShowInfo.vue';

    export default {
        components: {
            ShowInfo
        },
        setup() {
            const info = reactive({
                name: "zpz",
                age: 20,
                height: 1.8
            })

            function changeInfoName(payload) {
                info.name = payload
            }

            const roInfo = readonly(info)
            function changeRoInfoName(payload) {
                console.log('changeRoInfoName', payload)
                info.name = payload
            }

            return {
                info,
                changeInfoName,
                roInfo,
                changeRoInfoName
            }
        }
    }
</script>
 
<style lang="less" scoped>
</style>