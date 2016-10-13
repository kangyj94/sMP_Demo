package kr.co.bitcube.organ.dto;

public class AdminBorgsDto {

	private String adminBorgId;
	private String userId;
	private String manageBorgId;
	private String manageBorgCd;
	private String borgTypeCd;
	private String userNm;
	private String mobile;
	private String loginId;
	
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getLoginId() {
		return loginId;
	}
	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}
	public String getAdminBorgId() {
		return adminBorgId;
	}
	public void setAdminBorgId(String adminBorgId) {
		this.adminBorgId = adminBorgId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getManageBorgId() {
		return manageBorgId;
	}
	public void setManageBorgId(String manageBorgId) {
		this.manageBorgId = manageBorgId;
	}
	public String getManageBorgCd() {
		return manageBorgCd;
	}
	public void setManageBorgCd(String manageBorgCd) {
		this.manageBorgCd = manageBorgCd;
	}
	public String getBorgTypeCd() {
		return borgTypeCd;
	}
	public void setBorgTypeCd(String borgTypeCd) {
		this.borgTypeCd = borgTypeCd;
	}
}
