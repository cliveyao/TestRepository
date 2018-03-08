package org.lf.admin.action.console.zcgl;

import java.io.File;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.lf.admin.action.console.BaseController;
import org.lf.admin.db.dao.CZCGLMapper;
import org.lf.admin.db.pojo.CZCGL;
import org.lf.admin.db.pojo.VZC;
import org.lf.admin.service.OperException;
import org.lf.admin.service.utils.ExcelFileUtils;
import org.lf.admin.service.utils.WXMediaService;
import org.lf.admin.service.zcgl.ZCDJService;
import org.lf.admin.service.zcgl.ZCFPService;
import org.lf.admin.service.zcgl.ZCService;
import org.lf.admin.service.zcgl.ZCZT;
import org.lf.utils.EasyuiDatagrid;
import org.lf.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

/**
 * 资产登记
 * 
 * @author 
 *
 */
@Controller
@RequestMapping("/console/zcgl/regist/")
public class RegistBMZCController extends BaseController {
	
	@Autowired
	private ZCService zcService;
	
	@Autowired
	private CZCGLMapper czcglDao;
	
	@Autowired
	private ZCDJService zcdjService;
	
	@Autowired
	private ZCFPService zcfpService;
	
	private final String ROOT = "/console/zcgl/regist";
	
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	@RequestMapping("registBMZCListUI.do")
	public String registBMZCListUI(){
		return ROOT + "/registBMZCListUI";
	}
	
	/**
	 * 查询v_zc，获取资产状态为“未使用、领用中”的资产列表。
	 * @param appId
	 * @param page
	 * @param rows
	 * @return
	 */
	@RequestMapping("bmzcList.do")
	@ResponseBody
	public EasyuiDatagrid<VZC> zcList(HttpSession session, String zcmc, String zclx,int page, int rows) {
		String glr = getCurrUser(session).getWxUsername();
		Integer appId = getAppId(session);
		CZCGL record = new CZCGL();
		record.setGlr(glr);
		Integer deptNo = czcglDao.select(record).getDeptNo();
		if (StringUtils.isEmpty(zcmc)) {
			zcmc = null;
		}
		if (StringUtils.isEmpty(zclx)) {
			zclx = null;
		}
		List<Integer> zcztList = new ArrayList<>();
		zcztList.add(ZCZT.领用中.getValue());
		zcztList.add(ZCZT.未使用.getValue());
		
		return zcService.getPageVZCListByDeptNoAndZCLX(appId, null, zcmc, zclx, null, null, deptNo, glr, zcztList, page, rows);
	}
	
	@RequestMapping("importBMZCExcelUI.do")
	public String importBMZCExcelUI() {
		return ROOT+"/importBMZCExcelUI";
	}
	/**
	 * 通过excel表来批量导入
	 * @param session
	 * @param file_upload
	 * @return
	 */
	@RequestMapping("importBMZCExcel.do")
	@ResponseBody
	public String importBMZCExcel(HttpSession session, @RequestParam(value = "file_upload", required = false) MultipartFile file_upload) {
		try {
			Integer appId = getAppId(session);
			String djr = getCurrUser(session).getWxUsername();
			zcdjService.insertBMZCListByExcel(appId, file_upload, djr);
			return SUCCESS;
		}catch(OperException e){
			return e.getMessage();
		} catch (Exception e) {
			e.printStackTrace();
			return "系统错误";
		}
	}
	
	/**
	 * 下载excel表
	 * @param session
	 * @param response
	 * @return
	 */
	@RequestMapping("exportBMZCTempExcel.do")
	@ResponseBody
	public String exportBMZCTempExcel(HttpSession session,HttpServletResponse response) {
		String fileName  = "zc_temp.xls";
		String filePath = session.getServletContext().getRealPath("") + "/upload/template/";
		File excel = new File(filePath+fileName);
		HSSFWorkbook wb;
		try {
			wb = new HSSFWorkbook(new POIFSFileSystem(excel));
			ExcelFileUtils.exportExcel(wb, response, fileName);
			return SUCCESS;
		} catch (Exception e) {
			return e.getMessage();
		}
		
	}
	
	@RequestMapping("insertRegistBMZCUI")
	public String insertRegistBMZCUI() {
		return ROOT + "/insertRegistBMZCUI";
	}
	
	/**
	 * 资产数量（NUM）：可编辑数值框，默认值为1. 检查输入值是大于1的正整数
	 * @return
	 */
	private boolean checkNum(Integer num) {
		if (num == null) {
			return true;
		}
		if (num <= 0) {
			return true;
		} else {
			return false;
		}
	}
	
	/**
	 * 资产照片（PIC_URL）：上传文件框。可以为空。仅能上传.jpg格式文件，文件大小小于1MB。
	 * @return
	 */
	private boolean checkPIC(MultipartFile file_upload) {
		if (file_upload == null) {
			return false;
		}
		if (file_upload.getSize() > WXMediaService.MAX_IMAGE_SIZE) {
			return true;
		} else {
			return false;
		}
	}
	/**
	 * 检查是否是输入的正数
	 * @return
	 */
	private Boolean checkCost(BigDecimal cost){
		BigDecimal compareNum = new BigDecimal("0");
		if (cost.compareTo(compareNum)==1) {
			return false;
		}else {
			return true;
		}
	}
	
