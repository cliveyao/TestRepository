export default {
  MyAction: {title: '我的操作', link: 'MyAction'},
  MySetting: {title: '我的设置', link: 'MySetting'},
  MyConcat: {title: '我的通讯录', link: 'MyConcat'},
  setHeadTitle (thisObj) {
    thisObj.$store.dispatch('setNavHeadTitle', '我的')
  },
  setHeadBack (thisObj, backFlag) {
    thisObj.$store.dispatch('showNavHeadBack', true)
  }
}
