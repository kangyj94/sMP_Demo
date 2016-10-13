package kr.co.bitcube.organ.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bitcube.common.dao.CommonDao;
import kr.co.bitcube.common.dto.RolesDto;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.organ.dao.ReqBorgDao;
import kr.co.bitcube.system.dao.BorgDao;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class ReqBorgSvc {
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private ReqBorgDao reqBorgDao;
	
	@Autowired
	private CommonDao commonDao;
	
	@Autowired
	private BorgDao borgDao;
	
	@Resource(name="seqMpBorgsService")
	private EgovIdGnrService seqMpBorgsService; 	

	@Resource(name="seqMpUsersService")
	private EgovIdGnrService seqMpUsersService; 	
	
	@Resource(name="seqMpDeliveryInfoService")
	private EgovIdGnrService seqMpDeliveryInfoService;
	
	@Resource(name="seqContractList")
	private EgovIdGnrService seqContractList; // 물품공급 계약 시퀀스
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void saveReqBranch(HashMap<String, Object> saveMap) throws Exception{
		
		/**	사용자 요청 파라미터 셋팅 **/
		String clientId = seqMpBorgsService.getNextStringId();
		String branchId = seqMpBorgsService.getNextStringId();
		
		saveMap.put("clientId"		, clientId);	// 법인ID  
		saveMap.put("branchId"		, branchId);	// 조직ID
		saveMap.put("groupId"		, "304452");	// 그룹ID (일반그룹)
		saveMap.put("registerCd"	, "10");		// 등록상태 (10 : 등록요청)		
		saveMap.put("loginAuthType"	, "10");		// 로그인인증 (10 : 모바일인증)		
		saveMap.put("orderAuthType"	, "10");		// 주문요청인증 (10 : 공인인증)		

		
		
		/**	사업장 요청 Insert **/
		if(logger.isDebugEnabled()) { logger.debug("insertReqBranch saveMap : "+saveMap); }
		reqBorgDao.insertReqBranch(saveMap);	
		
		/**	사용자 정보 파라미터 셋팅 **/
		String userId = seqMpUsersService.getNextStringId();
		saveMap.put("userId"	, userId);	// UserId
		saveMap.put("isUse"		, 0);		// 사용여부   (초기값 : 0)
		saveMap.put("isLogin"	, 0);		// 활성화여부 (초기값 : 0)
		
		/**사용자 정보 Insert**/
		if(logger.isDebugEnabled()) { logger.debug("insertSmpUser saveMap : "+saveMap); }
		reqBorgDao.insertSmpUser(saveMap);	
		
		/** 배송처 정보 파라미터 셋팅 **/
		String[] shippingPlaceArr 	 = (String[]) saveMap.get("shippingPlaceArr");
		String[] shippingPhoneNumArr = (String[]) saveMap.get("shippingPhoneNumArr");
		String[] shippingAddresArr 	 = (String[]) saveMap.get("shippingAddresArr");
		
		if(shippingPlaceArr != null && shippingPlaceArr.length > 0){
			for(int shipCnt = 0 ; shipCnt < shippingPlaceArr.length ; shipCnt++){
				
				saveMap.put("deliveryId"		, seqMpDeliveryInfoService.getNextStringId());
				saveMap.put("shippingPlace"		, shippingPlaceArr[shipCnt]);
				saveMap.put("shippingAddres"	, shippingAddresArr[shipCnt]);
				saveMap.put("shippingPhoneNum"	, shippingPhoneNumArr[shipCnt]);
				saveMap.put("isDefault"			, shipCnt == 0 ? 1 : 0);
				
				/** 배송처 정보 Insert **/
				if(logger.isDebugEnabled()) { logger.debug("insertDeliveryInfo saveMap : "+saveMap); }
				reqBorgDao.insertDeliveryInfo(saveMap);
			}
		}
		
		/** 기본권한 셋팅 **/
		saveMap.put("roleCd", "BUY_CLT");			// 사업장 RoleCd
		List<RolesDto> roleList = reqBorgDao.selectRolesList(saveMap);
		
		if(roleList != null && roleList.size() > 0){
			for(RolesDto dto : roleList){
				// 소속조직 Insert
				saveMap.put("borgId"		, branchId);
				saveMap.put("borgsIsDefault", "1");
				reqBorgDao.insertBorgsUsers(saveMap);
				
				// 사용자 조직 역활 Insert
				saveMap.put("roleId"		, dto.getRoleId());
				saveMap.put("borgScopeCd"	, dto.getBorgScopeCd());
				if(logger.isDebugEnabled()) { logger.debug("insertUserRoles saveMap : "+saveMap); }
				reqBorgDao.insertUserRoles(saveMap);
			}
		}
		
		/** 공인인증서 등록 **/
		saveMap.put("borgId" ,clientId);	// 법인ID (조직ID) 
		if(logger.isDebugEnabled()) { logger.debug("insertAuthInfo saveMap : "+saveMap); }
		commonDao.insertAuthInfo(saveMap);
		
		//물품공급계약서등록
		Map<String, Object> contractMap = new HashMap<String, Object>();
		contractMap.put("contractVersionArray", saveMap.get("contractVersionArray"));
		contractMap.put("contractClassifyArray", saveMap.get("contractClassifyArray"));
		contractMap.put("loginId",saveMap.get("loginId"));
		contractMap.put("userNm", saveMap.get("userNm"));
		contractMap.put("borgId", saveMap.get("branchId"));
		contractMap.put("contractCustomerCd", saveMap.get("clientCd").toString()+"0000001");
		if(logger.isDebugEnabled()) { logger.debug("commodityContractClientSave contractMap : "+contractMap); }
		this.commodityContractClientSave(contractMap);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void saveReqVendor(HashMap<String, Object> saveMap) throws Exception{
		
		/**	공급사 요청 파라미터 셋팅 **/
		String vendorId = seqMpBorgsService.getNextStringId();
  
		saveMap.put("vendorId"		, vendorId);		// 조직ID
		saveMap.put("vendorCd"		, "VEN"+vendorId);	// 공급사코드
		saveMap.put("registerCd"	, "10");			// 등록상태 (10 : 등록요청)		
		saveMap.put("loginAuthType"	, "20");			// 로그인인증 (20 : 일반)		
		
		/**	사업장 요청 Insert **/
		reqBorgDao.insertReqVendor(saveMap);
		
		/**	사용자 정보 파라미터 셋팅 **/
		String userId = seqMpUsersService.getNextStringId();
		saveMap.put("userId"	, userId);	// UserId
		saveMap.put("isUse"		, 0);		// 사용여부   (초기값 : 0)
		saveMap.put("isLogin"	, 0);		// 활성화여부 (초기값 : 0)
		
		/**사용자 정보 Insert**/
		reqBorgDao.insertSmpUser(saveMap);	
		
		/** 기본권한 셋팅 **/
		saveMap.put("roleCd", "VEN_MNG");			// 사업장 RoleCd
		List<RolesDto> roleList = reqBorgDao.selectRolesList(saveMap);
		
		if(roleList != null && roleList.size() > 0){
			for(RolesDto dto : roleList){
				// 소속조직 Insert
				saveMap.put("borgId"		, vendorId);
				saveMap.put("borgsIsDefault", "1");
				reqBorgDao.insertBorgsUsers(saveMap);
				
				// 사용자 조직 역활 Insert
				saveMap.put("roleId"		, dto.getRoleId());
				saveMap.put("borgScopeCd"	, dto.getBorgScopeCd());
				reqBorgDao.insertUserRoles(saveMap);
			}
		}
		saveMap.put("borgId" ,vendorId);	// 사업장ID 
		commonDao.insertAuthInfo(saveMap);
		
		//물품공급계약서 등록
		Map<String, Object> contractMap = new HashMap<String, Object>();
		contractMap.put("contractVersionArray", saveMap.get("contractVersionArray"));
		contractMap.put("contractClassifyArray", saveMap.get("contractClassifyArray"));
		contractMap.put("loginId",saveMap.get("loginId"));
		contractMap.put("userNm", saveMap.get("userNm"));
		contractMap.put("borgId", saveMap.get("vendorId"));
		contractMap.put("contractCustomerCd", saveMap.get("vendorCd"));
		this.commodityContractClientSave(contractMap);
		
	}

	public CustomResponse reqBorgDupCheck(String clintCd) throws Exception {
		CustomResponse custResponse = new CustomResponse(true);
		
		int dupCnt = reqBorgDao.reqBorgDupCheck(clintCd);
		
		if(dupCnt > 0){
			logger.error("Exception : Duplication ClientCd ");
			custResponse.setSuccess(false);
			custResponse.setMessage("이미 사용중인 법인코드 입니다.");
		}
		
		return custResponse;	 
	}

	public CustomResponse loginIdDupCheck(String loginId) throws Exception {
		CustomResponse custResponse = new CustomResponse(true);
		
		int dupCnt = reqBorgDao.loginIdDupCheck(loginId);
		
		if(dupCnt > 0){
			logger.error("Exception : Duplication LoginId ");
			custResponse.setSuccess(false);
			custResponse.setMessage("이미 사용중인 ID입니다.");
		}
		
		return custResponse;			
	}
	
	//회원가입요청시 법인정보로 계약등록
	private void commodityContractClientSave(Map<String, Object> contractMap) throws Exception{
		String[] contractVersion = (String[])contractMap.get("contractVersionArray");
		String[] contractClassify = (String[])contractMap.get("contractClassifyArray");
		for(int i=0;i<contractVersion.length;i++){		
			contractMap.put("contractNo", seqContractList.getNextStringId());
			contractMap.put("contractVersion", contractVersion[i]);
			contractMap.put("contractClassify", contractClassify[i]);
			borgDao.insertCommodityContractClient(contractMap);
		}
		
	}
}
