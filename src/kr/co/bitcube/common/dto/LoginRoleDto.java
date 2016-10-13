package kr.co.bitcube.common.dto;

public class LoginRoleDto {
	
	private String roleId;
	private String isDefault;
	private String borgScopeCd;
	private String roleCd;
	private String roleNm;
	private String userId;
	private String borgId;
	private String svcTypeCd;
	
	public String getSvcTypeCd() {
		return svcTypeCd;
	}
	public void setSvcTypeCd(String svcTypeCd) {
		this.svcTypeCd = svcTypeCd;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getBorgId() {
		return borgId;
	}
	public void setBorgId(String borgId) {
		this.borgId = borgId;
	}
	public String getRoleId() {
		return roleId;
	}
	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
	public String getIsDefault() {
		return isDefault;
	}
	public void setIsDefault(String isDefault) {
		this.isDefault = isDefault;
	}
	public String getBorgScopeCd() {
		return borgScopeCd;
	}
	public void setBorgScopeCd(String borgScopeCd) {
		this.borgScopeCd = borgScopeCd;
	}
	public String getRoleCd() {
		return roleCd;
	}
	public void setRoleCd(String roleCd) {
		this.roleCd = roleCd;
	}
	public String getRoleNm() {
		return roleNm;
	}
	public void setRoleNm(String roleNm) {
		this.roleNm = roleNm;
	}
}
