package kr.co.bitcube.order.dto;

public class OrderBorgDto {

	private String borgId;
	private String borgCd;
	private String groupId;
	private String ClientId;
	private String branchId;
	
	public String getBorgId() {
		return borgId;
	}
	public void setBorgId(String borgId) {
		this.borgId = borgId;
	}
	public String getBorgCd() {
		return borgCd;
	}
	public void setBorgCd(String borgCd) {
		this.borgCd = borgCd;
	}
	public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}
	public String getClientId() {
		return ClientId;
	}
	public void setClientId(String clientId) {
		ClientId = clientId;
	}
	public String getBranchId() {
		return branchId;
	}
	public void setBranchId(String branchId) {
		this.branchId = branchId;
	}
}
