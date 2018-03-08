package org.lf.wx.user;

import org.junit.Test;
import org.lf.wx.WXProperties;
import org.lf.wx.utils.WXException;
import org.lf.wx.utils.WXUtils;

import com.alibaba.fastjson.JSONObject;

public class TagManagerTest {
	@Test
	public void testCreateTag() throws WXException {
		int tagid = 10001;
		String tagName = "test1";
		
		System.out.println(TagManager.createTag(WXUtils.getLocalToken(), tagid, tagName));
	}

	@Test
	public void testGetUserList() throws WXException {
		Integer tagid = 1;
		
		JSONObject json = TagManager.getUserList(WXUtils.getLocalToken(), tagid.toString());
		System.out.println(json.toJSONString());
	}
	
	@Test
	public void testAddTagUsers() throws WXException {
		TagManager.addTagUsers(WXUtils.getAccessToken(WXProperties.CORP_ID, WXProperties.CONTACT_SECRET), 6, "XuQingWei");
	}
	
	@Test
	public void testDelTagUsers() throws WXException {
		TagManager.delTagUsers(WXUtils.getAccessToken(WXProperties.CORP_ID, WXProperties.CONTACT_SECRET), 6, "XuQingWei");
	}

}
