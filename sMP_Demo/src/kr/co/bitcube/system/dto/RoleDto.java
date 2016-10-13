package kr.co.bitcube.system.dto;

public class RoleDto {

	private String roleId;
	private String roleCd;
	private String roleNm;
	private String svcTypeCd;
	private String svcTypeNm;
	private String borgScopeCd;
	private String borgScopeNm;
	private String isUse;
	private String roleDesc;
	private String initIsRole;
	private String initBorgScopeCd;
	
	public String getBorgScopeNm() {
		return borgScopeNm;
	}
	public void setBorgScopeNm(String borgScopeNm) {
		this.borgScopeNm = borgScopeNm;
	}
	public String getInitIsRole() {
		return initIsRole;
	}
	public void setInitIsRole(String initIsRole) {
		this.initIsRole = initIsRole;
	}
	public String getInitBorgScopeCd() {
		return initBorgScopeCd;
	}
	public void setInitBorgScopeCd(String initBorgScopeCd) {
		this.initBorgScopeCd = initBorgScopeCd;
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
	public String getSvcTypeCd() {
		return svcTypeCd;
	}
	public void setSvcTypeCd(String svcTypeCd) {
		this.svcTypeCd = svcTypeCd;
	}
	public String getBorgScopeCd() {
		return borgScopeCd;
	}
	public void setBorgScopeCd(String borgScopeCd) {
		this.borgScopeCd = borgScopeCd;
	}
	public String getIsUse() {
		return isUse;
	}
	public void setIsUse(String isUse) {
		this.isUse = isUse;
	}
	public String getRoleDesc() {
		return roleDesc;
	}
	public void setRoleDesc(String roleDesc) {
		this.roleDesc = roleDesc;
	}
}
