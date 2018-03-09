package org.lf.admin.action.console.InfoManage;

import java.util.ArrayList;
import java.util.List;

import org.lf.admin.db.pojo.Sqs_emp;
import org.lf.admin.service.InfoManage.EmpInfoService;
import org.lf.utils.EasyuiDatagrid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/console/ygxx/")
public class EmpInfoController {
	@Autowired
	private EmpInfoService empInfoService;
	
	private final static String ROOT="/console/xxgl/";
	
	@RequestMapping("ygxxUI.do")
	public String ygxxUI(){
		return ROOT+"ygxxUI";
	}
	
	
	@RequestMapping("getEmpList.do")
	@ResponseBody
	public EasyuiDatagrid<Sqs_emp> getEmpList(@RequestParam(defaultValue="1")int page,@RequestParam(name="rows",defaultValue="15")int pagesize){
		List<Sqs_emp> list=empInfoService.getEmpList(page, pagesize);
		EasyuiDatagrid<Sqs_emp> result=new EasyuiDatagrid<>();
		if(list==null || list.size()==0){
			result.setRows(new ArrayList<Sqs_emp>());
			result.setTotal(0);
		}else{
			result.setRows(list);
			result.setTotal(list.size());
		}
		return result;
	}
	
	@RequestMapping("delEmp.do")
	@ResponseBody
	public String delEmp(int id){
		int i=empInfoService.delEmp(id);
		return i==1?"success":"failed";
	}
}
