import api from '@/api'
import common from '@/components/common'
import { stringTrim } from 'vux'
export default {
  loadZcListData (thisObj) {
    let param = {
      rows: common.pageRowNo,
      page: thisObj.page,
      tagName: thisObj.tagName,
      extraParam: thisObj.extraParam
    }
    if (thisObj.searchParam) {
      param['searchParam'] = stringTrim(thisObj.searchParam)
    }
    let url = '/wx/zcgl/getZCList.do'
    if (url) {
      api.post(url, param).then(function (res) {
        if (res) {
          // 添加资产列表
          let zcList = res.zcList
          thisObj.page++
          thisObj.zcListData.push.apply(thisObj.zcListData, zcList)
          // 设置统计数量
          if (res.countNo) {
            thisObj.$store.dispatch('setGzCount', res.countNo.toString())
          }
          console.log(thisObj.page)// 此处的log不要删除
        } else {
          thisObj.$store.dispatch('setGzCount', '')
          thisObj.$vux.toast.text('没有更多数据', 'bottom')
        }
      })
    }
  }
}
