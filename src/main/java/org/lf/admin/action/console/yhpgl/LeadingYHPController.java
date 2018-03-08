package org.lf.admin.action.console.yhpgl;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.lf.admin.action.console.BaseController;
import org.lf.admin.db.pojo.CZCGL;
import org.lf.admin.db.pojo.ChuWXDept;
import org.lf.admin.db.pojo.JYHPSQ;
import org.lf.admin.db.pojo.VYHP;
import org.lf.admin.db.pojo.VYHPSQ;
import org.lf.admin.db.pojo.VYHPSQXZ;
import org.lf.admin.db.pojo.WXUser;
import org.lf.admin.service.OperException;
import org.lf.admin.service.catalog.ZCGLService;
import org.lf.admin.service.sys.WXDeptService;
import org.lf.admin.service.sys.WXUserService;
import org.lf.admin.service.yhpgl.YHPSQService;
import org.lf.admin.service.yhpgl.YHPSQStatus;
import org.lf.admin.service.yhpgl.YHPSQType;
import org.lf.admin.service.yhpgl.YHPSQXZService;
import org.lf.admin.service.yhpgl.YHPService;
import org.lf.utils.EasyuiDatagrid;
import org.lf.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 部门（个人）易耗品申领
 * 
 */
@Controller
@RequestMapping("/console/yhpgl/yhpsl/")
public class LeadingYHPController extends BaseController {
	
	private static final String ROOT = "/console/yhpgl/yhpsl";
	
	@Autowired
	private YHPSQService yhpsqService;
	
	@Autowired
	private ZCGLService zcbmService;
	
	@Autowired
	private YHPSQXZService yhpsqxzService;
	
	@Autowired
	private YHPService yhpService;
	
	@Autowired
	private ZCGLService zcglService;
	
	@Autowired
	private WXUserService userService;
	/**
	 * 部门易耗品申领
	 */
	@RequestMapping("leadingBMYHPListUI.do")
	public String leadingBMYHPListUI(HttpSession session,Model m){
		Integer appId = getAppId(session);
		String fzr = getCurrUser(session).getWxUsername();
		boolean isBMGLY = false;
		try {
			zcglService.getFZR(appId, fzr);
			isBMGLY = true;
		} catch (OperException e) {
			isBMGLY = false;
		}
		m.addAttribute("isBMGLY",isBMGLY);
		return ROOT +"/leadingBMYHPListUI";
	}
	
	/**
	 * 获取部门易耗品申领单列表
	 * select id from c_zcgl where appid=? and fzr=?。
	 * 查询V_YHP_SQ表，获得指定appId，SQ_TYPE为部门申领，申请部门（SQBM_ID）为上面id的申请单列表。
	 */
	@RequestMapping("getBMYHPSQList.do")
	@ResponseBody
	public EasyuiDatagrid<VYHPSQ> getBMYHPSQList(HttpSession session,int rows,int page) {
		Integer appId = getAppId(session);
		String sqr = getCurrUser(session).getWxUsername();
		EasyuiDatagrid<VYHPSQ> yhpsqData =  yhpsqService.getPagedBMYHPSQList(appId, YHPSQType.部门申领, sqr, rows, page);
		List<VYHPSQ> yhpsqList = yhpsqData.getRows();
		for(VYHPSQ yhpsq : yhpsqList){
			yhpsq.setDeptName(zcbmService.getWXDeptRootName(appId, yhpsq.getDeptNo()));
		}
		return yhpsqData;
	}
	
	/**
	 * 个人易耗品申领
	 */
	@RequestMapping("leadingGRYHPListUI.do")
	public String leadingGRYHPListUI(){
		return ROOT +"/leadingGRYHPListUI";
	}
	
