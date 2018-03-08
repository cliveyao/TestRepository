package org.lf.admin.action.wx;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.lf.admin.service.wx.WXOAuthService;
import org.lf.utils.AjaxResultModel;
import org.lf.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 微信网页授权控制器
 * 
 * @author sunwill
 *
 */
@Controller
@RequestMapping("/wx/oauth/")
public class WXOAuthController {
	/**
	 * session中存放用户信息的key值
	 */
	public static final String WX_LOGIN_USER = "wx_login_user";

	@Autowired
	private WXOAuthService wXOAuthService;

	/**
	 * 验证token
	 * 
	 * @param rwid
	 * @return
	 */
	@CrossOrigin
	@RequestMapping("checkToken.do")
	@ResponseBody
	public AjaxResultModel checkToken(HttpServletRequest request, String appId) {
		return wXOAuthService.checkToken(request, appId);
	}

	/**
	 * 初始化授权界面
	 * 
	 * @param session
	 * @param response
	 * @throws IOException
	 *             http://localhost:8081/?appId=17
	 */
	@RequestMapping("toOAuth.do")
	@ResponseBody
	public void toOAuth(HttpServletResponse response, String requestUrl) throws IOException {
		wXOAuthService.getCode(response, "/wx/oauth/getOAuthInfo.do", requestUrl);
	}

	/**
	 * 网络授权完成后，生成token
	 */
	@RequestMapping("getOAuthInfo.do")
	public String getOAuthInfo(String code, String state, Integer appId, String requestUrl) {
		return wXOAuthService.getRedirectUrl(code, state, appId, requestUrl);
	}

	@RequestMapping("toOAuthTest.do")
	public String toOAuthTest(String testToken, String requestUrl) {
		// TODO 阿里云测试用 正式上线删除
		if (StringUtils.isEmpty(testToken) || StringUtils.isEmpty(requestUrl)) {
			return null;
		}
		return wXOAuthService.getOAuthRedirect(testToken, requestUrl);
	}

}
