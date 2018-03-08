import Vue from 'vue'
import Router from 'vue-router'
Vue.use(Router)

import Welcome from '@/components/Welcome'

// 登录验证
import Oauth from '@/components/oauth/Oauth'

export default new Router({
  mode: 'history',
  scrollBehavior (to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { x: 0, y: 0 }
    }
  },
  routes: [
    { path: '*', component: Welcome },
    { name: 'Welcome', path: '/', component: Welcome },
    { name: 'Rwxq', path: '/xq/rwxq', component: resolve => require(['@/components/xq/rwxq/Rwxq'], resolve), meta: {keepAlive: true} },
    { name: 'Zcxq', path: '/xq/zcxq', component: resolve => require(['@/components/xq/zcxq/Zcxq'], resolve) },
    { name: 'Userxq', path: '/xq/userxq', component: resolve => require(['@/components/xq/userxq/Userxq'], resolve) },

    { name: 'Test', path: '/test', component: resolve => require(['@/components/Test'], resolve) },
    { name: 'TestEnter', path: '/testEnter', component: resolve => require(['@/components/TestEnter'], resolve) },
    { name: 'Oauth', path: '/oauth/saveToken', component: Oauth },

    {
      name: 'NaviZc',
      path: '/zc',
      component: resolve => require(['@/components/navi/zc'], resolve),
      meta: {
        keepAlive: true
      }
    },
    {
      name: 'NaviMyZcLy',
      path: '/myZcLy',
      component: resolve => require(['@/components/navi/zc/ZcLy_my'], resolve),
      meta: {
        keepAlive: true
      }
    },
    {
      name: 'NaviMyZcSq',
      path: '/myZcSq',
      component: resolve => require(['@/components/navi/zc/ZcSq_my'], resolve),
      meta: {
        keepAlive: true
      }
    },
    {
      name: 'NaviBmGz',
      path: '/bmgz',
      component: resolve => require(['@/components/navi/gz/Gz_bm'], resolve)
    },
    {
      name: 'NaviAdminGz',
      path: '/adminGz',
      component: resolve => require(['@/components/navi/gz/Gz_admin'], resolve)
    },
    {
      name: 'NaviRcxjGz',
      path: '/rcxjGz',
      component: resolve => require(['@/components/navi/gz/Gz_rcxj'], resolve),
      meta: {
        keepAlive: true
      }
    },
    {
      name: 'NaviGzwxGz',
      path: '/gzwxGz',
      component: resolve => require(['@/components/navi/gz/Gz_gzwx'], resolve),
      meta: {
        keepAlive: true
      }
    },
    {
      name: 'GzZcdbList',
      path: '/gzZcdbList',
      component: resolve => require(['@/components/navi/gz/zcList/Zcdb_list'], resolve),
      meta: {
        keepAlive: true
      }
    },
    {
      name: 'GzZcspList',
      path: '/gzZcspList',
      component: resolve => require(['@/components/navi/gz/zcList/Zcsp_list'], resolve),
      meta: {
        keepAlive: true
      }
    },
    {
      name: 'GzZcfpList',
      path: '/gzZcfpList',
      component: resolve => require(['@/components/navi/gz/zcList/Zcfp_list'], resolve),
      meta: {
        keepAlive: true
      }
    },
    {
      name: 'GzZcghList',
      path: '/gzZcghList',
      component: resolve => require(['@/components/navi/gz/zcList/Zcgh_list'], resolve),
      meta: {
        keepAlive: true
      }
    },
    {
      name: 'NaviBmMy',
      path: '/bmMy',
      component: resolve => require(['@/components/navi/my/My_bm'], resolve)
    },
    {
      name: 'NaviAdminMy',
      path: '/adminMy',
      component: resolve => require(['@/components/navi/my/My_admin'], resolve)
    },
    {
      name: 'NaviRcxjMy',
      path: '/rcxjMy',
      component: resolve => require(['@/components/navi/my/My_rcxj'], resolve)
    },
    {
      name: 'NaviGzwxMy',
      path: '/gzwxMy',
      component: resolve => require(['@/components/navi/my/My_gzwx'], resolve)
    },
    { name: 'ZcxqNav', path: '/xq', component: resolve => require(['@/components/navi/zclist/ZcxqNav'], resolve) },
    // 资产调拨
    { name: 'Zcdb', path: '/wx/zcdj/allocateZC', component: resolve => require(['@/components/zc/zcdj/Zcdb'], resolve) },
    { name: 'Zccxdb', path: '/wx/zcdj/reallocateZC', component: resolve => require(['@/components/zc/zcdj/Zccxdb'], resolve) },
    { name: 'Zcjjgh', path: '/wx/zcdj/refuseRevertZC', component: resolve => require(['@/components/zc/zcdj/Zcjjgh'], resolve) },
    // 日常巡检
    { name: 'XjSqbfzc', path: '/wx/rcxj/zcbfSQ', component: resolve => require(['@/components/zc/rcxj/Sqbfzc'], resolve) },
    { name: 'XjSqwxzc', path: '/wx/rcxj/zcwxSQ', component: resolve => require(['@/components/zc/rcxj/Sqwxzc'], resolve) },
    { name: 'XjSqxzzc', path: '/wx/rcxj/zcxzSQ', component: resolve => require(['@/components/zc/rcxj/Sqxzzc'], resolve) },
    { name: 'XjWcrcxj', path: '/wx/rcxj/finishRCXJ', component: resolve => require(['@/components/zc/rcxj/Wcrcxj'], resolve) },
    // 故障维修
    { name: 'Wcwx', path: '/wx/gzwx/finishGZWX', component: resolve => require(['@/components/zc/gzwx/Wcwx'], resolve) },
    { name: 'Sqbfzc', path: '/wx/gzwx/zcbfSQ', component: resolve => require(['@/components/zc/gzwx/Sqbfzc'], resolve) },
    { name: 'Sqxzzc', path: '/wx/gzwx/zcxzSQ', component: resolve => require(['@/components/zc/gzwx/Sqxzzc'], resolve) },
    { name: 'Sqzcwx', path: '/wx/gzwx/resubmitWXSQ', component: resolve => require(['@/components/zc/gzwx/Sqzcwx'], resolve) },
    // test页面
    { name: 'rcxjTest', path: '/wx/rcxj/rcxjTest', component: resolve => require(['@/components/zc/rcxj/rcxjTest'], resolve) },
    { name: 'JssdkTest', path: '/wx/rcxj/JssdkTest', component: resolve => require(['@/components/zc/JssdkTest'], resolve) },
    { name: 'zcdjTest', path: '/wx/zcdj/zcdjTest', component: resolve => require(['@/components/zc/zcdj/zcdjTest'], resolve) },
    { name: 'gzwxTest', path: '/wx/zcsy/gzwxTest', component: resolve => require(['@/components/zc/gzwx/gzwxTest'], resolve) },
    { name: 'ZcfpTest', path: '/wx/zcfp/ZcfpTest', component: resolve => require(['@/components/zc/zcfp/ZcfpTest'], resolve) },
    { name: 'ZcywTest', path: '/wx/zcyw/ZcywTest', component: resolve => require(['@/components/zc/zcyw/ZcywTest'], resolve) },
    // 我的
    { name: 'MySetting', path: '/wx/my/MySetting', component: resolve => require(['@/components/zc/my/MySetting'], resolve) },
    { name: 'MyAbout', path: '/wx/my/MyAbout', component: resolve => require(['@/components/zc/my/MyAbout'], resolve) },
    { name: 'MyMsg', path: '/wx/my/MyMsg', component: resolve => require(['@/components/zc/my/MyMsg'], resolve) },
    { name: 'MyUpdate', path: '/wx/my/MyUpdate', component: resolve => require(['@/components/zc/my/MyUpdate'], resolve) },
    { name: 'MyConcat', path: '/wx/my/MyConcat', component: resolve => require(['@/components/zc/my/MyConcat'], resolve) },
    { name: 'MyAction', path: '/wx/my/MyAction', component: resolve => require(['@/components/zc/my/MyAction'], resolve) },
    // 使用人
    { name: 'Jjlyzc', path: '/wx/zcsy/refuseLeadingZC', component: resolve => require(['@/components/zc/syzc/Jjlyzc'], resolve) },
    { name: 'Sjzc', path: '/wx/zcsy/sendbackZC', component: resolve => require(['@/components/zc/syzc/Sjzc'], resolve) },
    { name: 'SyrSqwxzc', path: '/wx/zcsy/zcwxSQ', component: resolve => require(['@/components/zc/syzc/Sqwxzc'], resolve) },
    { name: 'SyrSqbfzc', path: '/wx/zcsy/zcbfSQ', component: resolve => require(['@/components/zc/syzc/Sqbfzc'], resolve) },
    { name: 'SyrSqxzzc', path: '/wx/zcsy/zcxzSQ', component: resolve => require(['@/components/zc/syzc/Sqxzzc'], resolve) },
    // 资产分配
    { name: 'Sqgh', path: '/wx/zcfp/revertZC', component: resolve => require(['@/components/zc/zcfp/Sqgh'], resolve) },
    { name: 'Zccxfp', path: '/wx/zcfp/reassignZC', component: resolve => require(['@/components/zc/zcfp/Zccxfp'], resolve) },
    { name: 'Zcfp', path: '/wx/zcfp/assignZC', component: resolve => require(['@/components/zc/zcfp/Zcfp'], resolve) },
    { name: 'Jjzcsj', path: '/wx/zcfp/refuseSendbackZC', component: resolve => require(['@/components/zc/zcfp/Jjzcsj'], resolve) },
    // 资产运维
    { name: 'agreeBFSQ', path: '/wx/zcyw/agreeBFSQ', component: resolve => require(['@/components/zc/zcyw/agreeBFSQ'], resolve) },
    { name: 'agreeBFZC', path: '/wx/zcyw/agreeBFZC', component: resolve => require(['@/components/zc/zcyw/agreeBFZC'], resolve) },
    { name: 'agreeXZSQ', path: '/wx/zcyw/agreeXZSQ', component: resolve => require(['@/components/zc/zcyw/agreeXZSQ'], resolve) },
    { name: 'refuseBFSQ', path: '/wx/zcyw/refuseBFSQ', component: resolve => require(['@/components/zc/zcyw/refuseBFSQ'], resolve) },
    { name: 'refuseWXSQ', path: '/wx/zcyw/refuseWXSQ', component: resolve => require(['@/components/zc/zcyw/refuseWXSQ'], resolve) },
    { name: 'refuseXZSQ', path: '/wx/zcyw/refuseXZSQ', component: resolve => require(['@/components/zc/zcyw/refuseXZSQ'], resolve) },
    { name: 'Zcdj', path: '/wx/zc/Zcdj', component: resolve => require(['@/components/zc/Zcdj'], resolve) }
  ]
})
