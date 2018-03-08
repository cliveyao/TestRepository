package org.lf.admin.action.console.zcpd;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.lf.admin.action.console.BaseController;
import org.lf.admin.db.dao.CZCGLMapper;
import org.lf.admin.db.pojo.CZCGL;
import org.lf.admin.db.pojo.VLYHP;
import org.lf.admin.service.OperException;
import org.lf.admin.service.catalog.ZCGLService;
import org.lf.admin.service.yhpgl.LYHPService;
import org.lf.admin.service.yhpgl.YHPCZLXService;
import org.lf.utils.EasyuiComboBoxItem;
import org.lf.utils.EasyuiDatagrid;
import org.lf.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 企业（部门）易耗品出入库记录查询
 * 
 */
@Controller
@RequestMapping("/console/zcpd/lyhpcx/")
public class LYHPCXController extends BaseController {
	private final String ROOT = "/console/zcpd/lyhpcx";
	
	@Autowired
	private CZCGLMapper czcglDao;
	
	@Autowired
	private LYHPService lyhpService;
	
	@Autowired
	private YHPCZLXService yhpczlxService;
	
	@Autowired
	private ZCGLService zcglService;
	
	/**
	 * 部门易耗品出入库记录查询
	 * @return
	 */
	@RequestMapping("BMLYHPListUI.do")
	public String BMLYHPListUI() {
		return ROOT + "/BMLYHPListUI";
	}
	
	@RequestMapping("validFzr.do")
	@ResponseBody
	public String validFzr(HttpSession session) {
		String result = SUCCESS;
		Integer appId = getAppId(session);
		String fzr = getCurrUser(session).getWxUsername();
		try {
			zcglService.getFZR(appId, fzr);
		} catch (OperException e) {
			result = e.getMessage();
		}
		return result;
	}
	
	@RequestMapping("getCZLXComboWithAll.do")
	@ResponseBody
	public List<EasyuiComboBoxItem> getCZLXComboWithAll(){
		return yhpczlxService.getYHPCZLXComboWithAll();
	}
	
	/**
	 * 企业易耗品出入库记录查询
	 * @return
	 */
	@RequestMapping("LYHPListUI.do")
	public String LYHPListUI() {
		return ROOT + "/LYHPListUI";
	}

	@RequestMapping("getBMLYHPList.do")
	@ResponseBody
	public EasyuiDatagrid<VLYHP> getBMLYHPList(HttpSession session,String czr,String czlx,String lxId, int page, int rows) {
		Integer appId = getAppId(session);
		CZCGL zcgl = new CZCGL();
		zcgl.setFzr(getCurrUser(session).getWxUsername());
		zcgl.setAppId(getAppId(session));
		Integer czlxNum = null;
		if (StringUtils.isEmpty(czr)) {
			czr = null;
		}
		if (!StringUtils.isEmpty(czlx)) {
			czlxNum = Integer.parseInt(czlx.trim());
		}
		return lyhpService.getPagedLYHPListFuzzy(appId, lxId, czr, czlxNum,czcglDao.select(zcgl).getDeptNo(),rows, page);
	}
	
	@RequestMapping("getLYHPList.do")
	@ResponseBody
	public EasyuiDatagrid<VLYHP> getLYHPList(HttpSession session,String czr,String czlx,String lxId,Integer deptNo, int page, int rows) {
		Integer appId = getAppId(session);
		Integer czlxNum = null;
		if (StringUtils.isEmpty(czr)) {
			czr = null;
		}
		if (!StringUtils.isEmpty(czlx)) {
			czlxNum = Integer.parseInt(czlx.trim());
		}
		return lyhpService.getPagedLYHPListFuzzy(appId, lxId, czr, czlxNum, deptNo, rows, page);
	}
}