	/**
	 * 获取个人易耗品申领单列表
	 * 查询V_YHP_SQ表，获得指定appId，SQ_TYPE为个人申领（1），申请人（sqr）为当前用户的申请单列表
	 */
	@RequestMapping("getGRYHPSQList.do")
	@ResponseBody
	public EasyuiDatagrid<VYHPSQ> getGRYHPSQList(HttpSession session,int rows,int page) {
		Integer appId = getAppId(session);
		YHPSQType type = YHPSQType.个人申领;
		String sqr = getCurrUser(session).getWxUsername();		
		EasyuiDatagrid<VYHPSQ> gryhpsqList = yhpsqService.getPagedGRYHPSQList(appId, type, sqr, rows, page);
		List<VYHPSQ> yhpsqList= gryhpsqList.getRows();
		for(VYHPSQ yhpsq : yhpsqList) {
			yhpsq.setDeptName(zcbmService.getWXDeptRootName(appId, yhpsq.getDeptNo()));
		}
		return gryhpsqList;
	}
	
	@RequestMapping("delYHPSQ.do")
	@ResponseBody
	public String delYHPSQ(String sqdm) {
		try {
			yhpsqService.delYHPSQ(sqdm);
			return SUCCESS;
		} catch (OperException e) {
			return e.getMessage();
		}
	}
	
	/**
	 * 新增低值易耗品部门申领
	 */
	@RequestMapping("insertBMYHPSQUI.do")
	public String insertBMYHPSQUI(){
		return ROOT +"/insertBMYHPSQUI";
	}
	
	/**
	 * 1. 向J_YHP_SQ表中插入一条记录
	 * 	申请单代码（DM）：36位UUID
	 * 	申请人（SQR）：当前用户userid
	 * 	申请类型（SQ_TYPE）：部门申领（0）
	 * 	申请时间（SQSJ）：当前系统时间
	 * 	申请部门（SQBM_ID）：如果用户选中的是“企业”，SQBM_ID为空；否则为部门对应C_ZCGL中的ID号。
	 * 	审批结果（STATUS）为：未提交（0）
	 * 
	 * 2. J_YHP_SQXZ中插入一组记录
	 * 		申请数量SQ_NUM值来自sqNumMap<Integer, Integer>中指定yhpId对应的值。
	 * 		审批数量SP_NUM为0
	 * 
	 * @param sqdm
	 * @return
	 */
	@RequestMapping("insertBMYHPSQ.do")
	@ResponseBody
	public String insertBMYHPSQ(HttpSession session,Integer deptNo, String sqNumMap) {
		Integer appId = getAppId(session);
		String fzr = getCurrUser(session).getWxUsername();
		
		JYHPSQ param = new JYHPSQ();
		param.setDm(StringUtils.getUUID());
	    param.setAppId(appId);
	    param.setSqr(fzr);
	    param.setSqType(YHPSQType.部门申领.getValue());
	    param.setSqsj(new Date());
	    CZCGL record = new CZCGL();
    	record.setDeptNo(deptNo);	    	
    	try {
			param.setSqbmId(zcbmService.getFZR(appId, fzr).getId());
		    param.setStatus(YHPSQStatus.未提交.getValue());
		    yhpsqService.insertYHPSQ(param, sqNumMap);
		    return SUCCESS;
		} catch (OperException e) {
			return e.getMessage();
		}
	}
	
	/**
	 * 查询V_YHP_SQXZ表，显示指定APP_ID和deptNo下的易耗品列表
	 * 如果用户选择“企业”，zcglId传入值为空。即查询存放在后勤仓库尚未分配给部门的易耗品信息。
	 * 
	 * @return
	 */
	@RequestMapping("getYHPSQXZList.do")
	@ResponseBody
	public EasyuiDatagrid<VYHPSQXZ> getYHPSQXZList(HttpSession session, Integer deptNo, String sqdm) {
		Integer appId = getAppId(session);
		if(StringUtils.isEmpty(sqdm)){
			return yhpsqxzService.getPagedYHPSQXZList(appId, deptNo);	
		}else{
			return yhpsqxzService.getPagedYHPSQXZList(appId, sqdm);
		}	
	}
	
	/**
	 * 查询V_YHP表，显示指定APP_ID和deptNo下的易耗品列表 getYHPList
	 * 
	 * @return
	 */
	@RequestMapping("getYHPList.do")
	@ResponseBody
	public EasyuiDatagrid<VYHP> getYHPList(HttpSession session, Integer deptNo) {
		Integer appId = getAppId(session);
		int rows=yhpService.countYHPList(appId, null, deptNo);
		return yhpService.getPagedYHPList(appId,null,deptNo,rows,1);
	}
	
