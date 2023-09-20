<template>
  <div class="app">
    <h2>app</h2>
    <RouterLink to="/main">主要</RouterLink>
    <div>klfjlsjf</div>
    <RouterLink to="/login">登录</RouterLink>
    <div>1klfjlsjf</div>
    <router-view></router-view>

    <el-row class="mb-4">
      <el-button type="primary">Primary</el-button>
      <el-button type="success">Success</el-button>
      <el-button type="info">Info</el-button>
      <el-button type="warning">Warning</el-button>
      <el-button type="danger">Danger</el-button>
    </el-row>
  </div>
</template>

<script setup lang="ts">
interface IKun {
  name: string
  age: string
}

const ikun: IKun = {
  name: 'koko',
  age: 'HashChangeEvent'
}
console.log(ikun)
</script>

<style scoped></style>
