package org.lf.wx.user;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.lf.wx.WXProperties;
import org.lf.wx.utils.WXException;
import org.lf.wx.utils.WXUtils;

import com.alibaba.fastjson.JSON;

public class UserManagerTest {

	@Test
	public void testGetUser() throws WXException {
		User u = UserManager.getUser(WXUtils.getLocalToken(), "XuQingWei");
		
		System.out.println(u.getJSON().toJSONString());
	}
	
	@Test
	public void testGetUserList() throws WXException {
		List<User> uList = UserManager.getUserList(WXUtils.getLocalToken(), 2, false, UserStatus.全部成员);
		System.out.println(JSON.toJSONString(uList));
	}
	
	@Test
	public void testCreateUser() throws WXException {
		List<Integer> deptList = new ArrayList<>();
		deptList.add(1);
		
		User u = UserManager.createUser(WXUtils.getLocalToken(), "xqw1", "许1", "13347897488", deptList);
		System.out.println(JSON.toJSONString(u));
	}
	
	@Test
	public void testUpdateUser() throws WXException {
		User u = new User("XuQingWei");
		u.setName("许庆炜");
		u.setDepartment("2");
		
		UserManager.updateUser(WXUtils.getAccessToken(WXProperties.CORP_ID, WXProperties.CONTACT_SECRET), u);
	}

}
