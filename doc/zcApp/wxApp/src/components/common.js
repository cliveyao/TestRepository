const tagNames = {
  hqglryz: '后勤管理人员组',
  syrz: '使用人组',
  wxz: '维修组',
  xjz: '巡检组',
  bmzcglyz: '部门资产管理员组'
}
const pageRowNo = 10
export default {
  tagNames,
  pageRowNo,
  scanCodeInfo (result) {
    if (result) {
      let json = {}
      try {
        json = JSON.parse(result.resultStr)
        json = json.zcdm
        if (json == null || json === '') {
          json = result.resultStr
        }
      } catch (error) {
        json = result.resultStr
      }
      if (json.length > 35) {
        return false
      }
      return json
    } else {
      return false
    }
  },
  isMessage (appFlag) {
    return appFlag === 'message'
  },
  isAdmin (appFlag) {
    return appFlag === 'admin'
  },
  isBmadmin (appFlag) {
    return appFlag === 'bmadmin'
  },
  isGzwx (appFlag) {
    return appFlag === 'gzwx'
  },
  isMy (appFlag) {
    return appFlag === 'my'
  },
  isRcxj (appFlag) {
    return appFlag === 'rcxj'
  },
  getIndexRoute (appFlag) {
    let indexRoute
    if (this.isBmadmin(appFlag)) {
      indexRoute = {name: 'NaviBmGz', query: {tagName: tagNames.bmzcglyz}}
    } else if (this.isAdmin(appFlag)) {
      indexRoute = {name: 'NaviAdminGz', query: {tagName: tagNames.hqglryz}}
    } else if (this.isMessage(appFlag)) {
      indexRoute = {name: 'MyMsg'}
    } else if (this.isRcxj(appFlag)) {
      indexRoute = {name: 'NaviRcxjGz', query: {tagName: tagNames.xjz, extraParam: 0, title: '我的工作'}}
    } else if (this.isGzwx(appFlag)) {
      indexRoute = {name: 'NaviGzwxGz', query: {tagName: tagNames.wxz, extraParam: 0, title: '我的工作'}}
    } else if (this.isMy(appFlag)) {
      indexRoute = {name: 'NaviMyZcLy', query: {tagName: tagNames.syrz, extraParam: 0, title: '待领用资产'}}
    }
    return indexRoute
  },
  toIndex (thisObj, appFlag) {
    thisObj.$router.replace(this.getIndexRoute(appFlag))
  },
  isCurrPage (thisObj, routeName) {
    return thisObj.$route.name === routeName
  },
  changeMainPageFlag (thisObj, isMainPage) {
    thisObj.$store.dispatch('updateMainPageFlag', isMainPage)
  },
  showHeadRight (thisObj) {
    return false
  }
}
