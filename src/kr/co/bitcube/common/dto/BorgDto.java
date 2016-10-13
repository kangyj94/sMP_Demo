package kr.co.bitcube.common.dto;

public class BorgDto {

	private String treeKey;
	private String borgId;
	private String borgCd;
	private String borgNm;
	private String borgTypeCd;
	private String borgTypeNm;
	private String isUse;
	private int borgLevel;
	private String isLeaf;
	private String parent;
	private int level;
	private String expanded;
	private String svcTypeCd;
	private String adminBorgId;
	private String manageBorgId;
	private String adminUserId;
	
	private String groupId;
	private String clientId;
	private String branchId;
	private String borgNms;
	private String areaNm;
	private String areaType;

	
	private String loan;
	private String isPrepay;
	private String isLimit;
	
	
	
	public String getLoan() {
		return loan;
	}
	public void setLoan(String loan) {
		this.loan = loan;
	}
	public String getIsPrepay() {
		return isPrepay;
	}
	public void setIsPrepay(String isPrepay) {
		this.isPrepay = isPrepay;
	}
	public String getIsLimit() {
		return isLimit;
	}
	public void setIsLimit(String isLimit) {
		this.isLimit = isLimit;
	}
	public String getAdminUserId() {
		return adminUserId;
	}
	public void setAdminUserId(String adminUserId) {
		this.adminUserId = adminUserId;
	}
	public String getAreaNm() {
		return areaNm;
	}
	public void setAreaNm(String areaNm) {
		this.areaNm = areaNm;
	}
	public String getAreaType() {
		return areaType;
	}
	public void setAreaType(String areaType) {
		this.areaType = areaType;
	}
	public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}
	public String getClientId() {
		return clientId;
	}
	public void setClientId(String clientId) {
		this.clientId = clientId;
	}
	public String getBranchId() {
		return branchId;
	}
	public void setBranchId(String branchId) {
		this.branchId = branchId;
	}
	public String getBorgNms() {
		return borgNms;
	}
	public void setBorgNms(String borgNms) {
		this.borgNms = borgNms;
	}
	public String getManageBorgId() {
		return manageBorgId;
	}
	public void setManageBorgId(String manageBorgId) {
		this.manageBorgId = manageBorgId;
	}
	public String getAdminBorgId() {
		return adminBorgId;
	}
	public void setAdminBorgId(String adminBorgId) {
		this.adminBorgId = adminBorgId;
	}
	public String getSvcTypeCd() {
		return svcTypeCd;
	}
	public void setSvcTypeCd(String svcTypeCd) {
		this.svcTypeCd = svcTypeCd;
	}
	public String getExpanded() {
		return expanded;
	}
	public void setExpanded(String expanded) {
		this.expanded = expanded;
	}
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	public String getParent() {
		return parent;
	}
	public void setParent(String parent) {
		this.parent = parent;
	}
	public String getIsLeaf() {
		return isLeaf;
	}
	public void setIsLeaf(String isLeaf) {
		this.isLeaf = isLeaf;
	}
	public String getTreeKey() {
		return treeKey;
	}
	public void setTreeKey(String treeKey) {
		this.treeKey = treeKey;
	}
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
	public String getBorgNm() {
		return borgNm;
	}
	public void setBorgNm(String borgNm) {
		this.borgNm = borgNm;
	}
	public String getBorgTypeCd() {
		return borgTypeCd;
	}
	public void setBorgTypeCd(String borgTypeCd) {
		this.borgTypeCd = borgTypeCd;
	}
	public String getBorgTypeNm() {
		return borgTypeNm;
	}
	public void setBorgTypeNm(String borgTypeNm) {
		this.borgTypeNm = borgTypeNm;
	}
	public String getIsUse() {
		return isUse;
	}
	public void setIsUse(String isUse) {
		this.isUse = isUse;
	}
	public int getBorgLevel() {
		return borgLevel;
	}
	public void setBorgLevel(int borgLevel) {
		this.borgLevel = borgLevel;
	}
}
