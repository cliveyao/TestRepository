package org.lf.admin.service.InfoManage;

import java.util.List;

import org.lf.admin.db.dao.Sqs_companyMapper;
import org.lf.admin.db.pojo.Sqs_company;
import org.lf.utils.PageNavigator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CompanyInfoService {
	@Autowired
	private Sqs_companyMapper companyInfoDao;
	
	public List<Sqs_company> getCompanyList(int page,int pagesize){
		PageNavigator pageNav=new PageNavigator(pagesize, page);
		Sqs_company params=new Sqs_company();
		params.setStart(pageNav.getStart());
		params.setOffset(pageNav.getOffset());
		return companyInfoDao.selectList(params);
	}
	
	public int delCompany(int id){
		return companyInfoDao.deleteByPrimaryKey(id);
	}
}
