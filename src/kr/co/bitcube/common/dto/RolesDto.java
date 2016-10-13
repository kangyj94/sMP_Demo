package kr.co.bitcube.common.dto;

public class RolesDto {
	
	private String roleId;
	private String roleCd;
	private String roleNm;
	private String roleDesc;
	private String borgScopeCd;
	private String svcTypeCd;
	private String isUse;
	private String initIsRole;
	private String initBorgScopeCd;
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
	public String getRoleDesc() {
		return roleDesc;
	}
	public void setRoleDesc(String roleDesc) {
		this.roleDesc = roleDesc;
	}
	public String getBorgScopeCd() {
		return borgScopeCd;
	}
	public void setBorgScopeCd(String borgScopeCd) {
		this.borgScopeCd = borgScopeCd;
	}
	public String getSvcTypeCd() {
		return svcTypeCd;
	}
	public void setSvcTypeCd(String svcTypeCd) {
		this.svcTypeCd = svcTypeCd;
	}
	public String getIsUse() {
		return isUse;
	}
	public void setIsUse(String isUse) {
		this.isUse = isUse;
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
}
