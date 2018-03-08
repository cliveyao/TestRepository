package org.lf.admin.service.yhpgl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections4.map.HashedMap;
import org.lf.admin.db.dao.CYHPLXMapper;
import org.lf.admin.db.dao.VLYHPMapper;
import org.lf.admin.db.dao.VYHPMapper;
import org.lf.admin.db.pojo.VLYHP;
import org.lf.admin.service.catalog.ZCGLService;
import org.lf.admin.service.sys.WXDeptService;
import org.lf.utils.EasyuiDatagrid;
import org.lf.utils.PageNavigator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 易耗品操作日志服务
 * 
 */
@Service("lyhpService")
public class LYHPService {
	
	@Autowired
	private ZCGLService zcglService;
	
	@Autowired
	private VYHPMapper vyhpDao;
	
	@Autowired
	private VLYHPMapper vlyhpDao;
	
	@Autowired
	private CYHPLXMapper cyhplxDao;
	
	@Autowired
	private WXDeptService wxDeptService;
	
	
	/*
	 * 查询易耗品操作记录数
	 * 
	 * */
	public int countLYHPList(Integer id, Integer czlx) {
		VLYHP vlyhp = new VLYHP();
		vlyhp.setYhpId(id);
		if(czlx != null){
			vlyhp.setCzlx(czlx);
		}
		return vlyhpDao.countYHPList(vlyhp);
	}
	
	/** 
	 * 查询易耗品操作记录列表
	 */
	private List<VLYHP> getLYHPList(Integer yhpId, Integer czlx, int rows,int  page) {
		PageNavigator pn = new PageNavigator(rows, page);
		VLYHP vlyhp = new VLYHP();
		vlyhp.setYhpId(yhpId);
		if(czlx != null){
			vlyhp.setCzlx(czlx);
		}
		vlyhp.setStart(pn.getStart());
		vlyhp.setOffset(pn.getOffset());
		return vlyhpDao.selectList(vlyhp);
	}
	
	/** 
	 * 查询易耗品操作记录列表前端显示数据
	 */
	public EasyuiDatagrid<VLYHP> getPagedLYHPList(Integer yhpId, Integer czlx, int rows, int page) {
		int count = countLYHPList(yhpId ,czlx);
		EasyuiDatagrid<VLYHP> param = new EasyuiDatagrid<VLYHP>();
		if(count == 0){
			param.setRows(new ArrayList<VLYHP>());
		}else{
			List<VLYHP> list = getLYHPList(yhpId, czlx, rows, page);
			param.setRows(list);
		}
		param.setTotal(count);
		return param;
	}
	/**
	 * 根据传进来的appId、czr、czlx进行查找
	 * 其中lxId是模糊查找、deptNo会找该部门底下的子部门
	 * @return 查询得到的数量
	 */
	public int countLYHPListFuzzy(Integer appId, String lxId, String czr,Integer czlx,Integer deptNo) {
		Map<String,Object> param = new HashedMap<String,Object>();
		param.put("appId", appId);
		param.put("czr", czr);
		param.put("deptNo", getDeptList(appId, deptNo));
		param.put("lxId", lxId);
		param.put("czlx", czlx);
		return vlyhpDao.countLYHPListFuzzy(param);
	}
	/**
	 * 根据传进来的appId、czr、czlx进行查找
	 * 其中lxId是模糊查找、deptNo会找该部门底下的子部门
	 * @return v_lyhp的记录
	 */
	public List<VLYHP> getLYHPListFuzzy(Integer appId, String lxId, String czr,Integer czlx,Integer deptNo,int rows,int page) {
		Map<String,Object> param = new HashedMap<String,Object>();
		param.put("appId", appId);
		param.put("czr", czr);
		param.put("deptNo", getDeptList(appId, deptNo));
		param.put("lxId",  lxId);
		param.put("czlx", czlx);
		PageNavigator pg = new PageNavigator(rows, page);
		param.put("start", pg.getStart());
		param.put("offset", pg.getOffset());
		return vlyhpDao.getLYHPListFuzzy(param);
	}
	
	public EasyuiDatagrid<VLYHP> getPagedLYHPListFuzzy(Integer appId, String lxId, String czr,Integer czlx,Integer deptNo, int rows, int page) {
		EasyuiDatagrid<VLYHP> datagrid = new EasyuiDatagrid<>();
		//lxId先查询，判断是不是父节点，若是的，则查询得到子节点，将子节点的id放入一个list
		//czbmId先查询，判断是不是父节点，若是的，则查询得到子节点，将子节点的id放入一个list
		datagrid.setTotal(countLYHPListFuzzy(appId, lxId, czr, czlx, deptNo));
		datagrid.setRows(getLYHPListFuzzy(appId, lxId, czr, czlx, deptNo, rows, page));
		return datagrid;
	}
	
	//将lxId传入，判断该lx下面是否还有子类，若有，则将子类放入一个list，若无，则将该lxId放入
	private List<String> getDeptList (Integer appId,Integer deptNo) {
		List<String> result = new ArrayList<>();
		if (deptNo == null) {
			return result;
		}
		result = wxDeptService.getSubDeptmentByDeptNo(appId, deptNo);
		return result;
	}
	
}