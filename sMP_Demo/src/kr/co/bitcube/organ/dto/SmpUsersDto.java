package kr.co.bitcube.organ.dto;

public class SmpUsersDto {

	private String borgId;
	private String userId;
	private String loginId;
	private String pwd;
	private String userNm;
	private String tel;
	private String mobile;
	private String fax;
	private String zipCode;
	private String eMail;
	private String branchNm;
	private String areaType;
	private String areaTypeNm;
	private String isUse;
	private String isLogin;
	private String createDate;
	private String vendorNm;
	private String vendorId;
	private String isEmail;
	private String isSms;
	private String endCauseDesc;
	private String userNote;
	private String svcTypeCd;
	private String svcTypeNm;
	private String isUseCd;
	private String borg_IsUse;
	private String borg_IsUseCd;
	private String isDefault;
	private String workId;
	private String workNm;

	//이메일, SMS 전송여부 추가
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
	
	//감독관 관련내용 추가
	private String directorId;
	private String isDirect;
	
	//물품공급 계약서 서명 내역
	private String borgNm;
	private String businessNum;
	private String contractVersion;
	private String contractUserNm;
	private String contractDate;
	private String contractFlag;
	
	//휴면계정
	private String userLoginYn;
	private String isOrderApproval;
	private String isBranchOrderApproval;
	
	
	public String getUserLoginYn() {
		return userLoginYn;
	}
	public void setUserLoginYn(String userLoginYn) {
		this.userLoginYn = userLoginYn;
	}
	public void setContractVersion(String contractVersion) {
		this.contractVersion = contractVersion;
	}
	public String getContractFlag() {
		return contractFlag;
	}
	public void setContractFlag(String contractFlag) {
		this.contractFlag = contractFlag;
	}
	public String getWorkId() {
		return workId;
	}
	public void setWorkId(String workId) {
		this.workId = workId;
	}
	public String getBorgNm() {
		return borgNm;
	}
	public void setBorgNm(String borgNm) {
		this.borgNm = borgNm;
	}
	public String getBusinessNum() {
		return businessNum;
	}
	public void setBusinessNum(String businessNum) {
		this.businessNum = businessNum;
	}
	public String getContractVersion() {
		return contractVersion;
	}
	public void setContarctVersion(String contractVersion) {
		this.contractVersion = contractVersion;
	}
	public String getContractUserNm() {
		return contractUserNm;
	}
	public void setContractUserNm(String contractUserNm) {
		this.contractUserNm = contractUserNm;
	}
	public String getContractDate() {
		return contractDate;
	}
	public void setContractDate(String contractDate) {
		this.contractDate = contractDate;
	}
	public String getWorkNm() {
		return workNm;
	}
	public void setWorkNm(String workNm) {
		this.workNm = workNm;
	}
	public String getIsDefault() {
		return isDefault;
	}
	public void setIsDefault(String isDefault) {
		this.isDefault = isDefault;
	}
	public String getBorg_IsUse() {
		return borg_IsUse;
	}
	public void setBorg_IsUse(String borg_IsUse) {
		this.borg_IsUse = borg_IsUse;
	}
	public String getBorg_IsUseCd() {
		return borg_IsUseCd;
	}
	public void setBorg_IsUseCd(String borg_IsUseCd) {
		this.borg_IsUseCd = borg_IsUseCd;
	}
	public String getIsUseCd() {
		return isUseCd;
	}
	public void setIsUseCd(String isUseCd) {
		this.isUseCd = isUseCd;
	}
	public String getIsDirect() {
		return isDirect;
	}
	public void setIsDirect(String isDirect) {
		this.isDirect = isDirect;
	}
	public String getDirectorId() {
		return directorId;
	}
	public void setDirectorId(String directorId) {
		this.directorId = directorId;
	}
	public String getSvcTypeCd() {
		return svcTypeCd;
	}
	public void setSvcTypeCd(String svcTypeCd) {
		this.svcTypeCd = svcTypeCd;
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
	public String getUserNote() {
		return userNote;
	}
	public void setUserNote(String userNote) {
		this.userNote = userNote;
	}
	public String getEndCauseDesc() {
		return endCauseDesc;
	}
	public void setEndCauseDesc(String endCauseDesc) {
		this.endCauseDesc = endCauseDesc;
	}
	public String getBorgId() {
		return borgId;
	}
	public void setBorgId(String borgId) {
		this.borgId = borgId;
	}
	public String getIsEmail() {
		return isEmail;
	}
	public void setIsEmail(String isEmail) {
		this.isEmail = isEmail;
	}
	public String getIsSms() {
		return isSms;
	}
	public void setIsSms(String isSms) {
		this.isSms = isSms;
	}
	public String getVendorNm() {
		return vendorNm;
	}
	public void setVendorNm(String vendorNm) {
		this.vendorNm = vendorNm;
	}
	public String getVendorId() {
		return vendorId;
	}
	public void setVendorId(String vendorId) {
		this.vendorId = vendorId;
	}
	public String getBranchNm() {
		return branchNm;
	}
	public void setBranchNm(String branchNm) {
		this.branchNm = branchNm;
	}
	public String getAreaType() {
		return areaType;
	}
	public void setAreaType(String areaType) {
		this.areaType = areaType;
	}
	public String getAreaTypeNm() {
		return areaTypeNm;
	}
	public void setAreaTypeNm(String areaTypeNm) {
		this.areaTypeNm = areaTypeNm;
	}
	public String getIsUse() {
		return isUse;
	}
	public void setIsUse(String isUse) {
		this.isUse = isUse;
	}
	public String getIsLogin() {
		return isLogin;
	}
	public void setIsLogin(String isLogin) {
		this.isLogin = isLogin;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getLoginId() {
		return loginId;
	}
	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getFax() {
		return fax;
	}
	public void setFax(String fax) {
		this.fax = fax;
	}
	public String getZipCode() {
		return zipCode;
	}
	public void setZipCode(String zipCode) {
		this.zipCode = zipCode;
	}
	public String geteMail() {
		return eMail;
	}
	public void seteMail(String eMail) {
		this.eMail = eMail;
	}
	public String getSvcTypeNm() {
		return svcTypeNm;
	}
	public void setSvcTypeNm(String svcTypeNm) {
		this.svcTypeNm = svcTypeNm;
	}
	public String getIsOrderApproval() {
		return isOrderApproval;
	}
	public void setIsOrderApproval(String isOrderApproval) {
		this.isOrderApproval = isOrderApproval;
	}
	public String getIsBranchOrderApproval() {
		return isBranchOrderApproval;
	}
	public void setIsBranchOrderApproval(String isBranchOrderApproval) {
		this.isBranchOrderApproval = isBranchOrderApproval;
	}
}
