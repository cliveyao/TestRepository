package org.lf.admin.db.pojo;

public class VYHP extends PagedPojo {
	private Integer yhpId;

	private Integer appId;

	private String lx;

	private String lxId;

	private String xh;

	private String ccbh;

	private Integer zcglId;

	private Integer deptNo;

	private String deptName;

	private String fzr;

	private Integer num;

	private String cfdd;
	
	private String cfddmc;

	private Integer leftLimit;

	private String picUrl;

	private Long imgVersion;

	public Integer getYhpId() {
		return yhpId;
	}

	public void setYhpId(Integer yhpId) {
		this.yhpId = yhpId;
	}

	public Integer getAppId() {
		return appId;
	}

	public void setAppId(Integer appId) {
		this.appId = appId;
	}

	public String getLx() {
		return lx;
	}

	public void setLx(String lx) {
		this.lx = lx == null ? null : lx.trim();
	}

	public String getLxId() {
		return lxId;
	}

	public void setLxId(String lxId) {
		this.lxId = lxId == null ? null : lxId.trim();
	}

	public Integer getZcglId() {
		return zcglId;
	}

	public void setZcglId(Integer zcglId) {
		this.zcglId = zcglId;
	}

	public String getXh() {
		return xh;
	}

	public void setXh(String xh) {
		this.xh = xh == null ? null : xh.trim();
	}

	public String getCcbh() {
		return ccbh;
	}

	public void setCcbh(String ccbh) {
		this.ccbh = ccbh == null ? null : ccbh.trim();
	}

	public Integer getDeptNo() {
		return deptNo;
	}

	public void setDeptNo(Integer deptNo) {
		this.deptNo = deptNo;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName == null ? null : deptName.trim();
	}

	public String getFzr() {
		return fzr;
	}

	public void setFzr(String fzr) {
		this.fzr = fzr == null ? null : fzr.trim();
	}

	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}

	public String getCfdd() {
		return cfdd;
	}

	public void setCfdd(String cfdd) {
		this.cfdd = cfdd == null ? null : cfdd.trim();
	}
	
	public String getCfddmc() {
		return cfddmc;
	}

	public void setCfddmc(String cfddmc) {
		this.cfddmc = cfddmc;
	}

	public Integer getLeftLimit() {
		return leftLimit;
	}

	public void setLeftLimit(Integer leftLimit) {
		this.leftLimit = leftLimit;
	}

	public String getPicUrl() {
		return picUrl;
	}

	public void setPicUrl(String picUrl) {
		this.picUrl = picUrl == null ? null : picUrl.trim();
	}

	public Long getImgVersion() {
		return imgVersion;
	}

	public void setImgVersion(Long imgVersion) {
		this.imgVersion = imgVersion;
	}
}