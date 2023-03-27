<template>
    <div>AppContent</div>
    <button @click="
    value++"> value++</button>
    <div>{{ value }}</div>
  </template>
  
  <script>
    import { onMounted, onUpdated, onUnmounted, ref } from 'vue'
  
    export default {
      beforeCreate() {
        console.log("beforeCreate")

      },
      created() {
        console.log("created")

      },
      beforeMount() {
         console.log("beforeMount")

      },
      mounted() {
        console.log("mounted")

      },
      beforeUpdate() {
        console.log("beforeUpdate")

      },
      updated() {
        console.log("updated")

      },
      setup() {
        const value = ref(2)
        // 在执行setup函数的过程中, 你需要注册别的生命周期函数
        onMounted(() => {
          console.log("onmounted")
        }),
        onUpdated(()=> {
            console.log("onUpdated")

        })
        return {
            value
        }
      }
    }
  </script>
  
  <style scoped>
  </style>
  
  