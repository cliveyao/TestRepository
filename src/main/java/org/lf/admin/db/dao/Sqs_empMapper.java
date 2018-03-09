package org.lf.admin.db.dao;

import org.lf.admin.db.pojo.Sqs_emp;

public interface Sqs_empMapper extends BaseMapper<Sqs_emp>{
    int deleteByPrimaryKey(Integer id);

    int insert(Sqs_emp record);

    int insertSelective(Sqs_emp record);

    Sqs_emp selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Sqs_emp record);

    int updateByPrimaryKey(Sqs_emp record);
}