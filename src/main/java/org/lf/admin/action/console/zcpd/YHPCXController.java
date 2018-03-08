package org.lf.admin.action.console.zcpd;


import java.util.List;

import javax.servlet.http.HttpSession;

import org.lf.admin.action.console.BaseController;
import org.lf.admin.db.pojo.VLYHP;
import org.lf.admin.db.pojo.VYHP;
import org.lf.admin.service.OperException;
import org.lf.admin.service.catalog.ZCGLService;
import org.lf.admin.service.yhpgl.LYHPService;
import org.lf.admin.service.yhpgl.YHPCZLXService;
import org.lf.admin.service.yhpgl.YHPService;
import org.lf.utils.EasyuiComboBoxItem;
import org.lf.utils.EasyuiDatagrid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 易耗品查询
 * 
 * 部门资产管理员查询本部门易耗品。
 * 后勤管理人员查询整个企业易耗品。
 * 
 * @author 
 *
 */
@Controller
@RequestMapping("/console/zcpd/yhpcx/")
public class YHPCXController extends BaseController {
	private final String ROOT = "/console/zcpd/yhpcx";
	
	@Autowired
	private YHPService yhpService;
	
	@Autowired
	private LYHPService lyhpService;
	
	@Autowired
	private ZCGLService zcglService;
	
	@Autowired
	private YHPCZLXService yhpczlxService;
	/**
	 * 部门易耗品查询
	 * @return
	 */
	@RequestMapping("BMYHPListUI.do")
	public String BMYHPListUI(HttpSession session,Model m) {
		Integer appId = getAppId(session);
		String fzr = getCurrUser(session).getWxUsername();
		boolean isBMGLY = false;
		try {
			isBMGLY = zcglService.getFZR(appId, fzr) != null;
		} catch (OperException e) {
			
		}
		
		m.addAttribute("isBMGLY", isBMGLY);
		return ROOT + "/BMYHPListUI";
	}
	
	/**
	 * 企业易耗品查询
	 * @return
	 */
	@RequestMapping("YHPListUI.do")
	public String YHPListUI(HttpSession session,Model m) {
		Integer appId = getAppId(session);
		String fzr = getCurrUser(session).getWxUsername();
		boolean isBMGLY = false;
		try {
			isBMGLY = zcglService.getFZR(appId, fzr) != null;
		} catch (OperException e) {
			
		}
		
		m.addAttribute("isBMGLY", isBMGLY);
		return ROOT + "/YHPListUI";
	}

	/**
	 * 企业易耗品库存查询
	 */
	@RequestMapping("getYHPList.do")
	@ResponseBody
	public EasyuiDatagrid<VYHP> getYHPList(HttpSession session, String lxId, Integer deptNo, int page, int rows) {
		Integer appId = getAppId(session);
		return yhpService.getYHPListByDeptNoAndYHPLX(appId, lxId, deptNo, rows, page);
	}
	
	/**
	 * 部门易耗品库存查询
	 * @throws OperException 
	 */
	@RequestMapping("getBMYHPList.do")
	@ResponseBody
	public EasyuiDatagrid<VYHP> getBMYHPList(HttpSession session, String lxId, int page, int rows) throws OperException {
		Integer appId = getAppId(session);
		String fzr = getCurrUser(session).getWxUsername();
		Integer deptno;
		deptno = yhpService.getDeptNo(appId, fzr);
		return yhpService.getYHPListByDeptNoAndYHPLX(appId, lxId, deptno, rows, page);
	}
	
	/**
	 * 易耗品操作记录
	 * @return
	 */
	@RequestMapping("detailYHPUI.do")
	public String detailYHPUI(Integer yhpId, Model m) {
		m.addAttribute("yhpId", yhpId);
		return ROOT + "/detailYHPUI";
	}
	
	@RequestMapping("getYHPDetail.do")
	@ResponseBody
	public EasyuiDatagrid<VLYHP> getYHPDetail(HttpSession session,Integer yhpId, Integer czlx, int rows, int page) {
		return lyhpService.getPagedLYHPList(yhpId, czlx, rows, page);
	}	
	
	/**
	 * 任务类型下拉列表框（包含全部）。
	 * @param session
	 * @return
	 */
	@RequestMapping("getYHPCZLXComboWithAll.do")
	@ResponseBody
	public List<EasyuiComboBoxItem> getRWLXComboWithAll(HttpSession session) {
		return yhpczlxService.getYHPCZLXComboWithAll();
	}
}

