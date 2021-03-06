package org.lf.admin.action.console.catalog;

import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.lf.admin.action.console.BaseController;
import org.lf.admin.db.pojo.CZCGL;
import org.lf.admin.db.pojo.ChuWXDept;
import org.lf.admin.service.OperException;
import org.lf.admin.service.catalog.ZCGLService;
import org.lf.admin.service.sys.WXDeptService;
import org.lf.admin.service.utils.ExcelFileUtils;
import org.lf.utils.EasyuiDatagrid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;

@Controller
@RequestMapping("/console/catalog/zcbmgl/")
public class ZCBMController extends BaseController {
	private final String ROOT = "/console/catalog/zcbmgl";
	
	@Autowired
	private ZCGLService zcbmService;
	
	@Autowired
	private WXDeptService wxDeptService;
	
	@RequestMapping("zcbmListUI.do")
	public String zcbmListUI() {
		return ROOT + "/NewZcbmListUI";
	}

	@RequestMapping("zcbmList.do")
	@ResponseBody
	public EasyuiDatagrid<CZCGL> zcbmList(HttpSession session, int page, int rows) {
		Integer appId = getAppId(session);
		CZCGL param = new CZCGL();
		param.setAppId(appId);
		EasyuiDatagrid<CZCGL> zcbmList = zcbmService.getPageZCGLList(param, rows, page);
		List<CZCGL> zcglList= zcbmList.getRows();
		for(CZCGL zcgl : zcglList) {
			zcgl.setDeptName(zcbmService.getWXDeptRootName(appId, zcgl.getDeptNo()));
		}
		return zcbmList;
	}
	
	@RequestMapping("updateZCBMUI.do")
	public String updateZCBMUI(Integer id, Model m) {
		CZCGL zcgl = zcbmService.getZCGL(id);
		m.addAttribute("zcgl", zcgl);
		
		return ROOT + "/updateZCBMUI";
	}
	
	/**
	 * 通过chu_wxdept表的id值查找对应部门的zcgl_id
	 * @param dept_id
	 * @return
	 */
	@RequestMapping("queryZCGL.do")
	@ResponseBody
	public String queryZCGL(Integer dept_id) {
		ChuWXDept dept=wxDeptService.getChuWXDeptByPrimaryKey(dept_id);
		CZCGL param=new CZCGL();
		param.setAppId(dept.getAppId());
		param.setDeptNo(dept.getDeptNo());
		CZCGL c;
		try {
			c = zcbmService.getZCGL(param);
		} catch (OperException e) {
			return e.getMessage();
		}
		return JSON.toJSONString(c);
	}
	
	@RequestMapping("updateZCBM.do")
	@ResponseBody
	public String updateZCBM(HttpSession session, Integer id, String fzr, String glr) {
		try {
			Integer appId = getAppId(session);
			zcbmService.checkFzrAndGlr(appId, id, fzr, glr);
			zcbmService.updateZCGL(id, fzr, glr);
			return SUCCESS;
		} catch (OperException e) {
			return e.getMessage();
		}
	}
	
	@RequestMapping("exportZCBMExcel.do")
	@ResponseBody
	public String exportZCBMExcel(HttpSession session, HttpServletResponse response) {
		Integer appId = getAppId(session);
		CZCGL param = new CZCGL();
		param.setAppId(appId);
		List<CZCGL> zcglList = zcbmService.getZCGLList(param);
		HSSFWorkbook wb;
		try {
			wb = zcbmService.exportZCGLList(zcglList);
			ExcelFileUtils.exportExcel(wb, response, "zcbm.xls");
			return SUCCESS;
		} catch (OperException e) {
			return e.getMessage();
		}
		
	}
}
