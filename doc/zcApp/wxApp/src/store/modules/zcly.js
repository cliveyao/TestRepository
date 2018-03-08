export default {
  state: {
    lyZcCountNo: ''
  },
  mutations: {
    setLyZcCountNo (state, payload) {
      state.lyZcCountNo = payload.lyZcCountNo
    }
  },
  actions: {
    setLyZcCountNo: ({commit}, lyZcCountNo) => {
      commit({type: 'setLyZcCountNo', lyZcCountNo: lyZcCountNo})
    }
  },
  getters: {
    lyZcCountNo (state) {
      return state.lyZcCountNo
    }
  }
}
