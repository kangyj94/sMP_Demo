package kr.co.bitcube.organ.dto;

/**
 * @author Administrator
 *
 */
public class SmpBranchsDto {

	private String groupId;
	private String clientId;
	private String clientCd;
	private String clientNm;
	private String registerCd;
	private String branchId;
	private String branchNm;
	private String branchCd;
	private String areaType;
	private String areaTypeNm;
	private String branchGrad;
	private String businessNum;
	private String borgNm;
	private String registNum;
	private String branchBusiType;
	private String branchBusiClas;
	private String pressentNm;
	private String phoneNum;
	private String e_mail;
	private String homePage;
	private String postAddrNum;
	private String addres;
	private String addresDesc;
	private String faxNum;
	private String loginAuthType;
	private String orderAuthType;
	private String refereceDesc;
	private String payBilltype;
	private String payBillDay;
	private String accountManageNm;
	private String accountTelNum;
	private String bankCd;
	private String recipient;
	private String accountNum;
	private String businessAttachFileSeq;
	private String businessAttachFileNm;
	private String businessAttachFilePath;
	private String appraisalAttachFileSeq;
	private String appraisalAttachFileNm;
	private String appraisalAttachFilePath;
	private String isUse;
	private String createDate;
	private String closeReason;
	private String borgCd;
	private String prePay;
	private String userNm;
	private String workNm;
	private String workId;
	private String userId;
	private String isOrderLimit;
	private String isOrderLimit1;
	private String autOrderLimitPeriod;
	private String clientStatus;
	private String clientStatus1;
	private String contractSpecial;
	
	private String firstContractDate;//물품공급계약서 제일처음계약
	
	private String sharp_mail;//샵메일
	
	private String ebillEmail;
	
	private String confirmorId;
	
	private String updateDate;
	private String loan; // 여신금액
	
	
	private String basicContractDate; // 기본계약일
	private String basicContractVersion; // 기본계약 버전
	private String individualContractDate; // 개인정보제공동의일
	private String individualContractVersion; // 개인정보제공동의 버전
	private String specialContractDate; // 특별계약 등록일
	private String specialContractVersion; // 특별계약 등록버전
	
	
	private String clt_loan; // 법인 여신금액
	private String clt_isprepay; // 법인선입금여부
	private String clt_islimit; // 법인 주문제한여부
	private String checkDate;
	
