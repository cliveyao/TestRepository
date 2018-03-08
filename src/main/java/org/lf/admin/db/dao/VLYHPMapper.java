package org.lf.admin.db.dao;

import java.util.List;
import java.util.Map;

import org.lf.admin.db.pojo.VLYHP;

public interface VLYHPMapper extends BaseMapper<VLYHP>{
	int countYHPList(VLYHP vlyhp);
	
	int countLYHPListFuzzy (Map<String,?> lxIdLists);
    
    List<VLYHP> getLYHPListFuzzy(Map<String,?> lxIdLists);
}