<template>
  <group>
    <cell :title="MyAction.title" :link="{name: MyAction.link}" is-link></cell>
    <cell :title="MySetting.title" :link="{name: MySetting.link}" is-link></cell>
    <cell :title="MyConcat.title" :link="{name: MyConcat.link}" is-link></cell>
  </group>
</template>

<script>
  import { Cell, Group } from 'vux'
  import myCommon from './myCommon'
  export default {
    components: {
      Group,
      Cell
    },
    methods: {},
    data () {
      return {
        MyAction: myCommon.MyAction,
        MySetting: myCommon.MySetting,
        MyConcat: myCommon.MyConcat
      }
    },
    beforeRouteEnter (to, from, next) {
      next(vm => {
        myCommon.setHeadTitle(vm)
      })
    },
    beforeRouteLeave (to, from, next) {
      myCommon.setHeadBack(this)
      next()
    }
  }
</script>
<style scoped>
</style>
