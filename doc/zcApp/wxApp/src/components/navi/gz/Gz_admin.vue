<template>
  <div>
    <grid>
      <grid-item label="登记"  @on-item-click="bmzcdj">
        <img slot="icon" src="../../../assets/zcdj.png">
      </grid-item>
      <grid-item :link="{ name: 'GzZcdbList', query: {tagName: tagName, extraParam: 0, title: '资产调拨'}}" label="调拨">
        <img slot="icon" src="../../../assets/zcdb.png">
      </grid-item>
      <grid-item :link="{ name: 'GzZcspList', query: {tagName: tagName, extraParam: 1, title: '资产审批'}}" label="审批">
        <img slot="icon" src="../../../assets/zcsp.png">
      </grid-item>
      <grid-item :link="{name: 'NaviZc', query: {tagName: tagName, extraParam: 2, title: '固定资产'}}" label="盘点">
        <img slot="icon" src="../../../assets/zcpd.png">
      </grid-item>
    </grid>
  </div>
</template>
<script>
import api from '@/api/index'
import common from '@/components/common'
import { Grid, GridItem } from 'vux'
export default {
  components: {
    Grid,
    GridItem
  },
  data () {
    return {
      gzTabIndex: 0,
      wxConfig: {}
    }
  },
  computed: {
    tagName () {
      return this.$route.query.tagName
    }
  },
  mounted () {
    this.getWxConfig()
  },
  methods: {
    onItemClick (index) {
      this.gzTabIndex = index
    },
    getWxConfig () {
      let _this = this
      api.post('/wx/common/getWXConfig.do', {url: document.URL}).then(function (res) {
        if (res) {
          let wxConfig = res
          wxConfig['debug'] = false
          wxConfig['jsApiList'] = ['scanQRCode']
          _this.wxConfig = wxConfig
        }
      })
    },
    bmzcdj () {
      let _this = this
      let wxObj = _this.$wechat
      wxObj.config(_this.wxConfig)
      wxObj.ready(function () {
        _this.scanQRCode(wxObj)
      })
    },
    scanQRCode (wxObj) {
      let _this = this
      wxObj.scanQRCode({
        desc: '扫描设备二维码',
        needResult: 1, // 默认为0，扫描结果由企业微信处理，1则直接返回扫描结果，
        scanType: ['qrCode', 'barCode'], // 可以指定扫二维码还是一维码，默认二者都有
        success: function (res) {
          let json = common.scanCodeInfo(res)
          if (json) {
            api.post('/wx/zczt/isExist.do', {
              dm: json
            }).then((response) => {
              if (response == null) {
                _this.$router.push({name: 'Zcdj', query: {zcdm: json}})
              } else {
                _this.$vux.alert.show({
                  title: '提示',
                  content: '资产已登记！'
                })
                _this.$router.push({name: 'ZcxqNav', query: {zcid: response.id}})
              }
            })
              .catch((response) => {
                console.log(response)
              })
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
  },
  beforeRouteEnter (to, from, next) {
    next(vm => {
      vm.$store.dispatch('setNavHeadTitle', '我的工作')
      vm.$store.dispatch('updateInitZcList') // 初始化资产列表
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
