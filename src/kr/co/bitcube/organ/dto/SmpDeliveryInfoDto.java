package kr.co.bitcube.organ.dto;

public class SmpDeliveryInfoDto {

	private String deliveryId;
	private String groupId;
	private String clientId;
	private String branchId;
	private String shippingPlace;
	private String shippingAddres;
	private String shippingPhoneNum;
	private String isDefault;
	
	
	public String getDeliveryId() {
		return deliveryId;
	}
	public void setDeliveryId(String deliveryId) {
		this.deliveryId = deliveryId;
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
	public String getShippingPlace() {
		return shippingPlace;
	}
	public void setShippingPlace(String shippingPlace) {
		this.shippingPlace = shippingPlace;
	}
	public String getShippingAddres() {
		return shippingAddres;
	}
	public void setShippingAddres(String shippingAddres) {
		this.shippingAddres = shippingAddres;
	}
	public String getShippingPhoneNum() {
		return shippingPhoneNum;
	}
	public void setShippingPhoneNum(String shippingPhoneNum) {
		this.shippingPhoneNum = shippingPhoneNum;
	}
	public String getIsDefault() {
		return isDefault;
	}
	public void setIsDefault(String isDefault) {
		this.isDefault = isDefault;
	}
}
