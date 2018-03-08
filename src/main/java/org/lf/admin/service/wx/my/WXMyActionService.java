package org.lf.admin.service.wx.my;

import org.lf.admin.db.pojo.VZT;
import org.lf.admin.service.WXResultCode;
import org.lf.admin.service.logs.ZTService;
import org.lf.utils.AjaxResultModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("WXMyActionService")
public class WXMyActionService {
	private static final Logger logger = LoggerFactory.getLogger(WXMyActionService.class);
	@Autowired
	private ZTService ztService;
	
	public AjaxResultModel getVZTList(Integer appId, String jlr, Integer rows, Integer page) {
		AjaxResultModel result = new AjaxResultModel();
		try {
			VZT param = new VZT();
			param.setAppId(appId);
			param.setJlr(jlr);
			result.setData(ztService.getZTList(param, rows, page));
			result.setCode(WXResultCode.SUCCESS.getCode());
			result.setMsg(WXResultCode.SUCCESS.getMsg());
		} catch (Exception e) {
			logger.error("获取用户状态列表出错", e);
			result.setCode(WXResultCode.ERROR.getCode());
			result.setMsg(e.getMessage());
		}
		return result;
	}

	
}
