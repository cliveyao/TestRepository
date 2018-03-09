package org.lf.admin.service.InfoManage;

import java.util.List;

import org.lf.admin.db.dao.Sqs_empMapper;
import org.lf.admin.db.pojo.Sqs_emp;
import org.lf.utils.PageNavigator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class EmpInfoService {
	@Autowired
	private Sqs_empMapper empInfoDao;
	
	public List<Sqs_emp> getEmpList(int page,int pagesize){
		PageNavigator pageNav=new PageNavigator(pagesize, page);
		Sqs_emp params=new Sqs_emp();
		params.setStart(pageNav.getStart());
		params.setOffset(pageNav.getOffset());
		return empInfoDao.selectList(params);
	}
	
	public int delEmp(int id){
		return empInfoDao.deleteByPrimaryKey(id);
	}
}
