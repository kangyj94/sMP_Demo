package kr.co.bitcube.quality.controller;


import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.adjust.service.AdjustSvc;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.quality.service.QualitySvc;

import org.apache.commons.collections.iterators.EntrySetMapIterator;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import sun.font.LayoutPathImpl.EndType;

@Controller
@RequestMapping("quality")
public class QualityCtl {
	
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private QualitySvc qualitySvc;

	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired
	private AdjustSvc adjustSvc;
	
	@Autowired
	private GeneralDao generalDao;
	
	
	
	@RequestMapping("bmtManage.sys")
	public ModelAndView bmtManage(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("quality/bmtManage");
		return modelAndView;
	}

	/**
	 * 품질관리 업로드 파일 insert
	 * @param branchId
	 * @param branchNm
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("qualityFileSave.sys")
	public ModelAndView qualityFileSave(
			@RequestParam(value = "kind"	 	, required = true)	String kind,		// kind
			@RequestParam(value = "attach_seq"	, required = true)	String attach_seq,	// attach_seq
			@RequestParam(value = "sourcingId"	, required = true) 	String sourcingId,	// sourcingId
		HttpServletRequest request, ModelAndView modelAndView) throws Exception {
	
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("kind"		, kind);
		saveMap.put("attach_seq", attach_seq);
		saveMap.put("sourcingId", sourcingId);
		saveMap.put("regId"		, userInfoDto.getUserId());
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			qualitySvc.qualityFileSave(saveMap);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;			
	}
	
	/** 소싱 공급사 등록/ 수정 */
	@RequestMapping("saveSourcingVenInfo.sys")
	public ModelAndView saveSourcingVenInfo(
			@RequestParam(value = "businessnum", required = true) String businessnum, 				// 사업자번호
			@RequestParam(value = "sourcingid", required = true) String sourcingid,					// 소싱명
			@RequestParam(value = "sourcingdesc", required = true) String sourcingdesc,				// 공급사 참조사항
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("businessnum", businessnum);
		saveMap.put("sourcingid", sourcingid);
		saveMap.put("sourcingdesc", sourcingdesc);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		String errMsg = "";
		try {
			errMsg = this.qualitySvc.saveSourcingVenInfo(saveMap,userInfoDto);
			if("".equals(errMsg) == false){ // 리턴된 에러메시지가 있다면.
				throw new Exception();
			}
		} catch(Exception e) {
			errMsg = "".equals(errMsg) ? "처리중 오류가 발생했습니다." : errMsg;
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(errMsg);	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/** 
	 * lab test, field test 저장
	 * @param lftd_kind
	 * @param lftd_purpose
	 * @param lftd_yn
	 * @param lftd_sdate
	 * @param lftd_edate
	 * @param lftd_file_seq1
	 * @param lftd_file_seq2
	 * @param lftd_desc
	 * @param lftd_sourcingid
	 * @param lftd_businessnum
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("saveQualityTestInfo.sys")
	public ModelAndView saveQualityTestInfo(
			@RequestParam(value = "lftd_kind"		, required = true) String lftd_kind, 				
			@RequestParam(value = "lftd_purpose"	, required = true) String lftd_purpose, 				
			@RequestParam(value = "lftd_yn"			, required = true) String lftd_yn, 				
			@RequestParam(value = "lftd_sdate"		, required = true) String lftd_sdate, 				
			@RequestParam(value = "lftd_edate"		, required = true) String lftd_edate, 				
			@RequestParam(value = "lftd_file_seq1"	, defaultValue="") String lftd_file_seq1, 				
			@RequestParam(value = "lftd_file_seq2"	, defaultValue="") String lftd_file_seq2, 				
			@RequestParam(value = "lftd_desc"		, defaultValue="") String lftd_desc, 				
			@RequestParam(value = "lftd_sourcingid"	, defaultValue="") String lftd_sourcingid, 				
			@RequestParam(value = "lftd_businessnum", defaultValue="") String lftd_businessnum, 				
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("lftd_kind"		, lftd_kind);
		saveMap.put("lftd_purpose"	, lftd_purpose);
		saveMap.put("lftd_yn"		, lftd_yn);
		saveMap.put("lftd_sdate"	, lftd_sdate);
		saveMap.put("lftd_edate"	, lftd_edate);
		saveMap.put("lftd_file_seq1", lftd_file_seq1);
		saveMap.put("lftd_file_seq2", lftd_file_seq2);
		saveMap.put("lftd_desc"		, lftd_desc);
		saveMap.put("lftd_sourcingid", lftd_sourcingid);
		saveMap.put("lftd_businessnum", lftd_businessnum);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		String errMsg = "";
		try {
			errMsg = this.qualitySvc.saveQualityTestInfo(saveMap,userInfoDto);
			if("".equals(errMsg) == false){ // 리턴된 에러메시지가 있다면.
				throw new Exception();
			}
		} catch(Exception e) {
			errMsg = "".equals(errMsg) ? "처리중 오류가 발생했습니다." : errMsg;
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(errMsg);	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 최종정보 요청자 정보 저장
	 * @param final_kind
	 * @param final_mst_sourcingId
	 * @param final_mst_businissnum
	 * @param btmFinal_yn
	 * @param final_file_seq1
	 * @param final_1stApprUserId
	 * @param final_mst_sourcingId
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("saveBmtFinalReqInfo.sys")
	public ModelAndView saveBmtFinalReqInfo(
			@RequestParam(value = "final_kind"				, required = true) String final_kind, 				
			@RequestParam(value = "final_mst_sourcingId"	, required = true) String final_mst_sourcingId, 				
			@RequestParam(value = "final_mst_businissnum"	, required = true) String final_mst_businissnum, 				
			@RequestParam(value = "btmFinal_yn"				, required = true) String btmFinal_yn, 				
			@RequestParam(value = "final_file_seq1"			, defaultValue="") String final_file_seq1, 				
			@RequestParam(value = "final_1stApprUserId"		, required = true) String final_1stApprUserId, 				
			@RequestParam(value = "final_2ndApprUserId"		, defaultValue="") String final_2ndApprUserId, 				
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("final_kind"			, final_kind);
		saveMap.put("final_mst_sourcingId"	, final_mst_sourcingId);
		saveMap.put("final_mst_businissnum"	, final_mst_businissnum);
		saveMap.put("btmFinal_yn"			, btmFinal_yn);
		saveMap.put("final_file_seq1"		, final_file_seq1);
		saveMap.put("final_1stApprUserId"	, final_1stApprUserId);
		saveMap.put("final_2ndApprUserId"	, final_2ndApprUserId);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		String errMsg = "";
		try {
			errMsg = this.qualitySvc.saveBmtFinalReqInfo(saveMap,userInfoDto);
			if("".equals(errMsg) == false){ // 리턴된 에러메시지가 있다면.
				throw new Exception();
			}
		} catch(Exception e) {
			errMsg = "".equals(errMsg) ? "처리중 오류가 발생했습니다." : errMsg;
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(errMsg);	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/** 품질관리 결재 */
	@RequestMapping("qualityApprovalList.sys")
	public ModelAndView qualityApprovalList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("quality/qualityApprovalList");
		return modelAndView;
	}
	
	@RequestMapping("qualityManage.sys")
	public ModelAndView qualityManage(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("quality/qualityManage");
		modelAndView.addObject("qualityStdList"	, commonSvc.getCodeList("SMPITEM_QUALITYSTD", 1));
		modelAndView.addObject("adminUserList"	, adjustSvc.getAdjustAlramUserList());
		return modelAndView;
	}	
	
	
	@RequestMapping("qualityEval.sys")
	public ModelAndView qualityEval(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("quality/qualityEval");
		return modelAndView;
	}

	
	/** 품질관리현황 > 공급사 상태 수정. */
	@RequestMapping("updateQualityVenStatus.sys")
	public ModelAndView updateQualityVenStatus(
			@RequestParam(value = "qualityid"		, required = true) String qualityid, 				// 품질관리순번
			@RequestParam(value = "qualityyyyy"		, required = true) String qualityyyyy, 				// 관리년월
			@RequestParam(value = "sourcingid"		, required = true) String sourcingid, 				// 소싱관리순번
			@RequestParam(value = "businessnum"		, required = true) String businessnum, 				// 공급사 사업자 등록번호
			@RequestParam(value = "vendorStatus"	, required = true) String vendorStatus, 			// 공급사 상태
			@RequestParam(value = "changeDesc"		, defaultValue="") String changeDesc, 				// 변경사유
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("qualityid"		, qualityid);
		saveMap.put("qualityyyyy"	, qualityyyyy);
		saveMap.put("sourcingid"	, sourcingid);
		saveMap.put("businessnum"	, businessnum);
		saveMap.put("vendorStatus"	, vendorStatus);
		saveMap.put("changeDesc"	, changeDesc);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		String errMsg = "";
		try {
			errMsg = this.qualitySvc.updateQualityVenStatus(saveMap,userInfoDto);
			if("".equals(errMsg) == false){ // 리턴된 에러메시지가 있다면.
				throw new Exception();
			}
		} catch(Exception e) {
			errMsg = "".equals(errMsg) ? "처리중 오류가 발생했습니다." : errMsg;
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(errMsg);	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	
	/** 품질관리현황 > 품질검사실시 */
	@RequestMapping("saveQualityReqInfo.sys")
	public ModelAndView saveQualityReqInfo(
			@RequestParam(value = "saveKindTmp"				, required = true) String saveKindTmp, 			// 저장유형 (T : 임시, S : 승인요청)
			@RequestParam(value = "quality_kind"			, required = true) String quality_kind, 		// 1~4분기(1 ~ 4), 전반기(F), 후반기(S)
			@RequestParam(value = "purposeQualityChk"		, required = true) String purposeQualityChk, 	// 검사목적
			@RequestParam(value = "qualityCheck_yn"			, required = true) String qualityCheck_yn, 		// 적합여부
			@RequestParam(value = "qualitydateQualityChk"	, required = true) String qualitydateQualityChk,// 품질검사일
			@RequestParam(value = "quality_file_seq1"		, defaultValue="") String quality_file_seq1, 	// 결과보고서
			@RequestParam(value = "quality_file_seq2"		, defaultValue="") String quality_file_seq2, 	// 성적서
			@RequestParam(value = "qualitychk_qualitydesc"	, defaultValue="") String qualitychk_qualitydesc, 	// 검사내용
			@RequestParam(value = "tmp1stApprUserId"		, required = true) String tmp1stApprUserId, 	// 1차 승인자
			@RequestParam(value = "tmp2ndApprUserId"		, defaultValue="") String tmp2ndApprUserId, 	// 2차 승인자
			@RequestParam(value = "quality_sourcingId"		, required = true) String quality_sourcingId, 	// 소싱ID
			@RequestParam(value = "quality_businissnum"		, required = true) String quality_businissnum, 	// 사업자번호
			@RequestParam(value = "quality_qualityid"		, required = true) String quality_qualityid, 	// 품질관리ID
			@RequestParam(value = "quality_qualityyyyy"		, required = true) String quality_qualityyyyy, 	// 관리 년도
			@RequestParam(value = "quality_qualityPartSeq"	, defaultValue="") String quality_qualityPartSeq,// 품질검사 순번
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("saveKind"		, saveKindTmp);
		saveMap.put("quarter_kind"	, quality_kind);
		saveMap.put("purpose"		, purposeQualityChk);
		saveMap.put("qualityyn"		, qualityCheck_yn);
		saveMap.put("qualitydate"	, qualitydateQualityChk);
		saveMap.put("resultfile"	, quality_file_seq1);
		saveMap.put("gradefile"		, quality_file_seq2);
		saveMap.put("qualitydesc"	, qualitychk_qualitydesc);
		saveMap.put("reqid"			, userInfoDto.getUserId());
		saveMap.put("appid1"		, tmp1stApprUserId);
		saveMap.put("appid2"		, tmp2ndApprUserId);
		saveMap.put("sourcingId"	, quality_sourcingId);
		saveMap.put("businissnum"	, quality_businissnum);
		saveMap.put("qualityid"		, quality_qualityid);
		saveMap.put("qualityyyyy"	, quality_qualityyyyy);
		saveMap.put("quality_part_seq", quality_qualityPartSeq);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		String errMsg = "";
		try {
			errMsg = this.qualitySvc.saveQualityReqInfo(saveMap,userInfoDto);
			if("".equals(errMsg) == false){ // 리턴된 에러메시지가 있다면.
				throw new Exception();
			}
		} catch(Exception e) {
			errMsg = "".equals(errMsg) ? "처리중 오류가 발생했습니다." : errMsg;
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(errMsg);	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	
	/** VOC 등록 */
	@RequestMapping("vocRegist.sys")
	public ModelAndView vocRegist(
			@RequestParam(value = "qualityId"	, required = true) String qualityId,			
			@RequestParam(value = "qualityYYYY"	, required = true) String qualityYYYY,			
			@RequestParam(value = "sourcingId"	, required = true) String sourcingId,			
			@RequestParam(value = "businessNum"	, required = true) String businessNum,			
			@RequestParam(value = "reqBorgId"	, required = true) String reqBorgId,			
			@RequestParam(value = "reqUserNm"	, required = true) String reqUserNm,			
			@RequestParam(value = "reqDate"		, required = true) String reqDate,			
			@RequestParam(value = "reqTel"		, defaultValue="") String reqTel,		
			@RequestParam(value = "reqFile1"	, defaultValue="") String reqFile1,		
			@RequestParam(value = "reqFile2"	, defaultValue="") String reqFile2,			
			@RequestParam(value = "reqDesc"		, defaultValue="") String reqDesc,		
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("qualityId"		, qualityId);
		saveMap.put("qualityYYYY"	, qualityYYYY);
		saveMap.put("sourcingId"	, sourcingId);
		saveMap.put("businessNum"	, businessNum);
		saveMap.put("reqBorgId"		, reqBorgId);
		saveMap.put("reqUserNm"		, reqUserNm);
		saveMap.put("reqDate"		, reqDate);
		saveMap.put("reqTel"		, reqTel);
		saveMap.put("reqFile1"		, reqFile1);
		saveMap.put("reqFile2"		, reqFile2);
		saveMap.put("reqDesc"		, reqDesc);
		saveMap.put("regId"			, userInfoDto.getUserId());
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		String errMsg = "";
		try {
			this.qualitySvc.vocRegist(saveMap);
		} catch(Exception e) {
			errMsg = "".equals(errMsg) ? "처리중 오류가 발생했습니다." : errMsg;
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(errMsg);	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	
	/** VOC 처리결과 등록 */
	@RequestMapping("saveVocProcInfo.sys")
	public ModelAndView saveVocProcInfo(
			@RequestParam(value = "treatresult"		, required = true) String treatresult,			
			@RequestParam(value = "judgmentresult"	, required = true) String judgmentresult,			
			@RequestParam(value = "measureresult"	, defaultValue="") String measureresult,			
			@RequestParam(value = "measurefile1"	, defaultValue="") String measurefile1,			
			@RequestParam(value = "measurefile2"	, defaultValue="") String measurefile2,			
			@RequestParam(value = "measuredesc"		, defaultValue="") String measuredesc,			
			@RequestParam(value = "appUserId1"		, defaultValue="") String appUserId1,			
			@RequestParam(value = "appUserId2"		, defaultValue="") String appUserId2,			
			@RequestParam(value = "vocAppcomment1"	, defaultValue="") String vocAppcomment1,			
			@RequestParam(value = "vocAppcomment2"	, defaultValue="") String vocAppcomment2,			
			@RequestParam(value = "vocid"			, required = true) String vocid,			
			@RequestParam(value = "kind"			, required = true) String kind,			
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("treatresult"		, treatresult);
		saveMap.put("judgmentresult"	, judgmentresult);
		saveMap.put("measureresult"		, measureresult);
		saveMap.put("measurefile1"		, measurefile1);
		saveMap.put("measurefile2"		, measurefile2);
		saveMap.put("measuredesc"		, measuredesc);
		saveMap.put("measureid"			, userInfoDto.getUserId());
		saveMap.put("appUserId1"		, appUserId1);
		saveMap.put("appUserId2"		, appUserId2);
		saveMap.put("vocAppcomment1"	, vocAppcomment1);
		saveMap.put("vocAppcomment2"	, vocAppcomment2);
		saveMap.put("kind"				, kind);
		saveMap.put("vocid"				, vocid);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		String errMsg = "";
		try {
			errMsg = this.qualitySvc.saveVocProcInfo(saveMap);
			if("".equals(errMsg) == false){
				throw new Exception();
			}
		} catch(Exception e) {
			errMsg = "".equals(errMsg) ? "처리중 오류가 발생했습니다." : errMsg;
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(errMsg);	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * BMT 승인/반려
	 */
	@RequestMapping("setSourcingApproval.sys")
	public ModelAndView setSourcingApproval(
			@RequestParam(value = "kind"	 	, required = true)	String kind,		// kind
			@RequestParam(value = "sourcingId"	, required = true)	String sourcingId,	// attach_seq
			@RequestParam(value = "businessNum"	, required = true) 	String businessNum,	// businessNum
			@RequestParam(value = "appStep"		, required = true) 	String appStep,		// appStep
			@RequestParam(value = "finalYn"		, required = true) 	String finalYn,		// finalYn
			@RequestParam(value = "isLastAppr"	, required = true) 	String isLastAppr,	// isLastAppr
			@RequestParam(value = "bmtFinalAppcomment1"	, defaultValue = "") 	String bmtFinalAppcomment1,	// bmtFinalAppcomment1
			@RequestParam(value = "bmtFinalAppcomment2"	, defaultValue = "") 	String bmtFinalAppcomment2,	// bmtFinalAppcomment2
			@RequestParam(value = "bmt2ndApprUserId"	, defaultValue = "") 	String bmt2ndApprUserId,	// bmt2ndApprUserId
		HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		HashMap<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("kind"			, kind);
		saveMap.put("sourcingId"	, sourcingId);
		saveMap.put("businessNum"	, businessNum);
		saveMap.put("appStep"		, appStep);
		saveMap.put("finalYn"		, finalYn);
		saveMap.put("isLastAppr"	, isLastAppr);
		saveMap.put("bmtFinalAppcomment1"	, bmtFinalAppcomment1);
		saveMap.put("bmtFinalAppcomment2"	, bmtFinalAppcomment2);
		saveMap.put("bmt2ndApprUserId"		, bmt2ndApprUserId);
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			qualitySvc.setSourcingApproval(saveMap);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;			
	}	
	
	/**
	 * 품질검사 승인/반려
	 */
	@RequestMapping("setQualityApproval.sys")
	public ModelAndView setQualityApproval(
			@RequestParam(value = "kind"	 		, required = true)	String kind,			// kind
			@RequestParam(value = "qualityPartSeq"	, required = true)	String qualityPartSeq,	// qualityPartSeq
			@RequestParam(value = "appStep"			, required = true) 	String appStep,			// appStep
			@RequestParam(value = "isLastAppr"		, required = true) 	String isLastAppr,		// isLastAppr
			@RequestParam(value = "qualityYn"		, required = true) 	String qualityYn,		// qualityYn
			@RequestParam(value = "qualityChkAppcomment1"		, defaultValue = "") 	String qualityChkAppcomment1,		// qualityChkAppcomment1
			@RequestParam(value = "qualityChkAppcomment2"		, defaultValue = "") 	String qualityChkAppcomment2,		// qualityChkAppcomment2
			@RequestParam(value = "quality2ndApprUserId"		, defaultValue = "") 	String quality2ndApprUserId,		// quality2ndApprUserId
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		HashMap<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("kind"				, kind);
		saveMap.put("appStep"			, appStep);
		saveMap.put("isLastAppr"		, isLastAppr);
		saveMap.put("qualityPartSeq"	, qualityPartSeq);
		saveMap.put("qualityYn"			, qualityYn);
		saveMap.put("qualityChkAppcomment1"			, qualityChkAppcomment1);
		saveMap.put("qualityChkAppcomment2"			, qualityChkAppcomment2);
		saveMap.put("quality2ndApprUserId"			, quality2ndApprUserId);
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			qualitySvc.setQualityApproval(saveMap);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;			
	}	
	
	/**
	 * BMT 자료이관
	 */
	@RequestMapping("saveTransBmtData.sys")
	public ModelAndView saveTransBmtData(HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			
			LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			qualitySvc.saveTransBmtData(userInfoDto.getUserId());

		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;			
	}	
	
	/**
	 * BMT 자료이관 (ROW단위)
	 */
	@RequestMapping("saveTransBmtRowData.sys")
	public ModelAndView saveTransBmtRowData(
			@RequestParam(value = "sourcingId"	, required = true)	String sourcingId,	// sourcindId
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			ModelMap params = new ModelMap();
			LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			params.put("sourcingId"	, sourcingId);
			params.put("userId"		, userInfoDto.getUserId());
			qualitySvc.saveTransBmtRowData(params);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;			
	}	
	
	/**
	 * BMT 생성
	 */
	@RequestMapping("saveRegSourcing.sys")
	public ModelAndView saveRegSourcing(
			@RequestParam(value = "regSourcingNm"	, required = true)	String regSourcingNm,	// regSourcingNm
			@RequestParam(value = "regSpec"	 		, required = true)	String regSpec,			// regSpec
			@RequestParam(value = "regItemType1"	, required = true)	String regItemType1,	// regItemType1
			@RequestParam(value = "regItemType2"	, required = true)	String regItemType2,	// regItemType2
			@RequestParam(value = "sRegFileSeq"		, defaultValue= "")	String sRegFileSeq,		// sRegFileSeq
			@RequestParam(value = "pRegFileSeq"		, defaultValue= "")	String pRegFileSeq,		// pRegFileSeq
			
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
		
			Map<String, Object> params = new HashMap<String, Object>();
			LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			
			params.put("sourcingNm"		, regSourcingNm);
			params.put("spec"			, regSpec);
			params.put("prodType1"		, regItemType1);
			params.put("prodType2"		, regItemType2);
			params.put("sRegFileSeq"	, sRegFileSeq);
			params.put("pRegFileSeq"	, pRegFileSeq);
			params.put("userId"			, userInfoDto.getUserId());
			
			qualitySvc.saveRegSourcing(params);
			
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;			
	}	
	
	/**
	 * 품질기준 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("setQualityStd.sys")
	public ModelAndView setQualityStd(
			@RequestParam(value = "qualityId"		, required = true)	String qualityId,	// qualityId
			@RequestParam(value = "sourcingId"		, required = true)	String sourcingId,	// sourcingId
			@RequestParam(value = "qualityYYYY"		, required = true)	String qualityYYYY,	// qualityYYYY
			@RequestParam(value = "qualityStdCd"	, required = true)	String qualityStdCd,// qualityStdCd
			
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			Map<String, Object> params = new HashMap<String, Object>();
			LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			
			params.put("qualityId"		, qualityId);
			params.put("sourcingId"		, sourcingId);
			params.put("qualityYYYY"	, qualityYYYY);
			params.put("qualityStdCd"	, qualityStdCd);
			params.put("userId"			, userInfoDto.getUserId());
			
			int result = generalDao.updateGernal("quality.setQualityStd", params);
			if(result == 1){
				
				List<Object> targetList = (List<Object>) generalDao.selectGernalList("quality.getQualityVendorCheckTarget", params);
				
				for(Object obj : targetList){
					Map<String, Object> objMap = (Map<String, Object>)obj;
					Iterator<Entry<String, Object>> it = objMap.entrySet().iterator();
					while(it.hasNext()){
						Map<String, Object> delMap = new HashMap<String, Object>();
						delMap.put("qualityPartSeq", it.next().getValue().toString());
						generalDao.deleteGernal("quality.deleteQualityCheck", delMap);
					}
				}
				generalDao.updateGernal("quality.resetQualityVendor", params);
			}

		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;			
	}	
	
	/**
	 * 담당자 변경
	 */
	@RequestMapping("setManager.sys")
	public ModelAndView setManager(
			@RequestParam(value = "qualityId"	, required = true)	String qualityId,	// qualityId
			@RequestParam(value = "sourcingId"	, required = true)	String sourcingId,	// sourcingId
			@RequestParam(value = "qualityYYYY"	, required = true)	String qualityYYYY,	// qualityYYYY
			@RequestParam(value = "managerId"	, required = true)	String managerId,// managerId
			
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			Map<String, Object> params = new HashMap<String, Object>();
			LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			
			params.put("qualityId"		, qualityId);
			params.put("sourcingId"		, sourcingId);
			params.put("qualityYYYY"	, qualityYYYY);
			params.put("managerId"		, managerId);
			params.put("userId"			, userInfoDto.getUserId());
			
			generalDao.updateGernal("quality.setManager", params);
			
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;			
	}	
	
	
	/**
	 * 사용여부 변경
	 */
	@RequestMapping("setQualityIsUse.sys")
	public ModelAndView setQualityIsUse(
			@RequestParam(value = "qualityId"	, required = true)	String qualityId,	// qualityId
			@RequestParam(value = "sourcingId"	, required = true)	String sourcingId,	// sourcingId
			@RequestParam(value = "qualityYYYY"	, required = true)	String qualityYYYY,	// qualityYYYY
			@RequestParam(value = "isUse"		, required = true)	String isUse,		// isUse
			
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			Map<String, Object> params = new HashMap<String, Object>();
			LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			
			params.put("qualityId"		, qualityId);
			params.put("sourcingId"		, sourcingId);
			params.put("qualityYYYY"	, qualityYYYY);
			params.put("isUse"			, isUse);
			params.put("userId"			, userInfoDto.getUserId());
			
			generalDao.updateGernal("quality.setQualityIsUse", params);
			
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;			
	}
	
	
	/**
	 * 품질관리 자료이관
	 */
	@RequestMapping("saveTransQualityData.sys")
	public ModelAndView saveTransQualityData(HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			qualitySvc.saveTransQualityData();
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;			
	}
	
	/**
	 * VOC 승인/반려
	 */
	@RequestMapping("setVocApproval.sys")
	public ModelAndView setVocApproval(
			@RequestParam(value = "kind"		, required = true)	String kind,		// kind
			@RequestParam(value = "vocId"		, required = true)	String vocId,		// vocId
			@RequestParam(value = "appStep"		, required = true) 	String appStep,		// appStep
			@RequestParam(value = "isLastAppr"	, required = true) 	String isLastAppr,	// isLastAppr
			@RequestParam(value = "vocAppcomment1"	, defaultValue = "") 	String vocAppcomment1,	// vocAppcomment1
			@RequestParam(value = "vocAppcomment2"	, defaultValue = "") 	String vocAppcomment2,	// vocAppcomment2
			@RequestParam(value = "vocUserId"	, defaultValue = "") 		String vocUserId,	// vocUserId
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		HashMap<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("kind"			, kind);
		saveMap.put("appStep"		, appStep);
		saveMap.put("isLastAppr"	, isLastAppr);
		saveMap.put("vocId"			, vocId);
		saveMap.put("vocAppcomment1", vocAppcomment1);
		saveMap.put("vocAppcomment2", vocAppcomment2);
		saveMap.put("vocUserId"		, vocUserId);
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			qualitySvc.setVocApproval(saveMap);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;			
	}		
	
	
}