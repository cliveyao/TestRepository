<template>
  <div style="height:100%;">
    <div v-transfer-dom>
      <loading v-model="isLoading"></loading>
    </div>
    <!-- <div v-transfer-dom>
      <actionsheet :menus="menus" v-model="showMenu" show-cancel @on-click-menu="doMoreAction"></actionsheet>
    </div> -->

    <drawer
    width="200px;"
    :show.sync="drawerVisibility"
    :show-mode="showModeValue"
    :placement="showPlacementValue"
    :drawer-style="{'background-color':'#35495e', width: '200px'}">

      <!-- drawer content 
      <div slot="drawer">
        <group title="Drawer demo(beta)" style="margin-top:20px;">
          <cell title="Demo" link="/foo" value="演示" @click.native="drawerVisibility = false">
          </cell>
          <cell title="Buy me a coffee" link="project/donate" @click.native="drawerVisibility = false">
          </cell>
          <cell title="Github" link="http://github.com/airyland/vux" value="Star me" @click.native="drawerVisibility = false">
          </cell>
        </group>
        <group title="showMode">
          <radio v-model="showMode" :options="['push', 'overlay']" @on-change="onShowModeChange"></radio>
        </group>
        <group title="placement">
          <radio v-model="showPlacement" :options="['left', 'right']" @on-change="onPlacementChange"></radio>
        </group>
      </div>-->

      <!-- main content -->
      <view-box ref="viewBox" body-padding-top="46px" :body-padding-bottom="mainPaddingBottom">
        
        <x-header slot="header"
        style="width:100%;position:absolute;left:0;top:0;z-index:100;"
        :left-options="leftOptions"
        :right-options="rightOptions"
        :title="headTitle"
        :transition="headerTransition"
        @on-click-more="onClickMore">
          <!-- <span v-if="route.path === '/' || route.path === '/component/drawer'" slot="overwrite-left" @click="drawerVisibility = !drawerVisibility">
            <x-icon type="navicon" size="35" style="fill:#fff;position:relative;top:-8px;left:-3px;"></x-icon>
          </span> -->
        </x-header>
        
        <!-- remember to import BusPlugin in main.js if you use components: x-img and sticky -->
        <transition
        @after-enter="$vux.bus && $vux.bus.$emit('vux:after-view-enter')" 
        :name="'vux-pop-' + (direction === 'forward' ? 'in' : 'out')">
          <keep-alive>
            <router-view class="router-view" v-if="$route.meta.keepAlive"></router-view>
          </keep-alive>
        </transition>
        <transition
        @after-enter="$vux.bus && $vux.bus.$emit('vux:after-view-enter')" 
        :name="'vux-pop-' + (direction === 'forward' ? 'in' : 'out')">
          <router-view class="router-view" v-if="!$route.meta.keepAlive"></router-view>
        </transition>
        
        <BmadminTab v-if="isBmadmin" :tag-name="tagName" :app-flag="appFlag" :valid-param="validParam"></BmadminTab>
        
        <AdminTab v-if="isAdmin" :tag-name="tagName" :app-flag="appFlag" :valid-param="validParam"></AdminTab>

        <RcxjTab v-if="isRcxj" :tag-name="tagName" :app-flag="appFlag" :valid-param="validParam"></RcxjTab>

        <GzwxTab v-if="isGzwx" :tag-name="tagName" :app-flag="appFlag" :valid-param="validParam"></GzwxTab>

        <MyzcTab v-if="isMy" :tag-name="tagName" :app-flag="appFlag" :valid-param="validParam"></MyzcTab>

      </view-box>
    </drawer>
  </div>
</template>

<script>
import BmadminTab from '@/components/navi/tabbar/BmadminTab'
import AdminTab from '@/components/navi/tabbar/AdminTab'
import RcxjTab from '@/components/navi/tabbar/RcxjTab'
import GzwxTab from '@/components/navi/tabbar/GzwxTab'
import MyzcTab from '@/components/navi/tabbar/MyzcTab'

