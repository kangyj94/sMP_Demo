package kr.co.bitcube.organ.dto;

public class SmpVendorsDto {

	private String vendorId;
	private String vendorNm;
	private String vendorCd;
	private String areaType;
	private String businessNum;
	private String registNum;
	private String vendorBusiType;
	private String vendorBusiClas;
	private String pressentNm;
	private String phoneNum;
	private String e_mail;
	private String homePage;
	private String postAddrNum;
	private String addres;
	private String addresDesc;
	private String faxNum;
	private String loginAuthType;
	private String refereceDesc;
	private String payBillType;
	private String payBillDay;
	private String accountManageNm;
	private String accountTelNum;
	private String bankCd;
	private String recipient;
	private String accountNum;
	private String businessAttachFileSeq;
	private String appraisalAttachFileSeq;
	private String etcFirstAttachSeq;
	private String etcSecondAttachSeq;
	private String etcThirdAttachSeq;
	private String etcFourthAttachSeq;
	private String createDate;
	private String isUse;
	private String areaTypeNm;
	private String registerDate;
	private String registerCd;
	private String confirDate;
	private String payBilltype;
	private String businessAttachFilePath;
	private String businessAttachFileNm;
	private String appraisalAttachFilePath;
	private String appraisalAttachFileNm;
	private String etcFirstAttachNm;
	private String etcFirstAttachPath;
	private String etcSecondAttachNm;
	private String etcSecondAttachPath;
	private String etcThirdAttachNm;
	private String etcThirdAttachPath;
	private String trustBillUserId;
	private String trustBillUserNm;
	private String trustBillUserEmail;
	private String trustBillUserTel;
	
	private String firstContractDate;
	private String basicContractDate;
	private String individualContractDate;
	
	private String firstContractVersion;
	private String basicContractVersion;
	private String individualContractVersion;
	private String qualityContractVersion;
	
	private String sharp_mail; //회사샵메일
	private String confirmorId;
	private String classify; //구분
	
	private String etcFourthAttachNm;
	private String etcFourthAttachPath;
	
	private String appDate;
	private String checkDate;
	
	private String userLoginYn;	//휴면여부
	
	
	private String contractYn;
	
	
	
