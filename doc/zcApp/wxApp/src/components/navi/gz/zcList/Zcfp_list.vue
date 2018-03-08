<template>
  <div>
    <Zclist :tag-name="tagName" :extra-param="extraParam" ></Zclist>
  </div>
</template>
<script>
  import Zclist from '@/components/navi/zclist/Zclist'
  export default {
    components: {
      Zclist
    },
    data () {
      return {
      }
    },
    computed: {
      tagName () {
        return this.$route.query.tagName
      },
      extraParam () {
        return this.$route.query.extraParam
      }
    },
    mounted () {
    },
    methods: {
    },
    beforeRouteEnter (to, from, next) {
      next(vm => {
        // hidebottomtab
        vm.$store.dispatch('setNavHeadTitle', to.query.title)
      })
    },
    beforeRouteLeave (to, from, next) {
      // showbottomtab
      next()
    }
  }
</script>
<style scoped>
  
</style>
