package org.lf.admin.service.yhpgl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.lf.admin.db.dao.ChuAppMapper;
import org.lf.admin.db.dao.JYHPMapper;
import org.lf.admin.db.dao.LYHPMapper;
import org.lf.admin.db.dao.VYHPMapper;
import org.lf.admin.db.pojo.CZCGL;
import org.lf.admin.db.pojo.ChuApp;
import org.lf.admin.db.pojo.JYHP;
import org.lf.admin.db.pojo.LYHP;
import org.lf.admin.db.pojo.VYHP;
import org.lf.admin.db.pojo.VZC;
import org.lf.admin.service.OperErrCode;
import org.lf.admin.service.OperException;
import org.lf.admin.service.ZCGLProperties;
import org.lf.admin.service.catalog.ZCGLService;
import org.lf.admin.service.sys.WXDeptService;
import org.lf.admin.service.utils.WXMediaService;
import org.lf.admin.service.zcgl.ZCService;
import org.lf.utils.EasyuiDatagrid;
import org.lf.utils.PageNavigator;
import org.lf.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

/**
 * 易耗品管理
 * 
 */
@Service("yhpService")
public class YHPService {
	@Autowired
	private VYHPMapper vyhpDao;
	
	@Autowired
	private JYHPMapper jyhpDao;
	
	@Autowired
	private LYHPMapper l_yhpDao;
	
	@Autowired
	private ZCGLService zcglService;
	
	@Autowired
	private WXMediaService wxMediaService;
	
	@Autowired
	private WXDeptService wxDeptService;
	
	@Autowired
	private ChuAppMapper appDao;
	
	@Autowired
	private ZCService zcService;
	
	public static final OperErrCode 调拨易耗品失败 = new OperErrCode("11201", "调拨易耗品失败！ ");
	public static final OperErrCode 登记易耗品失败 = new OperErrCode("11202", "登记易耗品失败！ ");
	public static final OperErrCode 补货易耗品失败 = new OperErrCode("11203", "补货易耗品失败！ ");
	public static final OperErrCode 编辑易耗品失败 = new OperErrCode("11204", "编辑易耗品失败！ ");
	public static final OperErrCode 库存下限不能大于持有数量 = new OperErrCode("11205", "库存下限不能大于持有数量！ ");
	public static final OperErrCode 删除失败 = new OperErrCode("11206", "删除失败！ ");
	public static final OperErrCode 资产总数超出预设配额 = new OperErrCode("11207", "资产总数超出预设配额");
	
	public int countYHPList(Integer appId, String lxId, Integer deptno) {
		VYHP param=new VYHP();
		param.setAppId(appId);
		param.setLxId(lxId);
		param.setDeptNo(deptno);  	//根据deptno查找易耗品
		return vyhpDao.countYhpList(param);
	}
	
	public List<VYHP> getYHPList(Integer appId, String lxId, Integer deptno, int rows, int page) {
		PageNavigator pn = new PageNavigator(rows, page);
		VYHP param=new VYHP();
		param.setStart(pn.getStart());
		param.setOffset(pn.getOffset());
		param.setAppId(appId);
		param.setLxId(lxId);
		param.setDeptNo(deptno);  	//根据deptno查找易耗品
		return vyhpDao.selectYhpList(param);
	}
	
	public EasyuiDatagrid<VYHP> getPagedYHPList(Integer appId, String lxId, Integer deptno, int rows, int page) {
		int total=countYHPList(appId, lxId, deptno);
		EasyuiDatagrid<VYHP> result=new EasyuiDatagrid<>();
		if(total>0){
			List<VYHP> list=getYHPList(appId, lxId, deptno, rows, page);
			result.setRows(list);
		}else{
			result.setRows(new ArrayList<VYHP>());
		}
		result.setTotal(total);
		return result;
	}
	
	
	
	public EasyuiDatagrid<VYHP> getYHPListByDeptNoAndYHPLX(Integer appId, String lxId, Integer deptno, int rows, int page){
		//获取指定部门的所有子部门列表(包括指定部门)
		List<String> deptNoList=wxDeptService.getSubDeptmentByDeptNo(appId, deptno);
		//查询指定部门列表对应的资产列表
		Map<String, Object> param = new HashMap<String, Object>();
		if(deptNoList.size() > 1 || !StringUtils.isEmpty(deptNoList.get(0)) ){
			param.put("list", deptNoList);
		}
		param.put("appId", appId);
		param.put("lxId", lxId);
		PageNavigator pn = new PageNavigator(rows, page);
		param.put("start", pn.getStart());
		param.put("offset", pn.getOffset());
		
		int total=vyhpDao.countYHPListByDeptNoAndYHPLX(param);
		List<VYHP> list=vyhpDao.selectYHPListByDeptNoAndYHPLX(param);
		
		return new EasyuiDatagrid<VYHP>(list, total);
	}
	
	
	public JYHP getYHPByPrimaryKey(Integer yhpid){
		return jyhpDao.selectByPrimaryKey(yhpid);
	}
	
