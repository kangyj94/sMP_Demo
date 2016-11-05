package kr.co.bitcube.buyController.dto;

public class MractAppline {

	private String branchId;
	private String userId;
	private int appOrder;
	private String appBranchId;
	private String appBranchNm;
	private String appUserId;
	private String appUserNm;
	
	public String getBranchId() {
		return branchId;
	}
	public void setBranchId(String branchId) {
		this.branchId = branchId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getAppOrder() {
		return appOrder;
	}
	public void setAppOrder(int appOrder) {
		this.appOrder = appOrder;
	}
	public String getAppBranchId() {
		return appBranchId;
	}
	public void setAppBranchId(String appBranchId) {
		this.appBranchId = appBranchId;
	}
	public String getAppUserId() {
		return appUserId;
	}
	public void setAppUserId(String appUserId) {
		this.appUserId = appUserId;
	}
	public String getAppBranchNm() {
		return appBranchNm;
	}
	public void setAppBranchNm(String appBranchNm) {
		this.appBranchNm = appBranchNm;
	}
	public String getAppUserNm() {
		return appUserNm;
	}
	public void setAppUserNm(String appUserNm) {
		this.appUserNm = appUserNm;
	}
}
