export default {
  state: {
    showMainTabbar: false,
    gzCountNo: '',
    navHeadTitle: '',
    navHeadBack: true,
    validParam: true,
    mainPageFlag: false,
    appFlag: '',
    initZcList: 0
  },
  mutations: {
    setValidParam (state, payload) {
      state.validParam = payload.validParam
    },
    hideMainTabbar (state) {
      state.showMainTabbar = false
    },
    showMainTabbar (state) {
      state.showMainTabbar = true
    },
    clearGzCount (state) {
      state.gzCountNo = ''
    },
    setGzCount (state, payload) {
      state.gzCountNo = payload.count
    },
    setNavHeadTitle (state, payload) {
      state.navHeadTitle = payload.navHeadTitle
    },
    showNavHeadBack (state, payload) {
      state.navHeadBack = payload.navHeadBack
    },
    updateMainPageFlag (state, payload) {
      state.mainPageFlag = payload.mainPageFlag
    },
    updateAppFlag (state, payload) {
      state.appFlag = payload.appFlag
    },
    updateInitZcList (state) {
      state.initZcList++
    }
  },
  actions: {
    setValidParam: ({commit}, validParam) => {
      commit({type: 'setValidParam', validParam: validParam})
    },
    hideMainTabbar: ({commit}) => {
      commit('hideMainTabbar')
    },
    showMainTabbar: ({commit}) => {
      commit('showMainTabbar')
    },
    clearGzCount: ({commit}) => {
      commit('clearGzCount')
    },
    setGzCount: ({commit}, count) => {
      if (count) {
        commit({type: 'setGzCount', count: count})
      }
    },
    setNavHeadTitle: ({commit}, navHeadTitle) => {
      if (navHeadTitle) {
        commit({type: 'setNavHeadTitle', navHeadTitle: navHeadTitle})
      }
    },
    showNavHeadBack: ({commit}, navHeadBack) => {
      commit({type: 'showNavHeadBack', navHeadBack: navHeadBack})
    },
    updateMainPageFlag: ({commit}, mainPageFlag) => {
      commit({type: 'updateMainPageFlag', mainPageFlag: mainPageFlag})
    },
    updateAppFlag: ({commit}, appFlag) => {
      commit({type: 'updateAppFlag', appFlag: appFlag})
    },
    updateInitZcList: ({commit}) => {
      commit('updateInitZcList')
    }
  },
  getters: {
    showMainTabbar (state) {
      return state.showMainTabbar
    },
    gzCountNo (state) {
      return state.gzCountNo
    },
    navHeadTitle (state) {
      return state.navHeadTitle
    },
    navHeadBack (state) {
      return state.navHeadBack
    },
    validParam (state) {
      return state.validParam
    },
    mainPageFlag (state) {
      return state.mainPageFlag
    },
    appFlag (state) {
      return state.appFlag
    },
    initZcList (state) {
      return state.initZcList
    }
  }
}
