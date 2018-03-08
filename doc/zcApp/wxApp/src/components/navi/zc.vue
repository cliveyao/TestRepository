<template>
  <div>
    <!-- 此组件是无操作资产列表 -->
    <div>
      <MyZclist :tag-name="tagName" :extra-param="extraParam"></MyZclist>
    </div>
  </div>
</template>
<script>
import { XHeader } from 'vux'
import MyZclist from './zclist/MyZclist.vue'
export default {
  components: {
    XHeader,
    MyZclist
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
