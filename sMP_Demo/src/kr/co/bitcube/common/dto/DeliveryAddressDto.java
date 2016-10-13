package kr.co.bitcube.common.dto;

public class DeliveryAddressDto {

	private String deliveryid;
	private String groupid;
	private String clientid;
	private String branchid;
	private String shippingplace;
	private String shippingaddres;
	private String shippingphonenum;
	private String isdefault;

	public String getDeliveryid() {
		return deliveryid;
	}

	public void setDeliveryid(String deliveryid) {
		this.deliveryid = deliveryid;
	}

	public String getGroupid() {
		return groupid;
	}

	public void setGroupid(String groupid) {
		this.groupid = groupid;
	}

	public String getClientid() {
		return clientid;
	}

	public void setClientid(String clientid) {
		this.clientid = clientid;
	}

	public String getBranchid() {
		return branchid;
	}

	public void setBranchid(String branchid) {
		this.branchid = branchid;
	}

	public String getShippingplace() {
		return shippingplace;
	}

	public void setShippingplace(String shippingplace) {
		this.shippingplace = shippingplace;
	}

	public String getShippingaddres() {
		return shippingaddres;
	}

	public void setShippingaddres(String shippingaddres) {
		this.shippingaddres = shippingaddres;
	}

	public String getShippingphonenum() {
		return shippingphonenum;
	}

	public void setShippingphonenum(String shippingphonenum) {
		this.shippingphonenum = shippingphonenum;
	}

	public String getIsdefault() {
		return isdefault;
	}

	public void setIsdefault(String isdefault) {
		this.isdefault = isdefault;
	}

}
