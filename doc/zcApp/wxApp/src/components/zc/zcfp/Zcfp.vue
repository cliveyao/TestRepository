<template>
  <div class="main">
    <group>
       <popup-picker :title="title" :data="userList" v-model="zcsyr" :columns="2" ref="picker3" show-name></popup-picker>
    </group>
    <flexbox class="foot">
      <flexbox-item>
        <x-button type="primary" @click.native="assignZC">确认</x-button>
      </flexbox-item>
      <flexbox-item>
        <x-button type="warn" @click.native="cancel">取消</x-button>
      </flexbox-item>
    </flexbox>
  </div>
</template>

<script>
  import api from '@/api/index'
  import { PopupPicker, Group, Cell, Picker, XButton, ToastPlugin, Flexbox, FlexboxItem } from 'vux'
  import Vue from 'vue'
  Vue.use(ToastPlugin)
  export default {
    components: {
      PopupPicker,
      Group,
      Picker,
      ToastPlugin,
      XButton,
      Flexbox,
      FlexboxItem,
      Cell
    },
    methods: {
      cancel () {
        this.$router.go(-1)
      },
      assignZC () {
        if (this.zcsyr === null || this.zcsyr.length === 0) {
          this.$vux.toast.show({
            type: 'warn',
            text: '请选择一个资产使用人'
          })
          return
        }
        api.post('/wx/zczt/assignZC.do', {
          zcId: this.$route.query.zcId,
          syr: this.zcsyr[1]
        }).then((response) => {
          this.$router.go(-1)
          if (response === 'success') {
            this.$store.dispatch('updateInitZcList')
            this.$vux.toast.show({
              text: '资产分配成功'
            })
          } else {
            this.$vux.toast.show({
              type: 'warn',
              text: '分配失败'
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
      api.get('/wx/wxchuuser/getUserPicker.do').then((response) => {
        this.userList = response
      })
        .catch((response) => {
          console.log(response)
        })
    },
    data () {
      return {
        title: '资产使用人:',
        userList: [],
        zcsyr: []
      }
    },
    beforeRouteEnter (to, from, next) {
      next(vm => {
        // hidebottomtab
        // 资产分配
        vm.$store.dispatch('setNavHeadTitle', '资产分配')
      })
    },
    beforeRouteLeave (to, from, next) {
      // showbottomtab
      next()
    }
  }
</script>

<style scoped>
  .picker-buttons {
    margin: 0 15px;
  }
  .foot{position:fixed;left:0;height:42px;line-height:42px;width:100%;}
  .foot{bottom:0px;}

</style>
