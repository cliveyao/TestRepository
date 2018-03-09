package org.lf.admin.db.pojo;

import java.util.Date;

public class Sqs_finance extends PagedPojo{
    private Integer id;

    private Integer empId;

    private Integer comId;

    private String transaction;

    private String empName;

    private Date sendTime;

    private String comName;

    private String pay;

    private Integer workDay;

    private String grossPay;

    private String empCost;

    private String comCost;

    private String payroll;

    private Integer empCostStatus;

    private Integer comCostStatus;

    private String empAccount;

    private Integer deleteStatus;

    private String vdef1;

    private String vdef2;

    private String vdef3;

    private String vdef4;

    private String vdef5;

    private Date createOn;

    private String createBy;

    private Date updateOn;

    private String updateBy;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getEmpId() {
        return empId;
    }

    public void setEmpId(Integer empId) {
        this.empId = empId;
    }

    public Integer getComId() {
        return comId;
    }

    public void setComId(Integer comId) {
        this.comId = comId;
    }

    public String getTransaction() {
        return transaction;
    }

    public void setTransaction(String transaction) {
        this.transaction = transaction == null ? null : transaction.trim();
    }

    public String getEmpName() {
        return empName;
    }

    public void setEmpName(String empName) {
        this.empName = empName == null ? null : empName.trim();
    }

    public Date getSendTime() {
        return sendTime;
    }

    public void setSendTime(Date sendTime) {
        this.sendTime = sendTime;
    }

    public String getComName() {
        return comName;
    }

    public void setComName(String comName) {
        this.comName = comName == null ? null : comName.trim();
    }

    public String getPay() {
        return pay;
    }

    public void setPay(String pay) {
        this.pay = pay == null ? null : pay.trim();
    }

    public Integer getWorkDay() {
        return workDay;
    }

    public void setWorkDay(Integer workDay) {
        this.workDay = workDay;
    }

    public String getGrossPay() {
        return grossPay;
    }

    public void setGrossPay(String grossPay) {
        this.grossPay = grossPay == null ? null : grossPay.trim();
    }

    public String getEmpCost() {
        return empCost;
    }

    public void setEmpCost(String empCost) {
        this.empCost = empCost == null ? null : empCost.trim();
    }

    public String getComCost() {
        return comCost;
    }

    public void setComCost(String comCost) {
        this.comCost = comCost == null ? null : comCost.trim();
    }

    public String getPayroll() {
        return payroll;
    }

    public void setPayroll(String payroll) {
        this.payroll = payroll == null ? null : payroll.trim();
    }

    public Integer getEmpCostStatus() {
        return empCostStatus;
    }

    public void setEmpCostStatus(Integer empCostStatus) {
        this.empCostStatus = empCostStatus;
    }

    public Integer getComCostStatus() {
        return comCostStatus;
    }

    public void setComCostStatus(Integer comCostStatus) {
        this.comCostStatus = comCostStatus;
    }

    public String getEmpAccount() {
        return empAccount;
    }

    public void setEmpAccount(String empAccount) {
        this.empAccount = empAccount == null ? null : empAccount.trim();
    }

    public Integer getDeleteStatus() {
        return deleteStatus;
    }

    public void setDeleteStatus(Integer deleteStatus) {
        this.deleteStatus = deleteStatus;
    }

    public String getVdef1() {
        return vdef1;
    }

    public void setVdef1(String vdef1) {
        this.vdef1 = vdef1 == null ? null : vdef1.trim();
    }

    public String getVdef2() {
        return vdef2;
    }

    public void setVdef2(String vdef2) {
        this.vdef2 = vdef2 == null ? null : vdef2.trim();
    }

    public String getVdef3() {
        return vdef3;
    }

    public void setVdef3(String vdef3) {
        this.vdef3 = vdef3 == null ? null : vdef3.trim();
    }

    public String getVdef4() {
        return vdef4;
    }

    public void setVdef4(String vdef4) {
        this.vdef4 = vdef4 == null ? null : vdef4.trim();
    }

    public String getVdef5() {
        return vdef5;
    }

    public void setVdef5(String vdef5) {
        this.vdef5 = vdef5 == null ? null : vdef5.trim();
    }

    public Date getCreateOn() {
        return createOn;
    }

    public void setCreateOn(Date createOn) {
        this.createOn = createOn;
    }

    public String getCreateBy() {
        return createBy;
    }

    public void setCreateBy(String createBy) {
        this.createBy = createBy == null ? null : createBy.trim();
    }

    public Date getUpdateOn() {
        return updateOn;
    }

    public void setUpdateOn(Date updateOn) {
        this.updateOn = updateOn;
    }

    public String getUpdateBy() {
        return updateBy;
    }

    public void setUpdateBy(String updateBy) {
        this.updateBy = updateBy == null ? null : updateBy.trim();
    }
}