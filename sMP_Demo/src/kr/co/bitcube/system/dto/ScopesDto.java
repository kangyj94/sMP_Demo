package kr.co.bitcube.system.dto;

public class ScopesDto {

	private String scopeId;
	private String scopeCd;
	private String scopeNm;
	private String scopeDesc;
	private String isUse;
	private String roleNms;
	private String svcTypeCd;
	private String isCheck;
	
	public String getIsCheck() {
		return isCheck;
	}
	public void setIsCheck(String isCheck) {
		this.isCheck = isCheck;
	}
	public String getSvcTypeCd() {
		return svcTypeCd;
	}
	public void setSvcTypeCd(String svcTypeCd) {
		this.svcTypeCd = svcTypeCd;
	}
	public String getRoleNms() {
		return roleNms;
	}
	public void setRoleNms(String roleNms) {
		this.roleNms = roleNms;
	}
	public String getScopeId() {
		return scopeId;
	}
	public void setScopeId(String scopeId) {
		this.scopeId = scopeId;
	}
	public String getScopeCd() {
		return scopeCd;
	}
	public void setScopeCd(String scopeCd) {
		this.scopeCd = scopeCd;
	}
	public String getScopeNm() {
		return scopeNm;
	}
	public void setScopeNm(String scopeNm) {
		this.scopeNm = scopeNm;
	}
	public String getScopeDesc() {
		return scopeDesc;
	}
	public void setScopeDesc(String scopeDesc) {
		this.scopeDesc = scopeDesc;
	}
	public String getIsUse() {
		return isUse;
	}
	public void setIsUse(String isUse) {
		this.isUse = isUse;
	}
}
