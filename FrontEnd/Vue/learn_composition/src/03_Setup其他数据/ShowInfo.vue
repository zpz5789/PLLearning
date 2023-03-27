<template>
    <div class="abc">
        <h2>ShowInfo: {{ info }}</h2>
            <!-- 代码没有错误, 但是违背规范(单项数据流) -->
        <button @click=" info.name = 'kobe'">ShowInfo按钮</button>
            <!-- 正确的做法: 符合单项数据流-->
        <button @click="showInfobtnClick">ShowInfo按钮</button>
        <!-- 使用readonly的数据 -->
        <h2>ShowInfo: {{ roInfo }}</h2>
         <!-- 代码就会无效(报警告) -->
         <!-- <button @click="roInfo.name = 'james'">ShowInfo按钮</button> -->
         <!-- 正确的做法 -->
         <button @click="roInfoBtnClick">roInfo按钮</button>
    </div>
</template>
 
<script>
    export default {
        props: {
                info: {
                        type: Object,
                        default: ()=>({})
                },
                roInfo: {
                        type: Object,
                        default: ()=>({})
                }
        },
        emits: ["changeInfoName", "changeRoInfoName"],
        setup(props, context) {
            function showInfobtnClick() {
                context.emit("changeInfoName", "kobe")
            }

            function roInfoBtnClick() {
                console.log(context)
                context.emit("changeRoInfoName", "wade")
            }

            return {
                showInfobtnClick,
                roInfoBtnClick
            }
        }
        
    }

</script>
 
<style lang="less" scoped>
</style>