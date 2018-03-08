<template>
  <div>
    <!-- 此组件是不包含搜索工具栏的资产列表 -->
    <div v-show="hasData">
      <panel :footer="footer" :list="zcListData" :type="type" @on-click-footer="loadZcListData" @on-click-item="toZcdetail"></panel>
    </div>
  </div>
</template>
<script>
  import zcListApi from '@/components/zcListApi'
  import { Panel } from 'vux'
  import { mapState } from 'vuex'
  export default {
    components: {
      Panel
    },
    props: ['tagName', 'extraParam', 'searchParam'],
    data () {
      return {
        page: 1,
        type: '5',
        zcListData: [],
        footer: {
          title: '查看更多'
        }
      }
    },
    computed: {
      ...mapState({
        initZcList: state => state.vux.navi.initZcList
      }),
      hasData () {
        return this.zcListData.length > 0
      }
    },
    watch: {
      initZcList (initZcList) {
        if (initZcList) {
          this.page = 1
          this.zcListData = []
        }
      }
    },
    activated () {
      if (this.zcListData.length === 0) {
        this.loadZcListData()
      }
    },
    mounted () {
      if (this.searchParam) {
        this.loadZcListData()
      }
    },
    methods: {
      loadZcListData () {
        zcListApi.loadZcListData(this)
      },
      toZcdetail (item) {
        this.$router.push({name: 'ZcxqNav', query: {zcid: item.zcid, tagName: this.tagName}})
      }
    }
  }
</script>
<style scoped>
  
</style>