import { Radio, Group, Cell, Badge, Drawer, ButtonTab, ButtonTabItem, ViewBox, XHeader, Loading, TransferDom } from 'vux'
import { mapState, mapActions } from 'vuex'
import common from '@/components/common'
export default {
  directives: {
    TransferDom
  },
  components: {
    BmadminTab,
    AdminTab,
    RcxjTab,
    GzwxTab,
    MyzcTab,
    Radio,
    Group,
    Cell,
    Badge,
    Drawer,
    ButtonTab,
    ButtonTabItem,
    ViewBox,
    XHeader,
    Loading
  },
  methods: {
    // onShowModeChange (val) {
    //   /** hide drawer before changing showMode **/
    //   this.drawerVisibility = false
    //   setTimeout(one => {
    //     this.showModeValue = val
    //   }, 400)
    // },
    // onPlacementChange (val) {
    //   /** hide drawer before changing position **/
    //   this.drawerVisibility = false
    //   setTimeout(one => {
    //     this.showPlacementValue = val
    //   }, 400)
    // },
    // doMoreAction (key) {
    //   let _this = this
    //   if (key === 'menu_zcdj') {
    //     let wxObj = _this.$wechat
    //     wxObj.config(_this.mainWxConfig)
    //     wxObj.ready(function () {
    //       _this.scanQRCode(wxObj)
    //     })
    //   }
    // },
    onClickMore () {
      this.showMenu = true
    },
    ...mapActions([
      'updateDemoPosition'
    ]),
    initFuc () {
      this.handler = () => {
        if (this.path === '/foo') {
          this.box = document.querySelector('#demo_list_box')
          this.updateDemoPosition(this.box.scrollTop)
        }
      }
    }
  },
  mounted () {
    this.initFuc()
  },
  beforeDestroy () {
    this.box && this.box.removeEventListener('scroll', this.handler, false)
  },
  watch: {
    path (path) {
      if (path === '/component/foo') {
        this.$router.replace('/foo')
        return
      }
      if (path === '/foo') {
        setTimeout(() => {
          this.box = document.querySelector('#demo_list_box')
          if (this.box) {
            this.box.removeEventListener('scroll', this.handler, false)
            this.box.addEventListener('scroll', this.handler, false)
          }
        }, 1000)
      } else {
        this.box && this.box.removeEventListener('scroll', this.handler, false)
      }
    }
  },
  computed: {
    tagName () {
      return this.$route.query.tagName
    },
    isBmadmin () {
      return common.isBmadmin(this.appFlag)
    },
    isAdmin () {
      return common.isAdmin(this.appFlag)
    },
    isRcxj () {
      return common.isRcxj(this.appFlag)
    },
    isGzwx () {
      return common.isGzwx(this.appFlag)
    },
    isMy () {
      return common.isMy(this.appFlag)
    },
    ...mapState({
      route: state => state.route,
      path: state => state.route.path,
      deviceready: state => state.app.deviceready,
      demoTop: state => state.vux.demoScrollTop,
      isLoading: state => state.vux.isLoading,
      direction: state => state.vux.direction,
      gzCountNo: state => state.vux.navi.gzCountNo,
      navHeadTitle: state => state.vux.navi.navHeadTitle,
      navHeadBack: state => state.vux.navi.navHeadBack,
      validParam: state => state.vux.navi.validParam,
      mainPageFlag: state => state.vux.navi.mainPageFlag,
      appFlag: state => state.vux.navi.appFlag
    }),
    isShowBar () {
      if (/component/.test(this.path)) {
        return true
      }
      return false
    },
    leftOptions () {
      let backFlag = true
      if (this.mainPageFlag) {
        backFlag = false
      } else {
        backFlag = this.navHeadBack
      }
      return {
        showBack: backFlag
      }
    },
    mainPaddingBottom () {
      if (this.mainPageFlag) {
        return '55px'
      } else {
        return '0px'
      }
    },
    rightOptions () {
      return {
        // showMore: common.showHeadRight(this)
        showMore: false
      }
    },
    headerTransition () {
      return this.direction === 'forward' ? 'vux-header-fade-in-right' : 'vux-header-fade-in-left'
    },
    componentName () {
      if (this.route.path) {
        const parts = this.route.path.split('/')
        if (/component/.test(this.route.path) && parts[2]) return parts[2]
      }
    },
    isDemo () {
      return /component|demo/.test(this.route.path)
    },
    headTitle () {
      return this.navHeadTitle
    }
  },
  data () {
    return {
      showMenu: false,
      menus: {
        menu_zcdj: ''
      },
      drawerVisibility: false,
      showMode: 'push',
      showModeValue: 'push',
      showPlacement: 'left',
      showPlacementValue: 'left'
    }
  }
}
</script>