	public String getContractYn() {
		return contractYn;
	}
	public void setContractYn(String contractYn) {
		this.contractYn = contractYn;
	}
	public String getUserLoginYn() {
		return userLoginYn;
	}
	public void setUserLoginYn(String userLoginYn) {
		this.userLoginYn = userLoginYn;
	}
	public void setIndividualContractVersion(String individualContractVersion) {
		this.individualContractVersion = individualContractVersion;
	}
	public String getCheckDate() {
		return checkDate;
	}
	public void setCheckDate(String checkDate) {
		this.checkDate = checkDate;
	}
	public String getQualityContractVersion() {
		return qualityContractVersion;
	}
	public void setQualityContractVersion(String qualityContractVersion) {
		this.qualityContractVersion = qualityContractVersion;
	}
	public String getFirstContractVersion() {
		return firstContractVersion;
	}
	public void setFirstContractVersion(String firstContractVersion) {
		this.firstContractVersion = firstContractVersion;
	}
	public String getBasicContractVersion() {
		return basicContractVersion;
	}
	public void setBasicContractVersion(String basicContractVersion) {
		this.basicContractVersion = basicContractVersion;
	}
	public String getIndividualContractVersion() {
		return individualContractVersion;
	}
	public String getEtcFourthAttachSeq() {
		return etcFourthAttachSeq;
	}
	public void setEtcFourthAttachSeq(String etcFourthAttachSeq) {
		this.etcFourthAttachSeq = etcFourthAttachSeq;
	}
	public String getEtcFourthAttachNm() {
		return etcFourthAttachNm;
	}
	public void setEtcFourthAttachNm(String etcFourthAttachNm) {
		this.etcFourthAttachNm = etcFourthAttachNm;
	}
	public String getEtcFourthAttachPath() {
		return etcFourthAttachPath;
	}
	public void setEtcFourthAttachPath(String etcFourthAttachPath) {
		this.etcFourthAttachPath = etcFourthAttachPath;
	}
	public String getConfirmorId() {
		return confirmorId;
	}
	public void setConfirmorId(String confirmorId) {
		this.confirmorId = confirmorId;
	}
	public String getClassify() {
		return classify;
	}
	public void setClassify(String classify) {
		this.classify = classify;
	}
	public String getSharp_mail() {
		return sharp_mail;
	}
	public void setSharp_mail(String sharp_mail) {
		this.sharp_mail = sharp_mail;
	}
	public String getFirstContractDate() {
		return firstContractDate;
	}
	public void setFirstContractDate(String firstContractDate) {
		this.firstContractDate = firstContractDate;
	}
	public String getBasicContractDate() {
		return basicContractDate;
	}
	public void setBasicContractDate(String basicContractDate) {
		this.basicContractDate = basicContractDate;
	}
	public String getIndividualContractDate() {
		return individualContractDate;
	}
	public void setIndividualContractDate(String individualContractDate) {
		this.individualContractDate = individualContractDate;
	}
	public String getTrustBillUserId() {
		return trustBillUserId;
	}
	public void setTrustBillUserId(String trustBillUserId) {
		this.trustBillUserId = trustBillUserId;
	}
	public String getTrustBillUserNm() {
		return trustBillUserNm;
	}
	public void setTrustBillUserNm(String trustBillUserNm) {
		this.trustBillUserNm = trustBillUserNm;
	}
	public String getTrustBillUserEmail() {
		return trustBillUserEmail;
	}
	public void setTrustBillUserEmail(String trustBillUserEmail) {
		this.trustBillUserEmail = trustBillUserEmail;
	}
	public String getTrustBillUserTel() {
		return trustBillUserTel;
	}
	public void setTrustBillUserTel(String trustBillUserTel) {
		this.trustBillUserTel = trustBillUserTel;
	}
	public String getAreaTypeNm() {
		return areaTypeNm;
	}
	public void setAreaTypeNm(String areaTypeNm) {
		this.areaTypeNm = areaTypeNm;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getIsUse() {
		return isUse;
	}
	public void setIsUse(String isUse) {
		this.isUse = isUse;
	}	
	public String getEtcFirstAttachNm() {
		return etcFirstAttachNm;
	}
	public void setEtcFirstAttachNm(String etcFirstAttachNm) {
		this.etcFirstAttachNm = etcFirstAttachNm;
	}
	public String getEtcFirstAttachPath() {
		return etcFirstAttachPath;
	}
	public void setEtcFirstAttachPath(String etcFirstAttachPath) {
		this.etcFirstAttachPath = etcFirstAttachPath;
	}
	public String getEtcSecondAttachNm() {
		return etcSecondAttachNm;
	}
	public void setEtcSecondAttachNm(String etcSecondAttachNm) {
		this.etcSecondAttachNm = etcSecondAttachNm;
	}
	public String getEtcSecondAttachPath() {
		return etcSecondAttachPath;
	}
	public void setEtcSecondAttachPath(String etcSecondAttachPath) {
		this.etcSecondAttachPath = etcSecondAttachPath;
	}
	public String getEtcThirdAttachNm() {
		return etcThirdAttachNm;
	}
	public void setEtcThirdAttachNm(String etcThirdAttachNm) {
		this.etcThirdAttachNm = etcThirdAttachNm;
	}
	public String getEtcThirdAttachPath() {
		return etcThirdAttachPath;
	}
	public void setEtcThirdAttachPath(String etcThirdAttachPath) {
		this.etcThirdAttachPath = etcThirdAttachPath;
	}
	public String getBusinessAttachFilePath() {
		return businessAttachFilePath;
	}
	public void setBusinessAttachFilePath(String businessAttachFilePath) {
		this.businessAttachFilePath = businessAttachFilePath;
	}
	public String getBusinessAttachFileNm() {
		return businessAttachFileNm;
	}
	public void setBusinessAttachFileNm(String businessAttachFileNm) {
		this.businessAttachFileNm = businessAttachFileNm;
	}
	public String getAppraisalAttachFilePath() {
		return appraisalAttachFilePath;
	}
	public void setAppraisalAttachFilePath(String appraisalAttachFilePath) {
		this.appraisalAttachFilePath = appraisalAttachFilePath;
	}
	public String getAppraisalAttachFileNm() {
		return appraisalAttachFileNm;
	}
	public void setAppraisalAttachFileNm(String appraisalAttachFileNm) {
		this.appraisalAttachFileNm = appraisalAttachFileNm;
	}
	public String getPayBilltype() {
		return payBilltype;
	}
	public void setPayBilltype(String payBilltype) {
		this.payBilltype = payBilltype;
	}
	public String getRegisterCd() {
		return registerCd;
	}
	public void setRegisterCd(String registerCd) {
		this.registerCd = registerCd;
	}
	public String getRegisterDate() {
		return registerDate;
	}
	public void setRegisterDate(String registerDate) {
		this.registerDate = registerDate;
	}
	public String getConfirDate() {
		return confirDate;
	}
	public void setConfirDate(String confirDate) {
		this.confirDate = confirDate;
	}
	public String getLoginAuthType() {
		return loginAuthType;
	}
	public void setLoginAuthType(String loginAuthType) {
		this.loginAuthType = loginAuthType;
	}
	public String getVendorId() {
		return vendorId;
	}
	public void setVendorId(String vendorId) {
		this.vendorId = vendorId;
	}
	public String getVendorNm() {
		return vendorNm;
	}
	public void setVendorNm(String vendorNm) {
		this.vendorNm = vendorNm;
	}
	public String getVendorCd() {
		return vendorCd;
	}
	public void setVendorCd(String vendorCd) {
		this.vendorCd = vendorCd;
	}
	public String getAreaType() {
		return areaType;
	}
	public void setAreaType(String areaType) {
		this.areaType = areaType;
	}
	public String getBusinessNum() {
		return businessNum;
	}
	public void setBusinessNum(String businessNum) {
		this.businessNum = businessNum;
	}
	public String getRegistNum() {
		return registNum;
	}
	public void setRegistNum(String registNum) {
		this.registNum = registNum;
	}
	public String getVendorBusiType() {
		return vendorBusiType;
	}
	public void setVendorBusiType(String vendorBusiType) {
		this.vendorBusiType = vendorBusiType;
	}
	public String getVendorBusiClas() {
		return vendorBusiClas;
	}
	public void setVendorBusiClas(String vendorBusiClas) {
		this.vendorBusiClas = vendorBusiClas;
	}
	public String getPressentNm() {
		return pressentNm;
	}
	public void setPressentNm(String pressentNm) {
		this.pressentNm = pressentNm;
	}
	public String getPhoneNum() {
		return phoneNum;
	}
	public void setPhoneNum(String phoneNum) {
		this.phoneNum = phoneNum;
	}
	public String getE_mail() {
		return e_mail;
	}
	public void setE_mail(String e_mail) {
		this.e_mail = e_mail;
	}
	public String getHomePage() {
		return homePage;
	}
	public void setHomePage(String homePage) {
		this.homePage = homePage;
	}
	public String getPostAddrNum() {
		return postAddrNum;
	}
	public void setPostAddrNum(String postAddrNum) {
		this.postAddrNum = postAddrNum;
	}
	public String getAddres() {
		return addres;
	}
	public void setAddres(String addres) {
		this.addres = addres;
	}
	public String getAddresDesc() {
		return addresDesc;
	}
	public void setAddresDesc(String addresDesc) {
		this.addresDesc = addresDesc;
	}
	public String getFaxNum() {
		return faxNum;
	}
	public void setFaxNum(String faxNum) {
		this.faxNum = faxNum;
	}
	public String getRefereceDesc() {
		return refereceDesc;
	}
	public void setRefereceDesc(String refereceDesc) {
		this.refereceDesc = refereceDesc;
	}
	public String getPayBillType() {
		return payBillType;
	}
	public void setPayBillType(String payBillType) {
		this.payBillType = payBillType;
	}
	public String getPayBillDay() {
		return payBillDay;
	}
	public void setPayBillDay(String payBillDay) {
		this.payBillDay = payBillDay;
	}
	public String getAccountManageNm() {
		return accountManageNm;
	}
	public void setAccountManageNm(String accountManageNm) {
		this.accountManageNm = accountManageNm;
	}
	public String getAccountTelNum() {
		return accountTelNum;
	}
	public void setAccountTelNum(String accountTelNum) {
		this.accountTelNum = accountTelNum;
	}
	public String getBankCd() {
		return bankCd;
	}
	public void setBankCd(String bankCd) {
		this.bankCd = bankCd;
	}
	public String getRecipient() {
		return recipient;
	}
	public void setRecipient(String recipient) {
		this.recipient = recipient;
	}
	public String getAccountNum() {
		return accountNum;
	}
	public void setAccountNum(String accountNum) {
		this.accountNum = accountNum;
	}
	public String getBusinessAttachFileSeq() {
		return businessAttachFileSeq;
	}
	public void setBusinessAttachFileSeq(String businessAttachFileSeq) {
		this.businessAttachFileSeq = businessAttachFileSeq;
	}
	public String getAppraisalAttachFileSeq() {
		return appraisalAttachFileSeq;
	}
	public void setAppraisalAttachFileSeq(String appraisalAttachFileSeq) {
		this.appraisalAttachFileSeq = appraisalAttachFileSeq;
	}
	public String getEtcFirstAttachSeq() {
		return etcFirstAttachSeq;
	}
	public void setEtcFirstAttachSeq(String etcFirstAttachSeq) {
		this.etcFirstAttachSeq = etcFirstAttachSeq;
	}
	public String getEtcSecondAttachSeq() {
		return etcSecondAttachSeq;
	}
	public void setEtcSecondAttachSeq(String etcSecondAttachSeq) {
		this.etcSecondAttachSeq = etcSecondAttachSeq;
	}
	public String getEtcThirdAttachSeq() {
		return etcThirdAttachSeq;
	}
	public void setEtcThirdAttachSeq(String etcThirdAttachSeq) {
		this.etcThirdAttachSeq = etcThirdAttachSeq;
	}
	public String getAppDate() {
		return appDate;
	}
	public void setAppDate(String appDate) {
		this.appDate = appDate;
	}
}
