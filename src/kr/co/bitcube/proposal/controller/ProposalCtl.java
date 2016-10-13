package kr.co.bitcube.proposal.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.proposal.service.ProposalSvc;
import kr.co.bitcube.common.service.CommonSvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("proposal")
public class ProposalCtl {
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private ProposalSvc proposalSvc;
	
	@Autowired
	private CommonSvc commonSvc;

	/** 신규자제 제안 리스트 화면으로 이동 */
	@RequestMapping("viewProposalList.sys")
	public ModelAndView viewProposalList( HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		List<Map<String,Object>> codeList = proposalSvc.selectProposalStat();
		List<Map<String,Object>> finalUserList = proposalSvc.selectProposalFinalUserList(params);
		params.put("searchB2BAdm", "true");
		List<Map<String,Object>> b2bAdmList = proposalSvc.selectProposalB2BAdmList(params);
		modelAndView.setViewName("proposal/viewProposalList");
		modelAndView.addObject("codeList", codeList);			// 상태 코드값
		modelAndView.addObject("b2bAdmList", b2bAdmList);		// b2b운영권한자
		modelAndView.addObject("finalUserList", finalUserList);	// 최종결정권사용자
		return modelAndView;
	}
	/** 신규자제 제안 리스트 화면으로 이동 */
	@RequestMapping("viewProposalListBuy.sys")
	public ModelAndView viewProposalListBuy( HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		List<Map<String,Object>> codeList = proposalSvc.selectProposalStat();
		modelAndView.setViewName("proposal/viewProposalListBuy");
		modelAndView.addObject("codeList", codeList);			// 상태 코드값
		return modelAndView;
	}
	/** 신규자제 제안 리스트 화면으로 이동 */
	@RequestMapping("viewProposalListVen.sys")
	public ModelAndView viewProposalListVen( HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		List<Map<String,Object>> codeList = proposalSvc.selectProposalStat();
		modelAndView.setViewName("proposal/viewProposalListVen");
		modelAndView.addObject("codeList", codeList);			// 상태 코드값
		return modelAndView;
	}