	private String userLoginYn;	//휴면사업장
	
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
	public String getCheckDate() {
		return checkDate;
	}
	public void setCheckDate(String checkDate) {
		this.checkDate = checkDate;
	}
	public String getClt_loan() {
		return clt_loan;
	}
	public void setClt_loan(String clt_loan) {
		this.clt_loan = clt_loan;
	}
	public String getClt_isprepay() {
		return clt_isprepay;
	}
	public void setClt_isprepay(String clt_isprepay) {
		this.clt_isprepay = clt_isprepay;
	}
	public String getClt_islimit() {
		return clt_islimit;
	}
	public void setClt_islimit(String clt_islimit) {
		this.clt_islimit = clt_islimit;
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
	public void setIndividualContractVersion(String individualContractVersion) {
		this.individualContractVersion = individualContractVersion;
	}
	public String getSpecialContractVersion() {
		return specialContractVersion;
	}
	public void setSpecialContractVersion(String specialContractVersion) {
		this.specialContractVersion = specialContractVersion;
	}
	public String getIsOrderLimit1() {
		return isOrderLimit1;
	}
	public void setIsOrderLimit1(String isOrderLimit1) {
		this.isOrderLimit1 = isOrderLimit1;
	}
	public String getClientStatus1() {
		return clientStatus1;
	}
	public void setClientStatus1(String clientStatus1) {
		this.clientStatus1 = clientStatus1;
	}
	public String getBorgNm() {
		return borgNm;
	}
	public void setBorgNm(String borgNm) {
		this.borgNm = borgNm;
	}
	
	public String getConfirmorId() {
		return confirmorId;
	}
	public void setConfirmorId(String confirmorId) {
		this.confirmorId = confirmorId;
	}
	public String getEbillEmail() {
		return ebillEmail;
	}
	public void setEbillEmail(String ebillEmail) {
		this.ebillEmail = ebillEmail;
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
	public String getSpecialContractDate() {
		return specialContractDate;
	}
	public void setSpecialContractDate(String specialContractDate) {
		this.specialContractDate = specialContractDate;
	}
	public String getContractSpecial() {
		return contractSpecial;
	}
	public void setContractSpecial(String contractSpecial) {
		this.contractSpecial = contractSpecial;
	}
	public String getClientStatus() {
		return clientStatus;
	}
	public void setClientStatus(String clientStatus) {
		this.clientStatus = clientStatus;
	}
	public String getAutOrderLimitPeriod() {
		return autOrderLimitPeriod;
	}
	public void setAutOrderLimitPeriod(String autOrderLimitPeriod) {
		this.autOrderLimitPeriod = autOrderLimitPeriod;
	}
	public String getIsOrderLimit() {
		return isOrderLimit;
	}
	public void setIsOrderLimit(String isOrderLimit) {
		this.isOrderLimit = isOrderLimit;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getWorkId() {
		return workId;
	}
	public void setWorkId(String workId) {
		this.workId = workId;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getWorkNm() {
		return workNm;
	}
	public void setWorkNm(String workNm) {
		this.workNm = workNm;
	}
	public String getPrePay() {
		return prePay;
	}
	public void setPrePay(String prePay) {
		this.prePay = prePay;
	}
	public String getBorgCd() {
		return borgCd;
	}
	public void setBorgCd(String borgCd) {
		this.borgCd = borgCd;
	}
	public String getCloseReason() {
		return closeReason;
	}
	public void setCloseReason(String closeReason) {
		this.closeReason = closeReason;
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
	public String getAreaTypeNm() {
		return areaTypeNm;
	}
	public void setAreaTypeNm(String areaTypeNm) {
		this.areaTypeNm = areaTypeNm;
	}
	public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}
	public String getClientCd() {
		return clientCd;
	}
	public void setClientCd(String clientCd) {
		this.clientCd = clientCd;
	}
	public String getBusinessAttachFileNm() {
		return businessAttachFileNm;
	}
	public void setBusinessAttachFileNm(String businessAttachFileNm) {
		this.businessAttachFileNm = businessAttachFileNm;
	}
	public String getBusinessAttachFilePath() {
		return businessAttachFilePath;
	}
	public void setBusinessAttachFilePath(String businessAttachFilePath) {
		this.businessAttachFilePath = businessAttachFilePath;
	}
	public String getAppraisalAttachFileNm() {
		return appraisalAttachFileNm;
	}
	public void setAppraisalAttachFileNm(String appraisalAttachFileNm) {
		this.appraisalAttachFileNm = appraisalAttachFileNm;
	}
	public String getAppraisalAttachFilePath() {
		return appraisalAttachFilePath;
	}
	public void setAppraisalAttachFilePath(String appraisalAttachFilePath) {
		this.appraisalAttachFilePath = appraisalAttachFilePath;
	}
	public String getEtcFirstNm() {
		return etcFirstNm;
	}
	public void setEtcFirstNm(String etcFirstNm) {
		this.etcFirstNm = etcFirstNm;
	}
	public String getEtcFirstPath() {
		return etcFirstPath;
	}
	public void setEtcFirstPath(String etcFirstPath) {
		this.etcFirstPath = etcFirstPath;
	}
	public String getEtcSecondNm() {
		return etcSecondNm;
	}
	public void setEtcSecondNm(String etcSecondNm) {
		this.etcSecondNm = etcSecondNm;
	}
	public String getEtcSecondPath() {
		return etcSecondPath;
	}
	public void setEtcSecondPath(String etcSecondPath) {
		this.etcSecondPath = etcSecondPath;
	}
	public String getEtcThirdNm() {
		return etcThirdNm;
	}
	public void setEtcThirdNm(String etcThirdNm) {
		this.etcThirdNm = etcThirdNm;
	}
	public String getEtcThirdPath() {
		return etcThirdPath;
	}
	public void setEtcThirdPath(String etcThirdPath) {
		this.etcThirdPath = etcThirdPath;
	}
	private String etcFirstSeq;
	private String etcFirstNm;
	private String etcFirstPath;
	private String etcSecondSeq;
	private String etcSecondNm;
	private String etcSecondPath;
	private String etcThirdSeq;
	private String etcThirdNm;
	private String etcThirdPath;
	private String registerDate;
	private String confirDate;
	private String appDate;
	
	
	public String getAppDate() {
		return appDate;
	}
	public void setAppDate(String appDate) {
		this.appDate = appDate;
	}
	public String getClientId() {
		return clientId;
	}
	public void setClientId(String clientId) {
		this.clientId = clientId;
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
	public String getRegisterCd() {
		return registerCd;
	}
	public void setRegisterCd(String registerCd) {
		this.registerCd = registerCd;
	}
	public String getClientNm() {
		return clientNm;
	}
	public void setClientNm(String clientNm) {
		this.clientNm = clientNm;
	}
	public String getBranchId() {
		return branchId;
	}
	public void setBranchId(String branchId) {
		this.branchId = branchId;
	}
	public String getBranchNm() {
		return branchNm;
	}
	public void setBranchNm(String branchNm) {
		this.branchNm = branchNm;
	}
	public String getBranchCd() {
		return branchCd;
	}
	public void setBranchCd(String branchCd) {
		this.branchCd = branchCd;
	}
	public String getAreaType() {
		return areaType;
	}
	public void setAreaType(String areaType) {
		this.areaType = areaType;
	}
	public String getBranchGrad() {
		return branchGrad;
	}
	public void setBranchGrad(String branchGrad) {
		this.branchGrad = branchGrad;
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
	public String getBranchBusiType() {
		return branchBusiType;
	}
	public void setBranchBusiType(String branchBusiType) {
		this.branchBusiType = branchBusiType;
	}
	public String getBranchBusiClas() {
		return branchBusiClas;
	}
	public void setBranchBusiClas(String branchBusiClas) {
		this.branchBusiClas = branchBusiClas;
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
	public String getLoginAuthType() {
		return loginAuthType;
	}
	public void setLoginAuthType(String loginAuthType) {
		this.loginAuthType = loginAuthType;
	}
	public String getOrderAuthType() {
		return orderAuthType;
	}
	public void setOrderAuthType(String orderAuthType) {
		this.orderAuthType = orderAuthType;
	}
	public String getRefereceDesc() {
		return refereceDesc;
	}
	public void setRefereceDesc(String refereceDesc) {
		this.refereceDesc = refereceDesc;
	}
	public String getPayBilltype() {
		return payBilltype;
	}
	public void setPayBilltype(String payBilltype) {
		this.payBilltype = payBilltype;
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
	public String getEtcFirstSeq() {
		return etcFirstSeq;
	}
	public void setEtcFirstSeq(String etcFirstSeq) {
		this.etcFirstSeq = etcFirstSeq;
	}
	public String getEtcSecondSeq() {
		return etcSecondSeq;
	}
	public void setEtcSecondSeq(String etcSecondSeq) {
		this.etcSecondSeq = etcSecondSeq;
	}
	public String getEtcThirdSeq() {
		return etcThirdSeq;
	}
	public void setEtcThirdSeq(String etcThirdSeq) {
		this.etcThirdSeq = etcThirdSeq;
	}
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	public String getLoan() {
		return loan;
	}
	public void setLoan(String loan) {
		this.loan = loan;
	}
}
