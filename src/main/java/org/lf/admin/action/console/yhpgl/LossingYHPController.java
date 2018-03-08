package org.lf.admin.action.console.yhpgl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.lf.admin.action.console.BaseController;
import org.lf.admin.db.pojo.JYHPSQ;
import org.lf.admin.db.pojo.VYHPSQ;
import org.lf.admin.db.pojo.VYHPSQXZ;
import org.lf.admin.service.OperException;
import org.lf.admin.service.catalog.ZCGLService;
import org.lf.admin.service.yhpgl.YHPSQService;
import org.lf.admin.service.yhpgl.YHPSQStatus;
import org.lf.admin.service.yhpgl.YHPSQType;
import org.lf.utils.EasyuiDatagrid;
import org.lf.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 部门（个人）易耗品报损
 * 
 */
@Controller
@RequestMapping("/console/yhpgl/yhpbs/")
public class LossingYHPController extends BaseController {
	
	private static final String ROOT = "/console/yhpgl/yhpbs";
	
	@Autowired
	private ZCGLService zcglService;
	
	@Autowired
	private YHPSQService yhpsqService;
	
	
	/**
	 * 部门易耗品报损
	 */
	@RequestMapping("lossingBMYHPListUI.do")
	public String lossingBMYHPListUI(HttpSession session,Model m){
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
		return ROOT +"/lossingBMYHPListUI";
	}
	
	/**
	 * 获取部门易耗品报损单列表
	 * 查询J_YHP_SQ表，获得指定appId，SQ_TYPE为部门报损，申请人（sqr）为当前用户的申请单列表
	 */
	@RequestMapping("getBMYHPBSList.do")
	@ResponseBody
	public EasyuiDatagrid<VYHPSQ> getBMYHPBSList(HttpSession session,int rows,int page) {
		Integer appId = getAppId(session);
		String sqr = getCurrUser(session).getWxUsername();
		EasyuiDatagrid<VYHPSQ> yhpbsData =  yhpsqService.getPagedBMYHPSQList(appId, YHPSQType.部门报损, sqr, rows, page);
		List<VYHPSQ> yhpsqList = yhpbsData.getRows();
		for(VYHPSQ yhpsq : yhpsqList){
			yhpsq.setDeptName(zcglService.getWXDeptRootName(appId, yhpsq.getDeptNo()));
		}
		return yhpbsData;
	}
	
	/**
	 * 个人易耗品报损
	 */
	@RequestMapping("lossingGRYHPListUI.do")
	public String lossingGRYHPListUI(){
		return ROOT +"/lossingGRYHPListUI";
	}
	
	/**
	 * 获取个人易耗品报损单列表
	 * 查询J_YHP_SQ表，获得指定appId，SQ_TYPE为个人报损，申请人（sqr）为当前用户的申请单列表
	 */
	@RequestMapping("getGRYHPBSList.do")
	@ResponseBody
	public EasyuiDatagrid<VYHPSQ> getGRYHPBSList(HttpSession session,int rows,int page) {
		Integer appId = getAppId(session);
		String sqr = getCurrUser(session).getWxUsername();		
		EasyuiDatagrid<VYHPSQ> yhpbsData = yhpsqService.getPagedGRYHPSQList(appId, YHPSQType.个人报损, sqr, rows, page);
		List<VYHPSQ> yhpsqList= yhpbsData.getRows();
		for(VYHPSQ yhpsq : yhpsqList) {
			yhpsq.setDeptName(zcglService.getWXDeptRootName(appId, yhpsq.getDeptNo()));
		}
		return yhpbsData;
	}
	
	@RequestMapping("delYHPBS.do")
	@ResponseBody
	public String delYHPBS(String sqdm) {
		try {
			yhpsqService.delYHPSQ(sqdm);
			return SUCCESS;
		} catch (OperException e) {
			return e.getMessage();
		}
	}
	
	/**
	 * 新增低值易耗品部门报损
	 */
	@RequestMapping("insertBMYHPBSUI.do")
	public String insertBMYHPBSUI(){
		return ROOT +"/insertBMYHPBSUI";
	}
	
	/**
	 * 1. 向J_YHP_SQ表中插入一条记录
	 * 	申请单代码（DM）：36位UUID
	 * 	申请人（SQR）：当前用户userid
	 * 	申请类型（SQ_TYPE）：部门报损
	 * 	申请时间（SQSJ）：当前系统时间
	 * 	审批结果（STATUS）为：未提交（0）
	 * 
	 * 2. J_YHP_SQXZ中插入一组记录
	 * 		申请数量SQ_NUM值来自sqNumMap<Integer, Integer>中指定yhpId对应的值。
	 * 		审批数量SP_NUM为0
	 * 
	 */
	/**
	 * 
	 * @param session
	 * @param deptNo 持有部门Id
	 * @param sqNumMap{"yhpId":数量}
	 * @return
	 */
	@RequestMapping("insertBMYHPBS.do")
	@ResponseBody
	public String insertBMYHPBS(HttpSession session,Integer deptNo,String sqNumMap) {
		Integer appId = getAppId(session);
		String fzr = getCurrUser(session).getWxUsername();
		
		JYHPSQ param = new JYHPSQ();
		param.setDm(StringUtils.getUUID());
	    param.setAppId(appId);
	    param.setSqr(fzr);
	    param.setSqType(YHPSQType.部门报损.getValue());
	    param.setSqsj(new Date());
    	try {
			param.setSqbmId(zcglService.getFZR(appId, fzr).getId());
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
		return null;
	}
	
	/**
	 * 新增低值易耗品个人报损
	 */
	@RequestMapping("insertGRYHPBSUI.do")
	public String insertGRYHPSQUI(){
		return ROOT +"/insertGRYHPBSUI";
	}
	
	/**
	 * 1. 向J_YHP_SQ表中插入一条记录
	 * 	申请单代码（DM）：36位UUID
	 * 	申请人（SQR）：当前用户userid
	 * 	申请类型（SQ_TYPE）：个人报损
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
	public boolean insertGRYHPSQ(HttpSession session, Map<Integer, Integer> sqNumMap) {
		return false;
	}
	
	/**
	 * 编辑低值易耗品报损单
	 */
	@RequestMapping("updateYHPSQUI.do")
	public String updateYHPSQUI(){
		return ROOT +"/updateYHPBSUI";
	}
	
	/**
	 * 编辑低值易耗品报损单，更新用户申请数量。
	 * 
	 * 1. 将J_YHP_SQXZ中指的SQ_DM下的记录全部删除
	 * 2. 新的申请数量SQ_NUM值来自sqNumMap<Integer, Integer>中指定yhpId对应的值。
	 * 
	 * @return
	 */
	@RequestMapping("updateYHPSQ.do")
	@ResponseBody
	public boolean updateYHPSQ(String sqdm, Map<Integer, Integer> sqNumMap) {
		return false;
	}
	
	/**
	 * 提交低值易耗品报损单
	 */
	@RequestMapping("submitYHPBSUI.do")
	public String submitYHPBSUI(){
		return ROOT +"/submitYHPBSUI";
	}
	
	/**
	 * 将J_YHP_SQ相应记录的STATUS更新为待审批（1）
	 */
	@RequestMapping("submitYHPBS.do")
	@ResponseBody
	public boolean submitYHPBS(Integer sqId) {
		return false;
	}
}