	/**
	 * 新增低值易耗品个人申领
	 */
	@RequestMapping("insertGRYHPSQUI.do")
	public String insertGRYHPSQUI(){
		return ROOT +"/insertGRYHPSQUI";
	}
	
	/**
	 * 1. 向J_YHP_SQ表中插入一条记录
	 * 	申请单代码（DM）：36位UUID
	 * 	申请人（SQR）：当前用户userid
	 * 	申请类型（SQ_TYPE）：个人申领（1）
	 * 	申请时间（SQSJ）：当前系统时间
	 * 	申请部门（SQBM_ID）：如果用户选中的是“企业”，SQBM_ID为空；否则为部门对应C_ZCGL中的ID号。
	 * 	审批结果（STATUS）为：未提交（0）
	 * 
	 * 2. J_YHP_SQXZ中插入一组记录
	 * 		申请数量SQ_NUM值来自sqNumMap<Integer, Integer>中指定yhpId对应的值。
	 * 		审批数量SP_NUM为0
	 * 
	 * @param sqdm
	 * @return
	 */
	@RequestMapping("insertGRYHPSQ.do")
	@ResponseBody
	public String insertGRYHPSQ(HttpSession session, Integer deptNo, String sqNumMap) {
		Integer appId = getAppId(session);
		String syr = getCurrUser(session).getWxUsername();
		
		JYHPSQ param = new JYHPSQ();
		param.setDm(StringUtils.getUUID());
	    param.setAppId(getAppId(session));
	    param.setSqr(getCurrUser(session).getWxUsername());
	    param.setSqType(YHPSQType.个人申领.getValue());
	    param.setSqsj(new Date());
    	
    	try {
    		CZCGL zcgl = new CZCGL();
        	zcgl.setAppId(appId);
        	WXUser user = userService.getWXUser(appId, syr);
        	List<ChuWXDept> deptList = user.getDeptList();
        	if (deptList == null || deptList.size() == 0) {
        		throw new OperException(WXDeptService.微信部门不存在);
        	}
        	zcgl.setDeptNo(deptList.get(0).getDeptNo());
        	
			param.setSqbmId(zcbmService.getZCGL(zcgl).getId());
		    param.setStatus(YHPSQStatus.未提交.getValue());
		    yhpsqService.insertYHPSQ(param, sqNumMap);	
		    return SUCCESS;   
		} catch (OperException e) {
			return e.getMessage();
		}
	}
	
	/**
	 * 编辑低值易耗品申领单
	 */
	@RequestMapping("updateYHPSQUI.do")
	public String updateYHPSQUI(){
		return ROOT +"/updateYHPSQUI";
	}
	
	/**
	 * 编辑低值易耗品申领单，更新用户申请数量。
	 * 
	 * 1. 将J_YHP_SQXZ中指的SQ_DM下的记录全部删除
	 * 2. 新的申请数量SQ_NUM值来自sqNumMap<Integer, Integer>中指定yhpId对应的值。
	 * 
	 * @return
	 */
	@RequestMapping("updateYHPSQ.do")
	@ResponseBody
	public String updateYHPSQ(String sqdm, String sqNumMap) {
		try {
			yhpsqxzService.updateYHPSQXZ(sqdm, sqNumMap);
			return SUCCESS;
		} catch (OperException e) {
			return e.getMessage();
		}	
		
	}
	
	/**
	 * 提交低值易耗品申领单
	 */
	@RequestMapping("submitYHPSQUI.do")
	public String submitYHPSQUI(){
		return ROOT +"/submitYHPSQUI";
	}
	
	/**
	 * 将J_YHP_SQ相应记录的STATUS更新为待审批（1）
	 */
	@RequestMapping("submitYHPSQ.do")
	@ResponseBody
	public String submitYHPSQ(String sqDm) {
		try {
			yhpsqService.submitYHPSQ(sqDm);
			return SUCCESS;
		} catch (OperException e) {
			return e.getMessage();
		}		
	}
	
	/**
	 * 部门申请详情页面
	 */
	@RequestMapping("detailsBMYHPSQUI.do")
	public String detailsBMYHPSQUI() {
		return ROOT +"/detailsBMYHPSQUI";
	}        	
}
