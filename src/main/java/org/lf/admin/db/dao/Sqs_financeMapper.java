package org.lf.admin.db.dao;

import org.lf.admin.db.pojo.Sqs_finance;

public interface Sqs_financeMapper extends BaseMapper<Sqs_finance>{
    int deleteByPrimaryKey(Integer id);

    int insert(Sqs_finance record);

    int insertSelective(Sqs_finance record);

    Sqs_finance selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Sqs_finance record);

    int updateByPrimaryKey(Sqs_finance record);
}