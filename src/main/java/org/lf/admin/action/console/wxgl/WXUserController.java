package org.lf.admin.action.console.wxgl;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.commons.collections4.map.HashedMap;
import org.lf.admin.action.console.BaseController;
import org.lf.admin.db.pojo.ChuTag;
import org.lf.admin.db.pojo.ChuUser;
import org.lf.admin.db.pojo.ChuWXUser;
import org.lf.admin.db.pojo.WXUser;
import org.lf.admin.service.OperException;
import org.lf.admin.service.sys.WXDeptService;
import org.lf.admin.service.sys.WXTagService;
import org.lf.admin.service.sys.WXUserService;
import org.lf.utils.EasyuiComboBoxItem;
import org.lf.utils.EasyuiDatagrid;
import org.lf.utils.EasyuiTree;
import org.lf.utils.servlet.LoginInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 微信应用有关，包括微信用户管理、微信部门管理、微信标签管理。
 * 
 */
@Controller
@RequestMapping("/console/wxgl/wxuser/")
public class WXUserController extends BaseController {
	private static final String ROOT = "/console/wxgl/wxuser";
	
	@Autowired
	private WXUserService userService;
	
	@Autowired
	private WXDeptService deptService;
	
	@Autowired
	private WXTagService tagService;
	
	/**
	 * 微信用户管理界面
	 */
	@RequestMapping("wxUserListUI.do")
	public String wxUserListUI(){
		return ROOT +"/wxUserListUI";
	}
	
	/**
	 * 同步微信用户界面
	 * @return
	 */
	@RequestMapping("syncWXUserUI.do")
	public String syncWXUserUI(){
		return ROOT + "/syncWXUserUI";
	}
	
	/**
	 * 编辑微信用户界面
	 * @return
	 */
	@RequestMapping("updateWXUserUI.do")
	public String updateWXUserUI(){
		return ROOT + "/updateWXUserUI";
	}
	
	/**
	 * 	所属部门：下拉列表框，默认为全部
	 * 
	 * @return
	 */
	@RequestMapping("getWXDeptComboWithAll.do")
	@ResponseBody
	public List<EasyuiComboBoxItem> getWXDeptComboWithAll(HttpSession session) {
		return deptService.getWXDeptComboWithAll(getAppId(session));
	}
	
	/**
	 * 		标签：下拉列表框，默认为全部
	 * 
	 * @return
	 */
	@RequestMapping("getWXTagComboWithAll.do")
	@ResponseBody
	public List<EasyuiComboBoxItem> getWXTagComboWithAll(HttpSession session) {
		
		return tagService.getWXTagComboWithAll(getAppId(session));
	}
	
	@RequestMapping("getWXUserList.do")
	@ResponseBody
	public EasyuiDatagrid<WXUser> getWXUserList(HttpSession session, String deptNo, String tagNo, int page, int rows) {
		deptNo=("".equals(deptNo))?null:deptNo;
		tagNo=("".equals(tagNo))?null:tagNo;
		ChuWXUser param =  new ChuWXUser();
		param.setTagNo(tagNo);
		param.setDepartment(deptNo);
		param.setAppId(getAppId(session));
		return userService.getPageWXUserList(param, rows, page);
	}
	
	/**
	 * 查询微信用户
	 * @return
	 */
	@RequestMapping("queryWXUserUI.do")
	public String queryWXUserUI(@RequestParam(required=false,defaultValue="false")boolean isEdit,Model model) {
		model.addAttribute("isEdit", isEdit);
		return ROOT + "/queryWXUserUI";
	}
	
	/**
	 * 根据appId，查询Chu_WXUser表，构建完成的微信用户树。
	 * @param session
	 * @return
	 */
	@RequestMapping("getWXUserTree.do")
	@ResponseBody
	public List<EasyuiTree> getWXUserTree(HttpSession session,String wxuser_name) {
		ChuUser user=(ChuUser) session.getAttribute(LoginInterceptor.LOGIN_INFO);
		if (wxuser_name != null) {
			wxuser_name = wxuser_name.trim();
		}
		return userService.getTreeUserList(user.getAppId(),wxuser_name);
	}
	
	/**
	 * 返回用户选中的user。
	 * @param id
	 * @return
	 */
	@RequestMapping("queryWXUser.do")
	@ResponseBody
	public ChuWXUser queryWXUser(Integer id) {
		return userService.getChuWXUserByPrimaryKey(id);
	}
	
	/**
	 * 同步微信信用户信息
	 * 如果用户在微信服务器上不存在，报错
	 * 如果用户在微信服务器上，但chu_wxuser中没有相关记录，新增。
	 * 如果用户在微信服务器上，但chu_wxuser中有相关记录，更新。
	 * @param session
	 * @param userid
	 * @param m
	 * @return
	 */
	@RequestMapping("syncWXUser.do")
	@ResponseBody
	public WXUser syncWXUser(HttpSession session,String userid){
		Integer appId = getAppId(session);
		try {
			return userService.syncWXUser(appId, userid);
		} catch (OperException e) {
			return null;
		}
	}
	
	/**
	 * 更新微信用户
	 * @param session
	 * @param userid
	 * @param name
	 * @param deptNo
	 * @param tagNoString
	 * @return
	 */
	@RequestMapping("updateWXUser.do")
	@ResponseBody
	public String updateWXUser(HttpSession session,String userid,String name,Integer deptNo,String tagNoString){
		Integer appId = getAppId(session);
		HashedMap<Integer, Boolean> tagNoMap = new HashedMap<Integer, Boolean>();
		String[] array = tagNoString.split(",");
		for(String tagName : array){
			ChuTag chuTag = userService.getTagNo(appId,tagName);
			tagNoMap.put(chuTag.getTagNo(), true);
		}
		try {
			userService.updateWXUser(appId, userid, name, deptNo, tagNoMap);
			return SUCCESS;
		} catch (OperException e) {
			return e.getMessage();
		}
	}
}