	/** 신규자재 제안 리스트 조회 */
	@RequestMapping("selectProposalList.sys")
	public ModelAndView selectProposalList(
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "RECEIPTNUM") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,
			/*  조회 조건 */
			@RequestParam(value = "srcSuggestStDate", defaultValue = "") String srcSuggestStDate,				// 제안일 조회 시작
			@RequestParam(value = "srcSuggestEndDate", defaultValue = "") String srcSuggestEndDate,				// 제안일 조회 끝
			@RequestParam(value = "srcSuggestTitle", defaultValue = "") String srcSuggestTitle,					// 제안명
			@RequestParam(value = "srcSuggestName", defaultValue = "") String srcSuggestName,					// 제안자
			@RequestParam(value = "srcSuitableUserNm", defaultValue = "") String srcSuitableUserNm,				// 검토자 userId
			@RequestParam(value = "srcAppraisalUserNm", defaultValue = "") String srcAppraisalUserNm,			// 최종결정자 userId
			@RequestParam(value = "srcFinalProcStatFlagNm", defaultValue = "") String srcFinalProcStatFlagNm,	// 현재 상태
			@RequestParam(value = "srcSuggestTarget", defaultValue = "") String srcSuggestTarget,	// 제안대상
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcSuggestStDate", srcSuggestStDate);
		params.put("srcSuggestEndDate", srcSuggestEndDate);
		params.put("srcSuggestTitle", srcSuggestTitle);
		params.put("srcSuggestName", srcSuggestName);
		params.put("srcSuitableUserNm", srcSuitableUserNm);
		params.put("srcAppraisalUserNm", srcAppraisalUserNm);
		params.put("srcFinalProcStatFlagNm", srcFinalProcStatFlagNm);
		params.put("srcSuggestTarget", srcSuggestTarget);
		params.put("orderString", " " + sidx + " " + sord + " ");
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		params.put("userInfoDto", userInfoDto);
		Map<String, Object> validChkMap = proposalSvc.getUserInfoMap(params,userInfoDto);
		params.put("isFinal", validChkMap.get("FINAL_ROLE").toString());
		params.put("isAdm", validChkMap.get("IS_ADM").toString());
		if("XXXXXXXXXX".equals(userInfoDto.getLoginId())){ 	// 비회원일 경우
			params.put("nonUserId", (Integer)proposalSvc.selectNonUserId(params));
		}else{
			params.put("userId", userInfoDto.getUserId());
		}
        int records = proposalSvc.selectProposalListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
        List<Map<String,Object>> list = null; 
        if(records>0) list = proposalSvc.selectProposalList(params, page, rows);
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("rows", rows);
		modelAndView.addObject("list", list);
		return modelAndView;
	}

	/** 신규자재 제안 등록관련 사용자 정보 조회 */
	@RequestMapping("selectProposalUserInfo.sys")
	public ModelAndView selectProposalUserInfo(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		if("XXXXXXXXXX".equals(userInfoDto.getLoginId())){ 	// 비회원일 경우
			userInfoDto = new LoginUserDto();
		}else{
			userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		}
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("userInfo", userInfoDto);
		modelAndView.addObject("proposalDate", CommonUtils.getCurrentDate());
		return modelAndView;
	}

	/** 신규자재 제안 카운트 조회 */
	@RequestMapping("selectProposalCntText.sys")
	public ModelAndView selectProposalCnt(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		params.put("userInfoDto", userInfoDto);
		Map<String, Object> validChkMap = proposalSvc.getUserInfoMap(params,userInfoDto);
		params.put("isFinal", validChkMap.get("FINAL_ROLE").toString());
		params.put("isAdm", validChkMap.get("IS_ADM").toString());
		if("XXXXXXXXXX".equals(userInfoDto.getLoginId())){ 	// 비회원일 경우
			params.put("nonUserId", (Integer)proposalSvc.selectNonUserId(params));
		}else{
			params.put("userId", userInfoDto.getUserId());
		}
        Map<String,Object> cntInfo = proposalSvc.selectProposalCntText(params);
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("cntInfo", cntInfo);			
		return modelAndView;
	}

	/** 신규자재 제안 상세화면 관련 사용자 권한정보 조회 */
	@RequestMapping("selectProposalDetailRole.sys")
	public ModelAndView selectProposalDetailRole(
			@RequestParam(value = "receiptNum", required = true ) String receiptNum,				//제안명
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("receiptNum", receiptNum);
		params.put("userInfoDto", userInfoDto);
		Map<String, Object> returnMap = proposalSvc.getUserInfoMap(params,userInfoDto);
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("userInfo", returnMap);
		modelAndView.addObject("proposalDate", CommonUtils.getCurrentDate());
		return modelAndView;
	}
	

	/** 신규자재 제안 등록 처리 */
	@RequestMapping("insertProposalInfo.sys")
	public ModelAndView insertProposalInfo(
			@RequestParam(value = "titleName", required = true ) String titleName,				//제안명
			@RequestParam(value = "regiUserName", required = true) String regiUserName,			//제안자명
			@RequestParam(value = "regiUserPhone", required = true) String regiUserPhone,		//제안자 핸드폰
			@RequestParam(value = "regiUserEmail", required = true) String regiUserEmail,		//제안자 이메일
			@RequestParam(value = "propPointDesc", required = true) String propPointDesc,		//주요내용
			@RequestParam(value = "firstattachseq", required = true) String firstattachseq,		//파일첨부 ppt
			@RequestParam(value = "secondattachseq", required = true) String secondattachseq,	//파일첨부1
			@RequestParam(value = "thirdattachseq", required = true) String thirdattachseq,		//파일첨부2
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("titleName", titleName);
		params.put("regiUserPhone", regiUserPhone);
		params.put("regiUserEmail", regiUserEmail);
		params.put("propPointDesc", propPointDesc);
		params.put("firstattachseq", firstattachseq);
		params.put("secondattachseq", secondattachseq);
		params.put("thirdattachseq", thirdattachseq);
		Map<String, Object> selParam = new HashMap<String, Object>();
		selParam.put("userInfoDto", userInfoDto);
		if("XXXXXXXXXX".equals(userInfoDto.getLoginId())){ 	// 비회원일 경우
			params.put("nonUserId", (Integer)proposalSvc.selectNonUserId(selParam));
			params.put("regiUserName", regiUserName);
			params.put("busiNm", userInfoDto.getBorgNms());
			params.put("busiNum", userInfoDto.getBorgNm());
		}else{											// 회원일경우
			params.put("userId", userInfoDto.getUserId());
			// 14-03-27 회원이라도 등록자명 수정할 수 있게 변경. parkjoon
			params.put("regiUserName", regiUserName);
			params.put("busiNm", userInfoDto.getBorgNms());
			// ADM 사용자의 경우 사업자 번호를 빈값("")으로 저장한다.
			Map<String, Object> busiNumMap = proposalSvc.selectBusiNum(selParam);
			params.put("busiNum", busiNumMap == null ? "" : busiNumMap.get("BUSINESSNUM") );
		}
		CustomResponse custResponse = new CustomResponse(true);
		try {
			proposalSvc.insertProposalInfo(params);
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

	/** 신규자재 제안 수정 처리 */
	@RequestMapping("modifyProposalInfo.sys")
	public ModelAndView modifyProposalInfo(
			@RequestParam(value = "receiptNum", required = true) String receiptNum,				//PK
			@RequestParam(value = "receiptNumStat", required = true) String receiptNumStat,		//상태
			@RequestParam(value = "titleName", required = true) String titleName,				//제안명
			@RequestParam(value = "regiUserName", required = true) String regiUserName,			//등록자명
			@RequestParam(value = "regiUserPhone", required = true) String regiUserPhone,		//등록자 전화번호
			@RequestParam(value = "regiUserEmail", required = true) String regiUserEmail,		//등록자 이메일
			@RequestParam(value = "propPointDesc", required = true) String propPointDesc,		//주요내용
			@RequestParam(value = "firstattachseq", required = true) String firstattachseq,		//첨부파일1
			@RequestParam(value = "secondattachseq", required = true) String secondattachseq,	//첨부파일2
			@RequestParam(value = "thirdattachseq", required = true) String thirdattachseq,		//첨부파일3
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		boolean isProc = true;
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("receiptNum", receiptNum);
		params.put("receiptNumStat", receiptNumStat);
		params.put("titleName", titleName);
		params.put("regiUserName", regiUserName);
		params.put("regiUserPhone", regiUserPhone);
		params.put("regiUserEmail", regiUserEmail);
		params.put("propPointDesc", propPointDesc);
		params.put("firstattachseq", firstattachseq);
		params.put("secondattachseq", secondattachseq);
		params.put("thirdattachseq", thirdattachseq);
		params.put("userInfoDto", userInfoDto);

		// 작성자, 어드민 여부 조회
		Map<String, Object> validChkMap = proposalSvc.getUserInfoMap(params,userInfoDto);
		// DB 조회한 상태 값과 현재 상태값이 맞지 않다면 진행을 중지한다.
		int dbResult = proposalSvc.selectProposalStatus(params);
		// DB 조회 결과 상태값이 10보다 크다면 수정된 부분이 있으므로, 진행불가.
		if( Integer.parseInt(receiptNumStat) != dbResult && 10 < dbResult  ){	
			isProc = false;
		}else{
			if(validChkMap.get("IS_WRITER").toString().equals("N")){
				// 작성자거나 운영자라면 수정 가능. 그외 불가.
				isProc = false;
			}
		}
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if(isProc == false){
				throw new Exception();// 의도된 Exception 처리
			}
			proposalSvc.updateProposalInfo(params);
		} catch(Exception e) {
			
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			if(isProc == false){
				custResponse.setMessage("진행할 수 없는 상태입니다.\n새로고침 후 다시 확인해주십시오.");
			}else{
				custResponse.setMessage("System Excute Error!....");
				custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
			}
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}

	/** 신규자재 제안 삭제 처리 */
	@RequestMapping("delProposalInfo.sys")
	public ModelAndView delProposalInfo(
			@RequestParam(value = "receiptNum", required = true) String receiptNum,				//PK
			@RequestParam(value = "receiptNumStat", required = true) String receiptNumStat,		//상태
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		boolean isProc = true;
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("receiptNum", receiptNum);
		params.put("receiptNumStat", receiptNumStat);
		params.put("userInfoDto", userInfoDto);
		// 작성자, 어드민 여부 조회
		Map<String, Object> validChkMap = proposalSvc.getUserInfoMap(params,userInfoDto);
		// DB 조회한 상태 값과 현재 상태값이 맞지 않다면 진행을 중지한다.
		int dbResult = proposalSvc.selectProposalStatus(params);
		// DB 조회 결과 상태값이 10보다 크다면 수정된 부분이 있으므로, 진행불가.
		if( Integer.parseInt(receiptNumStat) != dbResult && 10 < dbResult  ){	
			isProc = false;
		}else{
			if(validChkMap.get("IS_WRITER").toString().equals("N") && validChkMap.get("IS_ADM").toString().equals("N")){
				// 작성자거나 운영자라면 삭제  가능. 그외 불가.
				isProc = false;
			}
		}
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if(isProc == false){
				throw new Exception();// 의도된 Exception 처리
			}
			proposalSvc.delProposalInfo(params);
		} catch(Exception e) {
			
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			if(isProc == false){
				custResponse.setMessage("진행할 수 없는 상태입니다.\n새로고침 후 다시 확인해주십시오.");
			}else{
				custResponse.setMessage("System Excute Error!....");
				custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
			}
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}

	/** 신규자재 제안 접수 처리 */
	@RequestMapping("receProposalInfo.sys")
	public ModelAndView receProposalInfo(
			@RequestParam(value = "receiptNum", required = true) String receiptNum,				//PK
			@RequestParam(value = "receiptNumStat", required = true) String receiptNumStat,		//상태
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		boolean isProc = true;
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("receiptNum", receiptNum);
		params.put("receiptNumStat", receiptNumStat);
		params.put("userInfoDto", userInfoDto);
		// 작성자, 어드민 여부 조회
		Map<String, Object> validChkMap = proposalSvc.getUserInfoMap(params,userInfoDto);
		// DB 조회한 상태 값과 현재 상태값이 맞지 않다면 진행을 중지한다.
		int dbResult = proposalSvc.selectProposalStatus(params);
		// DB 조회 결과 상태값이 10보다 크다면 수정된 부분이 있으므로, 진행불가.
		if( Integer.parseInt(receiptNumStat) != dbResult && 10 < dbResult  ){	
			isProc = false;
		}else{
			if(validChkMap.get("IS_ADM").toString().equals("N")){
				// 작성자거나 운영자라면 삭제  가능. 그외 불가.
				isProc = false;
			}
		}
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if(isProc == false){
				throw new Exception();// 의도된 Exception 처리
			}
			params.put("receiptNumStat", "20");	// 접수상태로 변경한다.
			proposalSvc.insertProposalInfoHist(params);

			params.put("acceptStat", "20");
			params.put("acceptDate", "today");
			params.put("acceptId", userInfoDto.getUserId());
			proposalSvc.updateProposalInfo(params);
		} catch(Exception e) {
			
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			if(isProc == false){
				custResponse.setMessage("진행할 수 없는 상태입니다.\n새로고침 후 다시 확인해주십시오.");
			}else{
				custResponse.setMessage("System Excute Error!....");
				custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
			}
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}

	/** 신규자재 제안 검토 처리 */
	@RequestMapping("reviewProposalInfo.sys")
	public ModelAndView reviewProposalInfo(
			@RequestParam(value = "receiptNum", required = true) String receiptNum,				//PK
			@RequestParam(value = "receiptNumStat", required = true) String receiptNumStat,		//상태
			@RequestParam(value = "suitableStat", required = true) String suitableStat,			//검토상태
			@RequestParam(value = "suitableContent", required = true) String suitableContent,	//검토의견
			@RequestParam(value = "materialType", required = true) String materialType,			//자재유형
			@RequestParam(value = "fourthattachseq", required = true) String fourthattachseq,	//4번째 첨부파일
			@RequestParam(value = "suggestTarget", required = true) String suggestTarget,		//제안대상
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		boolean isProc = true;
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("receiptNum", receiptNum);
		params.put("receiptNumStat", receiptNumStat);
		params.put("userInfoDto", userInfoDto);
		// 작성자, 어드민 여부 조회
		Map<String, Object> validChkMap = proposalSvc.getUserInfoMap(params,userInfoDto);
		// DB 조회한 상태 값과 현재 상태값이 맞지 않다면 진행을 중지한다.
		if(Integer.parseInt(receiptNumStat) != proposalSvc.selectProposalStatus(params)){
			isProc = false;
		}else{
			if(validChkMap.get("IS_ADM").toString().equals("N")){
				// 작성자거나 운영자라면 삭제  가능. 그외 불가.
				isProc = false;
			}
		}
		logger.debug("isProc : "+isProc);
		logger.debug("suggestTarget : "+suggestTarget);
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if(isProc == false){
				throw new Exception();// 의도된 Exception 처리
			}
			params.put("receiptNumStat", suitableStat);	// 검토자가 선택한 상태로 최종 상태를 변경한다.
			params.put("statContent", suitableContent);	// 의견반영
			proposalSvc.insertProposalInfoHist(params);
			params.put("suitableStat", suitableStat);
			params.put("suitableContent", suitableContent);
			params.put("materialType", materialType);
			params.put("fourthattachseq", fourthattachseq);
			params.put("suitableId", userInfoDto.getUserId());
			params.put("suitableDate", "today");
			params.put("suggestTarget", suggestTarget);
			params.put("suitableMobile", userInfoDto.getMobile());
			proposalSvc.updateProposalInfo(params);
			proposalSvc.sendEmailByReceiptNum("FINAL_USER", (String)params.get("receiptNum"));
		} catch(Exception e) {
			
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			if(isProc == false){
				custResponse.setMessage("진행할 수 없는 상태입니다.\n새로고침 후 다시 확인해주십시오.");
			}else{
				custResponse.setMessage("System Excute Error!....");
				custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
			}
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}

	/** 신규자재 제안 최종 처리 */
	@RequestMapping("finalProposalInfo.sys")
	public ModelAndView finalProposalInfo(
			@RequestParam(value = "receiptNum", required = true) String receiptNum,				//PK
			@RequestParam(value = "receiptNumStat", required = true) String receiptNumStat,		//상태
			@RequestParam(value = "appraisalStat", required = true) String appraisalStat,		//최종승인상태
			@RequestParam(value = "appraisalContent", required = true) String appraisalContent,	//최종 평가 의견
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		boolean isProc = true;
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("receiptNum", receiptNum);
		params.put("receiptNumStat", receiptNumStat);
		params.put("userInfoDto", userInfoDto);
		Map<String, Object> validChkMap = proposalSvc.getUserInfoMap(params,userInfoDto);
		// DB 조회한 상태 값과 현재 상태값이 맞지 않다면 진행을 중지한다.
		if(Integer.parseInt(receiptNumStat) != proposalSvc.selectProposalStatus(params)){
			isProc = false;
		}else{
			if(validChkMap.get("FINAL_ROLE").toString().equals("N")){
				// 권한이 없을 경우 처리 불가
				isProc = false;
			}
		}
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if(isProc == false){
				throw new Exception();// 의도된 Exception 처리
			}
			params.put("receiptNumStat", appraisalStat);	// 검토자가 선택한 상태로 최종 상태를 변경한다.
			params.put("statContent", appraisalContent);	// 의견반영
			proposalSvc.insertProposalInfoHist(params);
			params.put("appraisalStat", appraisalStat);
			params.put("appraisalContent", appraisalContent);
			params.put("appraisalId", userInfoDto.getUserId());
			params.put("appraisalDate", "today");
			proposalSvc.updateProposalInfo(params);
		} catch(Exception e) {
			
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			if(isProc == false){
				custResponse.setMessage("진행할 수 없는 상태입니다.\n새로고침 후 다시 확인해주십시오.");
			}else{
				custResponse.setMessage("System Excute Error!....");
				custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
			}
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}

	/** 신규자재 제안 엑셀*/
	@RequestMapping("selectProposalListExcel.sys")
	public ModelAndView selectProposalListExcel(
			@RequestParam(value = "srcSuggestStDate", defaultValue = "") String srcSuggestStDate,				// 제안일 조회 시작
			@RequestParam(value = "srcSuggestEndDate", defaultValue = "") String srcSuggestEndDate,				// 제안일 조회 끝
			@RequestParam(value = "srcSuggestTitle", defaultValue = "") String srcSuggestTitle,					// 제안명
			@RequestParam(value = "srcSuggestName", defaultValue = "") String srcSuggestName,					// 제안자
			@RequestParam(value = "srcSuitableUserNm", defaultValue = "") String srcSuitableUserNm,				// 검토자 userId
			@RequestParam(value = "srcAppraisalUserNm", defaultValue = "") String srcAppraisalUserNm,			// 최종결정자 userId
			@RequestParam(value = "srcFinalProcStatFlagNm", defaultValue = "") String srcFinalProcStatFlagNm,	// 현재 상태
			@RequestParam(value = "srcSuggestTarget", defaultValue = "") String srcSuggestTarget,	// 제안대상

			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcSuggestStDate", srcSuggestStDate);
		params.put("srcSuggestEndDate", srcSuggestEndDate);
		params.put("srcSuggestTitle", srcSuggestTitle);
		params.put("srcSuggestName", srcSuggestName);
		params.put("srcSuitableUserNm", srcSuitableUserNm);
		params.put("srcAppraisalUserNm", srcAppraisalUserNm);
		params.put("srcFinalProcStatFlagNm", srcFinalProcStatFlagNm);
		params.put("srcSuggestTarget", srcSuggestTarget);
		params.put("orderString", "RECEIPTNUM DESC");
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		params.put("userInfoDto", userInfoDto);
		Map<String, Object> validChkMap = proposalSvc.getUserInfoMap(params,userInfoDto);
		params.put("isFinal", validChkMap.get("FINAL_ROLE").toString());
		params.put("isAdm", validChkMap.get("IS_ADM").toString());
		if("XXXXXXXXXX".equals(userInfoDto.getLoginId())){ 	// 비회원일 경우
			params.put("nonUserId", (Integer)proposalSvc.selectNonUserId(params));
		}else{
			params.put("userId", userInfoDto.getUserId());
		}
        List<Map<String,Object>> list = proposalSvc.selectProposalListExcel(params);
        
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", list);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);
        
//		modelAndView.setViewName("commonExcelViewResolver");
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("figureColIds", figureColIds);
//		modelAndView.addObject("colDataList", list);
		return modelAndView;
	}
	
	@RequestMapping("suggestTargetSelect.sys")
	public ModelAndView suggestTargetSelect (
			ModelAndView mav, HttpServletRequest request) throws Exception {
		List<CodesDto> list = commonSvc.getCodeList("PROPOSAL_SUGGEST", 1);
		mav.setViewName("jsonView");
		mav.addObject("list", list);
		return mav;
	}
}