	public JYHP getYHP(JYHP param){
		return jyhpDao.select(param);
	}
	
	public JYHP getQYYHP(JYHP param){
		return jyhpDao.selectQYYHP(param);
	}
	
	/**
	 * 企业易耗品登记，czbmId为空；部门易耗品登记，操作部门为用户所在部门id号。
	 * select id from c_zcgl where appid=? and fzr=?
	 * 这里，负责人（fzr）为当前用户userid。
	 *  
	 * 
	 * 	向J_YHP表中插入一条记录。
	 * 	向L_YHP表中插入一条记录：
	 */
	@Transactional(rollbackFor = Exception.class)
	public void insertYHP(Integer appId, String jlr, Integer czbmId, Integer lxId, String picUrl, String xh, String ccbh, Integer num,
			Integer leftLimit, String cfdd) throws OperException {
		
			//固定资产登记越界检查
			ChuApp app = new ChuApp();
			app.setAppId(appId);
			Integer maxCount = appDao.select(app).getMaxCount();
			VZC param = new VZC();
			param.setAppId(appId);
			Integer zcCount = zcService.countZCList(param);
			Integer yhpCount = countYHPList(appId, null, null);
			if (zcCount + yhpCount + 1 > maxCount) {
				throw new OperException(资产总数超出预设配额);
			}
		
			//向J_YHP表中插入一条记录。
			JYHP jyhp=new JYHP();
			jyhp.setAppId(appId);
			jyhp.setZcglId(czbmId);
			jyhp.setLxId(lxId);
			jyhp.setPicUrl(picUrl);
			jyhp.setXh(xh);
			jyhp.setCcbh(ccbh);
			jyhp.setNum(num);
			jyhp.setLeftLimit(leftLimit);
			jyhp.setCfdd(cfdd);
			jyhp.setImgVersion(1);
			int i=jyhpDao.insertSelective(jyhp);
			if(i<=0){
				throw new OperException(登记易耗品失败);
			}
			//向L_YHP表中插入一条记录
			LYHP lyhp=new LYHP();
			lyhp.setYhpId(jyhp.getId());
			lyhp.setJlr(jlr);
			lyhp.setJlsj(new Date());
			lyhp.setCzbmId(czbmId);
			if(czbmId==null){
				lyhp.setCzr(null);
			}else{
				lyhp.setCzr(jlr);
			}
			lyhp.setNum(num);
			lyhp.setCzlx(YHPCZLX.登记.getValue());		//登记（0）、调拨（1）、领用（2）、报损（3）、入库（4）
			i=l_yhpDao.insertSelective(lyhp);
			if(i<=0){
				throw new OperException(登记易耗品失败);
			}
	}
	
	@Transactional(rollbackFor = Exception.class)
	public void updateYHP(Integer yhpId, String picUrl, String xh, String ccbh, Integer leftLimit, String cfdd) throws OperException {
		JYHP jyhp=jyhpDao.selectByPrimaryKey(yhpId);
		if(jyhp.getImgVersion()==null){
			jyhp.setImgVersion(1);
		}else{
			jyhp.setImgVersion(jyhp.getImgVersion()+1);
		}
		jyhp.setId(yhpId);
		jyhp.setCfdd(cfdd);
		jyhp.setPicUrl(picUrl);
		jyhp.setXh(xh);
		jyhp.setCcbh(ccbh);
		jyhp.setLeftLimit(leftLimit);
		int i=jyhpDao.updateByPrimaryKeySelective(jyhp);
		if(i<=0){
			throw new OperException(编辑易耗品失败);
		}
	}
	
	@Transactional(rollbackFor = Exception.class)
	public void delYHP(Integer yhpId) throws OperException {
		int i=jyhpDao.deleteByPrimaryKey(yhpId);
		if(i<=0){
			throw new OperException(删除失败);
		}
	}
	
