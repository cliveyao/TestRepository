<template>
  <div>
    <group>
      <popup-picker title="消息类型" :data="lxList" v-model="lxValue" show-name @on-change="onChange"></popup-picker>
    </group>

    <div v-for="item in msgList">
      <group>
        <table>
          <tbody>
          <tr>
            <td class="textTop dateCls">
              <h3 class="inlineStyle">{{item.fssj | normalTime('DD')}}</h3><h5 class="inlineStyle ml">{{item.fssj | normalTime('MM月')}}</h5>
            </td>
            <td>
              {{item.nr}}
            </td>
          </tr>
          </tbody>
        </table>
      </group>
    </div>
  </div>
</template>

<script>
  import { XSwitch, Group, XButton, PopupPicker } from 'vux'
  import api from '@/api/index'
  export default {
    components: {
      XSwitch,
      Group,
      XButton,
      PopupPicker
    },
    methods: {
      onChange () {
        let _this = this
        api.post('/wx/mymsg/getMsgList.do', {
          msgLx: _this.lxValue[0]
        }).then((response) => {
          _this.msgList = response
        })
      }
    },
    data () {
      return {
        msgList: [],
        lxList: [],
        lxValue: []
      }
    },
    mounted: function () {
      let _this = this
      api.post('/wx/mymsg/getMsgList.do', {}).then((response) => {
        _this.msgList = response
      })
      api.post('/wx/mymsg/getLxPickListWithAll.do', {}).then((response) => {
        _this.lxList = response
        _this.lxValue = [response[0][0].value]
      })
    },
    beforeRouteEnter (to, from, next) {
      next(vm => {
        // 我的消息
        vm.$store.dispatch('setNavHeadTitle', '我的消息')
        // hidebottomtab
      })
    },
    beforeRouteLeave (to, from, next) {
      // showbottomtab
      next()
    }
  }
</script>
<style scoped>
  .textTop {
    vertical-align: top;
  }

  .textTop p {
    font-size: 10px;
  }

  .ttt {
    font-size: 10px;
  }

  .dateCls {
    width: 68px;
  }

  .inlineStyle {
    display: inline;
  }

  .ml {
    margin-left: 2px;
  }
</style>
