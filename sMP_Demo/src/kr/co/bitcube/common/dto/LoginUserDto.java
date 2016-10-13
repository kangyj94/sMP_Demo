package kr.co.bitcube.common.dto;

import java.util.List;

import kr.co.bitcube.organ.dto.SmpBranchsDto;
import kr.co.bitcube.organ.dto.SmpVendorsDto;
import kr.co.bitcube.system.dto.NonUsersDto;

public class LoginUserDto {

	private String userId;
	private String loginId;
	private String empNo;
	private String userNm;
	private String gradeNm;
	private String tel;
	private String mobile;
	private String email;
	private String borgId;
	private String borgCd;
	private String borgNm;
	private String topBorgId;
	private String parBorgId;
	private String borgLevel;
	private String borgTypeCd;
	private String svcTypeCd;
	private String svcTypeNm;
	private String borgNms;
	private String groupId;
	private String clientId;
	private String branchId;
	private String deptId;
	private String remoteIp;
	private String menuType;	//기본형, 트리형(tree)
	private String areaType;	//권역
	private String isKey;		//대표사업장여부
	private String clientCd;	//법인코드
	private String isLimit;		//법인주문제한여부
	private boolean isDirectMan;	//감독관여부
	private boolean isEvaluate;	//평가여부
	private int isUseClient;	//법인사용여부(1:사용[고객사를 제외한 조직은 모두 사용] 0:미사용)
	private String lastLoginDate;	//최종로그인일시
	
	private List<LoginRoleDto> loginRoleList;	//권한리스트
	private List<LoginMenuDto> bigMenuList;	//대메뉴리스트(하위메뉴리스트도 담겨 있음)
	private List<LoginMenuDto> middleMenuList;	//중메뉴리스트
	private List<LoginMenuDto> smallMenuList;	//소메뉴리스트
	private List<LoginMenuDto> staticMenuList;	//정적메뉴리스트
	private List<BorgDto> belongBorgList;	//소속기관리스트
	private SmpBranchsDto smpBranchsDto;	//로그인사용자 사업장정보
	private SmpVendorsDto smpVendorsDto;	//로그인사용자 공급사정보
	private SrcBorgScopeByRoleDto srcBorgScopeByRoleDto;	//로그인사용자 기본권한 조직허용범위에 따른 조직및 사용자 정보(고객사와 공급사만)
	
	private String contractSpecial;//물품공급계약서 특별 구분(고객사만 허용)
	private String workId;	//고객사 공사유형Id
	
	private boolean isSKTMng = false;  //SKT 매니저여부   (true 시 skMngFlag=1)
	private boolean isSKBMng = false;  //SKB 매니저여부   (true 시 skMngFlag=2)
	private String skMngFlag = "";    // 1: SKT   , 2: SKB  ( 3 : 일반 )   
	
	/*-----------------비회원관련속성 추가 시작---------------*/
	private boolean isGuest = false;
	private String nonUserId;
	private NonUsersDto nonUsersDto;
	public boolean isGuest() {
		return isGuest;
	}
	public void setGuest(boolean isGuest) {
		this.isGuest = isGuest;
	}
	public String getNonUserId() {
		return nonUserId;
	}
	public void setNonUserId(String nonUserId) {
		this.nonUserId = nonUserId;
	}
	public NonUsersDto getNonUsersDto() {
		return nonUsersDto;
	}
	public void setNonUsersDto(NonUsersDto nonUsersDto) {
		this.nonUsersDto = nonUsersDto;
	}
	/*-----------------비회원관련속성 추가 끝---------------*/
	