<style lang="less">
@import '~vux/src/styles/reset.less';
@import '~vux/src/styles/1px.less';
@import '~vux/src/styles/tap.less';

body {
  background-color: #fbf9fe;
}
html, body {
  height: 100%;
  width: 100%;
  overflow-x: hidden;
}

.demo-icon-22 {
  font-family: 'vux-demo';
  font-size: 22px;
  color: #888;
}
.weui-tabbar.vux-demo-tabbar {
  /** backdrop-filter: blur(10px);
  background-color: none;
  background: rgba(247, 247, 250, 0.5);**/
}
.vux-demo-tabbar .weui-bar__item_on .demo-icon-22 {
  color: #F70968;
}
.vux-demo-tabbar .weui-tabbar_item.weui-bar__item_on .vux-demo-tabbar-icon-home {
  color: rgb(53, 73, 94);
}
.demo-icon-22:before {
  content: attr(icon);
}
.vux-demo-tabbar-component {
  background-color: #F70968;
  color: #fff;
  border-radius: 7px;
  padding: 0 4px;
  line-height: 14px;
}
.weui-tabbar__icon + .weui-tabbar__label {
  margin-top: 0!important;
}
.vux-demo-header-box {
  z-index: 100;
  position: absolute;
  width: 100%;
  left: 0;
  top: 0;
}

@font-face {
  font-family: 'vux-demo';  /* project id 70323 */
  src: url('https://at.alicdn.com/t/font_h1fz4ogaj5cm1jor.eot');
  src: url('https://at.alicdn.com/t/font_h1fz4ogaj5cm1jor.eot?#iefix') format('embedded-opentype'),
  url('https://at.alicdn.com/t/font_h1fz4ogaj5cm1jor.woff') format('woff'),
  url('https://at.alicdn.com/t/font_h1fz4ogaj5cm1jor.ttf') format('truetype'),
  url('https://at.alicdn.com/t/font_h1fz4ogaj5cm1jor.svg#iconfont') format('svg');
}

.demo-icon {
  font-family: 'vux-demo';
  font-size: 20px;
  color: #04BE02;
}

.demo-icon-big {
  font-size: 28px;
}

.demo-icon:before {
  content: attr(icon);
}

.router-view {
  width: 100%;
  top: 46px;
}
.vux-pop-out-enter-active,
.vux-pop-out-leave-active,
.vux-pop-in-enter-active,
.vux-pop-in-leave-active {
  will-change: transform;
  transition: all 500ms;
  height: 100%;
  top: 46px;
  position: absolute;
  backface-visibility: hidden;
  perspective: 1000;
}
.vux-pop-out-enter {
  opacity: 0;
  transform: translate3d(-100%, 0, 0);
}
.vux-pop-out-leave-active {
  opacity: 0;
  transform: translate3d(100%, 0, 0);
}
.vux-pop-in-enter {
  opacity: 0;
  transform: translate3d(100%, 0, 0);
}
.vux-pop-in-leave-active {
  opacity: 0;
  transform: translate3d(-100%, 0, 0);
}
.menu-title {
  color: #888;
}
</style>