	@Transactional(rollbackFor = Exception.class)
	public void addYHP(Integer appId,String jlr,Integer yhpId, Integer addNum) throws OperException {
		JYHP param=jyhpDao.selectByPrimaryKey(yhpId);
		param.setNum(param.getNum()+addNum);
		int i=jyhpDao.updateByPrimaryKey(param);
		if(i<=0){
			throw new OperException(补货易耗品失败);
		}
		//在L_YHP表中增加一条补货记录
		LYHP lyhp=new LYHP();
		lyhp.setYhpId(param.getId());
		lyhp.setJlr(jlr);
		lyhp.setNum(addNum);
		lyhp.setCzlx(YHPCZLX.补货.getValue());             //登记（0）、调拨（1）、领用（2）、报损（3）、入库（4）、补货（5）
		Integer czbmId=getCZBM_Id(appId, jlr);
		lyhp.setCzbmId(czbmId);
		if(czbmId==null){
			lyhp.setCzr(null);
		}else{
			lyhp.setCzr(jlr);
		}
		lyhp.setJlsj(new Date());
		lyhp.setYhpId(yhpId);
		int m=l_yhpDao.insertSelective(lyhp);
		if(m<=0){
			throw new OperException(补货易耗品失败);
		}
	}
	
	@Transactional(rollbackFor = Exception.class)
	public void allocateYHP(Integer yhpId, Integer allocateZCGLId, Integer allocateNum, String cfdd, String jlr) throws OperException {
		//向J_YHP表中更新指定记录的NUM（NUM-ALLOCATE_NUM），如果小于LEFT_LIMIT，发送预警消息
		JYHP record=jyhpDao.selectByPrimaryKey(yhpId);
		int appId=record.getAppId();
		int num=record.getNum()-allocateNum;	//现在的持有数量
		record.setNum(num);
		jyhpDao.updateByPrimaryKeySelective(record);
		//NUM如果小于LEFT_LIMIT，发送预警消息
		//....do something
		// 根据zcgl_id, lx_id, xh, ccbh、cfdd查询调拨单位是否已有相关易耗品。如果有，更新记录；
		JYHP param=new JYHP();
		param.setAppId(appId);
		param.setZcglId(allocateZCGLId);
		param.setLxId(record.getLxId());
		param.setXh(record.getXh());
		param.setCcbh(record.getCcbh());
		param.setCfdd(cfdd);
		param=jyhpDao.select(param);
		int i=0;
		if(param==null){
			//在J_YHP中插入一条新记录。LX_ID，XH，CCBH，LEFT_LIMIT，PIC_URL，IMG_VERSION延用原有记录；
			//ZCGL_ID，NUM，CFDD为用户新增值。
			record.setId(null);
			record.setZcglId(allocateZCGLId);
			record.setNum(allocateNum);
			record.setCfdd(cfdd);
			i=jyhpDao.insertSelective(record);
		}else{
			record=new JYHP();
			record.setId(param.getId());
			record.setNum(param.getNum()+allocateNum);
			i=jyhpDao.updateByPrimaryKeySelective(record);
		}
		if(i<=0){
			throw new OperException(调拨易耗品失败);
		}
		//在L_YHP中插入一条调拨记录
		LYHP lyhp=new LYHP();
		lyhp.setYhpId(record.getId());
		lyhp.setJlr(jlr);
		lyhp.setJlsj(new Date());
		lyhp.setCzbmId(null);
		lyhp.setCzr(null);
		lyhp.setNum(allocateNum);
		lyhp.setCzlx(YHPCZLX.调拨.getValue());		
		i=l_yhpDao.insertSelective(lyhp);
		if (i <= 0) {
			throw new OperException(调拨易耗品失败);
		}
	}

	public JYHP getYHP(Integer id) {
		return null;
	}
	
	public String uploadPic(HttpSession session, MultipartFile file_upload, Integer appid) throws OperException {
		
		String returnUrl = "";
		// 根据appid生成文件前缀
		String prePath = ZCGLProperties.URL_YHP_TARGET_DIR + "/" + appid;
		MultipartFile[] FileList = new MultipartFile[]{file_upload};
		String FileName = file_upload.getOriginalFilename();
		String fileType=FileName.substring(FileName.lastIndexOf('.'),FileName.length());
		returnUrl = wxMediaService.uploadMediaListToPath(session, prePath, WXMediaService.MAX_IMAGE_SIZE, fileType, FileList);
		return returnUrl;
	}
	
	/**
	 * 根据fzr查询c_zcgl表获取czbmId
	 * @param appId
	 * @param fzr
	 * @return
	 * @throws OperException 
	 */
	public Integer getCZBM_Id(Integer appId,String fzr) throws OperException{
		CZCGL c=new CZCGL();
		c=zcglService.getFZR(appId, fzr);
		return c.getId();
	}
	
	public Integer getDeptNo(Integer appId,String fzr) throws OperException{
		if(StringUtils.isEmpty(fzr)){
			return null;
		}else{
			CZCGL c=new CZCGL();
			c=zcglService.getFZR(appId, fzr);
			if(c==null){
				return null;
			}
			return c.getDeptNo();
		}
	}
}
