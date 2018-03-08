<template>
  <div>
    <!-- 此组件是包含搜索工具栏的资产列表 -->
    <div>
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tbody>
          <tr>
            <td class="qrcodeTd"><div class="qrcodeBtn" @click="scanQrcode"></div></td>
            <td>
              <search placeholder="资产代码" :auto-fixed="false" v-model="searchParam" @on-submit="doSearch" ref="search"></search>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div v-if="doSearchFlag">
      <Zclist v-if="doSearchFlag" :search-param="searchParam" :tag-name="tagName" :extra-param="extraParam" key="myZcList_search"></Zclist>
    </div>
    <div v-show="!doSearchFlag">
      <Zclist :tag-name="tagName" :extra-param="extraParam" key="myZcList_main"></Zclist>
    </div>
  </div>
</template>
<script>
  import api from '@/api'
  import { Panel, Search } from 'vux'
  import common from '@/components/common'
  import Zclist from '@/components/navi/zclist/Zclist'
  export default {
    components: {
      Panel,
      Search,
      Zclist
    },
    props: ['tagName', 'extraParam'],
    data () {
      return {
        wxConfig: {},
        searchParam: '',
        doSearchFlag: false
      }
    },
    computed: {
    },
    watch: {
      searchParam: function () {
        if (!this.searchParam) {
          this.doSearchFlag = false
        }
      }
    },
    mounted () {
      this.getWxConfig()
    },
    methods: {
      doSearch () {
        this.doSearchFlag = true
      },
      getWxConfig () {
        let _this = this
        api.post('/wx/common/getWXConfig.do', {url: document.URL}).then(function (res) {
          if (res) {
            _this.wxConfig = res
            _this.wxConfig['debug'] = false
            _this.wxConfig['jsApiList'] = ['scanQRCode']
          }
        })
      },
      scanQrcode () {
        // 扫描设备二维码
        let _this = this
        let wxObj = _this.$wechat
        wxObj.config(_this.wxConfig)
        wxObj.scanQRCode({
          desc: '扫描设备二维码',
          needResult: 1, // 默认为0，扫描结果由企业微信处理，1则直接返回扫描结果，
          scanType: ['qrCode', 'barCode'], // 可以指定扫二维码还是一维码，默认二者都有
          success: function (res) {
            let reslt = common.scanCodeInfo(res)
            if (reslt) {
              _this.searchParam = reslt
              _this.doSearch()
            } else {
              _this.$vux.alert.show({content: '非法信息'})
            }
          },
          error: function (res) {
            if (res.errMsg.indexOf('function_not_exist') > 0) {
              _this.$vux.alert.show({
                title: '提示',
                content: '版本过低请升级！'
              })
            }
          }
        })
      }
    }
  }
</script>
<style scoped>
.qrcodeTd {
  text-align: center;
  width: 40px;
  background-color: #efeff4;
}
.qrcodeBtn {
  width: 32px;
  height: 32px;
  margin: 0 auto;
  background-image: url('../../../assets/qrcode.png');
}
.qrcodeBtn:before{
  background-image: url('../../../assets/qrcode.png');
}
.qrcodeBtn:active{
  background-image: url('../../../assets/qrcode_on.png');
}
.flex-demo {
  text-align: center;
  border: 1px solid #eee;
}
</style>
