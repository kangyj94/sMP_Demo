package kr.co.bitcube.quality.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.SmsEmailInfo;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.quality.dao.QualityDao;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import crosscert.Hash;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class QualitySvc {
	@SuppressWarnings("unused")
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private QualityDao qualityDao;
	
	@Autowired
	private GeneralDao generalDao;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Resource(name="seqMpQuality")
	private EgovIdGnrService seqMpQuality;
	
	/**
	 * 품질관리 업로드 파일 insert
	 * @param saveMap
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void qualityFileSave(Map<String, Object> saveMap) throws Exception{
		String kind = CommonUtils.getString(saveMap.get("kind"));
		String qualitySeq = seqMpQuality.getNextStringId();
		saveMap.put("qualitySeq", qualitySeq);
		qualityDao.qualityFileSave(kind, saveMap);	
	}

	/** * 소싱공급사 저장 
	 * @param userInfoDto */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public String saveSourcingVenInfo(Map<String, Object> saveMap, LoginUserDto userInfoDto) {
		String errMsg 				= "";
		String businessnum 			= CommonUtils.getString(saveMap.get("businessnum")) ;
		String sourcingid 			= CommonUtils.getString(saveMap.get("sourcingid")) ;
		String sourcingdesc 		= CommonUtils.getString(saveMap.get("sourcingdesc")) ;
		Map<String , Object> pMap	= null;
		
		if( "".equals(businessnum) == true || "".equals(sourcingid) == true ){
			errMsg = "사업자 번호나 소싱정보가 없습니다.";
		}
		if("".equals(errMsg)){
			// 기존에 등록된 정보가 있는지 조회 (존재하면 update, 없으면 insert)
			Map<String, Object> svMap = new HashMap<String, Object>();
			svMap.put("businessnum", businessnum);
			svMap.put("sourcingid", sourcingid);
			svMap = qualityDao.selectSourcingVendorExists(svMap);	
			pMap = new HashMap<String, Object>();
			if(svMap != null){
                pMap.put("businessnum"	, CommonUtils.getString(svMap.get("BUSINESSNUM")));
                pMap.put("sourcingid"	, CommonUtils.getString(svMap.get("SOURCINGID")));
                pMap.put("sourcingdesc"	, sourcingdesc);
                pMap.put("regid"		, userInfoDto.getUserId());
				qualityDao.updateSourcingVendor(pMap);	
			}else{
                pMap.put("businessnum"	, businessnum);
                pMap.put("sourcingid"	, sourcingid);
                pMap.put("sourcingdesc"	, sourcingdesc);
                pMap.put("regid"		, userInfoDto.getUserId());
				qualityDao.insertSourcingVendor(pMap);	
			}
		}
		return errMsg;
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public String saveQualityTestInfo(Map<String, Object> saveMap, LoginUserDto userInfoDto) {
		String errMsg 			= "";
		String lftd_kind 		= CommonUtils.getString(saveMap.get("lftd_kind"));
		if("L".equals(lftd_kind)){
			qualityDao.updateSourcingVendorLabTest(saveMap);
		}else if("F".equals(lftd_kind)){
			qualityDao.updateSourcingVendorFieldTest(saveMap);
		}else{
			errMsg = "처리중 오류가 발생하였습니다(1)";
		}
		return errMsg;
	}	
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public String saveBmtFinalReqInfo(Map<String, Object> saveMap, LoginUserDto userInfoDto) {
		String errMsg = "";
		String kind 			= CommonUtils.getString(saveMap.get("final_kind"));
		String sourcingId 		= CommonUtils.getString(saveMap.get("final_mst_sourcingId"));
		String businessnum 		= CommonUtils.getString(saveMap.get("final_mst_businissnum"));
		String final_yn 		= CommonUtils.getString(saveMap.get("btmFinal_yn"));
		String final_gradefile 	= CommonUtils.getString(saveMap.get("final_file_seq1"));
		String final_appid1 	= CommonUtils.getString(saveMap.get("final_1stApprUserId"));
		String final_appid2 	= CommonUtils.getString(saveMap.get("final_2ndApprUserId"));
		String final_reqid 		= userInfoDto.getUserId();
		String final_reqkind 	= "";
		
		if("T".equals(kind)){
			final_reqkind = "0";
		}else if("S".equals(kind)){
			if("90".equals(final_yn)){
				final_reqkind = "10";
			}else if("99".equals(final_yn)){
				final_reqkind = "19";
			}
		}
		if("".equals(final_reqkind) ){ 	errMsg += "1"; }
		if("".equals(sourcingId) ){ 	errMsg += "2"; }
		if("".equals(businessnum) ){ 	errMsg += "3"; }
		if("".equals(final_yn) ){ 		errMsg += "4"; }
		if("".equals(final_appid1) ){ 	errMsg += "5"; }
//		if("".equals(final_appid2) ){ 	errMsg += "6"; }
		
		if("".equals(errMsg) == true){ // 오류 없음을 의미
			Map<String, Object> saveParamMap = new HashMap<String, Object>();
			saveParamMap.put("sourcingId"		, sourcingId);
			saveParamMap.put("businessnum"		, businessnum);
			saveParamMap.put("final_yn"			, final_yn);
			saveParamMap.put("final_gradefile"	, final_gradefile);
			saveParamMap.put("final_appid1"		, final_appid1);
			saveParamMap.put("final_appid2"		, final_appid2);
			saveParamMap.put("final_reqid"		, final_reqid);
			saveParamMap.put("final_reqkind"	, final_reqkind);
			qualityDao.updateSourcingFinalInfo(saveParamMap);
			
			//승인요청 일 경우 1차 승인자 SMS발송
			if("S".equals(kind)){
				//1차 승인자 휴대폰 번호 조회
				SmsEmailInfo smsInfo = commonSvc.getUserSmsEmailInfoByUserId(final_appid1);
				commonSvc.sendRightSms(smsInfo.getMobileNum(), "BMT 승인 요청 드립니다.");
			}
		}else{
			errMsg = "처리중 오류가 발생했습니다.("+errMsg+")";
		}
		return errMsg;
	}
	
	/** 품질관리 > 공급사 상태 변경.*/
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public String updateQualityVenStatus(Map<String, Object> saveMap, LoginUserDto userInfoDto) {
		String errMsg 		= "";
		String qualityid 	= CommonUtils.getString(saveMap.get("qualityid"));
		String qualityyyyy 	= CommonUtils.getString(saveMap.get("qualityyyyy"));
		String sourcingid 	= CommonUtils.getString(saveMap.get("sourcingid"));
		String businessnum 	= CommonUtils.getString(saveMap.get("businessnum"));
		String vendorStatus = CommonUtils.getString(saveMap.get("vendorStatus"));
		if( "".equals(qualityid) == true){ 		errMsg += "1"; }
		if( "".equals(qualityyyyy) == true){ 	errMsg += "2"; }
		if( "".equals(sourcingid) == true){ 	errMsg += "3"; }
		if( "".equals(businessnum) == true){ 	errMsg += "4"; }
		if( "".equals(vendorStatus) == true){ 	errMsg += "5"; }
		if("".equals(errMsg) == true){
			qualityDao.updateQualityVenStatus(saveMap);
		}else{
			errMsg = "처리중 오류가 발생하였습니다.("+errMsg+")";
		}
		return errMsg;
	}
	
	/** 검사 정보 저장 * @throws Exception */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public String saveQualityReqInfo(Map<String, Object> saveMap, LoginUserDto userInfoDto) throws Exception {
		String errMsg 			= "";
		String saveKind         =  CommonUtils.getString(saveMap.get("saveKind"		));
		String quarter_kind     =  CommonUtils.getString(saveMap.get("quarter_kind"	));
		String purpose          =  CommonUtils.getString(saveMap.get("purpose"		));
		String qualityyn        =  CommonUtils.getString(saveMap.get("qualityyn"	)	);
		String qualitydate      =  CommonUtils.getString(saveMap.get("qualitydate"	));
		String resultfile       =  CommonUtils.getString(saveMap.get("resultfile"	)    );
		String gradefile        =  CommonUtils.getString(saveMap.get("gradefile"	)	);
		String qualitydesc      =  CommonUtils.getString(saveMap.get("qualitydesc"	));
		String reqid            =  CommonUtils.getString(saveMap.get("reqid"		)	);
		String appid1           =  CommonUtils.getString(saveMap.get("appid1"		)    );
		String appid2           =  CommonUtils.getString(saveMap.get("appid2"		)    );
		String sourcingId       =  CommonUtils.getString(saveMap.get("sourcingId"	)    );
		String businissnum      =  CommonUtils.getString(saveMap.get("businissnum"	));
		String qualityid        =  CommonUtils.getString(saveMap.get("qualityid"	)	);
		String qualityyyyy      =  CommonUtils.getString(saveMap.get("qualityyyyy"	));
		String quality_part_seq =  CommonUtils.getString(saveMap.get("quality_part_seq"	));
		String reqKind          =  "";
		
		if( "".equals(saveKind) == true){ 		errMsg += "1"; }
		if( "".equals(quarter_kind) == true){ 	errMsg += "2"; }
		if( "".equals(purpose) == true){ 		errMsg += "3"; }
		if( "".equals(qualityyn) == true){ 		errMsg += "4"; }
		if( "".equals(qualitydate) == true){ 	errMsg += "5"; }
		if( "".equals(appid1) == true){ 		errMsg += "6"; }
//		if( "".equals(appid2) == true){ 		errMsg += "7"; }
		if( "".equals(sourcingId) == true){ 	errMsg += "8"; }
		if( "".equals(businissnum) == true){ 	errMsg += "9"; }
		if( "".equals(qualityid) == true){ 		errMsg += "A"; }
		if( "".equals(qualityyyyy) == true){ 	errMsg += "B"; }
		if( "".equals(errMsg) == true){
			if("T".equals(saveKind)){
				reqKind = "0";
			}else if("S".equals(saveKind)){
				if("90".equals(qualityyn)){
					reqKind = "10";
				}else if("99".equals(qualityyn)){
					reqKind = "19";
				}
			}
			
			// 등록/ 수정 처리
			if("".equals(quality_part_seq) == true){
                logger.debug("============		insert		===============");
				// 품질검사 값이 없으면 새로 등록을 의미한다.
				quality_part_seq = seqMpQuality.getNextStringId();
                // smpqualityvendor 테이블에 분기별 컬럼에 키값을 저장한다.
                Map<String , Object> sqvMap = new HashMap<String, Object>(); // SmpQualityVendor Map
                sqvMap.put("quarter_kind"		, quarter_kind);
                sqvMap.put("quality_part_seq"	, quality_part_seq);
                sqvMap.put("qualityid"			, qualityid);
                sqvMap.put("qualityyyyy"		, qualityyyyy);
                sqvMap.put("sourcingid"			, sourcingId);
                sqvMap.put("businissnum"		, businissnum);
                logger.debug("updateQualityvendorInfo : "+sqvMap.toString());
                qualityDao.updateQualityvendorInfo(sqvMap);
                // smpqualityCheck 테이블에 정보를 저장한다.
                Map<String , Object> sqcMap = new HashMap<String, Object>(); // SmpQualityCheck Map
                sqcMap.put("quality_part_seq"	, quality_part_seq);
                sqcMap.put("purpose"			, purpose);
                sqcMap.put("qualityyn"			, qualityyn);
                sqcMap.put("qualitydate"		, qualitydate);
                sqcMap.put("resultfile"			, resultfile);
                sqcMap.put("gradefile"			, gradefile);
                sqcMap.put("qualitydesc"		, qualitydesc);
                sqcMap.put("reqid"				, reqid);
                sqcMap.put("reqkind"			, reqKind);
                sqcMap.put("appid1"				, appid1);
                sqcMap.put("appid2"				, appid2);
                logger.debug("insertQualityChkInfo : "+sqcMap.toString());
                qualityDao.insertQualityChkInfo(sqcMap);
			}else{
                logger.debug("============		update		===============");
				// smpqualityCheck 테이블에 정보를 수정한다.
                Map<String , Object> sqcMap = new HashMap<String, Object>(); // SmpQualityCheck Map
                sqcMap.put("quality_part_seq"	, quality_part_seq);
                sqcMap.put("purpose"			, purpose);
                sqcMap.put("qualityyn"			, qualityyn);
                sqcMap.put("qualitydate"		, qualitydate);
                sqcMap.put("resultfile"			, resultfile);
                sqcMap.put("gradefile"			, gradefile);
                sqcMap.put("qualitydesc"		, qualitydesc);
                sqcMap.put("reqid"				, reqid);
                sqcMap.put("reqkind"			, reqKind);
                sqcMap.put("appid1"				, appid1);
                sqcMap.put("appid2"				, appid2);
                logger.debug("updateQualityChkInfo : "+sqcMap.toString());
				qualityDao.updateQualityChkInfo(sqcMap);
			}
			
			//승인요청 일 경우 1차 승인자 SMS발송
			if("S".equals(saveKind)){
				//1차 승인자 휴대폰 번호 조회
				SmsEmailInfo smsInfo = commonSvc.getUserSmsEmailInfoByUserId(appid1);
				commonSvc.sendRightSms(smsInfo.getMobileNum(), "품질관리 승인 요청 드립니다.");
			}			
			
		}else{
			errMsg = "처리중 오류가 발생하였습니다.("+errMsg+")";
		}
		logger.debug("errMsg : "+errMsg);
		return errMsg;
	}
	
	/** VOC 등록 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void vocRegist(Map<String, Object> saveMap) throws Exception {
		saveMap.put("vocId", seqMpQuality.getNextStringId());
		qualityDao.insertVoc(saveMap);	
	}

	/** VOC 조치 
	 * @return */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public String saveVocProcInfo(Map<String, Object> saveMap) {
		String reqKind 			= "0";
		String treatresult		=	CommonUtils.getString(saveMap.get("treatresult"));
		String judgmentresult	=	CommonUtils.getString(saveMap.get("judgmentresult"));
		String measureresult	=	CommonUtils.getString(saveMap.get("measureresult"));
		String kind				=	CommonUtils.getString(saveMap.get("kind"));
		String appUserId1		=	CommonUtils.getString(saveMap.get("appUserId1"));

		String errMsg = "";
		if( "".equals(treatresult) == true) 		errMsg += "1"; 
		if( "".equals(judgmentresult) == true) 		errMsg += "2"; 
		if( "30".equals(judgmentresult) == true) 		
			if( "".equals(measureresult) == true) 	errMsg += "3"; 
		if("A".equals(kind))	
			if("".equals(appUserId1))				errMsg += "4";
		
		if("".equals(errMsg) == true){
			// update 로 사용자가 입력한 정보를 저장함.
			logger.debug("============\t\t\t saveVocProcInfo start!!!\t\t\t===================");
			logger.debug("param : "+saveMap.toString());
			
			if("A".equals(kind))	reqKind = "10";	//승인	
			
			saveMap.put("reqKind", reqKind);
            this.qualityDao.saveVocProcInfo(saveMap);
            
            if("A".equals(kind)){
				//1차 승인자 휴대폰 번호 조회
				SmsEmailInfo smsInfo = commonSvc.getUserSmsEmailInfoByUserId(appUserId1);
				commonSvc.sendRightSms(smsInfo.getMobileNum(), "VOC 승인 요청 드립니다.");            	
            }
            
		}else{
			errMsg = "처리중 오류가 발생하였습니다.("+errMsg+")";
		}
		return errMsg;
	}

	/** BMT 결재 승인/반려 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setSourcingApproval(HashMap<String, Object> saveMap) throws Exception {
		
		String kind				= CommonUtils.getString(saveMap.get("kind"));	
		String finalYn			= CommonUtils.getString(saveMap.get("finalYn"));	
		String bmt2ndApprUserId	= CommonUtils.getString(saveMap.get("bmt2ndApprUserId"));
		
		if("A".equals(kind)){
			saveMap.put("kind", "10");
			saveMap.put("reqKind", finalYn);
		}else{
			saveMap.put("kind", "20");
			if("90".equals(finalYn)){
				saveMap.put("reqKind", "20");	
			}else{
				saveMap.put("reqKind", "29");
			}
		}
		this.qualityDao.setSourcingApproval(saveMap);
		
		if(!"".equals(bmt2ndApprUserId) && "A".equals(kind)){
			SmsEmailInfo smsInfo = commonSvc.getUserSmsEmailInfoByUserId(bmt2ndApprUserId);
			commonSvc.sendRightSms(smsInfo.getMobileNum(), "BMT 승인 요청 드립니다.");
		}
	}
	
	/** 품질관리 결재 승인/반려 */	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setQualityApproval(HashMap<String, Object> saveMap) throws Exception {
		
		String kind					= CommonUtils.getString(saveMap.get("kind"));	
		String qualityYn			= CommonUtils.getString(saveMap.get("qualityYn"));	
		String quality2ndApprUserId	= CommonUtils.getString(saveMap.get("quality2ndApprUserId"));	
		
		if("A".equals(kind)){
			saveMap.put("kind", "10");
			saveMap.put("reqKind", qualityYn);
		}else{
			saveMap.put("kind", "20");
			if("90".equals(qualityYn)){
				saveMap.put("reqKind", "20");	
			}else{
				saveMap.put("reqKind", "29");
			}
		}
		this.qualityDao.setQualityApproval(saveMap);
		
		if(!"".equals(quality2ndApprUserId) && "A".equals(kind)){
			SmsEmailInfo smsInfo = commonSvc.getUserSmsEmailInfoByUserId(quality2ndApprUserId);
			commonSvc.sendRightSms(smsInfo.getMobileNum(), "품질관리 승인 요청 드립니다.");
		}
		
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void saveTransBmtData(String userId) throws Exception {
		//품질관리 정보 조회
		String qualityYYYY = CommonUtils.getCurrentDate().substring(0, 4);
		
		List<Map<String, Object>> tList = this.qualityDao.selectSourcingTarget(qualityYYYY);	
		
		if(tList != null && tList.size() > 0){
			//BMT기준 생성해야할 정보 Insert to SMPQUALITY
			for(Map<String, Object> targetMap : tList){
				targetMap.put("QUALITYID"	, seqMpQuality.getNextStringId());
				targetMap.put("QUALITYYYYY"	, qualityYYYY);
				targetMap.put("USERID"		, userId);
				this.qualityDao.insertQuality(targetMap);
			}
		}
		
		//품질관리 공급사 조회
		tList = this.qualityDao.selectSourcingVendorTarget(qualityYYYY);	
		
		if(tList != null && tList.size() > 0){
			//BMT기준 생성해야할 정보 Insert to SMPQUALITYVENDOR
			for(Map<String, Object> targetMap : tList){
				targetMap.put("USERID"		, userId);
				this.qualityDao.insertQualityVendor(targetMap);
			}
		}
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void saveRegSourcing(Map<String, Object> params) throws Exception {
		params.put("sourcingId", seqMpQuality.getNextStringId());
		this.qualityDao.insertSourcing(params);
		
		if(!"".equals(CommonUtils.getString(params.get("sRegFileSeq")))){
			params.put("kind"		, "S");
			params.put("attach_seq"	, CommonUtils.getString(params.get("sRegFileSeq")));
			this.qualityFileSave(params);
		}
		
		if(!"".equals(CommonUtils.getString(params.get("pRegFileSeq")))){
			params.put("kind"		, "P");
			params.put("attach_seq"	, CommonUtils.getString(params.get("pRegFileSeq")));
			this.qualityFileSave(params);
		}
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void saveTransBmtRowData(ModelMap params) throws Exception {
		params.put("qualityId"	, seqMpQuality.getNextStringId());
		params.put("qualityYYYY", CommonUtils.getCurrentDate().substring(0, 4));
		generalDao.updateGernal("quality.insertQualityMaster", params);
		generalDao.updateGernal("quality.insertQualityDetail", params);
	}

	public void saveTransQualityData() {
		String stdQualityYYYY = CommonUtils.getCustomDay("YEAR", -1).substring(0, 4);
		String curQualityYYYY = CommonUtils.getCurrentDate().substring(0, 4);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("stdQualityYYYY"	, stdQualityYYYY);
		params.put("curQualityYYYY"	, curQualityYYYY);
		generalDao.updateGernal("quality.insertTransQualityMaster", params);
		generalDao.updateGernal("quality.insertTransQualityDetail", params);
	}
	
	/** VOC 결재 승인/반려 */	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setVocApproval(HashMap<String, Object> saveMap) throws Exception {
		
		String kind			= CommonUtils.getString(saveMap.get("kind"));	
		String vocUserId	= CommonUtils.getString(saveMap.get("vocUserId"));	
		
		if("A".equals(kind)){
			saveMap.put("kind", "10");
			saveMap.put("reqKind", "90");
		}else{
			saveMap.put("kind", "20");
			saveMap.put("reqKind", "20");
		}
		
		this.qualityDao.setVocApproval(saveMap);
		
		if(!"".equals(vocUserId) && "A".equals(kind)){
			SmsEmailInfo smsInfo = commonSvc.getUserSmsEmailInfoByUserId(vocUserId);
			commonSvc.sendRightSms(smsInfo.getMobileNum(), "VOC 승인 요청 드립니다.");
		}		
	}	
}
