package kr.co.bitcube.common.dto;

import java.util.List;

public class SrcBorgScopeByRoleDto {

	private String roleId;
	private String borgScopeCd;
	private String srcGroupId;
	private String srcClientId;
	private String srcBranchId;
	private String srcBorgNms;
	private List srcUserList;
	
	public String getSrcClientId() {
		return srcClientId;
	}
	public void setSrcClientId(String srcClientId) {
		this.srcClientId = srcClientId;
	}
	public String getRoleId() {
		return roleId;
	}
	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
	public String getBorgScopeCd() {
		return borgScopeCd;
	}
	public void setBorgScopeCd(String borgScopeCd) {
		this.borgScopeCd = borgScopeCd;
	}
	public String getSrcGroupId() {
		return srcGroupId;
	}
	public void setSrcGroupId(String srcGroupId) {
		this.srcGroupId = srcGroupId;
	}
	public String getSrcBranchId() {
		return srcBranchId;
	}
	public void setSrcBranchId(String srcBranchId) {
		this.srcBranchId = srcBranchId;
	}
	public String getSrcBorgNms() {
		return srcBorgNms;
	}
	public void setSrcBorgNms(String srcBorgNms) {
		this.srcBorgNms = srcBorgNms;
	}
	public List getSrcUserList() {
		return srcUserList;
	}
	public void setSrcUserList(List srcUserList) {
		this.srcUserList = srcUserList;
	}
}
