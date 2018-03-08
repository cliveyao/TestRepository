<template>
  <div>
    <tabbar class="vux-demo-tabbar" icon-class="vux-center" v-show="mainTabbarFlag" slot="bottom">
      <tabbar-item :link="indexRoute" :selected="isIndex" :badge="gzCountNo">
        <img slot="icon-active" src="../../../assets/work_active.png">
        <img slot="icon" src="../../../assets/work.png">
        <span slot="label">巡检</span>
      </tabbar-item>
      <tabbar-item :link="{name: myRoute, query: {tagName: tagName}}" :selected="isMy">
        <img slot="icon-active" src="../../../assets/my_active.png">
        <img slot="icon" src="../../../assets/my.png">
        <span slot="label">我的</span>
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
        gzRoute: 'NaviRcxjGz',
        myRoute: 'NaviRcxjMy'
      }
    },
    computed: {
      ...mapState({
        gzCountNo: state => state.vux.navi.gzCountNo
      }),
      indexRoute () {
        return common.getIndexRoute(this.appFlag)
      },
      isIndex () {
        return common.isCurrPage(this, this.indexRoute.name)
      },
      isMy () {
        return this.$route.name === this.myRoute
      },
      isMainPage () {
        return this.isIndex || this.isMy
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
