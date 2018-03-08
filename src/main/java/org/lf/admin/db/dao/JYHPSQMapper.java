package org.lf.admin.db.dao;

import org.lf.admin.db.pojo.JYHPSQ;

public interface JYHPSQMapper extends BaseMapper<JYHPSQ>{
    int deleteByPrimaryKey(String dm);

    int insert(JYHPSQ record);

    int insertSelective(JYHPSQ record);

    JYHPSQ selectByPrimaryKey(String dm);

    int updateByPrimaryKeySelective(JYHPSQ record);

    int updateByPrimaryKey(JYHPSQ record);
    
    int countYHPSQList(JYHPSQ reccord);
    
    //通过申请代码删除记录
    int delYHPSQ(String dm);
}