<template>
  <div>
    <tabbar class="vux-demo-tabbar" icon-class="vux-center" v-show="mainTabbarFlag" slot="bottom">
      <tabbar-item :link="indexRoute" :selected="isIndex" :badge="lyZcCountNo">
        <img slot="icon-active" src="../../../assets/zcLy_active.png">
        <img slot="icon" src="../../../assets/zcLy.png">
        <span slot="label">领用</span>
      </tabbar-item>
      <tabbar-item :link="{name: sqRoute, query: {tagName: tagName, extraParam: 1, title: '待申请资产'}}" :selected="isZcSq">
        <img slot="icon-active" src="../../../assets/zcSq_active.png">
            <img slot="icon" src="../../../assets/zcSq.png">
            <span slot="label">申请</span>
      </tabbar-item>
      <tabbar-item :link="{name: zcRoute, query: {tagName: tagName, title: '我的资产'}}" :selected="isZc" >
        <img slot="icon-active" src="../../../assets/zc_active.png">
        <img slot="icon" src="../../../assets/zc.png">
        <span slot="label">资产</span>
      </tabbar-item>
    </tabbar>
  </div>
</template>
<script>
  import { Tabbar, TabbarItem } from 'vux'
  import common from '@/components/common'
  import { mapState } from 'vuex'
  export default {
    components: {
      Tabbar,
      TabbarItem
    },
    props: ['tagName', 'appFlag', 'validParam'],
    data () {
      return {
        zcRoute: 'NaviZc',
        sqRoute: 'NaviMyZcSq'
      }
    },
    computed: {
      ...mapState({
        lyZcCountNo: state => state.vux.navi.lyZcCountNo
      }),
      indexRoute () {
        return common.getIndexRoute(this.appFlag)
      },
      isIndex () {
        return common.isCurrPage(this, this.indexRoute.name)
      },
      isZcSq () {
        return common.isCurrPage(this, this.sqRoute)
      },
      isZc () {
        return common.isCurrPage(this, this.zcRoute)
      },
      isMainPage () {
        return this.isIndex || this.isZcSq || this.isZc
      },
      mainTabbarFlag () {
        if (!window.localStorage.token || !this.validParam) {
          return false
        }
        return this.isMainPage
      }
    },
    watch: {
      isMainPage (isMainPage) {
        common.changeMainPageFlag(this, isMainPage)
      }
    }
  }
</script>
<style scoped>
  
</style>
