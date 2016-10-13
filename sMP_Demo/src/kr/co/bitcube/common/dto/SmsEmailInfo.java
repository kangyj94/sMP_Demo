package kr.co.bitcube.common.dto;

public class SmsEmailInfo {
	private String manageClientId;	//관리법인Id
	private String mobileNum;	//받는핸드폰번호
	private String emailAddr;	//받는이메일주소
	private String userId;	//받는사용자Id
	private boolean isEmail;	//이메일발송여부
	private boolean isSms;	//Sms발송여부

	private String emailByPurchase;
	private String emailByDelivery;
	private String emailByRegisterGood;
	private String smsByPurchase;
	private String smsByDelivery;
	private String smsByRegisterGood;
	private String emailByPurchaseOrder;
	private String emailByOrdrtReceive;
	private String emailByNotiAuction;
	private String emailByNotiSuccessBid;
	private String smsByPurchaseOrder;
	private String smsByOrdrtReceive;
	private String smsByNotiAuction;
	private String smsByNotiSuccessBid;
	
	public String getManageClientId() {
		return manageClientId;
	}
	public void setManageClientId(String manageClientId) {
		this.manageClientId = manageClientId;
	}
	public String getMobileNum() {
		return mobileNum;
	}
	public void setMobileNum(String mobileNum) {
		this.mobileNum = mobileNum;
	}
	public String getEmailAddr() {
		return emailAddr;
	}
	public void setEmailAddr(String emailAddr) {
		this.emailAddr = emailAddr;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public boolean isEmail() {
		return isEmail;
	}
	public void setEmail(String isEmail) {
		if("1".equals(isEmail)) this.isEmail = true;
		else this.isEmail = false;
	}
	public boolean isSms() {
		return isSms;
	}
	public void setSms(boolean isSms) {
		if("1".equals(isSms)) this.isSms = true;
		else this.isSms = false;
	}
	public String getEmailByPurchase() {
		return emailByPurchase;
	}
	public void setEmailByPurchase(String emailByPurchase) {
		this.emailByPurchase = emailByPurchase;
	}
	public String getEmailByDelivery() {
		return emailByDelivery;
	}
	public void setEmailByDelivery(String emailByDelivery) {
		this.emailByDelivery = emailByDelivery;
	}
	public String getEmailByRegisterGood() {
		return emailByRegisterGood;
	}
	public void setEmailByRegisterGood(String emailByRegisterGood) {
		this.emailByRegisterGood = emailByRegisterGood;
	}
	public String getSmsByPurchase() {
		return smsByPurchase;
	}
	public void setSmsByPurchase(String smsByPurchase) {
		this.smsByPurchase = smsByPurchase;
	}
	public String getSmsByDelivery() {
		return smsByDelivery;
	}
	public void setSmsByDelivery(String smsByDelivery) {
		this.smsByDelivery = smsByDelivery;
	}
	public String getSmsByRegisterGood() {
		return smsByRegisterGood;
	}
	public void setSmsByRegisterGood(String smsByRegisterGood) {
		this.smsByRegisterGood = smsByRegisterGood;
	}
	public String getEmailByPurchaseOrder() {
		return emailByPurchaseOrder;
	}
	public void setEmailByPurchaseOrder(String emailByPurchaseOrder) {
		this.emailByPurchaseOrder = emailByPurchaseOrder;
	}
	public String getEmailByOrdrtReceive() {
		return emailByOrdrtReceive;
	}
	public void setEmailByOrdrtReceive(String emailByOrdrtReceive) {
		this.emailByOrdrtReceive = emailByOrdrtReceive;
	}
	public String getEmailByNotiAuction() {
		return emailByNotiAuction;
	}
	public void setEmailByNotiAuction(String emailByNotiAuction) {
		this.emailByNotiAuction = emailByNotiAuction;
	}
	public String getEmailByNotiSuccessBid() {
		return emailByNotiSuccessBid;
	}
	public void setEmailByNotiSuccessBid(String emailByNotiSuccessBid) {
		this.emailByNotiSuccessBid = emailByNotiSuccessBid;
	}
	public String getSmsByPurchaseOrder() {
		return smsByPurchaseOrder;
	}
	public void setSmsByPurchaseOrder(String smsByPurchaseOrder) {
		this.smsByPurchaseOrder = smsByPurchaseOrder;
	}
	public String getSmsByOrdrtReceive() {
		return smsByOrdrtReceive;
	}
	public void setSmsByOrdrtReceive(String smsByOrdrtReceive) {
		this.smsByOrdrtReceive = smsByOrdrtReceive;
	}
	public String getSmsByNotiAuction() {
		return smsByNotiAuction;
	}
	public void setSmsByNotiAuction(String smsByNotiAuction) {
		this.smsByNotiAuction = smsByNotiAuction;
	}
	public String getSmsByNotiSuccessBid() {
		return smsByNotiSuccessBid;
	}
	public void setSmsByNotiSuccessBid(String smsByNotiSuccessBid) {
		this.smsByNotiSuccessBid = smsByNotiSuccessBid;
	}
	
}