	public String getContractSpecial() {
		return contractSpecial;
	}
	public void setContractSpecial(String contractSpecial) {
		this.contractSpecial = contractSpecial;
	}
	public int getIsUseClient() {
		return isUseClient;
	}
	public void setIsUseClient(int isUseClient) {
		this.isUseClient = isUseClient;
	}
	public boolean isEvaluate() {
		return isEvaluate;
	}
	public void setEvaluate(boolean isEvaluate) {
		this.isEvaluate = isEvaluate;
	}
	public boolean isDirectMan() {
		return isDirectMan;
	}
	public void setDirectMan(boolean isDirectMan) {
		this.isDirectMan = isDirectMan;
	}
	public SrcBorgScopeByRoleDto getSrcBorgScopeByRoleDto() {
		return srcBorgScopeByRoleDto;
	}
	public void setSrcBorgScopeByRoleDto(SrcBorgScopeByRoleDto srcBorgScopeByRoleDto) {
		this.srcBorgScopeByRoleDto = srcBorgScopeByRoleDto;
	}
	public SmpVendorsDto getSmpVendorsDto() {
		return smpVendorsDto;
	}
	public void setSmpVendorsDto(SmpVendorsDto smpVendorsDto) {
		this.smpVendorsDto = smpVendorsDto;
	}
	public SmpBranchsDto getSmpBranchsDto() {
		return smpBranchsDto;
	}
	public void setSmpBranchsDto(SmpBranchsDto smpBranchsDto) {
		this.smpBranchsDto = smpBranchsDto;
	}
	public String getIsKey() {
		return isKey;
	}
	public void setIsKey(String isKey) {
		this.isKey = isKey;
	}
	public String getClientCd() {
		return clientCd;
	}
	public void setClientCd(String clientCd) {
		this.clientCd = clientCd;
	}
	public String getIsLimit() {
		return isLimit;
	}
	public void setIsLimit(String isLimit) {
		this.isLimit = isLimit;
	}
	public String getAreaType() {
		return areaType;
	}
	public void setAreaType(String areaType) {
		this.areaType = areaType;
	}
	public String getClientId() {
		return clientId;
	}
	public void setClientId(String clientId) {
		this.clientId = clientId;
	}
	public List<BorgDto> getBelongBorgList() {
		return belongBorgList;
	}
	public void setBelongBorgList(List<BorgDto> belongBorgList) {
		this.belongBorgList = belongBorgList;
	}
	public List<LoginMenuDto> getSmallMenuList() {
		return smallMenuList;
	}
	public void setSmallMenuList(List<LoginMenuDto> smallMenuList) {
		this.smallMenuList = smallMenuList;
	}
	public String getMenuType() {
		return menuType;
	}
	public void setMenuType(String menuType) {
		this.menuType = menuType;
	}
	public List<LoginMenuDto> getStaticMenuList() {
		return staticMenuList;
	}
	public void setStaticMenuList(List<LoginMenuDto> staticMenuList) {
		this.staticMenuList = staticMenuList;
	}
	public String getSvcTypeNm() {
		return svcTypeNm;
	}
	public void setSvcTypeNm(String svcTypeNm) {
		this.svcTypeNm = svcTypeNm;
	}
	public String getBorgNms() {
		return borgNms;
	}
	public void setBorgNms(String borgNms) {
		this.borgNms = borgNms;
	}
	public List<LoginRoleDto> getLoginRoleList() {
		return loginRoleList;
	}
	public List<LoginMenuDto> getBigMenuList() {
		return bigMenuList;
	}
	public void setBigMenuList(List<LoginMenuDto> bigMenuList) {
		this.bigMenuList = bigMenuList;
	}
	public List<LoginMenuDto> getMiddleMenuList() {
		return middleMenuList;
	}
	public void setMiddleMenuList(List<LoginMenuDto> middleMenuList) {
		this.middleMenuList = middleMenuList;
	}
	public void setLoginRoleList(List<LoginRoleDto> loginRoleList) {
		this.loginRoleList = loginRoleList;
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
	public String getEmpNo() {
		return empNo;
	}
	public void setEmpNo(String empNo) {
		this.empNo = empNo;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getGradeNm() {
		return gradeNm;
	}
	public void setGradeNm(String gradeNm) {
		this.gradeNm = gradeNm;
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
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
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
	public String getTopBorgId() {
		return topBorgId;
	}
	public void setTopBorgId(String topBorgId) {
		this.topBorgId = topBorgId;
	}
	public String getParBorgId() {
		return parBorgId;
	}
	public void setParBorgId(String parBorgId) {
		this.parBorgId = parBorgId;
	}
	public String getBorgLevel() {
		return borgLevel;
	}
	public void setBorgLevel(String borgLevel) {
		this.borgLevel = borgLevel;
	}
	public String getBorgTypeCd() {
		return borgTypeCd;
	}
	public void setBorgTypeCd(String borgTypeCd) {
		this.borgTypeCd = borgTypeCd;
	}
	public String getSvcTypeCd() {
		return svcTypeCd;
	}
	public void setSvcTypeCd(String svcTypeCd) {
		this.svcTypeCd = svcTypeCd;
	}
	public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}
	
	public String getBranchId() {
		return branchId;
	}
	public void setBranchId(String branchId) {
		this.branchId = branchId;
	}
	public String getDeptId() {
		return deptId;
	}
	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}
	public String getRemoteIp() {
		return remoteIp;
	}
	public void setRemoteIp(String remoteIp) {
		this.remoteIp = remoteIp;
	}
	
	// 세션 값 반환 
	public String toString(){
		StringBuffer strBuffer = new StringBuffer();
		strBuffer.append("\n userId       ["+userId         +"]");
		strBuffer.append("\n loginId      ["+loginId        +"]");
		strBuffer.append("\n empNo        ["+empNo          +"]");
		strBuffer.append("\n userNm       ["+userNm         +"]");
		strBuffer.append("\n gradeNm      ["+gradeNm        +"]");
		strBuffer.append("\n tel          ["+tel            +"]");
		strBuffer.append("\n mobile       ["+mobile         +"]");
		strBuffer.append("\n email        ["+email          +"]");
		strBuffer.append("\n borgId       ["+borgId         +"]");
		strBuffer.append("\n borgCd       ["+borgCd         +"]");
		strBuffer.append("\n borgNm       ["+borgNm         +"]");
		strBuffer.append("\n topBorgId    ["+topBorgId      +"]");
		strBuffer.append("\n parBorgId    ["+parBorgId      +"]");
		strBuffer.append("\n borgLevel    ["+borgLevel      +"]");
		strBuffer.append("\n borgTypeCd   ["+borgTypeCd     +"]");
		strBuffer.append("\n svcTypeCd    ["+svcTypeCd      +"]");
		strBuffer.append("\n svcTypeNm    ["+svcTypeNm      +"]");
		strBuffer.append("\n borgNms      ["+borgNms        +"]");
		strBuffer.append("\n groupId      ["+groupId        +"]");
		strBuffer.append("\n clientId     ["+clientId       +"]");
		strBuffer.append("\n branchId     ["+branchId       +"]");
		strBuffer.append("\n deptId       ["+deptId         +"]");
		strBuffer.append("\n remoteIp     ["+remoteIp       +"]");
		strBuffer.append("\n menuType	  ["+menuType	    +"]");
		strBuffer.append("\n areaType	  ["+areaType	    +"]");
		strBuffer.append("\n isKey		  ["+isKey			+"]");
		strBuffer.append("\n clientCd	  ["+clientCd	    +"]");
		strBuffer.append("\n isLimit      ["+isLimit		+"]");
				
		return strBuffer.toString();
	}
	public String getLastLoginDate() {
		return lastLoginDate;
	}
	public void setLastLoginDate(String lastLoginDate) {
		this.lastLoginDate = lastLoginDate;
	}
	public String getWorkId() {
		return workId;
	}
	public void setWorkId(String workId) {
		this.workId = workId;
	}
	public boolean isSKTMng() {
		return isSKTMng;
	}
	public void setSKTMng(boolean isSKTMng) {
		if(isSKTMng) setSkMngFlag("1");
		this.isSKTMng = isSKTMng;
	}
	public boolean isSKBMng() {
		return isSKBMng;
	}
	public void setSKBMng(boolean isSKBMng) {
		if(isSKBMng) setSkMngFlag("2");
		this.isSKBMng = isSKBMng;
	}
	public String getSkMngFlag() {
		return skMngFlag;
	}
	public void setSkMngFlag(String skMngFlag) {
		this.skMngFlag = skMngFlag;
	}
}
