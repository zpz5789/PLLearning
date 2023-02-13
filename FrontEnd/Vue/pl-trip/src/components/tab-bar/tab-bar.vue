<template>
    <div class="tab-bar">
       <template v-for="(item, index) in tabbarData">
        <div class="tab-bar-item">
            <img :src="getAssetURL(item.image)">
            <span>{{item.text}}</span>
        </div>
       </template>
    </div>
</template>
 
<script setup>
import tabbarData from '@/assets/data/tabbar';
import {getAssetURL} from "@/utils/load_assets"


</script>
 
<style lang="less" scoped>

.tab-bar {
    position: fixed;
    display: flex;
    bottom: 0;
    left: 0;
    right: 0;
    height: 50px;
    border-top: 1px solid #f4f4f4;
    .tab-bar-item {
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;

        img {
            width: 36px;
        }
        .text {
            font-size: 12px;
            margin-top: 2px;
        }
    }
}

</style>