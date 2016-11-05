package kr.co.bitcube.organ.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.RolesDto;
import kr.co.bitcube.common.dto.SmsEmailInfo;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.JcoAdapter;
import kr.co.bitcube.organ.dao.OrganDao;
import kr.co.bitcube.organ.dto.AdminBorgsDto;
import kr.co.bitcube.organ.dto.BorgRoleDto;
import kr.co.bitcube.organ.dto.SmpBranchsDto;
import kr.co.bitcube.organ.dto.SmpDeliveryInfoDto;
import kr.co.bitcube.organ.dto.SmpUsersDto;
import kr.co.bitcube.organ.dto.SmpVendorsDto;
import kr.co.bitcube.system.service.BorgSvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class OrganSvc {
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private OrganDao organDao;
	
	@Autowired
	private BorgSvc borgSvc;
	
	@Autowired
	private CommonSvc commonSvc;

	@Resource(name="systemIdGenerationService")
	private EgovIdGnrService systemIdGenerationService;
	
	@Resource(name="seqMpDeliveryInfoService")
	private EgovIdGnrService seqMpDeliveryInfoService;
	
	@Resource(name="seqMpBorgsService")
	private EgovIdGnrService seqMpBorgsService;
	
	@Resource(name="seqMpUsersService")
	private EgovIdGnrService seqMpUsersService;
	@Autowired
	private GeneralDao generalDao;
	
	
	public int getOrganClientRegistRequestListCnt(HashMap<String, Object> paramMap) throws Exception {
		return organDao.selectReqClientListCnt(paramMap);
	}

	public int getOrganVendorRegistRequestListCnt(HashMap<String, Object> paramMap) throws Exception {
		return organDao.selectReqVendorListCnt(paramMap);
	}
	
	public List<SmpBranchsDto> getOrganClientRegistRequestListJQGrid (HashMap<String, Object> paramMap, int page, int rows) throws Exception {
		return organDao.selectReqBranchList(paramMap, page, rows);
	}
	
	public List<SmpVendorsDto> getOrganVendorRegistRequestListJQGrid (HashMap<String, Object> paramMap, int page, int rows) throws Exception {
		return organDao.selectReqVendorList(paramMap, page, rows);
	}
	
	public SmpBranchsDto selectOneBranchs(String branchId) {
		return organDao.selectOneBranchs(branchId);
	}

	public List<SmpDeliveryInfoDto> selectDeliveryInfoList(String branchId) {
		return organDao.selectDeliveryInfoList(branchId);
	}

	public List<BorgRoleDto> selectDefaultBorgRole(Map<String, Object> params) {
		return organDao.selectDefaultBorgRole(params);
	}

	public SmpUsersDto selectUserInfo(String branchId) {
		return organDao.selectUserInfo(branchId);
	}

	public List<AdminBorgsDto> getAdminborgs(String clientId) {
		return organDao.getAdminborgs(clientId);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void insertAdminBorgs(HashMap<String, Object> saveMap) throws Exception{
		
		int dupCnt = organDao.selectAdminborgsDupCheck(saveMap);
		
		if(dupCnt > 0){
			throw new Exception();
		}else{
			String adminBorgId = systemIdGenerationService.getNextStringId();
			saveMap.put("adminBorgId", adminBorgId);
			organDao.insertAdminBorgs(saveMap);
		}
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void deleteAdminBorgs(String adminBorgId) throws Exception{
		organDao.deleteAdminBorgs(adminBorgId);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void deleteUserRoles(HashMap<String, Object> saveMap) throws Exception{
		organDao.deleteBorgsUserRole(saveMap);
	}

	/**
	 * 사업장조회 리스트의 카운트 조회하는 메소드
	 * @param params
	 * @return
	 */
	public int getOrganBranchListCnt(Map<String, Object> params) {
		return organDao.selectOrganBranchListCnt(params);
	}
	
	/**
	 * 공급사조회 리스트의 카운트 조회하는 메소드
	 * @param params
	 * @return
	 */
	public int getOrganVendorListCnt(Map<String, Object> params) {
		return organDao.selectOrganVendorListCnt(params);
	}
	
	/**
	 * 사용자조회 리스트의 카운트 조회하는 메소드
	 * @param params
	 * @return
	 */
	public int getOrganUserListCnt(Map<String, Object> params) {
		return organDao.selectOrganUserListCnt(params);
	}
	
	/**
	 * 공급사사용자조회 리스트의 카운트 조회하는 메소드
	 * @param params
	 * @return
	 */
	public int getOrganVendorUserListCnt(Map<String, Object> params) {
		return organDao.selectOrganVendorUserListCnt(params);
	}
	
	/**
	 * 사업장조회 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @param page(페이지번호)
	 * @param rows(페이지 Row 개수)
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<SmpBranchsDto> getOrganBranchList(Map<String, Object> params, int page, int rows) {
		List<SmpBranchsDto>	list		= organDao.selectOrganBranchList(params, page, rows);
//		for(int i=0; i<list.size(); i++){
//			int					allCnt		= 0;
//			int					sameCnt		= 0;
//			String				contractYn	= "N";
//			String				borgId		= list.get(i).getBranchId();
//			ModelMap			daoParam	= new ModelMap();
//			daoParam.put("borgId",		borgId);
//			daoParam.put("svcTypeCd",	"BUY");
//			Map<String, Object>	contractMap	= (Map<String, Object>) generalDao.selectGernalObject("common.etc.selectBIQContractSameCnt", daoParam);
//			allCnt	= (int) contractMap.get("ALL_CNT");
//			sameCnt	= (int) contractMap.get("SAME_CNT");
//			if(allCnt == sameCnt){
//				contractYn = "Y";
//			}
//			list.get(i).setContractYn(contractYn);
//		}
		return list;
	}
	
	/**
	 * 공급사조회 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @param page(페이지번호)
	 * @param rows(페이지 Row 개수)
	 * @return
	 */
//	@SuppressWarnings("unchecked")
	public List<SmpVendorsDto> getOrganVendorList(Map<String, Object> params, int page, int rows) {
		List<SmpVendorsDto>	list		= organDao.selectOrganVendorList(params, page, rows);
//		for(int i=0; i<list.size(); i++){
//			int					allCnt		= 0;
//			int					sameCnt		= 0;
//			String				contractYn	= "N";
//			String				borgId		= list.get(i).getVendorId();
//			ModelMap			daoParam	= new ModelMap();
//			daoParam.put("borgId",		borgId);
//			daoParam.put("svcTypeCd",	"BUY");
//			Map<String, Object>	contractMap	= (Map<String, Object>) generalDao.selectGernalObject("common.etc.selectBIQContractSameCnt", daoParam);
//			allCnt	= (int) contractMap.get("ALL_CNT");
//			sameCnt	= (int) contractMap.get("SAME_CNT");
//			if(allCnt == sameCnt){
//				contractYn = "Y";
//			}
//			list.get(i).setContractYn(contractYn);
//		}
		return list;
	}
	
	/**
	 * 사용자조회 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @param page(페이지번호)
	 * @param rows(페이지 Row 개수)
	 * @return
	 */
	public List<SmpUsersDto> getOrganUserList(Map<String, Object> params, int page, int rows) {
		return organDao.selectOrganUserList(params, page, rows);
	}
	
	/**
	 * 공급사사용자조회 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @param page(페이지번호)
	 * @param rows(페이지 Row 개수)
	 * @return
	 */
	public List<SmpUsersDto> getOrganVendorUserList(Map<String, Object> params, int page, int rows) {
		return organDao.selectOrganVendorUserList(params, page, rows);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void updateBranchReq(HashMap <String, Object> saveMap) throws Exception {
		
		logger.info("요청법인 Update 시작 시간 : "+CommonUtils.getCurrentDateTime());
		//요청법인 Update
		if("40".equals((String)saveMap.get("registerCd")))	saveMap.put("confirm", "Y");
		organDao.updateBranchReq(saveMap);
		logger.info("요청법인 Update 시작 시간 : "+CommonUtils.getCurrentDateTime());
		
		logger.info("사용자정보 Update 시작 시간 : "+CommonUtils.getCurrentDateTime());
		//사용자정보 Update
		organDao.updateSmpUser(saveMap);
		logger.info("사용자정보 Update 끝 시간 : "+CommonUtils.getCurrentDateTime());
		
		if("40".equals((String)saveMap.get("registerCd"))){
			logger.info("사업장 승인 시작 시간 : "+CommonUtils.getCurrentDateTime());
			// SAP 등록 - SAP Return Result 가 Fail 일 경우 등록 취소.
			saveMap.put("bustType"	,saveMap.get("branchBustType"));
			saveMap.put("bustClas"	,saveMap.get("branchBustClas"));
				
//			Return Code		
//			1 : 사업자등록번호가 입력되지 않은 채로 I/F 된 경우
//			2 : 구매처 존재 / 고객 미존재
//			3 : 구매처 미존재 / 고객 존재
//			4 : 구매처 존재 / 고객 존재
//			5 : 구매처 미존재 / 고객 미존재				
			
//			승인시 SAP등록 부분 주석처리
//			String rtnCode = this.compDupCheck(saveMap.get("businessNum").toString());
			
//			logger.info("사업장 승인시 SAP 확인 시작 시간 : "+CommonUtils.getCurrentDateTime());
//			if(!"4".equals(rtnCode)){
//				String[] rtnResult = sendComp(saveMap);
//				if("F".equals(rtnResult[0])){
//					//전송시 Error 발생할 경우 1번더 전송시도
//					sendComp(saveMap);
//					//고객사/구매사중 어떤것만 등록되었는지 다시 확인
//					String chkCode = this.compDupCheck(saveMap.get("businessNum").toString());
//					
//					//체크확인 결과 고객사/구매처 모두 정상 생성이 되어있지 않으면 히스토리 테이블에 이력작성
//					if(!"4".equals(chkCode.trim())){
//						Map<String, Object> histSaveMap = new HashMap<String, Object>();
//						String tranDesc = "";
//						
//						histSaveMap.put("borgId"		, saveMap.get("branchId"));
//						histSaveMap.put("borgNm"		, saveMap.get("clientNm"));
//						histSaveMap.put("businessNum"	, saveMap.get("businessNum"));
//						histSaveMap.put("svcTypeCd"		, "BCH");
//						histSaveMap.put("transCd"		, "1");
//						
//						if("2".equals(chkCode.trim())){
//							tranDesc = "고객이 정상적으로 등록되지 않았습니다.";
//						}else if("3".equals(chkCode.trim())){
//							tranDesc = "구매처가 정상적으로 등록되지 않았습니다.";
//						}else if("5".equals(chkCode.trim())){
//							tranDesc = "구매처/고객이 정상적으로 등록되지 않았습니다.";
//						}
//						histSaveMap.put("tranDesc"		, tranDesc);
//						//조직I/F 히스토리 테이블 Insert
//						organDao.insertIfBorgsHist(histSaveMap);
//					}
//				}
//			}
			
			
			Map<String, Object> histSaveMap = new HashMap<String, Object>();
			
			histSaveMap.put("borgId"		, saveMap.get("branchId"));
			histSaveMap.put("borgNm"		, saveMap.get("clientNm"));
			histSaveMap.put("businessNum"	, saveMap.get("businessNum"));
			histSaveMap.put("svcTypeCd"		, "BCH");
			histSaveMap.put("transCd"		, "1");

			histSaveMap.put("tranDesc"		, "해당 고객사는 ERP에 등록되지 않았습니다.");
			//조직I/F 히스토리 테이블 Insert
			organDao.insertIfBorgsHist(histSaveMap);			
			
//			logger.info("사업장 승인시 SAP 확인 끝 시간 : "+CommonUtils.getCurrentDateTime());
			
			logger.info("1. 조직마스터 - 법인등록 시작 시간 : "+CommonUtils.getCurrentDateTime());
			// 승인완료 처리 - SMPBORGS, SMPBRANCHS Insert & 권한설정
			// 1. 조직마스터 - 법인등록
			Map<String, Object> borgMap = new HashMap<String, Object>();// 법인등록 Map
			
			borgMap.put("borgId"		, saveMap.get("clientId").toString());
			borgMap.put("borgCd"		, saveMap.get("clientCd").toString());
			borgMap.put("borgNm"		, saveMap.get("clientNm").toString());
			borgMap.put("topBorgId"		, saveMap.get("groupId").toString());
			borgMap.put("parBorgId"		, saveMap.get("groupId").toString());
			borgMap.put("borgLevel"		, "2");
			borgMap.put("borgTypeCd"	, "CLT");
			borgMap.put("svcTypeCd"		, "BUY");
			borgMap.put("groupId"		, saveMap.get("groupId").toString());
			borgMap.put("clientId"		, "0");
			borgMap.put("branchId"		, saveMap.get("branchId").toString());
			borgMap.put("deptId"		, "0");
			borgMap.put("remoteIp"		, saveMap.get("creatorRemoteIp").toString());
			borgMap.put("creatorId"		, saveMap.get("creatorUserId").toString());
			borgMap.put("isUse"			, "1");
			borgMap.put("isLimit"		, "0");
			organDao.insertSmpBorgs(borgMap);
			
			logger.info("1. 조직마스터 - 법인등록 끝 시간 : "+CommonUtils.getCurrentDateTime());
			
			
			logger.info("2. 조직마스터 - 대표사업장등록(_본사) 시작 시간 : "+CommonUtils.getCurrentDateTime());
			
			// 2. 조직마스터 - 대표사업장등록(_본사)
			Map<String, Object> branchMap = new HashMap<String, Object>();		// 대표사업장등록 Map
			branchMap.put("borgId"		, saveMap.get("branchId").toString());
			branchMap.put("borgCd"		, saveMap.get("clientCd").toString() + "0000001");
			branchMap.put("borgNm"		, saveMap.get("clientNm").toString() + "_본사");
			branchMap.put("topBorgId"	, saveMap.get("groupId").toString());
			branchMap.put("parBorgId"	, saveMap.get("clientId").toString());
			branchMap.put("borgLevel"	, "3");
			branchMap.put("borgTypeCd"	, "BCH");
			branchMap.put("svcTypeCd"	, "BUY");
			branchMap.put("groupId"		, saveMap.get("groupId").toString());							 
			branchMap.put("clientId"	, saveMap.get("clientId").toString());
			branchMap.put("branchId"	, saveMap.get("branchId").toString());
			branchMap.put("deptId"		, "0");
			branchMap.put("remoteIp"	, saveMap.get("creatorRemoteIp").toString());
			branchMap.put("creatorId"	, saveMap.get("creatorUserId").toString());
			branchMap.put("isUse"		, "1");
			branchMap.put("isKey"		, "1");
			branchMap.put("isLimit"		, "0");
			organDao.insertSmpBorgs(branchMap);
			
			logger.info("2. 조직마스터 - 대표사업장등록(_본사) 끝 시간 : "+CommonUtils.getCurrentDateTime());
			
			
			logger.info("3. 사업장 등록 시작 시간 : "+CommonUtils.getCurrentDateTime());
			// 3. 사업장 등록
			organDao.insertSmpBranchs(saveMap);
			
			logger.info("3. 사업장 등록 끝 시간 : "+CommonUtils.getCurrentDateTime());
			
			
			logger.info("4. 사용자(담당자) 사용유무 / 로그인유무 업데이트 시작 시간 : "+CommonUtils.getCurrentDateTime());
			// 4. 사용자(담당자) 사용유무 / 로그인유무 업데이트
			organDao.updateSmpUsersIsUse(saveMap);
			logger.info("4. 사용자(담당자) 사용유무 / 로그인유무 업데이트 끝 시간 : "+CommonUtils.getCurrentDateTime());
			
			logger.info("5. SMS/메일 발송여부 등록 시작 시간 : "+CommonUtils.getCurrentDateTime());
			// 5. SMS/메일 발송여부 등록
			Map<String, Object> receiveMap = new HashMap<String, Object>();		// SMS, 메일 발송등록 Map
			receiveMap.put("userId"					,saveMap.get("userId").toString());
			receiveMap.put("isEmail"                ,"1");
			receiveMap.put("isSms"                  ,"1");
			receiveMap.put("emailByPurchase"        ,"1");
			receiveMap.put("emailByDelivery"        ,"1");
			receiveMap.put("emailByRegistergood"    ,"1");
			receiveMap.put("smsByPurchase"          ,"1");
			receiveMap.put("smsByDelivery"          ,"1");
			receiveMap.put("smsByRegistergood"      ,"1");
			receiveMap.put("emailByPurchaseorder"   ,"0");
			receiveMap.put("emailByOrdrtreceive"    ,"0");
			receiveMap.put("emailByNotiauction"		,"0");
			receiveMap.put("emailByNotisuccessbid"	,"0");
			receiveMap.put("smsByPurchaseorder"     ,"0");
			receiveMap.put("smsByOrdrtreceive"      ,"0");
			receiveMap.put("smsByNotiauction"       ,"0");
			receiveMap.put("smsByNotisuccessbid"	,"0");
			
			organDao.insertSmpReceiveInfo(receiveMap);

			logger.info("5. SMS/메일 발송여부 등록 끝 시간 : "+CommonUtils.getCurrentDateTime());
			
			logger.info("6. 물품공급 계약서 업데이트 시작 시간 : "+CommonUtils.getCurrentDateTime());
			// 6. 물품공급 계약서 업데이트
			Map<String, Object> contractMap = new HashMap<String, Object>();
			contractMap.put("contractBorgId", saveMap.get("branchId").toString());
			borgSvc.updateCommodityContractList(contractMap);
			logger.info("6. 물품공급 계약서 업데이트 끝 시간 : "+CommonUtils.getCurrentDateTime());
			
			logger.info("사업장 승인 시작 시간"+CommonUtils.getCurrentDateTime());
		}
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void updateVendorReq(HashMap <String, Object> saveMap) throws Exception {
		if("40".equals((String)saveMap.get("registerCd")))	saveMap.put("confirm", "Y");
		organDao.updateVendorReq(saveMap);
		
		//사용자정보 Update
		organDao.updateSmpUser(saveMap);
		
		if("40".equals((String)saveMap.get("registerCd"))){
			saveMap.put("clientNm"	,saveMap.get("vendorNm"));
			saveMap.put("bustType"	,saveMap.get("vendorBustType"));
			saveMap.put("bustClas"	,saveMap.get("vendorBustClas"));
			
//			Return Code		
//			1 : 사업자등록번호가 입력되지 않은 채로 I/F 된 경우
//			2 : 구매처 존재 / 고객 미존재
//			3 : 구매처 미존재 / 고객 존재
//			4 : 구매처 존재 / 고객 존재
//			5 : 구매처 미존재 / 고객 미존재			
			
			
//			승인시 SAP등록 부분 주석처리			
//			String rtnCode = this.compDupCheck(saveMap.get("businessNum").toString());
//			if(!"4".equals(rtnCode)){
//				String[] rtnResult = sendComp(saveMap);
//				if("F".equals(rtnResult[0])){
//					//전송시 Error 발생할 경우 1번더 전송시도!
//					sendComp(saveMap);
//					//고객사/구매사중 어떤것만 등록되었는지 다시 확인
//					String chkCode = this.compDupCheck(saveMap.get("businessNum").toString());
//			
//					
//					//체크확인 결과 고객사/구매처 모두 정상 생성이 되어있지 않으면 히스토리 테이블에 이력작성
//					if(!"4".equals(chkCode.trim())){
//						Map<String, Object> histSaveMap = new HashMap<String, Object>();
//						String tranDesc = "";
//						
//						histSaveMap.put("borgId"		, saveMap.get("vendorId"));
//						histSaveMap.put("borgNm"		, saveMap.get("vendorNm"));
//						histSaveMap.put("businessNum"	, saveMap.get("businessNum"));
//						histSaveMap.put("svcTypeCd"		, "VEN");
//						histSaveMap.put("transCd"		, "1");
//						
//						if("2".equals(chkCode.trim())){
//							tranDesc = "고객이 정상적으로 등록되지 않았습니다.";
//						}else if("3".equals(chkCode.trim())){
//							tranDesc = "구매처가 정상적으로 등록되지 않았습니다.";
//						}else if("5".equals(chkCode.trim())){
//							tranDesc = "구매처/고객이 정상적으로 등록되지 않았습니다.";
//						}
//						histSaveMap.put("tranDesc"		, tranDesc);
//						//조직I/F 히스토리 테이블 Insert
//						organDao.insertIfBorgsHist(histSaveMap);
//					}
//				}
//			}
			
			Map<String, Object> histSaveMap = new HashMap<String, Object>();
			
			histSaveMap.put("borgId"		, saveMap.get("vendorId"));
			histSaveMap.put("borgNm"		, saveMap.get("vendorNm"));
			histSaveMap.put("businessNum"	, saveMap.get("businessNum"));
			histSaveMap.put("svcTypeCd"		, "VEN");
			histSaveMap.put("transCd"		, "1");

			histSaveMap.put("tranDesc"		, "해당 공급사는 ERP에 등록되지 않았습니다.");
			//조직I/F 히스토리 테이블 Insert
			organDao.insertIfBorgsHist(histSaveMap);				
			
			// 1. 조직마스터 - 등록
			Map<String, Object> borgMap = new HashMap<String, Object>();		// 법인등록 Map
			
			borgMap.put("borgId"		, saveMap.get("vendorId").toString());
			borgMap.put("borgCd"		, saveMap.get("vendorCd").toString());
			borgMap.put("borgNm"		, saveMap.get("vendorNm").toString());
			borgMap.put("topBorgId"		, "0");
			borgMap.put("parBorgId"		, "0");
			borgMap.put("borgLevel"		, "0");
			borgMap.put("borgTypeCd"	, "BCH");
			borgMap.put("svcTypeCd"		, "VEN");
			borgMap.put("groupId"		, "0");							 
			borgMap.put("clientId"		, "0");
			borgMap.put("branchId"		, "0");
			borgMap.put("deptId"		, "0");
			borgMap.put("remoteIp"		, saveMap.get("creatorRemoteIp").toString());
			borgMap.put("creatorId"		, saveMap.get("creatorUserId").toString());
			borgMap.put("isUse"			, "1");
			
			organDao.insertSmpBorgs(borgMap);
			
			// 2. 공급사 등록
			organDao.insertSmpVendors(saveMap);
			
			// 3. 사용자(담당자) 사용유무 / 로그인유무 업데이트
			organDao.updateSmpUsersIsUse(saveMap);
			
			// 4. SMS/메일 발송여부 등록
			Map<String, Object> receiveMap = new HashMap<String, Object>();		// SMS, 메일 발송등록 Map
			receiveMap.put("userId"					,saveMap.get("userId").toString());
			receiveMap.put("isEmail"                ,"0");
			receiveMap.put("isSms"                  ,"0");
			receiveMap.put("emailByPurchase"        ,"0");
			receiveMap.put("emailByDelivery"        ,"0");
			receiveMap.put("emailByRegistergood"    ,"0");
			receiveMap.put("smsByPurchase"          ,"0");
			receiveMap.put("smsByDelivery"          ,"0");
			receiveMap.put("smsByRegistergood"      ,"0");
			receiveMap.put("emailByPurchaseorder"   ,"1");
			receiveMap.put("emailByOrdrtreceive"    ,"1");
			receiveMap.put("emailByNotiauction"		,"1");
			receiveMap.put("emailByNotisuccessbid"	,"1");
			receiveMap.put("smsByPurchaseorder"     ,"1");
			receiveMap.put("smsByOrdrtreceive"      ,"1");
			receiveMap.put("smsByNotiauction"       ,"1");
			receiveMap.put("smsByNotisuccessbid"	,"1");	
			
			organDao.insertSmpReceiveInfo(receiveMap);
			
			//물품공급 계약서 업데이트
			Map<String, Object> contractMap = new HashMap<String, Object>();
			contractMap.put("contractBorgId", saveMap.get("vendorId").toString());
			borgSvc.updateCommodityContractList(contractMap);
		}		
	}

	public SmpBranchsDto selectOneReqBranchs(String branchId) {
		return organDao.selectOneReqBranchs(branchId);
	}

	public SmpVendorsDto selectOneReqVendors(String branchId) {
		return organDao.selectOneReqVendors(branchId);
	}

	/**
	 * 사용자권한정보을 등록
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void regBorgsUsersRoles(HashMap<String, Object> saveMap) {
		organDao.insertBorgsUsersRoles(saveMap);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void deleteDeliveryInfo(HashMap<String, Object> saveMap) {
		organDao.deleteDeliveryInfo(saveMap);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void insertDeliveryInfo(HashMap<String, Object> saveMap) throws Exception{
		/** 배송처 정보 파라미터 셋팅 **/
		saveMap.put("deliveryId"		, seqMpDeliveryInfoService.getNextStringId());
		/** 배송처 정보 Insert **/
		organDao.insertDeliveryInfo(saveMap);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void reqBranchRegisterCdCancel(Map<String, Object> saveMap) {
		organDao.reqBranchRegisterCdCancel(saveMap);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void deleteReqBranch(Map<String, Object> saveMap) {
		//REQSMPBRANCH			삭제
		organDao.deleteReqBranch(saveMap.get("branchId").toString());
		//SMPBORGS_USERS_ROLE	삭제
		organDao.deleteSmpBorgsUsersRoles(saveMap);
		//SMPBORGS_USERS		삭제
		organDao.deleteSmpBorgsUsers(saveMap);
		//SMPUSERS				삭제
		organDao.deleteSmpUsers(saveMap);
		//운영사 담당자 삭제
		//organDao.deleteAdminBorgs(saveMap);
		//배송처 정보 삭제
		organDao.deleteDeliveryInfo(saveMap);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void reqVendorRegisterCdCancel(Map<String, Object> saveMap) {
		organDao.reqVendorRegisterCdCancel(saveMap);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void deleteReqVendor(Map<String, Object> saveMap) {
		//REQSMPVENDOR			삭제
		organDao.deleteReqVendor(saveMap.get("vendorId").toString());
		//SMPBORGS_USERS_ROLE	삭제
		organDao.deleteSmpBorgsUsersRoles(saveMap);
		//SMPBORGS_USERS		삭제
		organDao.deleteSmpBorgsUsers(saveMap);
		//SMPUSERS				삭제
		organDao.deleteSmpUsers(saveMap);
		//운영사 담당자 삭제
		//organDao.deleteAdminBorgs(saveMap);
	}
	
	public List<SmpUsersDto> selectUsersMobile (Map<String, Object> saveMap) {
		return organDao.selectUsersMobile(saveMap);
	}
	
	public SmpBranchsDto selectBranchsDetail (String branchId) {
		return organDao.selectBranchsDetail(branchId);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})	
	public void updateSmpBranchs (Map<String, Object> saveMap) {
		// 사업장의 상태가 종료일경우 update date  칼럼 수정.
		organDao.updateSmpBranchs(saveMap);
		
		saveMap.put("borgId", saveMap.get("branchId"));
		saveMap.put("borgNm", saveMap.get("branchNm"));
		organDao.updateSmpBorgs(saveMap);
		
		//대표자명 일괄 업데이트
		organDao.updateAllSmpBranchsPressentNm(saveMap);
		
		// 상태 종료 일 경우 사용자의 상태도 변경
		String isModUpdatedate = (String)saveMap.get("isModUpdatedate");
		if(isModUpdatedate.equals("Y")){ // 종료처리를 의미
			Map<String, Object> tempParamMap = new HashMap<String, Object>();
			tempParamMap.put("borgid", saveMap.get("branchId"));
//			List<Map<String,Object>> bUserList = organDao.selectUserListByBranchId(tempParamMap);
			List<Map<String,Object>> bUserList = organDao.selectBranchEndUserList(tempParamMap);
			for(Map<String,Object> sud : bUserList){
				String userIdTemp = (String)sud.get("USERID");
				organDao.updateUserStatusByUserId(userIdTemp);
			}
		}
	}
	
	public List<SmpUsersDto> selectBorgUsers(String borgId) {
		return organDao.selectBorgUsers(borgId);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void insertBorgsUsers (Map<String, Object> saveMap) {
		// SmpBorg_Users
		organDao.insertBorgsUsers(saveMap);
		
		// Get Default Roles
		RolesDto roleDto = organDao.selectSmpBorgsUserRoles("BUY");
		// SmpBorg_Users_Roles
		saveMap.put("roleId"		, roleDto.getRoleId());
		saveMap.put("isDefault"		, "1");
		saveMap.put("borgScopeCd"	, roleDto.getBorgScopeCd());
		organDao.insertBorgsUsersRoles(saveMap);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void deleteBorgsUsers (Map<String, Object> saveMap) throws Exception {
		if(organDao.getMrordmCount(saveMap) > 0){
			throw new Exception("OrderException");
		}else{
			// SmpBorgs_Users, SmpBorgs_Users_Roles Delete
			organDao.deleteSmpBorgsUsers(saveMap);
			organDao.deleteSmpBorgsUsersRoles(saveMap);
		}
	}
	
	public SmpBranchsDto organBranchSearch(String clientId) {
		return organDao.organBranchSearch(clientId);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void saveOrganBranchReg (Map<String, Object> saveMap) throws Exception{
		//조직마스터 등록
		String borgId = seqMpBorgsService.getNextStringId();
		String tmpClientCd = saveMap.get("clientCd").toString();
		if(tmpClientCd==null || "".equals(tmpClientCd)) {
			saveMap.put("clientCd", organDao.getClientCdByClientId(saveMap.get("clientId").toString()));
		}
		String borgCd = organDao.getBranchCdSeq(saveMap.get("clientCd").toString());

		String branchNmAdd 	= "";
		String isKey 		= "0";
		
		if(borgCd.endsWith("0000001")){
			branchNmAdd = "_본사";
			isKey		= "1";
		}
		Map<String, Object> borgMap = new HashMap<String, Object>();
		borgMap.put("borgId"	, borgId);
		borgMap.put("borgCd"	, borgCd);
		borgMap.put("borgNm"	, saveMap.get("branchNm") + branchNmAdd);
		borgMap.put("topBorgId"	, saveMap.get("groupId").toString());
		borgMap.put("parBorgId"	, saveMap.get("clientId").toString());
		borgMap.put("borgLevel"	, "3");
		borgMap.put("borgTypeCd", "BCH");
		borgMap.put("svcTypeCd"	, "BUY");
		borgMap.put("groupId"	, saveMap.get("groupId").toString());							 
		borgMap.put("clientId"	, saveMap.get("clientId").toString());
		borgMap.put("branchId"	, borgId);
		borgMap.put("deptId"	, "0");
		borgMap.put("remoteIp"	, saveMap.get("remoteIp").toString());
		borgMap.put("creatorId"	, saveMap.get("regUserId").toString());
		borgMap.put("isUse"		, saveMap.get("isUse").toString());
		borgMap.put("isKey"		, isKey);
		borgMap.put("isLimit"	,"0");		
		organDao.insertSmpBorgs(borgMap);

		//사업장 등록
		saveMap.put("branchId", borgId);
		saveMap.put("branchCd", borgCd);
		organDao.insertRegSmpBranchs(saveMap);
		
		String userId = "";
		if("1".equals(saveMap.get("userSaveFlag").toString())) {
			//사용자, 권한 등록
			userId = seqMpUsersService.getNextStringId();
			saveMap.put("userId"	, userId);
			saveMap.put("isLogin"	, "1");
			saveMap.put("isUse"		, "1");
			organDao.insertSmpUser(saveMap);
	
			Map<String, Object> roleMap 	= new HashMap<String, Object>();
			String[] 			roleIdArr 	= (String[])saveMap.get("roleIdArr");
	
			roleMap.put("userId"			, userId);
			roleMap.put("borgId"			, borgId);
			roleMap.put("loginId"			, saveMap.get("loginId"));
			roleMap.put("borgsIsDefault"	, "1");
			organDao.insertBorgsUsers(roleMap);
			
			if(roleIdArr != null && roleIdArr.length > 0){
	
				for (int i = 0; i < roleIdArr.length; i++) {
					roleMap.put("roleId"		, roleIdArr[i]);
					roleMap.put("isDefault"		, "0");
					roleMap.put("borgScopeCd"	, organDao.selectSmpRoles(roleIdArr[i]).getBorgScopeCd());
					organDao.insertBorgsUsersRoles(roleMap);
				}
			}

		} else if("2".equals(saveMap.get("userSaveFlag").toString())) {		//기존사용자 등록
			Map<String, Object> roleMap 	= new HashMap<String, Object>();
			String[] 			roleIdArr 	= (String[])saveMap.get("roleIdArr");
	
			roleMap.put("userId"			, saveMap.get("userId").toString());
			roleMap.put("borgId"			, borgId);
			roleMap.put("loginId"			, saveMap.get("loginId"));
			roleMap.put("borgsIsDefault"	, "0");
			organDao.insertBorgsUsers(roleMap);
			
			if(roleIdArr != null && roleIdArr.length > 0){
	
				for (int i = 0; i < roleIdArr.length; i++) {
					roleMap.put("roleId"		, roleIdArr[i]);
					roleMap.put("isDefault"		, "0");
					roleMap.put("borgScopeCd"	, organDao.selectSmpRoles(roleIdArr[i]).getBorgScopeCd());
					organDao.insertBorgsUsersRoles(roleMap);
				}
			}
			
		}
		
		//배송처 등록
		/** 배송처 정보 파라미터 셋팅 **/
		String[] shippingPlaceArr 	 = (String[]) saveMap.get("shippingPlaceArr");
		String[] shippingPhoneNumArr = (String[]) saveMap.get("shippingPhoneNumArr");
		String[] shippingAddresArr 	 = (String[]) saveMap.get("shippingAddresArr");
		
		if(shippingPlaceArr != null && shippingPlaceArr.length > 0){
			for(int shipCnt = 0 ; shipCnt < shippingPlaceArr.length ; shipCnt++){
				
				saveMap.put("deliveryId"		, seqMpDeliveryInfoService.getNextStringId());
				saveMap.put("branchId"			, borgId);
				saveMap.put("shippingPlace"		, shippingPlaceArr[shipCnt]);
				saveMap.put("shippingAddres"	, shippingAddresArr[shipCnt]);
				saveMap.put("shippingPhoneNum"	, shippingPhoneNumArr[shipCnt]);
				saveMap.put("isDefault"			, shipCnt == 0 ? 1 : 0);
				
				/** 배송처 정보 Insert **/
				organDao.insertDeliveryInfo(saveMap);
			}
		}
		if("1".equals(saveMap.get("userSaveFlag").toString())) {
			// SMS/메일 발송여부 등록
			Map<String, Object> receiveMap = new HashMap<String, Object>();		// SMS, 메일 발송등록 Map
			receiveMap.put("userId"					,userId);
			receiveMap.put("isEmail"                ,"0");
			receiveMap.put("isSms"                  ,"1");
			receiveMap.put("emailByPurchase"        ,"0");
			receiveMap.put("emailByDelivery"        ,"0");
			receiveMap.put("emailByRegistergood"    ,"0");
			receiveMap.put("smsByPurchase"          ,"1");
			receiveMap.put("smsByDelivery"          ,"1");
			receiveMap.put("smsByRegistergood"      ,"1");
			receiveMap.put("emailByPurchaseorder"   ,"0");
			receiveMap.put("emailByOrdrtreceive"    ,"0");
			receiveMap.put("emailByNotiauction"		,"0");
			receiveMap.put("emailByNotisuccessbid"	,"0");
			receiveMap.put("smsByPurchaseorder"     ,"0");
			receiveMap.put("smsByOrdrtreceive"      ,"0");
			receiveMap.put("smsByNotiauction"       ,"0");
			receiveMap.put("smsByNotisuccessbid"	,"0");	
			
			organDao.insertSmpReceiveInfo(receiveMap);
		}
		
		//구매사에서 사업장 추가 생성시 	
		if(!borgCd.endsWith("0000001")){
			String clientNm = organDao.selectClientNm(saveMap.get("clientId").toString());
			//김철 과장에게 메일 송부
//			String mailSubject = "구매사 ["+clientNm+"]에서 사업장이 생성 되었습니다.";
//			String mailContent = "구매사 ["+clientNm+"]에서 사업장 ["+borgMap.get("borgNm").toString()+"] 가 생성 되었습니다.";
//			commonSvc.saveSendMail("bogeus@sk.com",mailSubject, mailContent);
			
			//공사유형 담당자에게 SMS 발송 (추가 요건사항 20160106 SUN)
			ModelMap params = new ModelMap();
			params.put("workId",  (String)saveMap.get("workId"));
			String workMngId = (String) generalDao.selectGernalObject("common.etc.selectWorkManagerIdByWorkId", params);//select공사유형담당자Id
			SmsEmailInfo workSendInfo = commonSvc.getUserSmsEmailInfoByUserId(workMngId);

			String smsMsg =  "구매사 ["+clientNm+"]에서 사업장 ["+borgMap.get("borgNm").toString()+"] 가(이) 생성 되었습니다";
			commonSvc.sendRightSms(workSendInfo.getMobileNum() , smsMsg);
			
		}

	}
	
	public SmpUsersDto selectOrganUserDetail(Map<String, Object> params) {
		return organDao.selectOrganUserDetail(params);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})	
	public void updateUserRolesIsDefault(Map<String, Object> saveMap) {
		organDao.updateUserRolesNoDefault(saveMap);
		organDao.updateUserRolesDefault(saveMap);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})	
	public void updateOrganUserDetail(Map<String, Object> saveMap) {
		organDao.updateSmpUser(saveMap);
		
		saveMap.put("isDefault"		,0);
		saveMap.put("isDefaultFlag"	,"N");
		organDao.setSmpBorgsUsersIsDefault(saveMap);
		
		saveMap.put("isDefault"		,1);
		saveMap.put("isDefaultFlag"	,"Y");
		organDao.setSmpBorgsUsersIsDefault(saveMap);
		
		// 5. SMS/메일 발송여부 등록
		int receiveCnt = organDao.smpReceiveInfoCnt(saveMap.get("userId").toString());
		if(receiveCnt == 0){
			organDao.insertSmpReceiveInfo(saveMap);		
		}else{
			organDao.updateSmpReceiveInfo(saveMap);
		}
		
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})	
	public void insertOrganUserDetail(Map<String, Object> saveMap) throws Exception{
		//사용자, 권한 등록
		String userId = seqMpUsersService.getNextStringId();
		saveMap.put("userId"	, userId);
		saveMap.put("isLogin"	, "1");
		organDao.insertSmpUser(saveMap);

		Map<String, Object> roleMap 	= new HashMap<String, Object>();
		String[] 			roleIdArr 		= (String[])saveMap.get("roleIdArr");
		String[] 			isDefaultArr 	= (String[])saveMap.get("isDefaultArr");

		roleMap.put("userId"			, userId);
		roleMap.put("borgId"			, saveMap.get("borgId"));
		roleMap.put("loginId"			, saveMap.get("loginId"));
		roleMap.put("borgsIsDefault"	, "0");
		organDao.insertBorgsUsers(roleMap);
		
		if(roleIdArr != null && roleIdArr.length > 0){

			for (int i = 0; i < roleIdArr.length; i++) {
				roleMap.put("roleId"		, roleIdArr[i]);
				roleMap.put("isDefault"		, isDefaultArr[i]);
				roleMap.put("borgScopeCd"	, organDao.selectSmpRoles(roleIdArr[i]).getBorgScopeCd());
				organDao.insertBorgsUsersRoles(roleMap);
			}
		}
		
		// SMS/메일 발송여부 등록
		int receiveCnt = organDao.smpReceiveInfoCnt(userId);
		if(receiveCnt == 0){
			organDao.insertSmpReceiveInfo(saveMap);		
		}
	}
	
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})	
	public void saveVendorReg(Map<String, Object> saveMap) throws Exception{
		/**	공급사 요청 파라미터 셋팅 **/
		String vendorId = seqMpBorgsService.getNextStringId();
		Map<String, Object> borgMap = new HashMap<String, Object>();		// 법인등록 Map
		borgMap.put("borgId"		, vendorId);
		borgMap.put("borgCd"		, "VEN" + vendorId);
		borgMap.put("borgNm"		, saveMap.get("vendorNm").toString());
		borgMap.put("topBorgId"		, "0");
		borgMap.put("parBorgId"		, "0");
		borgMap.put("borgLevel"		, "0");
		borgMap.put("borgTypeCd"	, "BCH");
		borgMap.put("svcTypeCd"		, "VEN");
		borgMap.put("groupId"		, "0");							 
		borgMap.put("clientId"		, "0");
		borgMap.put("branchId"		, "0");
		borgMap.put("deptId"		, "0");
		borgMap.put("remoteIp"		, saveMap.get("creatorRemoteIp").toString());
		borgMap.put("creatorId"		, saveMap.get("creatorUserId").toString());
		borgMap.put("isUse"			, "1");
		organDao.insertSmpBorgs(borgMap);		
		
		saveMap.put("vendorId"		, vendorId);		// 조직ID
		saveMap.put("vendorCd"		, "VEN"+vendorId);	// 공급사코드
		saveMap.put("loginAuthType"	, "20");			// 로그인인증 (20 : 일반)		
		/**	공급사 Insert **/		
		organDao.insertRegSmpVendors(saveMap);	

		//사용자, 권한 등록
		String userId = seqMpUsersService.getNextStringId();
		saveMap.put("userId"	, userId);
		saveMap.put("isLogin"	, "1");
		saveMap.put("isUse"		, "1");
		organDao.insertSmpUser(saveMap);

		Map<String, Object> roleMap 	= new HashMap<String, Object>();
		String[] 			roleIdArr 	= (String[])saveMap.get("roleIdArr");

		roleMap.put("userId"			, userId);
		roleMap.put("borgId"			, vendorId);
		roleMap.put("loginId"			, saveMap.get("loginId"));
		roleMap.put("borgsIsDefault"	, "1");
		organDao.insertBorgsUsers(roleMap);
		
		if(roleIdArr != null && roleIdArr.length > 0){

			for (int i = 0; i < roleIdArr.length; i++) {
				roleMap.put("roleId"		, roleIdArr[i]);
				roleMap.put("isDefault"		, "0");
				roleMap.put("borgScopeCd"	, organDao.selectSmpRoles(roleIdArr[i]).getBorgScopeCd());
				organDao.insertBorgsUsersRoles(roleMap);
			}
		}
		
		// SMS/메일 발송여부 등록
		Map<String, Object> receiveMap = new HashMap<String, Object>();		// SMS, 메일 발송등록 Map
		receiveMap.put("userId"					,userId);
		receiveMap.put("isEmail"                ,"1");
		receiveMap.put("isSms"                  ,"1");
		receiveMap.put("emailByPurchase"        ,"0");
		receiveMap.put("emailByDelivery"        ,"0");
		receiveMap.put("emailByRegistergood"    ,"0");
		receiveMap.put("smsByPurchase"          ,"0");
		receiveMap.put("smsByDelivery"          ,"0");
		receiveMap.put("smsByRegistergood"      ,"0");
		receiveMap.put("emailByPurchaseorder"   ,"1");
		receiveMap.put("emailByOrdrtreceive"    ,"1");
		receiveMap.put("emailByNotiauction"		,"1");
		receiveMap.put("emailByNotisuccessbid"	,"1");
		receiveMap.put("smsByPurchaseorder"     ,"1");
		receiveMap.put("smsByOrdrtreceive"      ,"1");
		receiveMap.put("smsByNotiauction"       ,"1");
		receiveMap.put("smsByNotisuccessbid"	,"1");	
		
		organDao.insertSmpReceiveInfo(receiveMap);				
		
	}
	
	public SmpVendorsDto selectVendorsDetail(String vendorId) {
		return organDao.selectVendorsDetail(vendorId);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})	
	public void updateVendorReg(Map<String, Object> saveMap) {
		organDao.updateSmpVendorsDetail(saveMap);
		//사용자정보 Update
//		saveMap.put("isUse"	, "1");
//		organDao.updateSmpUser(saveMap);		
		organDao.updateSmpBorgsIsUse(saveMap);
	}
	
	public SmpUsersDto selectVendorUserDetail (Map<String, Object> params) {
		return organDao.selectVendorUserDetail(params);
	}
	
	public List<SmpUsersDto> selectSmpDirectInfoList (Map<String, Object> params) {
		return organDao.selectSmpDirectInfoList(params);
	}
	
	public String[] sendComp(Map<String, Object> sendMap) throws Exception{
		JcoAdapter jcoAdapter = new JcoAdapter();
		Map<String, Object> param = new HashMap<String, Object>();
		
    	/*--------------------회원사가입---------------------*/
	    param.put("BUKRS"     , "SKTS"); 									// 회사 코드                                           
	    param.put("KTOKK"     , ""); 										// 공급업체 계정 그룹                                               
	    param.put("LIFNR"     , CommonUtils.lengthLimit(sendMap.get("businessNum").toString(), 10, null)); 	// 공급업체 사업자번호                                     
	    param.put("SORT1"     , ""); 										// 탐색용어1                                               
	    param.put("SORT2"     , ""); 										// 탐색용어2                                               
	    param.put("BANKS"     , "080"); 									// 은행 국가 키                                            
	    param.put("BANKL"     , CommonUtils.lengthLimit(sendMap.get("bankCd").toString(), 15, null));			// 은행 키                                             
	    param.put("BANKN"     , CommonUtils.lengthLimit(sendMap.get("accountNum").toString(), 18, null)); 		// 은행 계정 번호                                     
	    param.put("KOINH"     , CommonUtils.lengthLimit(sendMap.get("recipient").toString(), 10, null)); 		// 예금주명                                            
	    param.put("LAND1"     , ""); 										// 국가 키                                               
	    param.put("NAME1"     , CommonUtils.lengthLimit(sendMap.get("clientNm").toString(), 35, null));	 	// 이름 1                                       
	    param.put("ORT01"     , CommonUtils.lengthLimit(sendMap.get("addres").toString(), 35, null)); 			// 도시
	    param.put("PSTLZ"     , CommonUtils.lengthLimit(sendMap.get("postAddrNum").toString(), 10, null)); 	// 우편번호                     
	    param.put("STRAS"     , CommonUtils.lengthLimit(sendMap.get("addresDesc").toString(), 35, null)); 		// 번지 및 상세 주소                     
	    param.put("TELF1"     , CommonUtils.lengthLimit(sendMap.get("phoneNum").toString(), 16, null)); 		// 첫번째 전화번호                
	    param.put("TELFX"     , CommonUtils.lengthLimit(sendMap.get("faxNum").toString(), 31, null)); 			// 팩스번호                
	    param.put("SPRAS"     , ""); 										// 언어 키                            
	    param.put("STCD2"     , CommonUtils.lengthLimit(sendMap.get("businessNum").toString(), 11, null)); 	// 사업자등록번호                  
	    param.put("SMTP_ADDR" , CommonUtils.lengthLimit(sendMap.get("eMail").toString(), 100, null)); 			// 전자메일주소         
	    param.put("J_1KFREPRE", CommonUtils.lengthLimit(sendMap.get("pressentNm").toString(), 10, null)); 		// 대표자명          
	    param.put("J_1KFTBUS" , CommonUtils.lengthLimit(sendMap.get("bustClas").toString(), 30, null)); 		// 업태                
	    param.put("J_1KFTIND" , CommonUtils.lengthLimit(sendMap.get("bustType").toString(), 30, null)); 		// 종목                
	    param.put("AKONT"     , ""); 										// 총계정원장의 조정 계정                            
	    param.put("ZTERM"     , CommonUtils.lengthLimit(sendMap.get("payBillType").toString(), 4, null)); 	// 지급 조건 키(매입)                         
	    param.put("ZWELS"     , ""); 										// 지급 방법(매입)                            
	    param.put("ZTERM1"    , CommonUtils.lengthLimit(sendMap.get("payBillType").toString(), 4, null)); 	// 지급 조건 키(매출)                        
	    param.put("ZWELS1"    , ""); 										// 지급 방법(매출)                           
	    param.put("SPERR"     , ""); 										// 회사코드에 대해 전기보류 | 현재 사용안함                            
	    param.put("LOEVM"     , ""); 										// 마스터레코드에 대한 삭제 | 현재 사용안함                            
	    param.put("MSGTY"     , ""); 										// 메시지 유형                            
	    param.put("MSGLIN"    , ""); 										// 메시지 텍스트         
	    
	    List<Map<String, Object>> rfcResultList = jcoAdapter.callRfcTableParam("ZFI_MAST_03", param, "GT_0006");
	    Map<String, Object> resultMap = rfcResultList.get(0);	
	    String[] rtnArr = {resultMap.get("MSGTY").toString(),resultMap.get("MSGLIN").toString() }; 
	    
		return rtnArr;		
	}
	
	public String compDupCheck(String businessNum) throws Exception{
		JcoAdapter jcoAdapter = new JcoAdapter();
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("I_STCD2"    , businessNum);	//사업자 등록번호                                           
		jcoAdapter.callRfcString("ZFI_MAST_06", param, "O_FLAG");
//		Return Code		
//		1 : 사업자등록번호가 입력되지 않은 채로 I/F 된 경우
//		2 : 구매처 존재   / 고객 미존재
//		3 : 구매처 미존재 / 고객 존재
//		4 : 구매처 존재   / 고객 존재
//		5 : 구매처 미존재 / 고객 미존재
		return jcoAdapter.getReturnMessage();
	}
	
	public List<SmpUsersDto> getSmpBorgsUsersByUserId(String userId) {
		return organDao.getSmpBorgsUsersByUserId(userId);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})	
	public void updateReqSmpBranchs(Map<String, Object> saveMap) {
		organDao.updateReqSmpBranchs(saveMap);
	}
	
	/**
	 * 샵메일 등록 여부를 카운트 받음
	 */
	public int getSharpMailRegCheckCount(Map<String, Object> params) {
		int count = 0;
		if("VEN".equals(params.get("svcTypeCd").toString())){
			count = organDao.selectSharpMailVendorCount(params);
		}else if("BUY".equals(params.get("svcTypeCd").toString())){
			count = organDao.selectSharpMailBranchCount(params);
		}
		return count;
	}
	
	/**
	 * 샵메일 등록
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})	
	public void updateSharpMail(Map<String, Object> saveMap) {
		if("VEN".equals(saveMap.get("svcTypeCd").toString())){
			organDao.updateVendorSharpMail(saveMap);
		}else if("BUY".equals(saveMap.get("svcTypeCd").toString())){
			organDao.updateBranchsSharpMail(saveMap);
		}
	}

	
	/**
	 * menuCd를 검색
	 */
	public String getMenuCd(String menuId) {
		return organDao.selectMenuCd(menuId);
	}
	
	/**
	 * 공급사 등록요청시 첨부파일 수정
	 * @param saveMap
	 */
	public void updateReqSmpVendors(Map<String, Object> saveMap) {
		organDao.updateReqSmpVendors(saveMap);
	}
	
	/**
	 * 법인정보 수정
	 * @param params
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void updateCorporationInfo(Map<String, Object> params) {
		String isUseTemp = (String)params.get("isUse");
		isUseTemp = CommonUtils.getString(isUseTemp);
        String tmpBorgId = (String)params.get("borgId");
		organDao.updateCorporationInfo(params);
		String isPrepayTemp = (String)params.get("isPrepay");
		String isLimitTemp = (String)params.get("isLimit");
		if("0".equals(isUseTemp)){
			// 법인 정보중 사용 여부가 N 이 왔을 경우 해당 법인 이하 사업장도 종료 시킨다.
			params.clear();
			params.put("clientid", tmpBorgId);
            List<Map<String, Object>> branchsList = organDao.selectCorporationBranches(params);
            for(Map<String, Object> branchesMap : branchsList){
            	branchesMap.put("closeReason", "법인 종료로 인한 사업장 종료.");
            	organDao.updateBranchsClose(branchesMap);
            	// 사업장 종료 후 해당 사업장 이하 사용자도 종료 처리 함.
                params.clear();
                params.put("borgid", branchesMap.get("BRANCHID"));
                List<Map<String, Object>> b_userList = organDao.selectCorporationBranchesUsersList(params);
                for(Map<String, Object> b_userMap : b_userList){
                    String userIdTemp = (String)b_userMap.get("USERID");
                    organDao.updateUserStatusByUserId(userIdTemp);
                }
            }
		}
		if("1".equals(isPrepayTemp)){
			// 법인 정보 중 선입금여부가 Y 일 경우 해당 법인 이하 사업장도 선입금여부를 Y 로 수정함.
			params.clear();
			params.put("clientid", tmpBorgId);
            List<Map<String, Object>> branchsList = organDao.selectCorporationBranches(params);
            for(Map<String, Object> branchesMap : branchsList){
            	branchesMap.put("isPrepay", isPrepayTemp);
            	organDao.updateBranchsPrepay(branchesMap);
            }
		}
		if("1".equals(isLimitTemp)){
			// 법인 정보 중 주문제한여부가 Y 일 경우 해당 법인 이하 사업장도 선입금여부를 Y 로 수정함.
			params.clear();
			params.put("clientid", tmpBorgId);
            List<Map<String, Object>> branchsList = organDao.selectCorporationBranches(params);
            for(Map<String, Object> branchesMap : branchsList){
            	branchesMap.put("isLimit", isLimitTemp);
            	organDao.updateBranchsLimit(branchesMap);
            }
		}
	}

	public void insertClientInfo(Map<String, Object> saveMap) throws Exception {
		int borgCdCnt = organDao.selectBorgCdCnt((String)saveMap.get("borgCd"));
		if(borgCdCnt>0) { throw new Exception("입력하신 조직코드는 이미 등록되어 있습니다."); }
		saveMap.put("borgId", seqMpBorgsService.getNextStringId());
		organDao.insertClientInfo(saveMap);
	}
	
	public String getYnToZeroOne(String str) {
		String returnStr = "";
		if(str != null && "".equals(str) == false ){
			if("Y".equals(str)){
				returnStr = "1";
			}else{
				returnStr = "0";
			}
		}
		return returnStr;
	}

	public SmpBranchsDto organBranchSearchForReg(String clientId) {
		return organDao.organBranchSearchForReg(clientId);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})	
	public void updateSmpBranchNm(HashMap<String, Object> saveMap) throws Exception{
		organDao.updateSmpBorgsNm(saveMap);
		organDao.updateSmpBranchsNm(saveMap);
	}

	public List<Map<String, Object>> getVenEvaluationList(Map<String, Object> params) {
		List<Map<String,Object>> list = organDao.selectVenEvaluationList(params);
		
		if( list != null && list.size() > 0  ){
			List<Map<String,Object>> stats = organDao.selectVenEvaluationStats(params);
			int i=0;
			for (Map<String,Object> map : stats){
				list.add(i++,map);			//add 총계,통계 row
			}
		}
		
		return list;
	}
	public List<Map<String, Object>> getVenEvaluationExcel(Map<String, Object> params) {
		List<Map<String,Object>> list = organDao.selectVenEvaluationExcel(params);
		if( list != null && list.size() > 0  ){
			List<Map<String,Object>> stats = organDao.selectVenEvaluationStatsExcel(params);
			int i=0;
			for (Map<String,Object> map : stats){
				list.add(i++,map);			//add 총계,통계 row
			}
		}
		return list;
	}
}
