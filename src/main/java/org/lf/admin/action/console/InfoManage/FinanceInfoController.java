package org.lf.admin.action.console.InfoManage;

import java.util.ArrayList;
import java.util.List;

import org.lf.admin.db.pojo.Sqs_finance;
import org.lf.admin.service.InfoManage.FinanceInfoService;
import org.lf.utils.EasyuiDatagrid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/console/zcxx")
public class FinanceInfoController {
	@Autowired
	private FinanceInfoService financeInfoService;
	
	private final static String ROOT="/console/xxgl/";
	
	@RequestMapping("zcxxUI.do")
	public String ygxxUI(){
		return ROOT+"zcxxUI";
	}
	
	
	@RequestMapping("getFinanceList.do")
	@ResponseBody
	public EasyuiDatagrid<Sqs_finance> getEmpList(@RequestParam(defaultValue="1")int page,@RequestParam(name="rows",defaultValue="15")int pagesize){
		List<Sqs_finance> list=financeInfoService.getFinanceList(page, pagesize);
		EasyuiDatagrid<Sqs_finance> result=new EasyuiDatagrid<>();
		if(list==null || list.size()==0){
			result.setRows(new ArrayList<Sqs_finance>());
			result.setTotal(0);
		}else{
			result.setRows(list);
			result.setTotal(list.size());
		}
		return result;
	}
	
	@RequestMapping("delFinance.do")
	@ResponseBody
	public String delFinance(int id){
		int i=financeInfoService.delFinance(id);
		return i==1?"success":"failed";
	}
}
