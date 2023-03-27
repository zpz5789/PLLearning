<template>
    <div class="App">
      <h2> {{ fullName }}</h2>
      <button @click="setFullName">设置fullName</button>
      <h2>{{ scroeLevel }}</h2>
      输入分数: <input type="text" v-model="score">
    </div>
</template>
 
<script>
import { computed, reactive, ref } from 'vue'

    export default {
       
        setup() {
           const names = reactive({
            firstName: "james",
            lastName: "lebron"
           })

           const fullName = computed({
            set: function(newValue) {
                const tempNames = newValue.split(" ")
                names.firstName = tempNames[0]
                names.lastName = tempNames[1]
            },
            get: function() {
                return names.firstName + "" + names.lastName
            }
           })

           console.log(fullName)

           function setFullName() {
            fullName.value = 'zpz cool'
            console.log(names)
           }

           const score = ref(98)
           const scroeLevel = computed(()=>{
            return score.value >= 60 ? "及格": "不及格"
           })

           

            return {
                names,
                fullName,
                setFullName,
                scroeLevel,
                score
            }
        }
    }
</script>
 
<style lang="less" scoped>
</style>