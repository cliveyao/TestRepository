<template>
  <div>
  </div>
</template>

<script>
import config from '@/api/config'
import api from '@/api'
import { mapGetters } from 'vuex'
import common from '@/components/common'
const requestFlag = '1'
export default {
  components: {
  },
  mounted () {
    this.doDiapatch()
  },
  watch: {
    '$route': 'doDiapatch'
  },
  methods: {
    doDiapatch () {
      let _this = this
      let params = _this.$route.query
      if (params.doOauth === requestFlag) {
        _this.$router.replace({name: 'Oauth', query: {token: params.token, requestUrl: params.requestUrl}})
      } else {
        _this.toOAuth()
      }
    },
    fromMsgAct (params) {
      let action = params.action
      if (action) {
        if (action === 'rwxq') {
          // 任务详情
          this.$router.replace({name: 'Rwxq', query: {rwid: params.rwid}})
        } else if (action === 'userxq') {
          // 用户详情
          this.$router.replace({name: 'Userxq', query: {appId: params.appId, userId: params.userId}})
        } else if (action === 'zcxq') {
          // 资产详情
          this.$router.replace({name: 'Zcxq', query: {zcid: params.zcid}})
        }
      }
    },
    toOAuth () {
      // 网页授权
      let _this = this
      let params = _this.$route.query
      let appId = params.appId
      let appFlag = params.appFlag
      let fromMsg = params.fromMsg
      if (!appId || (!appFlag && fromMsg !== requestFlag)) {
        // appId不能为空，当fromMsg不为1时，appFlag也不能为空
        this.$store.dispatch('setValidParam', false)
        _this.$vux.alert.show({
          title: '错误',
          content: '应用ID或应用标识不能为空'
        })
        return false
      } else {
        this.$store.dispatch('setValidParam', true)
      }
      let errorMsg = '应用ID不能为空'
      api.post('/wx/oauth/checkToken.do', {appId: appId}).then(function (res) {
        if (res) {
          if (res === errorMsg) {
            _this.$vux.alert.show({
              title: '网页授权失败',
              content: res
            })
          } else if (res === '用户不存在,或未分配权限') {
            _this.$vux.alert.show({
              title: '网页授权失败',
              content: res
            })
          } else {
            // 授权成功
            _this.$store.dispatch('updateAppFlag', appFlag)
            if (fromMsg === requestFlag) {
              _this.fromMsgAct(params)// 通过消息进入
            } else {
              common.toIndex(_this, appFlag)
            }
          }
        } else {
          let url = document.URL
          // window.location.href = config.api + '/wx/oauth/toOAuth.do?requestUrl=' + encodeURIComponent(url)
          window.location.href = config.api + '/wx/oauth/toOAuthTest.do?testToken=' + _this.testToken + '&requestUrl=' + encodeURIComponent(url)
          _this.$destroy()
        }
      })
    },
    contains (arr, obj) {
      let i = arr.length
      while (i--) {
        if (arr[i] === obj) {
          return true
        }
      }
      return false
    }
  },
  computed: {
    ...mapGetters([
      'testToken'
    ])
  }
}
</script>

<style scoped>
</style>
