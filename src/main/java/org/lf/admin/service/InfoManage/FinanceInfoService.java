package org.lf.admin.service.InfoManage;

import java.util.List;

import org.lf.admin.db.dao.Sqs_financeMapper;
import org.lf.admin.db.pojo.Sqs_finance;
import org.lf.utils.PageNavigator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FinanceInfoService {
	@Autowired
	private Sqs_financeMapper financeInfoDao;
	
	public List<Sqs_finance> getFinanceList(int page,int pagesize){
		PageNavigator pageNav=new PageNavigator(pagesize, page);
		Sqs_finance params=new Sqs_finance();
		params.setStart(pageNav.getStart());
		params.setOffset(pageNav.getOffset());
		return financeInfoDao.selectList(params);
	}
	
	public int delFinance(int id){
		return financeInfoDao.deleteByPrimaryKey(id);
	}
}