	/**
	 * 折旧年限，数值型（可以是小数）, 只要大于0.
	 * @param session
	 * @param zcmc
	 * @return
	 */
	private boolean checkRegistZCByZJNX(HttpSession session, BigDecimal zjnx) {
		BigDecimal compareNum = new BigDecimal(0);
		if (zjnx.compareTo(compareNum)==1) {
			return false;
		} else {
			return true;
		}
	}
	
	/**
	 * 非空。在相同appId下唯一检查。
	 * @param session
	 * @param zcdm
	 * @return
	 */
	private boolean checkRegistZCByDM(HttpSession session, String zcdm) {
		Integer appId = getAppId(session);
		VZC param = new VZC();
		param.setAppId(appId);
		param.setZcdm(zcdm);
		return zcService.countZCList(param) != 0;
	}
	
	/**
	 * 资产名称非空。
	 * @param session
	 * @param zcmc
	 * @return
	 */
	private boolean checkRegistZCByMC(HttpSession session, String zcmc) {
		if (StringUtils.isEmpty(zcmc)) {
			return true;
		} else {
			return false;
		}
	}
	
	@RequestMapping("insertRegistBMZC.do")
	@ResponseBody
	public String insertRegistBMZC(HttpSession session, String dm, String mc, Integer lxid,String cfdd, String xh, String ccbh, String gzsj, BigDecimal cost,
			BigDecimal zjnx,Integer num,@RequestParam(value = "file_upload", required = false) MultipartFile file_upload) {
		String djr = getCurrUser(session).getWxUsername();
		Integer appId = getAppId(session);
		String resultStr = SUCCESS;
		if (checkRegistZCByDM(session, dm)) {
			resultStr = "ZCDM_ERROR";
			return resultStr;
		} else if (checkRegistZCByMC(session, mc)){
			resultStr = "ZCMC_ERROR";
			return resultStr;
		} else if (checkRegistZCByZJNX(session, zjnx)) {
			resultStr = "ZJNX_ERROR";
			return resultStr;
		} else if (checkPIC(file_upload)) {
			resultStr="PIC_ERROR";
			return resultStr;
		} else if (checkNum(num)) {
			resultStr = "NUM_ERROR";
			return resultStr;
		} else if (checkCost(cost)) {
			resultStr="COST_ERROR";
			return resultStr;
		} else {
			try {
				String Url = null;
				if (file_upload !=null) {
					Url = zcdjService.uploadPic(session, file_upload,getAppId(session));
				}
				zcdjService.registBMZC(appId, dm, mc, lxid,cfdd, cost, num, xh, ccbh, sdf.parse(gzsj), zjnx, djr, Url);
			} catch (OperException e) {
				resultStr = e.getMessage();
			} catch (ParseException e) {
				resultStr="您刚刚输入的日期无效，请重试";
			}
		}
		
		return resultStr;
	}
	/**
	 * 资产分配
	 * @return
	 */
	@RequestMapping("assignBMZCUI.do")
	public String assignBMZCUI() {
		return ROOT + "/assignBMZCUI";
	}
	
	@RequestMapping("assignBMZC.do")
	@ResponseBody
	public String assignBMZC(HttpSession session, Integer zcid, String syr) {
		String czr = getCurrUser(session).getWxUsername();
		try {
			zcfpService.assignZC(zcid, czr, syr);
			return SUCCESS;
		} catch (OperException e) {	
			return e.getMessage();
		}
	}
	
	/**
	 * 申请归还
	 * @return
	 */
	@RequestMapping("revertZCUI.do")
	public String revertZCUI() {
		return ROOT + "/revertZCUI";
	}
	
	@RequestMapping("revertZC.do")
	@ResponseBody
	public String revertZC(HttpSession session, Integer zcid, String remark) {
		String czr = getCurrUser(session).getWxUsername();
		
		try {
			zcfpService.revertZC(zcid, czr, remark.trim());
			return SUCCESS;
		} catch (OperException e) {
			return e.getMessage();
		}
	}
	
	/**
	 * 资产重新分配
	 * @return
	 */
	@RequestMapping("reassignZCUI.do")
	public String reassignZCUI() {
		return ROOT + "/reassignZCUI";
	}
	
	@RequestMapping("reassignZC.do")
	@ResponseBody
	public String reassignZC(HttpSession session, Integer zcid, String newSyr, String remark) {
		String czr = getCurrUser(session).getWxUsername();
		
		try {
			zcfpService.reassignZC(zcid, czr, newSyr, remark.trim());
			return SUCCESS;
		} catch (OperException e) {
			return e.getMessage();
		}
	}
}
