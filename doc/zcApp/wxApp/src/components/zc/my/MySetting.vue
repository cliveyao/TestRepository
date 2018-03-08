<template>
  <div>
    <group>
      <x-switch title="仅在WIFI环境下加载图片和音频" v-model="allowImg" @on-change="onClick"></x-switch>
    </group>
  </div>
</template>

<script>
  import { XSwitch, Group, XButton } from 'vux'
  export default {
    components: {
      XSwitch,
      Group,
      XButton
    },
    methods: {
      onClick () {
        if (window.localStorage.allowImg) {
          window.localStorage.removeItem('allowImg')
        } else {
          window.localStorage.allowImg = true
        }
      }
    },
    data () {
      return {
        allowImg: window.localStorage.allowImg
      }
    },
    beforeRouteEnter (to, from, next) {
      next(vm => {
        // hidebottomtab
        // 我的设置
        vm.$store.dispatch('setNavHeadTitle', '我的设置')
      })
    },
    beforeRouteLeave (to, from, next) {
      // showbottomtab
      next()
    }
  }
</script>
