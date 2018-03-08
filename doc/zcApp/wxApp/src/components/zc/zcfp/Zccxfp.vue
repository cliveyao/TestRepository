<template>
  <div class="main">

    <group>
      <cell title="原有资产使用人:" v-model="oldSyr"></cell>
      <popup-picker :title="title" :data="newZcsyr" v-model="zcsyr" :columns="2" ref="picker3" show-name></popup-picker>
    </group>

    <group title="重新分配原因">
        <XTextarea :max="100" v-model="remark"></XTextarea>
    </group>
    <flexbox class="foot">
      <flexbox-item>
        <x-button type="primary" @click.native="reassignZC">确认</x-button>
      </flexbox-item>
      <flexbox-item>
        <x-button type="warn" @click.native="cancel">取消</x-button>
      </flexbox-item>
    </flexbox>

  </div>
</template>

<script>
  import api from '@/api/index'
  import { Group, XButton, ToastPlugin, XTextarea, XInput, Flexbox, FlexboxItem, Cell, PopupPicker } from 'vux'
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
      FlexboxItem,
      Cell,
      PopupPicker
    },
    methods: {
      cancel () {
        this.$router.go(-1)
      },
      reassignZC () {
        if (this.zcsyr.length === 0 || this.zcsyr === null) {
          this.$vux.toast.show({
            type: 'warn',
            text: '请选择一个资产使用人'
          })
          return
        }
        api.post('/wx/zczt/reassignZC.do', {
          zcId: this.$route.query.zcId,
          syr: this.zcsyr[1],
          remark: this.remark
        }).then((response) => {
          this.$router.go(-1)
          if (response === 'success') {
            this.$store.dispatch('updateInitZcList')
            this.$vux.toast.show({
              text: '资产重新分配成功'
            })
          } else {
            this.$vux.toast.show({
              type: 'warn',
              text: '资产分配失败'
            })
          }
        })
        .catch((response) => {
          this.$vux.toast.show({
            type: 'warn',
            text: '失败'
          })
        })
      }
    },
    mounted: function () {
      api.post('/wx/zczt/getOldZCSYR.do', { zcId: this.$route.query.zcId }).then((response) => {
        this.oldSyr = response
      })
      .catch((response) => {
        console.log(response)
      })
      api.get('/wx/wxchuuser/getUserPicker.do', { zcId: this.$route.query.zcId }).then((response) => {
        this.newZcsyr = response
      })
      .catch((response) => {
        console.log(response)
      })
    },
    data () {
      return {
        oldSyr: '',
        newZcsyr: [],
        title: '新的资产使用人',
        zcsyr: [],
        remark: ''
      }
    },
    beforeRouteEnter (to, from, next) {
      next(vm => {
        // hidebottomtab
        // 资产重新分配
        vm.$store.dispatch('setNavHeadTitle', '资产重新分配')
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
  .foot{bottom:0px;}
</style>
