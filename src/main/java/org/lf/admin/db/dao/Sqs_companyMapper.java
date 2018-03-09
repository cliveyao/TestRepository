package org.lf.admin.db.dao;

import org.lf.admin.db.pojo.Sqs_company;

public interface Sqs_companyMapper extends BaseMapper<Sqs_company>{
    int deleteByPrimaryKey(Integer id);

    int insert(Sqs_company record);

    int insertSelective(Sqs_company record);

    Sqs_company selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Sqs_company record);

    int updateByPrimaryKey(Sqs_company record);
}