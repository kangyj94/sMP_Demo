package kr.co.bitcube.system.dto;

public class RoleMemberDto {

	private String roleId;
	private String borgId;
	private String userId;
	private String svcTypeCd;
	private String svcTypeNm;
	private String roleNm;
	private String borgScopeCd;
	private String userNm;
	private String loginId;
	private String borgNms;
	private String isDefault;
	
	public String getIsDefault() {
		return isDefault;
	}
	public void setIsDefault(String isDefault) {
		this.isDefault = isDefault;
	}
	public String getSvcTypeNm() {
		return svcTypeNm;
	}
	public void setSvcTypeNm(String svcTypeNm) {
		this.svcTypeNm = svcTypeNm;
	}
	public String getRoleId() {
		return roleId;
	}
	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
	public String getBorgId() {
		return borgId;
	}
	public void setBorgId(String borgId) {
		this.borgId = borgId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getSvcTypeCd() {
		return svcTypeCd;
	}
	public void setSvcTypeCd(String svcTypeCd) {
		this.svcTypeCd = svcTypeCd;
	}
	public String getRoleNm() {
		return roleNm;
	}
	public void setRoleNm(String roleNm) {
		this.roleNm = roleNm;
	}
	public String getBorgScopeCd() {
		return borgScopeCd;
	}
	public void setBorgScopeCd(String borgScopeCd) {
		this.borgScopeCd = borgScopeCd;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getLoginId() {
		return loginId;
	}
	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}
	public String getBorgNms() {
		return borgNms;
	}
	public void setBorgNms(String borgNms) {
		this.borgNms = borgNms;
	}
}
