<template>
  <div class="main">

    <group title="拒绝原因">
      <x-textarea :max="100" v-model="value" ></x-textarea>
    </group>

    <flexbox class="foot">
      <flexbox-item>
        <x-button type="primary" @click.native="refuseRevertZC">确认</x-button>
      </flexbox-item>
      <flexbox-item>
        <x-button type="warn" @click.native="cancel">取消</x-button>
      </flexbox-item>
    </flexbox>

  </div>
</template>

<script>
  import api from '@/api/index'
  import { Group, XButton, ToastPlugin, XTextarea, XInput, Flexbox, FlexboxItem } from 'vux'
  import Vue from 'vue'
  Vue.use(ToastPlugin)
  export default {
    components: {
      Group,
      XTextarea,
      XInput,
      ToastPlugin,
      XButton,
      Flexbox,
      FlexboxItem
    },
    methods: {
      cancel () {
        this.$router.go(-1)
      },
      refuseRevertZC () {
        api.post('/wx/zczt/refuseRevertZC.do', {
          zcId: this.$route.query.zcId,
          refuseRemark: this.value
        }).then((response) => {
          if (response === 'success') {
            this.$store.dispatch('updateInitZcList')
            this.$vux.toast.show({
              text: '成功'
            })
            this.$router.go(-1)
          } else {
            this.$vux.toast.show({
              type: 'warn',
              text: '失败'
            })
          }
        })
      }
    },
    data () {
      return {
        value: ''
      }
    },
    beforeRouteEnter (to, from, next) {
      next(vm => {
        // hidebottomtab
        // 拒绝归还资产
        vm.$store.dispatch('setNavHeadTitle', '拒绝归还资产')
      })
    },
    beforeRouteLeave (to, from, next) {
      // showbottomtab
      next()
    }
  }
</script>

<style scoped>
  .main{position:fixed;top:0px;bottom:42px;width:100%;}
  .foot{position:fixed;left:0;height:42px;line-height:42px;width:100%;}
  .foot{bottom:0;}

</style>
