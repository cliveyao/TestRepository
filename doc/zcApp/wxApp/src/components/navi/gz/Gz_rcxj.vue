<template>
  <div>
    <Zclist :tag-name="tagName" :extra-param="extraParam"></Zclist>
  </div>
</template>
<script>
import Zclist from '@/components/navi/zclist/Zclist.vue'
export default {
  components: {
    Zclist
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
      vm.$store.dispatch('setNavHeadTitle', to.query.title)
    })
  },
  beforeRouteLeave (to, from, next) {
    this.$store.dispatch('showNavHeadBack', true)
    this.$store.dispatch('hideMainTabbar')
    next()
  }
}
</script>
<style scoped>
</style>
