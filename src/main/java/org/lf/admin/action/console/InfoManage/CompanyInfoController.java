package org.lf.admin.action.console.InfoManage;

import java.util.ArrayList;
import java.util.List;

import org.lf.admin.db.pojo.Sqs_company;
import org.lf.admin.service.InfoManage.CompanyInfoService;
import org.lf.utils.EasyuiDatagrid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/console/gsxx/")
public class CompanyInfoController {
	@Autowired
	private CompanyInfoService companyInfoService;
	
	private final static String ROOT="/console/xxgl/";
	
	@RequestMapping("gsxxUI.do")
	public String gsxxUI(){
		return ROOT+"gsxxUI";
	}
	
	
	@RequestMapping("getCompanyList.do")
	@ResponseBody
	public EasyuiDatagrid<Sqs_company> getCompanyList(@RequestParam(defaultValue="1")int page,@RequestParam(name="rows",defaultValue="15")int pagesize){
		List<Sqs_company> list=companyInfoService.getCompanyList(page, pagesize);
		EasyuiDatagrid<Sqs_company> result=new EasyuiDatagrid<>();
		if(list==null || list.size()==0){
			result.setRows(new ArrayList<Sqs_company>());
			result.setTotal(0);
		}else{
			result.setRows(list);
			result.setTotal(list.size());
		}
		return result;
	}
	
	@RequestMapping("delCompany.do")
	@ResponseBody
	public String delCompany(int id){
		int i=companyInfoService.delCompany(id);
		return i==1?"success":"failed";
	}
}
