package kr.co.bitcube.common.dto;

public class WorkInfoDto {

	private String workId;
	private String userId;
	private String workNm;
	private String userNm;
	private String branchNm;
	private String businessNum;
	private String branchCd;
	private String branchId;
	private String accManageUserId;
	private String isSktsManage;
	private String areaType;
	private String mat_kind;
	private String contract_cd;
	
	public String getAreaType() {
		return areaType;
	}
	public void setAreaType(String areaType) {
		this.areaType = areaType;
	}
	public String getIsSktsManage() {
		return isSktsManage;
	}
	public void setIsSktsManage(String isSktsManage) {
		this.isSktsManage = isSktsManage;
	}
	public String getAccManageUserId() {
		return accManageUserId;
	}
	public void setAccManageUserId(String accManageUserId) {
		this.accManageUserId = accManageUserId;
	}
	public String getBranchNm() {
		return branchNm;
	}
	public void setBranchNm(String branchNm) {
		this.branchNm = branchNm;
	}
	public String getBusinessNum() {
		return businessNum;
	}
	public void setBusinessNum(String businessNum) {
		this.businessNum = businessNum;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	public String getBranchId() {
		return branchId;
	}
	public void setBranchId(String branchId) {
		this.branchId = branchId;
	}
	public String getWorkId() {
		return workId;
	}
	public void setWorkId(String workId) {
		this.workId = workId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getWorkNm() {
		return workNm;
	}
	public void setWorkNm(String workNm) {
		this.workNm = workNm;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getMat_kind() {
		return mat_kind;
	}
	public void setMat_kind(String mat_kind) {
		this.mat_kind = mat_kind;
	}
	public String getContract_cd() {
		return contract_cd;
	}
	public void setContract_cd(String contract_cd) {
		this.contract_cd = contract_cd;
	}
}
