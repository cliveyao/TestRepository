package org.lf.admin.service.yhpgl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.lf.admin.db.dao.JYHPSQMapper;
import org.lf.admin.db.dao.JYHPSQXZMapper;
import org.lf.admin.db.dao.VYHPSQMapper;
import org.lf.admin.db.dao.VYHPSQXZMapper;
import org.lf.admin.db.pojo.CZCGL;
import org.lf.admin.db.pojo.JYHPSQ;
import org.lf.admin.db.pojo.JYHPSQXZ;
import org.lf.admin.db.pojo.VYHPSQ;
import org.lf.admin.service.OperException;
import org.lf.admin.service.catalog.ZCGLService;
import org.lf.utils.EasyuiDatagrid;
import org.lf.utils.PageNavigator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;

/**
 * 易耗品申请单管理：包括申领单和报损单
 * 
 */
@Service("yhpSQService")
public class YHPSQService {
	
	@Autowired
	private YHPSQXZService sqxzService;
	
	@Autowired
	private VYHPSQMapper vyhpsqDao;
	
	@Autowired
	private ZCGLService zcglService;
	
	@Autowired
	private JYHPSQMapper jyhpsqDao;

	@Autowired
	private JYHPSQXZMapper jyhpsqxzDao;
	
	@Autowired
	private VYHPSQXZMapper vyhpsqxzDao;
	
	public int countYHPSQList(VYHPSQ param) {
		return vyhpsqDao.countYHPSQList(param);
	}
	
	public List<VYHPSQ> getYHPSQList(VYHPSQ param,int rows,int page) {
		PageNavigator pn = new PageNavigator(rows, page);
		param.setStart(pn.getStart());
		param.setOffset(pn.getOffset());
		return vyhpsqDao.selectList(param);	
	}
	
	/**
	 * 获取易耗品申领单列表(部门)
	 * select id from c_zcgl where appid=? and fzr=?。
	 * 查询J_YHP_SQ表，获得指定appId，SQ_TYPE为部门申领，申请部门（SQBM_ID）为上面id的申请单列表。
	 * @param appId
	 * @param type 申请状态
	 * @param fzr 通过负责人查询申请部门(SQBM_ID)
	 * @param status 审批状态
	 * @param rows
	 * @param page
	 * @return
	 */
	public EasyuiDatagrid<VYHPSQ> getPagedBMYHPSQList(Integer appId, YHPSQType type, String sqr,int rows, int page) {
		EasyuiDatagrid<VYHPSQ> yhpsqData = new EasyuiDatagrid<VYHPSQ>();
		VYHPSQ record = new VYHPSQ();
		//查询SQBM_ID
		CZCGL  czcgl = new CZCGL();
		czcgl.setAppId(appId);
		czcgl.setFzr(sqr);
		try {
			czcgl = zcglService.getZCGL(czcgl);
		} catch (OperException e) {
			yhpsqData.setRows(new ArrayList<VYHPSQ>());
			return yhpsqData;
		}
		record.setAppId(appId);
		record.setSqType(type.getValue());
		record.setSqbmId(czcgl.getId());
		
		int total = countYHPSQList(record);
		yhpsqData.setTotal(total);
		if(total == 0){
			yhpsqData.setRows(new ArrayList<VYHPSQ>());
		}else{
			List<VYHPSQ> yhpsqList = getYHPSQList(record, rows, page);
			yhpsqData.setRows(yhpsqList);
		}
		
		return yhpsqData;
	}
	
	/**
	 * 获取易耗品申领单列表(个人)
	 * @param appId
	 * @param type 申请状态
	 * @param sqr 当前登录用户
	 * @param status 审批状态
	 * @param rows
	 * @param page
	 * @return
	 */
	public EasyuiDatagrid<VYHPSQ> getPagedGRYHPSQList(Integer appId, YHPSQType type, String sqr, int rows, int page) {
		VYHPSQ param = new VYHPSQ();
		param.setAppId(appId);
		param.setSqType(type.getValue());
		param.setSqr(sqr);
		int total = countYHPSQList(param);
		EasyuiDatagrid<VYHPSQ> pageDatas = new EasyuiDatagrid<VYHPSQ>();
		if(total == 0){
			pageDatas.setRows(new ArrayList<VYHPSQ>());
		}else{
			List<VYHPSQ> list = getYHPSQList(param, rows, page);
			pageDatas.setRows(list);
		}
		pageDatas.setTotal(total);
		return pageDatas;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public void insertYHPSQ(JYHPSQ param, String sqNumMap) throws OperException {
		jyhpsqDao.insertSelective(param);
		JYHPSQXZ record = new JYHPSQXZ();
		record.setSqDm(param.getDm());
		record.setSpNum(0);
        sqNumMap = sqNumMap.replace("},", "} "); 		
		String[] sqArr = sqNumMap.split(" ");
		for (int i = 0 ;i < sqArr.length;i++) {
			JSONObject object = JSONObject.parseObject(sqArr[i]);
			record.setYhpId((Integer)object.get("yhpId"));
		    if((int)object.get("yhpNum") > 0){
				record.setSqNum((Integer)object.get("yhpNum"));
				jyhpsqxzDao.insertSelective(record);
			}
		}
	}
	
	@Transactional(rollbackFor = Exception.class)
	public void updateYHPSQ(String sqdm, Map<Integer, Integer> sqNumMap) throws OperException {
		sqxzService.delYHPSQXZ(sqdm);
		sqxzService.insertYHPSQXZ(sqdm, sqNumMap);
	}
	/**
	 * 通过申请代码(sqdm)删除易耗品申请
	 * @param sqdm
	 * @return
	 * @throws OperException
	 */
	@Transactional(rollbackFor = Exception.class)
	public void delYHPSQ(String sqdm) throws OperException {
		jyhpsqDao.delYHPSQ(sqdm);
		jyhpsqxzDao.delYHPSQ(sqdm);
	}
	
	/**
	 * 将易耗品提交(申请状态变为待审批)Status(1)
	 * @param sqdm
	 * @throws OperException
	 */
	@Transactional(rollbackFor = Exception.class)
	public void submitYHPSQ(String sqdm) throws OperException {
		JYHPSQ record = new JYHPSQ();
		record.setDm(sqdm);
		record.setStatus(YHPSQStatus.待审批.getValue());
		jyhpsqDao.updateByPrimaryKeySelective(record);
	}

}
