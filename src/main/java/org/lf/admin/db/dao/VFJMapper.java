package org.lf.admin.db.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Select;
import org.lf.admin.db.pojo.VFJ;

public interface VFJMapper extends BaseMapper<VFJ>{
	
	
	int countVFJList(VFJ param);
	
	//根据建筑物名称进行模糊查找
	List<VFJ> getFJListFuzzy(VFJ param);
	
	//根据建筑物名称进行模糊查找
	int countVFJListFuzzy(VFJ param);
	
	//查找param下不重复的floor
	List<String> selectFloorList(VFJ param);
	
	/**
	 * 根据房间id查找存放地点详细地址，返回值为字符串
	 */
	@Select("select concat(xqmc,jzw,floor,room,'--',dz) as cfddmc from v_fj where fj_id=#{fjId,jdbcType=INTEGER}")
	String selectCFDDMCByFJID(Map<String, Object> params);
}