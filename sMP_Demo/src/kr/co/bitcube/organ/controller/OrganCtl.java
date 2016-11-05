package kr.co.bitcube.organ.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.adjust.service.AdjustSvc;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.LoginRoleDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.ReceiveInfoDto;
import kr.co.bitcube.common.dto.SmsEmailInfo;
import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.common.dto.WorkInfoDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.organ.dto.AdminBorgsDto;
import kr.co.bitcube.organ.dto.BorgRoleDto;
import kr.co.bitcube.organ.dto.SmpBranchsDto;
import kr.co.bitcube.organ.dto.SmpDeliveryInfoDto;
import kr.co.bitcube.organ.dto.SmpUsersDto;
import kr.co.bitcube.organ.dto.SmpVendorsDto;
import kr.co.bitcube.organ.service.OrganSvc;
import kr.co.bitcube.system.service.BorgSvc;

import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;


@Controller
@RequestMapping("organ")
public class OrganCtl {

	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private OrganSvc organSvc;
	
	@Autowired
	private CommonSvc commonSvc;	
	
	@Autowired
	private BorgSvc borgSvc;
	
	@Autowired
	private AdjustSvc adjustSvc;
	
	@Autowired
	private GeneralDao generalDao;
	
	/**사업장조회
	 */
	@RequestMapping("organBranchList.sys")
	public ModelAndView getOrganBranchList( HttpServletRequest req, ModelAndView mav) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orderString", " workNm asc");
		List<UserDto> admUserList = adjustSvc.getAdjustAlramUserList();
		List<WorkInfoDto> workInfoList = commonSvc.selectWorkInfo(params);
		mav.addObject("admUserList", admUserList);
		mav.addObject("workInfoList", workInfoList);
		mav.setViewName("organ/organBranchList");
		return mav;
	}
	
	/**
	 * 사업장조회 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("organBranchListJQGrid.sys")
	public ModelAndView organBranchListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "a.branchId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,
			@RequestParam(value = "srcBranchGrad", defaultValue = "") String srcBranchGrad,
			@RequestParam(value = "srcAreaType", defaultValue = "") String srcAreaType,
			@RequestParam(value = "srcIsUse", defaultValue = "1") String srcIsUse,
			@RequestParam(value = "srcWorkId", defaultValue = "") String srcWorkId,
			@RequestParam(value = "srcAccUser", defaultValue = "") String srcAccUser,
			@RequestParam(value = "srcBorgNameLike", defaultValue = "") String srcBorgNameLike,
			@RequestParam(value = "srcIsOrderLimit", defaultValue = "") String srcIsOrderLimit,
			@RequestParam(value = "srcPrePay", defaultValue = "") String srcPrePay,
			@RequestParam(value = "srcPressentNm", defaultValue = "") String srcPressentNm,
			@RequestParam(value = "srcBusinessNum", defaultValue = "") String srcBusinessNum,
			@RequestParam(value = "srcClientNameLike", defaultValue = "") String srcClientNameLike,
			
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcBranchGrad", srcBranchGrad);
		params.put("srcAreaType", srcAreaType);
		params.put("srcIsUse", srcIsUse);
		params.put("srcWorkId", srcWorkId);
		params.put("srcAccUser", srcAccUser);
		params.put("srcBorgNameLike", srcBorgNameLike);
		params.put("srcIsOrderLimit", srcIsOrderLimit);
		params.put("srcPrePay", srcPrePay);
		params.put("srcPressentNm", srcPressentNm);
		params.put("srcBusinessNum", srcBusinessNum);
		params.put("srcClientNameLike", srcClientNameLike);
		
		if("BUY".equals(userInfoDto.getSvcTypeCd())) {
			params.put("srcClientId", userInfoDto.getClientId());
		}
		if("branchId".equals(sidx)) {
			sidx = "a."+sidx;
		}
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
		int records = organSvc.getOrganBranchListCnt(params); //조회조건에 따른 카운트
		int total = (int)Math.ceil((float)records / (float)rows);
		
		/*----------------조회------------*/
		List<SmpBranchsDto> list = null;
		if(records>0) list = organSvc.getOrganBranchList(params, page, rows);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 사업장조회 DB조회후 엑셀다운로드
	 */
	@RequestMapping("organBranchListExcel.sys")
	public ModelAndView organBranchListExcel(
			@RequestParam(value = "sidx", defaultValue = "a.branchId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,
			@RequestParam(value = "srcBranchGrad", defaultValue = "") String srcBranchGrad,
			@RequestParam(value = "srcAreaType", defaultValue = "") String srcAreaType,
			@RequestParam(value = "srcIsUse", defaultValue = "1") String srcIsUse,
			@RequestParam(value = "srcWorkId", defaultValue = "") String srcWorkId,
			@RequestParam(value = "srcAccUser", defaultValue = "") String srcAccUser,
			@RequestParam(value = "srcPressentNm", defaultValue = "") String srcPressentNm,
			@RequestParam(value = "srcBusinessNum", defaultValue = "") String srcBusinessNum,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			
			@RequestParam(value = "srcBorgNameLike", defaultValue = "") String srcBorgNameLike,
			@RequestParam(value = "srcIsOrderLimit", defaultValue = "") String srcIsOrderLimit,
			@RequestParam(value = "srcPrePay", defaultValue = "") String srcPrePay,
			@RequestParam(value = "srcClientNameLike", defaultValue = "") String srcClientNameLike,
			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcBranchGrad", srcBranchGrad);
		params.put("srcAreaType", srcAreaType);
		params.put("srcIsUse", srcIsUse);
		params.put("srcWorkId", srcWorkId);
		params.put("srcAccUser", srcAccUser);
		params.put("srcPressentNm", srcPressentNm);
		params.put("srcBusinessNum", srcBusinessNum);
		
		params.put("srcBorgNameLike", srcBorgNameLike);
		params.put("srcIsOrderLimit", srcIsOrderLimit);
		params.put("srcPrePay", srcPrePay);
		params.put("srcClientNameLike", srcClientNameLike);
		
		if("BUY".equals(userInfoDto.getSvcTypeCd())) {
			params.put("srcClientId", userInfoDto.getClientId());
		}
		if("branchId".equals(sidx)) {
			sidx = "a."+sidx;
		}
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------조회------------*/
		List<SmpBranchsDto> list = organSvc.getOrganBranchList(params, 1, RowBounds.NO_ROW_LIMIT);
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				rtnData.put("branchCd", list.get(i).getBranchCd());
				rtnData.put("branchNm", list.get(i).getBranchNm().replace("&gt;", ">"));
				rtnData.put("borgNm", list.get(i).getBorgNm());
				rtnData.put("businessNum", list.get(i).getBusinessNum());
				rtnData.put("workNm", list.get(i).getWorkNm());
				rtnData.put("userNm", list.get(i).getUserNm());
				rtnData.put("areaTypeNm", list.get(i).getAreaTypeNm());
				rtnData.put("branchGrad", list.get(i).getBranchGrad());
				rtnData.put("isUse", list.get(i).getIsUse());
				rtnData.put("phoneNum", list.get(i).getPhoneNum());
				rtnData.put("pressentNm", list.get(i).getPressentNm());
				rtnData.put("postAddrNum", list.get(i).getPostAddrNum());
				rtnData.put("addres", list.get(i).getAddres());
				rtnData.put("addresDesc", list.get(i).getAddresDesc());
				rtnData.put("createDate", list.get(i).getCreateDate());
				rtnData.put("clientStatus", list.get(i).getClientStatus());
				rtnData.put("clientStatus1", list.get(i).getClientStatus1());
				rtnData.put("isOrderLimit", list.get(i).getIsOrderLimit());
				rtnData.put("isOrderLimit1", list.get(i).getIsOrderLimit1());
				rtnData.put("autOrderLimitPeriod", list.get(i).getAutOrderLimitPeriod());
				rtnData.put("prePay", list.get(i).getPrePay());
				rtnData.put("userLoginYn", list.get(i).getUserLoginYn());
				rtnData.put("sharp_mail", list.get(i).getSharp_mail());
				rtnData.put("contractYn", list.get(i).getContractYn());
				colDataList.add(rtnData);
			}
		}
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", colDataList);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("figureColIds", figureColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;		
	}
	
	
	/**
	 * 사업장상세
	 */
	@RequestMapping("organBranchDetail.sys")
	public ModelAndView getOrganBranchDetail( 
			@RequestParam(value = "branchId",required = true) String branchId,
			ModelAndView modelAndView, HttpServletRequest req) throws Exception{
	
		SmpBranchsDto 				detailInfo 				= organSvc.selectBranchsDetail(branchId);	// 사업장 마스터
		
		modelAndView.addObject("branchId"				, branchId);
		modelAndView.addObject("detailInfo"				, detailInfo);
		
		//권역코드
		modelAndView.addObject("areaCode", commonSvc.getCodeList("DELI_AREA_CODE", 1));
		//은행코드
		modelAndView.addObject("bankCode", commonSvc.getCodeList("BANKCD", 1));
		//회원사등급
		modelAndView.addObject("mGradeCode", commonSvc.getCodeList("MEMBERGRADE", 1));
		//결제조건
		modelAndView.addObject("payCondCode", commonSvc.getCodeList("PAYMCONDCODE", 1));
		//공사유형
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orderString", " workNm asc");
		modelAndView.addObject("workInfoList", commonSvc.selectWorkInfo(params));
		//채권관리자
		modelAndView.addObject("admUserList", adjustSvc.getAdjustAlramUserList());
		
		modelAndView.setViewName("organ/organBranchDetail");
		return modelAndView;		
	}
	
	
	/**
	 * 사업장수정
	 */
	@RequestMapping("saveBranch.sys")
	public ModelAndView saveBranch(
			// 고객법인 마스터
			@RequestParam(value = "branchId", required = true) 		        String branchId,			// 조직ID
			@RequestParam(value = "branchNm", required = true) 		        String branchNm,			// 사업장명
			@RequestParam(value = "clientId", required = true) 		        String clientId,			// 법인ID
			@RequestParam(value = "registNum1", defaultValue = "") 	        String registNum1,			// 법인등록번호1
			@RequestParam(value = "registNum2", defaultValue = "") 	        String registNum2,			// 법인등록번호2
			@RequestParam(value = "branchBusiType", required = true)        String branchBusiType,		// 업종
			@RequestParam(value = "branchBusiClas", required = true)        String branchBusiClas,		// 업태
			@RequestParam(value = "pressentNm", required = true) 	        String pressentNm,			// 대표자명
			@RequestParam(value = "phoneNum", required = true) 		        String phoneNum,			// 대표전화번호
			@RequestParam(value = "eMail", required = true) 		        String eMail,				// 회사이메일
			@RequestParam(value = "homePage", defaultValue = "") 	        String homePage,			// 홈페이지 
			@RequestParam(value = "postAddrNum", required = true)       	String postAddrNum,			// 주소1 
			@RequestParam(value = "addres", required = true) 		        String addres,				// 주소2 
			@RequestParam(value = "addresDesc", defaultValue = "") 	        String addresDesc,			// 상세주소 
			@RequestParam(value = "faxNum", defaultValue = "") 				String faxNum,				// 팩스번호 
			@RequestParam(value = "refereceDesc", defaultValue = "")		String refereceDesc,		// 참고사항 
			@RequestParam(value = "areaType", required = true) 				String areaType,			// 권역 
			@RequestParam(value = "branchGrad", required = true) 			String branchGrad,			// 회원사등급 
			@RequestParam(value = "payBillType", required = true) 			String payBillType,			// 결제조건
			@RequestParam(value = "payBillDay", defaultValue="") 			String payBillDay,			// 결제일
			@RequestParam(value = "prePay", required = true) 				String prePay,				// 선입금여부
			@RequestParam(value = "accountManageNm", required = true) 		String accountManageNm,		// 회계담당자명 
			@RequestParam(value = "accountTelNum", required = true) 		String accountTelNum,		// 회계이동전화 
			@RequestParam(value = "bankCd", defaultValue="") 				String bankCd,				// 은행코드 
			@RequestParam(value = "recipient", defaultValue="") 			String recipient,			// 예금주명 
			@RequestParam(value = "accountNum", defaultValue="") 			String accountNum,			// 계좌번호 
			@RequestParam(value = "loginAuthType", defaultValue="") 		String loginAuthType,		// 로그인인증 
			@RequestParam(value = "orderAuthType", defaultValue="") 		String orderAuthType,		// 주문인증 
			@RequestParam(value = "isUse", required = true) 				String isUse,				// 상태  
			@RequestParam(value = "closeReason", defaultValue="") 			String closeReason,			// 종료사유 
			@RequestParam(value = "file_biz_reg_list", required = true) 	String file_biz_reg_list,	// 사업자등록첨부 
			@RequestParam(value = "file_app_sal_list", defaultValue = "") 	String file_app_sal_list,	// 신용평가서첨부 
			@RequestParam(value = "file_list1", defaultValue = "")			String file_list1,			// 기타첨부1 
			@RequestParam(value = "file_list2", defaultValue = "")			String file_list2,			// 기타첨부2 
			@RequestParam(value = "file_list3", defaultValue = "")			String file_list3,			// 기타첨부3 	
			@RequestParam(value = "isOrderLimit", defaultValue = "0")		String isOrderLimit,		// 주문제한여부
			@RequestParam(value = "autOrderLimitPeriod", required = true)	String autOrderLimitPeriod, // 주문제한날짜
			@RequestParam(value = "srcContractSpecial", defaultValue = "")	String contractSpecial,		// 계약구분
			@RequestParam(value = "sharpMail", defaultValue = "")			String sharpMail,			// 회사샵메일(필수에서 바뀜)
			@RequestParam(value = "ebillEmail", defaultValue = "")			String ebillEmail,			// 세금계산서 이메일
			@RequestParam(value = "workId", defaultValue = "")				String workId,				// 공사유형
			@RequestParam(value = "isOrderApproval", defaultValue = "0")	String isOrderApproval,		// 주문결재 사용여부
		HttpServletRequest request, ModelAndView modelAndView) throws Exception {
	
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		HashMap<String, Object> saveMap = new HashMap<String, Object>();
		
		saveMap.put("branchId"				,branchId);
		saveMap.put("branchNm"				,branchNm);
		saveMap.put("clientId"				,clientId);
		saveMap.put("registNum"				,registNum1 + registNum2);
		saveMap.put("branchBusiType"		,branchBusiType);
		saveMap.put("branchBusiClas"		,branchBusiClas);
		saveMap.put("pressentNm"			,pressentNm);
		saveMap.put("phoneNum"				,phoneNum);
		saveMap.put("eMail"					,eMail);
		saveMap.put("homePage"				,homePage);
		saveMap.put("postAddrNum"			,postAddrNum);
		saveMap.put("addres"				,addres);
		saveMap.put("addresDesc"			,addresDesc);
		saveMap.put("faxNum"				,faxNum);
		saveMap.put("refereceDesc"			,refereceDesc);
		saveMap.put("areaType"				,areaType);
		saveMap.put("branchGrad"			,branchGrad);
		saveMap.put("payBillType"			,payBillType);
		saveMap.put("payBillDay"			,payBillDay);
		saveMap.put("prePay"				,prePay);
		saveMap.put("accountManageNm"		,accountManageNm);
		saveMap.put("accountTelNum"			,accountTelNum);
		saveMap.put("bankCd"				,bankCd);
		saveMap.put("recipient"				,recipient);
		saveMap.put("accountNum"			,accountNum);
		saveMap.put("remoteIp"				,userInfoDto.getRemoteIp());
		saveMap.put("isUse"					,isUse);
		saveMap.put("closeReason"			,closeReason);
		saveMap.put("userId"				,userInfoDto.getUserId());
		saveMap.put("loginAuthType"			,loginAuthType);
		saveMap.put("orderAuthType"			,orderAuthType);
		saveMap.put("file_biz_reg_list"		,file_biz_reg_list);
		saveMap.put("file_app_sal_list"		,file_app_sal_list);
		saveMap.put("file_list1"			,file_list1);
		saveMap.put("file_list2"			,file_list2);
		saveMap.put("file_list3"			,file_list3);
		saveMap.put("isOrderLimit"			,isOrderLimit);
		saveMap.put("autOrderLimitPeriod"	, autOrderLimitPeriod);
		saveMap.put("contractSpecial"		, contractSpecial);
		saveMap.put("sharpMail"				, sharpMail);
		saveMap.put("ebillEmail"			, ebillEmail);
		saveMap.put("workId"				, workId);
		saveMap.put("isOrderApproval"		, isOrderApproval);
		
		// 사업장의 운영상태가 "종료"로 되었을때만 smpborgs 테이블의 updatedate 컬럼을 update 한다. (사업장 테이블 (smpbranchs 테이블에는 updatedate 칼럼이 없음.))
		// 또한 사용자도 종료 처리 함.
		saveMap.put("isModUpdatedate", "0".equals(isUse) ? "Y":"N" );
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			// 사업장 정보 업데이트, 조직마스터 업데이트 (상태_종료여부, 종료사유)
			organSvc.updateSmpBranchs(saveMap);
		
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
	 * 사업장등록
	 */
	@RequestMapping("saveOrganBranchReg.sys")
	public ModelAndView saveOrganBranchReg(
			// 사업장 정보
			@RequestParam(value = "branchNm", required = true ) 			String branchNm,
			@RequestParam(value = "groupId", required = true ) 				String groupId,
			@RequestParam(value = "clientId", required = true ) 			String clientId,
			@RequestParam(value = "clientCd", required = true ) 			String clientCd,
			@RequestParam(value = "areaType", required = true ) 			String areaType,
			@RequestParam(value = "branchGrad", required = true ) 			String branchGrad,
			@RequestParam(value = "businessNum", required = true ) 			String businessNum,
			@RequestParam(value = "registNum", required = true ) 			String registNum,
			@RequestParam(value = "branchBusiType", required = true ) 		String branchBusiType,
			@RequestParam(value = "branchBusiClas", required = true ) 		String branchBusiClas,
			@RequestParam(value = "pressentNm", required = true ) 			String pressentNm,
			@RequestParam(value = "phoneNum", required = true ) 			String phoneNum,
			@RequestParam(value = "eMail", required = true ) 				String eMail,
			@RequestParam(value = "homePage", defaultValue = "") 			String homePage,
			@RequestParam(value = "postAddrNum", required = true ) 			String postAddrNum,
			@RequestParam(value = "addres", required = true ) 				String addres,
			@RequestParam(value = "addresDesc", defaultValue = "" )			String addresDesc,
			@RequestParam(value = "faxNum", defaultValue = "" )				String faxNum,
			@RequestParam(value = "loginAuthType", required = true ) 		String loginAuthType,
			@RequestParam(value = "orderAuthType", required = true ) 		String orderAuthType,
			@RequestParam(value = "refereceDesc", defaultValue = "" ) 		String refereceDesc,
			@RequestParam(value = "payBillType", required = true ) 			String payBillType,
			@RequestParam(value = "payBillDay", defaultValue="") 			String payBillDay,
			@RequestParam(value = "prePay", required = true ) 				String prePay,
			@RequestParam(value = "accountManageNm", required = true ) 		String accountManageNm,
			@RequestParam(value = "accountTelNum", required = true ) 		String accountTelNum,
			@RequestParam(value = "bankCd", defaultValue = "" )	 			String bankCd,
			@RequestParam(value = "recipient", defaultValue = "" ) 			String recipient,
			@RequestParam(value = "accountNum", defaultValue = "" ) 		String accountNum,
			@RequestParam(value = "file_biz_reg_list", required = true ) 	String file_biz_reg_list,
			@RequestParam(value = "file_app_sal_list", defaultValue = "" ) 	String file_app_sal_list,
			@RequestParam(value = "file_list1", defaultValue = "" )			String file_list1,
			@RequestParam(value = "file_list2", defaultValue = "" )         String file_list2,
			@RequestParam(value = "file_list3", defaultValue = "" )         String file_list3,        
			@RequestParam(value = "isUse", defaultValue = "" )         		String isUse,        
			@RequestParam(value = "closeReason", defaultValue = "" )        String closeReason,
			@RequestParam(value = "accUser", required = true )        		String accUser,
			@RequestParam(value = "workId", required = true )        		String workId,
			@RequestParam(value = "autOrderLimitPeriod", required = true)	String autOrderLimitPeriod,//주문제한 만기일
			@RequestParam(value = "srcContractSpecial", defaultValue="")	String contractSpecial,//물품공급계약
			@RequestParam(value = "sharpMail", required = true)	String sharpMail,//회사샵메일
			//사용자 정보
			@RequestParam(value = "loginId", required = false) 				String loginId,
			@RequestParam(value = "userId", required = false) 				String userId,
			@RequestParam(value = "pwd", required = false) 					String pwd,
			@RequestParam(value = "userNm", required = false) 				String userNm, 
			@RequestParam(value = "tel", required = false) 					String tel,
			@RequestParam(value = "mobile", required = false) 				String mobile,
			@RequestParam(value = "userEmail", required = false) 			String userEmail,
			// 배송처 정보
			@RequestParam(value = "shippingPlaceArr[]", required = false) 	String[] shippingPlaceArr,
			@RequestParam(value = "shippingPhoneNumArr[]", required = false)String[] shippingPhoneNumArr,
			@RequestParam(value = "shippingAddresArr[]", required = false) 	String[] shippingAddresArr,
			// 권한 정보
			@RequestParam(value = "roleCdArr[]", required = false) 			String[] roleCdArr,
			@RequestParam(value = "roleNmArr[]", required = false) 			String[] roleNmArr,
			@RequestParam(value = "roleDescArr[]", required = false) 		String[] roleDescArr,
			@RequestParam(value = "roleIdArr[]", required = false) 			String[] roleIdArr,

			@RequestParam(value = "userSaveFlag", defaultValue = "0") 			String userSaveFlag,
			
			@RequestParam(value = "clientNm", defaultValue = "") 			String clientNm,
			
		HttpServletRequest request, ModelAndView modelAndView) throws Exception {
	
		HashMap<String, Object> saveMap = new HashMap<String, Object>();
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		saveMap.put("branchNm"			,branchNm);
		saveMap.put("clientId"			,clientId);
		saveMap.put("clientCd"			,clientCd);
		saveMap.put("branchBusiType"	,branchBusiType);
		saveMap.put("branchBusiClas"	,branchBusiClas);
		saveMap.put("pressentNm"		,pressentNm);
		saveMap.put("phoneNum"			,phoneNum);
		saveMap.put("eMail"				,eMail);
		saveMap.put("homePage"			,homePage);
		saveMap.put("postAddrNum"		,postAddrNum);
		saveMap.put("addres"			,addres);
		saveMap.put("addresDesc"		,addresDesc);
		saveMap.put("faxNum"			,faxNum);
		saveMap.put("refereceDesc"		,refereceDesc);
		saveMap.put("areaType"			,areaType);
		saveMap.put("branchGrad"		,branchGrad);
		saveMap.put("payBillType"		,payBillType);
		saveMap.put("payBillDay"		,payBillDay);
		saveMap.put("prePay"			,prePay);
		saveMap.put("accountManageNm"	,accountManageNm);
		saveMap.put("accountTelNum"		,accountTelNum);
		saveMap.put("bankCd"			,bankCd);
		saveMap.put("recipient"			,recipient);
		saveMap.put("accountNum"		,accountNum);
		saveMap.put("remoteIp"			,userInfoDto.getRemoteIp());
		saveMap.put("isUse"				,isUse);
		saveMap.put("closeReason"		,closeReason);
		saveMap.put("regUserId"			,userInfoDto.getUserId());
		saveMap.put("loginAuthType"		,loginAuthType);
		saveMap.put("orderAuthType"		,orderAuthType);
		saveMap.put("file_biz_reg_list"	,file_biz_reg_list);
		saveMap.put("file_app_sal_list"	,file_app_sal_list);
		saveMap.put("file_list1"		,file_list1);
		saveMap.put("file_list2"		,file_list2);
		saveMap.put("file_list3"		,file_list3);
		saveMap.put("groupId"			,groupId);
		saveMap.put("businessNum"		,businessNum);
		saveMap.put("registNum"			,registNum);
		saveMap.put("accUser"			,accUser);
		saveMap.put("workId"			,workId);
		saveMap.put("autOrderLimitPeriod", autOrderLimitPeriod);//주문제한만기일
		saveMap.put("contractSpecial", contractSpecial);//물품공급계약서
		saveMap.put("sharpMail", sharpMail);//회사샵메일
		//사용자 정보
		saveMap.put("loginId", 				loginId);			
		saveMap.put("userId", 				userId);
		saveMap.put("pwd", 					pwd);
		saveMap.put("userNm", 				userNm); 
		saveMap.put("tel", 					tel);
		saveMap.put("mobile", 				mobile);
		saveMap.put("userEmail", 			userEmail);
		//배송지 정보
		saveMap.put("shippingPlaceArr", 	shippingPlaceArr);
		saveMap.put("shippingPhoneNumArr",	shippingPhoneNumArr);
		saveMap.put("shippingAddresArr", 	shippingAddresArr);
		//권한 정보
		saveMap.put("roleCdArr", 			roleCdArr);
		saveMap.put("roleNmArr", 			roleNmArr);
		saveMap.put("roleDescArr", 			roleDescArr);
		saveMap.put("roleIdArr", 			roleIdArr);	

		saveMap.put("userSaveFlag", 			userSaveFlag);
		//사업장 생성시 메일에 보낼 법인명
		saveMap.put("clientNm", clientNm);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			// 사업장 등록
			organSvc.saveOrganBranchReg(saveMap);
		
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
	 * 소속사용자 조회
	 */
	@RequestMapping("organBorgUserJQGrid.sys")
	public ModelAndView organBorgUserJQGrid(
			@RequestParam(value = "borgId", required = true) 		String borgId,
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회------------*/
        List<SmpUsersDto> list = organSvc.selectBorgUsers(borgId);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}	
	
	/**
	 * 소속사용자 저장
	 */
	
	@RequestMapping("saveBorgsUsers.sys")
	public ModelAndView saveBorgsUsers(
		// 고객법인 마스터
		@RequestParam(value = "oper", defaultValue = "")          	String oper, 			// oper
		@RequestParam(value = "userId", defaultValue = "")          String userId, 			// 사용자 ID
		@RequestParam(value = "borgId", defaultValue = "")          String borgId,		    // 조직 ID 			
		@RequestParam(value = "loginId", defaultValue = "")         String loginId,		    // 로그인 ID 			
		@RequestParam(value = "isDefault", defaultValue = "0")      String isDefault,		// 기본권한여부 (Default : 0) 			
		HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		HashMap<String, Object> saveMap = new HashMap<String, Object>();
		
		saveMap.put("userId"		,userId);
		saveMap.put("borgId"		,borgId);
		saveMap.put("loginId"		,loginId);
		saveMap.put("isDefault"		,isDefault);
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			
			if("add".equals(oper)){
				organSvc.insertBorgsUsers(saveMap);
			}else if("del".equals(oper)){
				organSvc.deleteBorgsUsers(saveMap);
			}
			
		} catch(Exception e) {
			String msg = null;
			if(e.toString().indexOf("DuplicateKeyException") != -1){
				msg = "이미 등록된 사용자입니다.";
			}else if(e.toString().indexOf("OrderException") != -1){ //OrderException
				msg = "해당 사업장에서 주문한 내역이 존재하여\n 해당사용자를 삭제할수 없습니다.";
			}else{
				msg = CommonUtils.getErrSubString(e,50);
			}
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage(msg);
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;			
	}	
	
	
	/**
	 * 사업장등록
	 */
	@RequestMapping("organBranchReg.sys")
	public ModelAndView organBranchReg( HttpServletRequest req, ModelAndView mav) throws Exception{
		//권역코드
		mav.addObject("areaCode", commonSvc.getCodeList("DELI_AREA_CODE", 1));
		//은행코드
		mav.addObject("bankCode", commonSvc.getCodeList("BANKCD", 1));
		//회원사등급
		mav.addObject("mGradeCode", commonSvc.getCodeList("MEMBERGRADE", 1));
		//결제조건
		mav.addObject("payCondCode", commonSvc.getCodeList("PAYMCONDCODE", 1));
		
		//공사유형
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orderString", " workNm asc");
		mav.addObject("workInfoList", commonSvc.selectWorkInfo(params));
		//채권관리자
		mav.addObject("admUserList", adjustSvc.getAdjustAlramUserList());		
		
		mav.setViewName("organ/organBranchReg");
		return mav;

	}
	
	/**
	 * 법인대표사업장 정보검색
	 */
	
	/**
	 * 사용자조회 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("organBranchSearch.sys")
	public ModelAndView organBranchSearch(
			@RequestParam(value = "clientId", required=true) String clientId,		
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("clientId", clientId);
		
        /*----------------조회------------*/
		SmpBranchsDto detailInfo = organSvc.organBranchSearch(clientId);	// 사업장 마스터

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("data", detailInfo);
		return modelAndView;
	}	
	
	
	
	
	/**사용자조회 */
	@RequestMapping("organUserList.sys")
	public ModelAndView getOrganUserList( HttpServletRequest req, ModelAndView mav) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orderString", " workNm asc");		
		mav.addObject("workInfoList", commonSvc.selectWorkInfo(params));
		mav.setViewName("organ/organUserList");
		return mav;
	}
	
	/**
	 * 사용자조회 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("organUserListJQGrid.sys")
	public ModelAndView organUserListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "a.vendorId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,
			@RequestParam(value = "srcUserNm", defaultValue = "") String srcUserNm,
			@RequestParam(value = "srcLoginId", defaultValue = "") String srcLoginId,
			@RequestParam(value = "srcIsUse", defaultValue = "1") String srcIsUse,		
			@RequestParam(value = "srcIsDirect", defaultValue = "1") String srcIsDirect,		
			@RequestParam(value = "srcWorkId", defaultValue = "") String srcWorkId,		
			
			@RequestParam(value = "srcBorgIsUse", defaultValue = "") String srcBorgIsUse,		
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcUserNm", srcUserNm);
		params.put("srcLoginId", srcLoginId);
		params.put("srcIsUse", srcIsUse);
		params.put("srcIsDirect", srcIsDirect);
		params.put("srcWorkId", srcWorkId);
		
		params.put("srcBorgIsUse", srcBorgIsUse);
		if("userId".equals(sidx)) {
			sidx = "a."+sidx;
		}
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        int records = organSvc.getOrganUserListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<SmpUsersDto> list = null;
        if(records>0) list = organSvc.getOrganUserList(params, page, rows);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 사용자조회 DB조회후 엑셀다운로드
	 */
	@RequestMapping("organUserListExcel.sys")
	public ModelAndView organUserListExcel(
			@RequestParam(value = "sidx", defaultValue = "a.userId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,
			@RequestParam(value = "srcUserNm", defaultValue = "") String srcUserNm,
			@RequestParam(value = "srcLoginId", defaultValue = "") String srcLoginId,
			@RequestParam(value = "srcIsUse", defaultValue = "1") String srcIsUse,		
			@RequestParam(value = "srcIsDirect", defaultValue = "1") String srcIsDirect,	
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcUserNm", srcUserNm);
		params.put("srcLoginId", srcLoginId);
		params.put("srcIsUse", srcIsUse);
		params.put("srcIsDirect", srcIsDirect);
		if("userId".equals(sidx)) {
			sidx = "a."+sidx;
		}
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------조회------------*/
		List<SmpUsersDto> list = organSvc.getOrganUserList(params, 1, RowBounds.NO_ROW_LIMIT);
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				rtnData.put("branchNm", list.get(i).getBranchNm().replace("&gt;", ">"));
				rtnData.put("areaTypeNm", list.get(i).getAreaTypeNm());
				rtnData.put("userNm", list.get(i).getUserNm());
				rtnData.put("loginId", list.get(i).getLoginId());
				rtnData.put("isUse", list.get(i).getIsUse());
				rtnData.put("borg_IsUse", list.get(i).getBorg_IsUse());
				rtnData.put("isLogin", list.get(i).getIsLogin());
				rtnData.put("tel", list.get(i).getTel());
				rtnData.put("mobile", list.get(i).getMobile());
				rtnData.put("isEmail", list.get(i).getIsEmail());
				rtnData.put("isSms", list.get(i).getIsSms());
				rtnData.put("createDate", list.get(i).getCreateDate());
				rtnData.put("isDirect", list.get(i).getIsDirect());
				rtnData.put("workNm", list.get(i).getWorkNm());
				colDataList.add(rtnData);
			}
		}					
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
//        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", colDataList);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;		
	}
	
	/**
	 * 사용자상세
	 */
	@RequestMapping("organUserDetail.sys")
	public ModelAndView getOrganUserDetail(
			@RequestParam(value = "borgId", required = true) String borgId,
			@RequestParam(value = "userId", required = true) String userId,
			HttpServletRequest req, ModelAndView mav) throws Exception{

		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("userId", userId);
		params.put("borgId", borgId);
		
		SmpUsersDto userDto = organSvc.selectOrganUserDetail(params);
		
		mav.addObject("borgId"	, borgId);
		mav.addObject("userDto"	, userDto);
		mav.addObject("branchList"	, organSvc.getSmpBorgsUsersByUserId(userId));
		mav.setViewName("organ/organUserDetail");
		return mav;
	}
	
	/**
	 * 사용자등록
	 */
	@RequestMapping("organUserReg.sys")
	public ModelAndView organUserReg( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("organ/organUserReg");
		return mav;
	}
	
	/**
	 * 사용자 등록/수정
	 */
	@RequestMapping("saveUserDetail.sys")
	public ModelAndView saveUserDetail(
			@RequestParam(value = "oper"				, required = true) String oper,
			@RequestParam(value = "borgId"				, required = true) String borgId,
			@RequestParam(value = "userId"				, required = true) String userId,
			@RequestParam(value = "userNm"				, required = true) String userNm,
			@RequestParam(value = "loginId"				, required = true) String loginId,
			@RequestParam(value = "pwd"				    , required = true) String pwd,
			@RequestParam(value = "tel"				    , required = true) String tel,
			@RequestParam(value = "mobile"			    , required = true) String mobile,
			@RequestParam(value = "eMail"			    , required = true) String eMail,
			@RequestParam(value = "isUse"			    , required = true) String isUse,
			@RequestParam(value = "endCauseDesc"	    , defaultValue = "") String endCauseDesc,
			@RequestParam(value = "userNote"		    , defaultValue = "") String userNote,
			@RequestParam(value = "isEmail"	    		, defaultValue = "0") String isEmail,
			@RequestParam(value = "isSms"	    		, defaultValue = "0") String isSms,
			@RequestParam(value = "emailByPurchase"	    , defaultValue = "0") String emailByPurchase,
			@RequestParam(value = "emailByDelivery"		, defaultValue = "0") String emailByDelivery,
			@RequestParam(value = "emailByRegisterGood" , defaultValue = "0") String emailByRegisterGood,
			@RequestParam(value = "smsByPurchase"		, defaultValue = "0") String smsByPurchase,
			@RequestParam(value = "smsByDelivery"		, defaultValue = "0") String smsByDelivery,
			@RequestParam(value = "smsByRegisterGood"	, defaultValue = "0") String smsByRegisterGood,	
			@RequestParam(value = "emailByPurchaseOrder"  , defaultValue = "0") String emailByPurchaseorder,
			@RequestParam(value = "emailByOrdrtReceive"   , defaultValue = "0") String emailByOrdrtreceive,
			@RequestParam(value = "emailByNotiAuction"    , defaultValue = "0") String emailByNotiauction,
			@RequestParam(value = "emailByNotiSuccessBid" , defaultValue = "0") String emailByNotisuccessbid,
			@RequestParam(value = "smsByPurchaseOrder"    , defaultValue = "0") String smsByPurchaseorder,
			@RequestParam(value = "smsByOrdrtReceive"     , defaultValue = "0") String smsByOrdrtreceive,
			@RequestParam(value = "smsByNotiAuction"      , defaultValue = "0") String smsByNotiauction,
			@RequestParam(value = "smsByNotiSuccessBid"	  , defaultValue = "0") String smsByNotisuccessbid,
			@RequestParam(value = "isOrderApproval"	  	  , defaultValue = "0") String isOrderApproval,
			@RequestParam(value = "isDefaultBorgs"	  	  , defaultValue = "") String isDefaultBorgs,
			@RequestParam(value = "isDefaultArr[]", required = false) 		String[] isDefaultArr,
		HttpServletRequest request, ModelAndView modelAndView) throws Exception {
	
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("borgId"				, borgId);
		saveMap.put("userId"				, userId);
		saveMap.put("userNm"				, userNm);
		saveMap.put("loginId"				, loginId);
		saveMap.put("pwd"					, pwd);
		saveMap.put("tel"					, tel);
		saveMap.put("mobile"				, mobile);
		saveMap.put("userEmail"				, eMail);
		saveMap.put("isUse"					, isUse);
		saveMap.put("endCauseDesc"			, endCauseDesc);
		saveMap.put("userNote"				, userNote);
		saveMap.put("isEmail"				, isEmail);
		saveMap.put("isSms"					, isSms);		
		saveMap.put("emailByPurchase"		, emailByPurchase);
		saveMap.put("emailByDelivery"		, emailByDelivery);
		saveMap.put("emailByRegistergood"	, emailByRegisterGood);
		saveMap.put("smsByPurchase"			, smsByPurchase);
		saveMap.put("smsByDelivery"			, smsByDelivery);
		saveMap.put("smsByRegistergood"		, smsByRegisterGood);  
		saveMap.put("emailByPurchaseorder"  , emailByPurchaseorder);
		saveMap.put("emailByOrdrtreceive"   , emailByOrdrtreceive);
		saveMap.put("emailByNotiauction"    , emailByNotiauction);
		saveMap.put("emailByNotisuccessbid" , emailByNotisuccessbid);
		saveMap.put("smsByPurchaseorder"    , smsByPurchaseorder);
		saveMap.put("smsByOrdrtreceive"     , smsByOrdrtreceive);
		saveMap.put("smsByNotiauction"      , smsByNotiauction);
		saveMap.put("smsByNotisuccessbid"	, smsByNotisuccessbid);
		saveMap.put("isDefaultArr"			, isDefaultArr);
		saveMap.put("isOrderApproval"		, isOrderApproval);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			
			if("add".equals(oper)){
				organSvc.insertOrganUserDetail(saveMap);
			}else if("upd".equals(oper)){
				saveMap.put("isDefaultBorgs"	, isDefaultBorgs);
				organSvc.updateOrganUserDetail(saveMap);
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
	 * 고객법인등록요청조회
	 */
	@RequestMapping("organClientRegistRequestList.sys")
	public ModelAndView getOrganClientRegistRequestList( HttpServletRequest request, ModelAndView mav) throws Exception{
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		List<LoginRoleDto> roleList =  userInfoDto.getLoginRoleList();

		String registerCd = null;
		String userRoleCd = null;
		
		for(int i = 0 ; i < roleList.size() ; i++) {
			LoginRoleDto dto = roleList.get(i);
			
			if("ADM_APP".equals(dto.getRoleCd())) {
				userRoleCd	= dto.getRoleCd();
				registerCd 	= "30"; 
				break;
			} else if("ADM_REG".equals(dto.getRoleCd())){
				userRoleCd	= dto.getRoleCd();
				registerCd = "10";
				break;
			} else {
				userRoleCd	= dto.getRoleCd();
				registerCd = "20";
			}
		}
		//공사유형
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orderString", " workNm asc");
		mav.addObject("workInfoList", commonSvc.selectWorkInfo(params));
		//채권관리자
		mav.addObject("admUserList", adjustSvc.getAdjustAlramUserList());	
		mav.addObject("userRoleCd"		, userRoleCd);
		mav.addObject("srcRegisterCd"	, registerCd);
		mav.addObject("menuCd"	, organSvc.getMenuCd(request.getParameter("_menuId")));
		mav.setViewName("organ/organClientRegistRequestList");
		return mav;
	}
	
	/**
	 * 고객법인등옥요청 리스트
	 */
	@RequestMapping("organClientRegistRequestListJQGrid.sys")
	public ModelAndView organClientRegistRequestListJQGrid(
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			/*  조회 조건 */
			@RequestParam(value = "sidx", defaultValue = "clientId") String sidx, 													// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "desc") String sord,														// 정렬 조건
			@RequestParam(value = "srcClientNm", defaultValue = "") String srcClientNm,												// 법인명
			@RequestParam(value = "srcRegisterCd", defaultValue = "") String srcRegisterCd,											// 등록상태
			@RequestParam(value = "srcAccUser", defaultValue = "") String srcAccUser,
			@RequestParam(value = "srcWorkId", defaultValue = "") String srcWorkId,
			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		HashMap<String, Object> params = new HashMap<String, Object>();
		String preSidx = "";
		if("workNm".equals(sidx)) preSidx = "B.";
		if("userNm".equals(sidx)) preSidx = "C.";
		
		String orderString = " " + preSidx + sidx + " " + sord + " ";
		
		params.put("orderString"	, orderString);
		params.put("srcClientNm"	, srcClientNm);
		params.put("srcRegisterCd"	, srcRegisterCd);
		params.put("srcAccUser"		, srcAccUser);
		params.put("srcWorkId"		, srcWorkId);
		
		//----------------페이징 세팅------------/
        int records = organSvc.getOrganClientRegistRequestListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        //----------------조회------------/
        List<SmpBranchsDto> list = null; 
        if(records>0) list = organSvc.getOrganClientRegistRequestListJQGrid(params, page, rows);
        
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("srcRegisterCd", srcRegisterCd);
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 고객법인등옥요청 리스트
	 */
	@RequestMapping("organClientRegistRequestListExcel.sys")
	public ModelAndView organClientRegistRequestListExcel(
			/*  조회 조건 */
			@RequestParam(value = "sidx", defaultValue = "clientId") String sidx, 													// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "desc") String sord,														// 정렬 조건
			@RequestParam(value = "srcClientNm", defaultValue = "") String srcClientNm,												// 법인명
			@RequestParam(value = "srcRegisterCd", defaultValue = "") String srcRegisterCd,											// 등록상태
			@RequestParam(value = "srcAccUser", defaultValue = "") String srcAccUser,
			@RequestParam(value = "srcWorkId", defaultValue = "") String srcWorkId,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		HashMap<String, Object> params = new HashMap<String, Object>();
		String preSidx = "";
		if("workNm".equals(sidx)) preSidx = "B.";
		if("userNm".equals(sidx)) preSidx = "C.";
		
		String orderString = " " + preSidx + sidx + " " + sord + " ";
		
		params.put("orderString"	, orderString);
		params.put("srcClientNm"	, srcClientNm);
		params.put("srcRegisterCd"	, srcRegisterCd);
		params.put("srcAccUser"		, srcAccUser);
		params.put("srcWorkId"		, srcWorkId);
		
		//----------------조회------------/
		List<SmpBranchsDto> list = organSvc.getOrganClientRegistRequestListJQGrid(params, 1, RowBounds.NO_ROW_LIMIT);
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				rtnData.put("clientNm", list.get(i).getClientNm());
				rtnData.put("businessNum", list.get(i).getBusinessNum());
				rtnData.put("areaType", list.get(i).getAreaType());
				rtnData.put("registerCd", list.get(i).getRegisterCd());
				rtnData.put("phoneNum", list.get(i).getPhoneNum());
				rtnData.put("pressentNm", list.get(i).getPressentNm());
				rtnData.put("postAddrNum", list.get(i).getPostAddrNum());
				rtnData.put("addres", list.get(i).getAddres());
				rtnData.put("registerDate", list.get(i).getRegisterDate());
				rtnData.put("appDate", list.get(i).getAppDate());
				rtnData.put("confirDate", list.get(i).getConfirDate());
				rtnData.put("workNm", list.get(i).getWorkNm());
				rtnData.put("userNm", list.get(i).getUserNm());
				colDataList.add(rtnData);
			}
		}			
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
//        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", colDataList);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;			
	}
	
	/**고객법인등록요청 상세
	 */
	@RequestMapping("organClientRegistRequestDetail.sys")
	public ModelAndView getOrganClientRegistRequestDetail(
			@RequestParam(value = "branchId",required = true) String branchId,
			@RequestParam(value = "clientId",required = true) String clientId,
			ModelAndView modelAndView, HttpServletRequest req) throws Exception{
		
		/*----------------조회조건 세팅------------*/
		SmpBranchsDto 				detailInfo 				= organSvc.selectOneReqBranchs(branchId);		// 요청법인 마스터
		SmpUsersDto 				userInfo 				= organSvc.selectUserInfo(branchId);			// 사용자 마스터
		
		LoginUserDto userInfoDto = (LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME);
		List<LoginRoleDto> roleList =  userInfoDto.getLoginRoleList();

		String userRoleCd = null;
		
		for(int i = 0 ; i < roleList.size() ; i++) {
			LoginRoleDto dto = roleList.get(i);
			
			// 사용자 기본권한인지의 여부 확인
			if("1".equals(dto.getIsDefault())){
				userRoleCd = dto.getRoleCd();
				break;
			}
		}
		//공사유형
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orderString", " workNm asc");
		modelAndView.addObject("workInfoList"			, commonSvc.selectWorkInfo(params));
		//채권관리자
		modelAndView.addObject("admUserList"			, adjustSvc.getAdjustAlramUserList());			
		modelAndView.addObject("userRoleCd"				, userRoleCd);
		modelAndView.addObject("branchId"				, branchId);
		modelAndView.addObject("clientId"				, clientId);
		modelAndView.addObject("detailInfo"				, detailInfo);
		modelAndView.addObject("userInfo"				, userInfo);
		
		//권역코드
		modelAndView.addObject("areaCode", commonSvc.getCodeList("DELI_AREA_CODE", 1));
		//은행코드
		modelAndView.addObject("bankCode", commonSvc.getCodeList("BANKCD", 1));
		//회원사등급
		modelAndView.addObject("mGradeCode", commonSvc.getCodeList("MEMBERGRADE", 1));
		//결제조건
		modelAndView.addObject("payCondCode", commonSvc.getCodeList("PAYMCONDCODE", 1));
		
		modelAndView.setViewName("organ/organClientRegistRequestDetail");
		return modelAndView;		
	}

	/**
	 * 배송지 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getDeliveryInfoList.sys")
	public ModelAndView getDeliveryInfoList(
			@RequestParam(value = "branchId",required = true) String branchId,
			ModelAndView modelAndView, HttpServletRequest req) throws Exception{
		
		/*----------------조회조건 세팅------------*/
		List<SmpDeliveryInfoDto> 	deliveryInfoList 		= organSvc.selectDeliveryInfoList(branchId);// 배송처 정보 리스트
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list"		, deliveryInfoList);
		return modelAndView;		
	}
	
	
	/**
	 * 배송지 저장/삭제
	 */
	@RequestMapping("saveDeliveryInfo.sys")
	public ModelAndView saveDeliveryInfo (
			@RequestParam(value = "oper", required = true) String oper,	// oper
			@RequestParam(value = "shippingPlace", defaultValue = "") String shippingPlace,			// 배송지명
			@RequestParam(value = "shippingPhoneNum", defaultValue = "") String shippingPhoneNum,	// 배송지 전화번호
			@RequestParam(value = "shippingAddres", defaultValue = "") String shippingAddres,		// 배송지 주소
			@RequestParam(value = "groupId", defaultValue = "") String groupId,						// 그룹ID
			@RequestParam(value = "branchId", defaultValue = "") String branchId,					// 조직ID
			@RequestParam(value = "clientId", defaultValue = "") String clientId,					// 법인ID
			@RequestParam(value = "isDefault", defaultValue = "0") String isDefault,				// 기본배송지 여부
			@RequestParam(value = "deliveryId", defaultValue = "") String deliveryId,				// 배송지ID
			ModelAndView mav, HttpServletRequest req) throws Exception {
		
		/*----------------파라미터 세팅------------*/
		HashMap<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("shippingPlace"		, shippingPlace);
		saveMap.put("shippingPhoneNum"	, shippingPhoneNum);
		saveMap.put("shippingAddres"	, shippingAddres);
		saveMap.put("groupId"			, groupId);
		saveMap.put("branchId"			, branchId);
		saveMap.put("clientId"			, clientId);
		saveMap.put("isDefault"			, isDefault);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("del".equals(oper)) {
				saveMap.put("deliveryId" , deliveryId);
				organSvc.deleteDeliveryInfo(saveMap);
			} else if("add".equals(oper)) {
				organSvc.insertDeliveryInfo(saveMap);
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}		
		mav = new ModelAndView("jsonView");
		mav.addObject(custResponse);
		return mav;
	}	
	
	/**
	 * 기본권한 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getDefaultBorgRole.sys")
	public ModelAndView getDefaultBorgRole(
			@RequestParam(value = "sord",defaultValue = "desc") String sord,
			@RequestParam(value = "sidx",defaultValue = "b.isDefault") String sidx,
			@RequestParam(value = "borgId",required = true) String borgId,
			@RequestParam(value = "userId",defaultValue= "") String userId,
			ModelAndView modelAndView, HttpServletRequest req) throws Exception{
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("borgId"		, borgId);
		params.put("userId"		, userId);
		params.put("orderString", orderString);
		
		List<BorgRoleDto> selectDefaultBorgRole = organSvc.selectDefaultBorgRole(params);	// 기본권한 리스트
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list"	, selectDefaultBorgRole);
		return modelAndView;		
	}

	/**
	 * 조직운영자 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getAdminBorgs.sys")
	public ModelAndView getAdminBorgs(
			@RequestParam(value = "clientId",required = true) String clientId,
			ModelAndView modelAndView, HttpServletRequest req) throws Exception{
		
		/*----------------조회조건 세팅------------*/
		List<AdminBorgsDto> selectAdminborgs = organSvc.getAdminborgs(clientId);	// 기본권한 리스트
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list"	, selectAdminborgs);
		return modelAndView;		
	}
	
	/**고객법인등록요청 등록
	 */
	@RequestMapping("organClientRegistRequestRegist.sys")
	public ModelAndView getOrganClientRegistRequestRegist( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("organ/organClientRegistRequestDetail");
//		mav.setViewName("organ/organClientRegistRequestRegist"); 	//개발시 참조
		return mav;
	}
	
	/**
	 * 운영자 등록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("insertAdminBorgs.sys")
	public ModelAndView insertAdminBorgs (
			@RequestParam(value = "userId", required = true) 		        String userId,			// 사용자ID
			@RequestParam(value = "manageBorgId", required = true) 		    String manageBorgId,	// 실관리조직ID
			@RequestParam(value = "manageBorgCd", required = true) 		    String manageBorgCd,	// 실관리조직코드
			@RequestParam(value = "borgTypeCd", required = true) 		    String borgTypeCd,		// 관리조직유형코드
			
			ModelAndView mav, HttpServletRequest req) throws Exception {
		
		HashMap<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("userId"		, userId);
		saveMap.put("manageBorgId"	, manageBorgId);
		saveMap.put("manageBorgCd"	, manageBorgCd);
		saveMap.put("borgTypeCd"	, borgTypeCd);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			organSvc.insertAdminBorgs(saveMap);
	
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("이미 등록된 운영자입니다.");
			//custResponse.setMessage("System Excute Error!....");
			//custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}		
		mav = new ModelAndView("jsonView");
		mav.addObject(custResponse);
		return mav;
	}
	
	/**
	 * 운영자 삭제
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("deleteAdminBorgs.sys")
	public ModelAndView deleteAdminBorgs (
			@RequestParam(value = "adminBorgId", required = true) String adminBorgId,	// 사용자ID
			ModelAndView mav, HttpServletRequest req) throws Exception {
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			organSvc.deleteAdminBorgs(adminBorgId);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}		
		mav = new ModelAndView("jsonView");
		mav.addObject(custResponse);
		return mav;
	}

	/**
	 * 기본권한 삭제
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("saveUserRoles.sys")
	public ModelAndView saveUserRoles (
			@RequestParam(value = "oper", required = true) String oper,	// oper
			@RequestParam(value = "userId", required = true) String userId,	// 사용자ID
			@RequestParam(value = "roleId", required = true) String roleId,	// 권한ID
			@RequestParam(value = "borgId", required = true) String borgId,	// 조직ID
			@RequestParam(value = "isDefault", defaultValue = "0") String isDefault,
			@RequestParam(value = "borgScopeCd", defaultValue = "5000") String borgScopeCd,
			ModelAndView mav, HttpServletRequest req) throws Exception {
		
		/*----------------파라미터 세팅------------*/
		HashMap<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("userId", userId);
		saveMap.put("roleId", roleId);
		saveMap.put("borgId", borgId);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("del".equals(oper)) {
				organSvc.deleteUserRoles(saveMap);
			} else if("add".equals(oper)) {
				saveMap.put("isDefault", isDefault);
				saveMap.put("borgScopeCd", borgScopeCd);
				organSvc.regBorgsUsersRoles(saveMap);
			} else if("upd".equals(oper)) {
				organSvc.updateUserRolesIsDefault(saveMap);
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}		
		mav = new ModelAndView("jsonView");
		mav.addObject(custResponse);
		return mav;
	}
	
	
	/**
	 * 고객법인 확인요청 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("updateBranchReq.sys")
	public ModelAndView updateBranchReq(
			// 고객법인 마스터
			@RequestParam(value = "branchId", required = true) 		        	String branchId,			// 조직ID
			@RequestParam(value = "clientNm", required = true) 		        	String clientNm,			// 법인명
			@RequestParam(value = "clientCd", required = true) 		        	String clientCd,			// 법인코드
			@RequestParam(value = "clientId", required = true) 		        	String clientId,			// 법인ID
			@RequestParam(value = "businessNum1", required = true)          	String businessNum1,		// 사업자등록번호1
			@RequestParam(value = "businessNum2", required = true)          	String businessNum2,		// 사업자등록번호2
			@RequestParam(value = "businessNum3", required = true)          	String businessNum3,		// 사업자등록번호3
			@RequestParam(value = "registNum1", defaultValue = "") 	        	String registNum1,			// 법인등록번호1
			@RequestParam(value = "registNum2", defaultValue = "") 	        	String registNum2,			// 법인등록번호2
			@RequestParam(value = "branchBustType", required = true)        	String branchBustType,		// 업종
			@RequestParam(value = "branchBustClas", required = true)        	String branchBustClas,		// 업태
			@RequestParam(value = "pressentNm", required = true) 	        	String pressentNm,			// 대표자명
			@RequestParam(value = "phoneNum", required = true) 		        	String phoneNum,			// 대표전화번호
			@RequestParam(value = "eMail", required = true) 		        	String eMail,			    // 회사이메일
			@RequestParam(value = "homePage", defaultValue = "") 	        	String homePage,		    // 홈페이지 
			@RequestParam(value = "postAddrNum", required = true)       		String postAddrNum,		    // 주소1 
			@RequestParam(value = "addres", required = true) 		        	String addres,				// 주소2 
			@RequestParam(value = "addresDesc", defaultValue = "") 	        	String addresDesc,			// 상세주소 
			@RequestParam(value = "faxNum", defaultValue = "") 					String faxNum,				// 팩스번호 
			@RequestParam(value = "refereceDesc", defaultValue = "")			String refereceDesc,		// 참고사항 
			@RequestParam(value = "areaType", required = true) 					String areaType,		    // 권역 
			@RequestParam(value = "branchGrad", required = true) 				String branchGrad,		    // 회원사등급 
			@RequestParam(value = "payBillType", required = true) 				String payBillType,		    // 결제조건
			@RequestParam(value = "payBillDay", defaultValue="") 				String payBillDay,		    // 결제일
			@RequestParam(value = "accountManagerNm", required = true) 			String accountManagerNm,	// 회계담당자명 
			@RequestParam(value = "accountTelNum", required = true) 			String accountTelNum,		// 회계이동전화 
			@RequestParam(value = "bankCd", required = true) 					String bankCd,				// 은행코드 
			@RequestParam(value = "recipient", required = true) 				String recipient,		    // 예금주명 
			@RequestParam(value = "accountNum", required = true) 				String accountNum,		    // 계좌번호 
			@RequestParam(value = "userNm", required = true) 					String userNm,				// 성명 
			@RequestParam(value = "tel", required = true) 						String tel,					// 전화번호 
			@RequestParam(value = "mobile", required = true) 					String mobile,				// 이동전화번호 
			@RequestParam(value = "userEmail", required = true) 				String userEmail,			// 이메일 
			@RequestParam(value = "loginAuthType", required = true) 			String loginAuthType,		// 로그인 인증 
			@RequestParam(value = "orderAuthType", required = true) 			String orderAuthType,		// 결제 인증 
			@RequestParam(value = "userId", required = true) 					String userId,				// User ID 
			@RequestParam(value = "registerCd", required = true) 				String registerCd,			// 승인유형 
			@RequestParam(value = "workId", required = true) 					String workId,				// 공사유형 
			@RequestParam(value = "accUser", required = true) 					String accUser,				// 채권담당자 
			@RequestParam(value = "isSap", defaultValue = "0") 					String isSap,
			@RequestParam(value = "srcContractSpecial", required = true)	String contractSpecial,	//물품공급계약서구분
			@RequestParam(value = "sharpMail", required = true)	String sharpMail,	//회사샵메일
			
			// 첨부파일 저장추가
			@RequestParam(value="file_biz_reg_list",defaultValue="")String file_biz_reg_list,				//사업자등록증
			@RequestParam(value="file_app_sal_list",defaultValue="")String file_app_sal_list,				//신용평가서첨부
			@RequestParam(value="file_list1",defaultValue="")String file_list1,								//통장사본
			@RequestParam(value="file_list2",defaultValue="")String file_list2,								//공사계약서
			@RequestParam(value="file_list3",defaultValue="")String file_list3,								//회사소개서
			
		HttpServletRequest request, ModelAndView modelAndView) throws Exception {
	
		HashMap<String, Object> saveMap = new HashMap<String, Object>();
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		saveMap.put("branchId"			,branchId);
		saveMap.put("clientNm"			,clientNm);
		saveMap.put("clientCd"			,clientCd);
		saveMap.put("clientId"			,clientId);
		saveMap.put("businessNum"		,businessNum1 + businessNum2 + businessNum3);
		saveMap.put("registNum"			,registNum1 + registNum2);
		saveMap.put("branchBustType"	,branchBustType);
		saveMap.put("branchBustClas"	,branchBustClas);
		saveMap.put("pressentNm"		,pressentNm);
		saveMap.put("phoneNum"			,phoneNum);
		saveMap.put("eMail"				,eMail);
		saveMap.put("homePage"			,homePage);
		saveMap.put("postAddrNum"		,postAddrNum);
		saveMap.put("addres"			,addres);
		saveMap.put("addresDesc"		,addresDesc);
		saveMap.put("faxNum"			,faxNum);
		saveMap.put("refereceDesc"		,refereceDesc);
		saveMap.put("areaType"			,areaType);
		saveMap.put("branchGrad"		,branchGrad);
		saveMap.put("payBillType"		,payBillType);
		saveMap.put("payBillDay"		,payBillDay);
		saveMap.put("accountManagerNm"	,accountManagerNm);
		saveMap.put("accountTelNum"		,accountTelNum);
		saveMap.put("bankCd"			,bankCd);
		saveMap.put("recipient"			,recipient);
		saveMap.put("accountNum"		,accountNum);
		saveMap.put("userNm"			,userNm);
		saveMap.put("tel"				,tel);
		saveMap.put("mobile"			,mobile);
		saveMap.put("userEmail"			,userEmail);
		saveMap.put("remoteIp"			,request.getRemoteAddr());
		saveMap.put("loginAuthType"		,loginAuthType);
		saveMap.put("orderAuthType"		,orderAuthType);
		saveMap.put("userId"			,userId);
		saveMap.put("registerCd"		,registerCd);
		saveMap.put("creatorRemoteIp"	,userInfoDto.getRemoteIp());
		saveMap.put("creatorUserId"		,userInfoDto.getUserId());
		saveMap.put("groupId"			,"304452"); 				// 일반그룹 Default 값
		saveMap.put("workId"			,workId); 				
		saveMap.put("accUser"			,accUser); 				
		saveMap.put("isSap"				,isSap);
		saveMap.put("contractSpecial"	,contractSpecial);
		saveMap.put("sharpMail"	,sharpMail);
		
		saveMap.put("file_biz_reg_list"	,file_biz_reg_list);
		saveMap.put("file_app_sal_list"	,file_app_sal_list);
		saveMap.put("file_list1"	,file_list1);
		saveMap.put("file_list2"	,file_list2);
		saveMap.put("file_list3"	,file_list3);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			organSvc.updateBranchReq(saveMap);
			
			String smsStr 		= null;
			
			if("20".equals(registerCd)){
				smsStr = "[" + clientNm + "] 구매사를 승인요청 하였습니다";
//				try {
//					commonSvc.sendRightSms(mobile, smsStr);
//				} catch (Exception e) {
//					logger.error("SMS(managerSmsEmailInfoList) Save Error : "+e);
//				}
				List<SmsEmailInfo> selectUsersMobile = commonSvc.getManagerSmsEmailInfoByManageBranchId(branchId);
			
				for(int i = 0 ; i <  selectUsersMobile.size() ; i++){
					try {
						if(selectUsersMobile.get(i).isSms()){
							commonSvc.sendRightSms(selectUsersMobile.get(i).getMobileNum(), smsStr);
						}
					} catch (Exception e) {
						logger.error("SMS(managerSmsEmailInfoList) Save Error : "+e);
					}
				}
				
				//코드관리에 있는 사용자만 sms발송
//				List<CodesDto> unconditionalList = commonSvc.getCodeList("ORGAN_REQ_SMS", 1);
//				commonSvc.unconditionalSmsList(unconditionalList, smsStr);
				
				//파워 운영자에게 SMS발송
				List<SmsEmailInfo> receiveInfoList = commonSvc.getApproverSmsEmailInfoByRoleCd("MRO_ADMIN002");
				SmsEmailInfo dto 	= null;
				
				if(receiveInfoList != null && receiveInfoList.size() > 0){
					
					for(int i = 0 ; i <  receiveInfoList.size() ; i++){
						dto = receiveInfoList.get(i);
						try {
							//무조건SMS발송처리
//							if(dto.isSms()){
								commonSvc.sendRightSms(dto.getMobileNum(), smsStr);
//							}
						} catch (Exception e) {
							logger.error("SMS(managerSmsEmailInfoList) Save Error : "+e);
						}
					}
				}

			} else if("30".equals(registerCd)) {

				smsStr = "[" + clientNm + "]구매사를 최종 승인 검토 바랍니다.";
				
				List<SmsEmailInfo> receiveInfoList = commonSvc.getApproverSmsEmailInfoByRoleCd("ADM_APP");
				SmsEmailInfo dto 	= null;
				
				if(receiveInfoList != null && receiveInfoList.size() > 0){
					
					for(int i = 0 ; i <  receiveInfoList.size() ; i++){
						dto = receiveInfoList.get(i);
						try {
							//무조건SMS발송처리							
//							if(dto.isSms()){
								commonSvc.sendRightSms(dto.getMobileNum(), smsStr);
//							}
						} catch (Exception e) {
							logger.error("SMS(managerSmsEmailInfoList) Save Error : "+e);
						}
					}
				}
				
				//코드관리에 있는 사용자만 sms발송
//				List<CodesDto> unconditionalList = commonSvc.getCodeList("ORGAN_REQ_SMS", 1);
//				commonSvc.unconditionalSmsList(unconditionalList, smsStr);
				
			}else if("40".equals(registerCd)) {
				logger.info("*******서비스 이후 시작 시간 : "+CommonUtils.getCurrentDateTime());
				Map<String, Object> mobileMap = new HashMap<String, Object>();
				
				smsStr = "[" + clientNm + "]구매사가 등록 되었습니다.";			
				
				commonSvc.sendRightSms(mobile, smsStr);
				
				mobileMap.put("borgId", branchId);
//				List<SmsEmailInfo> selectUsersMobile =  commonSvc.getApproverSmsEmailInfoByRoleCd("ADM_B2B_MAN");
			
//				for(int i = 0 ; i <  selectUsersMobile.size() ; i++){
//					try {
						//무조건SMS발송처리
//						if(selectUsersMobile.get(i).isSms()){
//							commonSvc.sendRightSms(selectUsersMobile.get(i).getMobileNum(), smsStr);
////						}
//					} catch (Exception e) {
//						logger.error("SMS(managerSmsEmailInfoList) Save Error : "+e);
//					}
//				}
				
				//코드관리에 있는 사용자만 sms발송
//				List<CodesDto> unconditionalList = commonSvc.getCodeList("ORGAN_REQ_SMS", 1);
//				try{
//					smsStr = "[" + clientNm + "]구매사가 등록 되었습니다.";
//					commonSvc.unconditionalSmsList(unconditionalList, smsStr);
//				} catch (Exception e) {
//					logger.error("SMS(managerSmsEmailInfoList) Save Error : "+e);
//				}
				logger.info("**********서비스 이후 종료 시간 : "+CommonUtils.getCurrentDateTime());
			}
			
		} catch(Exception e) {
			
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
			commonSvc.sendRightSms("010-5247-3906", "구매사 승인 오류 입니다.");
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;			
	}
	
	/**
	 * 법인요청 거부/ 취소
	 */
	@RequestMapping("cancelBranchReq.sys")
	public ModelAndView cancelBranchReq(
			// 고객법인 마스터
			@RequestParam(value = "branchId", required = true) 		        String branchId,			// 조직ID
			@RequestParam(value = "clientId", required = true) 		        String clientId,			// 법인ID
			@RequestParam(value = "userId", required = true) 		        String userId,				// 담당자 ID
			@RequestParam(value = "userRoleCd", required = true) 			String userRoleCd,			// 사용자 권한코드 
			@RequestParam(value = "registerCd", required = true) 			String registerCd,			// 등록상태 
		HttpServletRequest request, ModelAndView modelAndView) throws Exception {
				
		Map<String, Object> saveMap = new HashMap<String, Object>();
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			
			if("10".equals(registerCd)){
				saveMap.put("borgId"		, branchId);
				saveMap.put("userId"		, userId);
				saveMap.put("branchId"		, branchId);
				saveMap.put("clientId"		, clientId);
				organSvc.deleteReqBranch(saveMap);				
			}else if("20".equals(registerCd)){
				saveMap.put("registerCd"	, "10");
				saveMap.put("branchId"		, branchId);
				organSvc.reqBranchRegisterCdCancel(saveMap);				
			}else if("30".equals(registerCd)){
				saveMap.put("registerCd"	, "20");
				saveMap.put("branchId"		, branchId);
				organSvc.reqBranchRegisterCdCancel(saveMap);
			}
//			if("ADM_APP".equals(userRoleCd)){ 	// 상태값 롤백 (거부)
//				saveMap.put("registerCd"	, "20");
//				saveMap.put("branchId"		, branchId);
//				organSvc.reqBranchRegisterCdCancel(saveMap);
//			} else {							// 등록정보 삭제처리 (취소)
//				saveMap.put("borgId"		, branchId);
//				saveMap.put("userId"		, userId);
//				saveMap.put("branchId"		, branchId);
//				saveMap.put("clientId"		, clientId);
//				organSvc.deleteReqBranch(saveMap);
//			}
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
	 * 공급사 등록요청 리스트
	 */
	@RequestMapping("organVendorRegistRequestListJQGrid.sys")
	public ModelAndView organVendorRegistRequestListJQGrid(
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			/*  조회 조건 */
			@RequestParam(value = "sidx", defaultValue = "vendorId") String sidx, 													// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "desc") String sord,														// 정렬 조건
			@RequestParam(value = "srcVendorNm", defaultValue = "") String srcVendorNm,												// 공급사명
			@RequestParam(value = "srcRegisterCd", defaultValue = "") String srcRegisterCd,											// 등록상태
			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		HashMap<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		
		params.put("orderString"	, orderString);
		params.put("srcVendorNm"	, srcVendorNm);
		params.put("srcRegisterCd"	, srcRegisterCd);
		
		//----------------페이징 세팅------------/
        int records = organSvc.getOrganVendorRegistRequestListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        //----------------조회------------/
        List<SmpVendorsDto> list = null; 
        if(records>0) list = organSvc.getOrganVendorRegistRequestListJQGrid(params, page, rows);
        
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("srcRegisterCd", srcRegisterCd);
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	/**
	 * 공급사 등록요청 리스트 엑셀 다운
	 */
	@RequestMapping("organVendorRegistRequestListExcel.sys")
	public ModelAndView organVendorRegistRequestListExcel(
			/*  조회 조건 */
			@RequestParam(value = "sidx", defaultValue = "vendorId") String sidx, 													// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "desc") String sord,														// 정렬 조건
			@RequestParam(value = "srcVendorNm", defaultValue = "") String srcVendorNm,												// 공급사명
			@RequestParam(value = "srcRegisterCd", defaultValue = "") String srcRegisterCd,											// 등록상태

			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		HashMap<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		
		params.put("orderString"	, orderString);
		params.put("srcVendorNm"	, srcVendorNm);
		params.put("srcRegisterCd"	, srcRegisterCd);
		
		//----------------조회------------/
		List<SmpVendorsDto> list = organSvc.getOrganVendorRegistRequestListJQGrid(params, 1, RowBounds.NO_ROW_LIMIT);
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				rtnData.put("vendorNm", list.get(i).getVendorNm());
				rtnData.put("businessNum", list.get(i).getBusinessNum());
				rtnData.put("areaType", list.get(i).getAreaType());
				rtnData.put("registerCd", list.get(i).getRegisterCd());
				rtnData.put("phoneNum", list.get(i).getPhoneNum());
				rtnData.put("pressentNm", list.get(i).getPressentNm());
				rtnData.put("postAddrNum", list.get(i).getPostAddrNum());
				rtnData.put("addres", list.get(i).getAddres());
				rtnData.put("registerDate", list.get(i).getRegisterDate());
				rtnData.put("appDate", list.get(i).getAppDate());
				rtnData.put("confirDate", list.get(i).getConfirDate());
				colDataList.add(rtnData);
			}
		}			
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
//        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", colDataList);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;			
	}
	
	/**
	 * 공급사 확인요청 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("updateVendorReq.sys")
	public ModelAndView updateVendorReq(
			// 고객법인 마스터
			@RequestParam(value = "vendorId", required = true) 		        String vendorId,			// 공급사ID
			@RequestParam(value = "vendorCd", required = true) 		        String vendorCd,			// 공급사CD
			@RequestParam(value = "vendorNm", required = true) 		        String vendorNm,			// 법인명
			@RequestParam(value = "businessNum1", required = true)          String businessNum1,		// 사업자등록번호1
			@RequestParam(value = "businessNum2", required = true)          String businessNum2,		// 사업자등록번호2
			@RequestParam(value = "businessNum3", required = true)          String businessNum3,		// 사업자등록번호3
			@RequestParam(value = "registNum1", defaultValue = "") 	        String registNum1,			// 법인등록번호1
			@RequestParam(value = "registNum2", defaultValue = "") 	        String registNum2,			// 법인등록번호2
			@RequestParam(value = "vendorBusiType", required = true)        String vendorBustType,		// 업종
			@RequestParam(value = "vendorBusiClas", required = true)        String vendorBustClas,		// 업태
			@RequestParam(value = "pressentNm", required = true) 	        String pressentNm,			// 대표자명
			@RequestParam(value = "phoneNum", required = true) 		        String phoneNum,			// 대표전화번호
			@RequestParam(value = "eMail", required = true) 		        String eMail,			    // 회사이메일
			@RequestParam(value = "homePage", defaultValue = "") 	        String homePage,		    // 홈페이지 
			@RequestParam(value = "postAddrNum", required = true)       	String postAddrNum,		    // 주소1 
			@RequestParam(value = "addres", required = true) 		        String addres,				// 주소2 
			@RequestParam(value = "addresDesc", defaultValue = "") 	        String addresDesc,			// 상세주소 
			@RequestParam(value = "faxNum", defaultValue = "") 				String faxNum,				// 팩스번호 
			@RequestParam(value = "refereceDesc", defaultValue = "")		String refereceDesc,		// 참고사항 
			@RequestParam(value = "areaType", required = true) 				String areaType,		    // 권역 
			@RequestParam(value = "payBillType", required = true) 			String payBillType,		    // 결제조건
			@RequestParam(value = "payBillDay", defaultValue="") 			String payBillDay,		    // 결제일
			@RequestParam(value = "accountManagerNm", required = true) 		String accountManagerNm,	// 회계담당자명 
			@RequestParam(value = "accountTelNum", required = true) 		String accountTelNum,		// 회계이동전화 
			@RequestParam(value = "bankCd", required = true) 				String bankCd,				// 은행코드 
			@RequestParam(value = "recipient", required = true) 			String recipient,		    // 예금주명 
			@RequestParam(value = "accountNum", required = true) 			String accountNum,		    // 계좌번호 
			@RequestParam(value = "userNm", required = true) 				String userNm,				// 성명 
			@RequestParam(value = "tel", required = true) 					String tel,					// 전화번호 
			@RequestParam(value = "mobile", required = true) 				String mobile,				// 이동전화번호 
			@RequestParam(value = "userEmail", required = true) 			String userEmail,			// 이메일 
			@RequestParam(value = "loginAuthType", defaultValue="20") 		String loginAuthType,		// 로그인인증 
			@RequestParam(value = "userId", required = true) 				String userId,				// User ID 
			@RequestParam(value = "registerCd", required = true) 			String registerCd,			// 등록상태
			@RequestParam(value = "classify", required = true) 			String classify,				// 구분
			
			//팝업창 가운데 저장버튼 삭제 후 저장후 승인버튼을 클릭시 첨부파일도 함께 저장되도록 수정
			@RequestParam(value="file_biz_reg_list",defaultValue="")String file_biz_reg_list,				//사업자등록증
			@RequestParam(value="file_app_sal_list",defaultValue="")String file_app_sal_list,				//신용평가서첨부
			@RequestParam(value="file_list1",defaultValue="")String file_list1,								//통장사본
			@RequestParam(value="file_list2",defaultValue="")String file_list2,								//공사계약서
			@RequestParam(value="file_list3",defaultValue="")String file_list3,								//회사소개서
		HttpServletRequest request, ModelAndView modelAndView) throws Exception {
	
		HashMap<String, Object> saveMap = new HashMap<String, Object>();
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		saveMap.put("vendorId"			,vendorId);
		saveMap.put("vendorCd"			,vendorCd);
		saveMap.put("vendorNm"			,vendorNm);
		saveMap.put("businessNum"		,businessNum1 + businessNum2 + businessNum3);
		saveMap.put("registNum"			,registNum1 + registNum2);
		saveMap.put("vendorBustType"	,vendorBustType);
		saveMap.put("vendorBustClas"	,vendorBustClas);
		saveMap.put("pressentNm"		,pressentNm);
		saveMap.put("phoneNum"			,phoneNum);
		saveMap.put("eMail"				,eMail);
		saveMap.put("homePage"			,homePage);
		saveMap.put("postAddrNum"		,postAddrNum);
		saveMap.put("addres"			,addres);
		saveMap.put("addresDesc"		,addresDesc);
		saveMap.put("faxNum"			,faxNum);
		saveMap.put("refereceDesc"		,refereceDesc);
		saveMap.put("areaType"			,areaType);
		saveMap.put("payBillType"		,payBillType);
		saveMap.put("payBillDay"		,payBillDay);
		saveMap.put("accountManagerNm"	,accountManagerNm);
		saveMap.put("accountTelNum"		,accountTelNum);
		saveMap.put("bankCd"			,bankCd);
		saveMap.put("recipient"			,recipient);
		saveMap.put("accountNum"		,accountNum);
		saveMap.put("userNm"			,userNm);
		saveMap.put("tel"				,tel);
		saveMap.put("mobile"			,mobile);
		saveMap.put("userEmail"			,userEmail);
		saveMap.put("remoteIp"			,request.getRemoteAddr());
		saveMap.put("loginAuthType"		,loginAuthType);
		saveMap.put("userId"			,userId);
		saveMap.put("registerCd"		,registerCd);
		saveMap.put("creatorRemoteIp"	,userInfoDto.getRemoteIp());
		saveMap.put("creatorUserId"		,userInfoDto.getUserId());
		saveMap.put("classify"		,classify);
		
		saveMap.put("file_biz_reg_list"	,file_biz_reg_list);
		saveMap.put("file_app_sal_list"	,file_app_sal_list);
		saveMap.put("file_list1"	,file_list1);
		saveMap.put("file_list2"	,file_list2);
		saveMap.put("file_list3"	,file_list3);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			organSvc.updateVendorReq(saveMap);
			
			/*---------- SMS 발송 ----------*/
			String smsStr 		= null;
			if("20".equals(registerCd)){
				smsStr = "[OK플라자] [" + vendorNm + "] 공급사를 승인요청 하였습니다";
				
				List<SmsEmailInfo> receiveInfoList = commonSvc.getApproverSmsEmailInfoByRoleCd("ADM_VEN_MNG");
				SmsEmailInfo dto 	= null;
				
				if(receiveInfoList != null && receiveInfoList.size() > 0){
					
					for(int i = 0 ; i <  receiveInfoList.size() ; i++){
						try {
							dto = receiveInfoList.get(i);
							//무조건SMS발송처리
//							if(dto.isSms()){
								commonSvc.sendRightSms(dto.getMobileNum(), smsStr);
//							}
						} catch (Exception e) {
							logger.error("SMS(managerSmsEmailInfoList) Save Error : "+e);
						}
					}
				}
				
				//송태리, 변지희 두 사람의 경우 무조건 sms발송
//				List<CodesDto> unconditionalList = commonSvc.getCodeList("ORGAN_REQ_SMS", 1);
//				commonSvc.unconditionalSmsList(unconditionalList, smsStr);
				
			} else if("30".equals(registerCd)) {

				smsStr = "[OK플라자] [" + vendorNm + "]공급사를 최종 승인 검토 바랍니다.";
				
				List<SmsEmailInfo> receiveInfoList = commonSvc.getApproverSmsEmailInfoByRoleCd("ADM_APP");
				SmsEmailInfo dto 	= null;
				
				if(receiveInfoList != null && receiveInfoList.size() > 0){
					for(int i = 0 ; i <  receiveInfoList.size() ; i++){
						try {
							dto = receiveInfoList.get(i);
							//무조건SMS발송처리
//							if(dto.isSms()){
								commonSvc.sendRightSms(dto.getMobileNum(), smsStr);
//							}
						} catch (Exception e) {
							logger.error("SMS(managerSmsEmailInfoList) Save Error : "+e);
						}
					}
				}
				
				//송태리, 변지희 두 사람의 경우 무조건 sms발송
//				List<CodesDto> unconditionalList = commonSvc.getCodeList("ORGAN_REQ_SMS", 1);
//				commonSvc.unconditionalSmsList(unconditionalList, smsStr);
				
			}else if("40".equals(registerCd)) {
				
				smsStr = "[OK플라자] [" + vendorNm + "] 공급사가 등록 되었습니다.";		
				
				List<SmsEmailInfo> receiveInfoList = commonSvc.getApproverSmsEmailInfoByRoleCd("ADM_VEN_MNG");
				SmsEmailInfo dto 	= null;
				//공급사 사용자에게 SMS 수신
				try {
					commonSvc.sendRightSms(mobile, smsStr);
				} catch (Exception e) {
					logger.error("SMS(managerSmsEmailInfoList) Save Error : "+e);
				}
				
				if(receiveInfoList != null && receiveInfoList.size() > 0){
					for(int i = 0 ; i <  receiveInfoList.size() ; i++){
						try {
							dto = receiveInfoList.get(i);
							//무조건SMS발송처리
//							if(dto.isSms()){
								commonSvc.sendRightSms(dto.getMobileNum(), smsStr);
//							}
						} catch (Exception e) {
							logger.error("SMS(managerSmsEmailInfoList) Save Error : "+e);
						}
					}
				}
				
				//송태리, 변지희 두 사람의 경우 무조건 sms발송
//				List<CodesDto> unconditionalList = commonSvc.getCodeList("ORGAN_REQ_SMS", 1);
//				commonSvc.unconditionalSmsList(unconditionalList, smsStr);
				
			}
		} catch(Exception e) {
			
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
			commonSvc.sendRightSms("010-5247-3906", "공급사 승인 오류 입니다.");
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;			
	}	
	
	
	/**
	 * 공급사요청 거부/ 취소
	 */
	@RequestMapping("cancelVendorReq.sys")
	public ModelAndView cancelVendorReq(
			// 고객법인 마스터
			@RequestParam(value = "vendorId", required = true) 		        String vendorId,			// 공급사ID
			@RequestParam(value = "userId", required = true) 		        String userId,				// 담당자 ID
			@RequestParam(value = "userRoleCd", required = true) 			String userRoleCd,			// 사용자 권한코드 
			@RequestParam(value = "registerCd", required = true) 			String registerCd,			// 등록상태 
		HttpServletRequest request, ModelAndView modelAndView) throws Exception {
				
		Map<String, Object> saveMap = new HashMap<String, Object>();
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
//			if("ADM_APP".equals(userRoleCd)){ 	// 상태값 롤백 (거부)
//				saveMap.put("registerCd"	, "20");
//				saveMap.put("vendorId"		, vendorId);
//				organSvc.reqVendorRegisterCdCancel(saveMap);
//			} else {							// 등록정보 삭제처리 (취소)
//				saveMap.put("borgId"		, vendorId);
//				saveMap.put("userId"		, userId);
//				saveMap.put("vendorId"		, vendorId);
//				organSvc.deleteReqVendor(saveMap);
//			}
			if("10".equals(registerCd)){
				saveMap.put("borgId"		, vendorId);
				saveMap.put("userId"		, userId);
				saveMap.put("vendorId"		, vendorId);
				organSvc.deleteReqVendor(saveMap);				
			}else if("20".equals(registerCd)){
				saveMap.put("registerCd"	, "10");
				saveMap.put("vendorId"		, vendorId);
				organSvc.reqVendorRegisterCdCancel(saveMap);				
			}else if("30".equals(registerCd)){
				saveMap.put("registerCd"	, "20");
				saveMap.put("vendorId"		, vendorId);
				organSvc.reqVendorRegisterCdCancel(saveMap);
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
	
	/**공급사조회
	 */
	@RequestMapping("organVendorList.sys")
	public ModelAndView getOrgranVendorList( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("organ/organVendorList");
		return mav;
	}
	
	/**
	 * 공급사조회 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("organVendorListJQGrid.sys")
	public ModelAndView organVendorListJQGrid(
			@RequestParam(value = "page",			defaultValue = "1")				int page,
			@RequestParam(value = "rows",			defaultValue = "30")			int rows,
			@RequestParam(value = "sidx",			defaultValue = "a.vendorId")	String sidx,
			@RequestParam(value = "sord",			defaultValue = "desc")			String sord,
			@RequestParam(value = "srcBusinessNum",	defaultValue = "")				String srcBusinessNum,
			@RequestParam(value = "srcAreaType",	defaultValue = "")				String srcAreaType,
			@RequestParam(value = "srcIsUse",		defaultValue = "1")				String srcIsUse,
			@RequestParam(value = "srcVendorNm",	defaultValue = "")				String srcVendorNm,
			@RequestParam(value = "vendorSearchId",	defaultValue = "")				String vendorSearchId,
			@RequestParam(value = "classify",		defaultValue = "")				String classify,
			@RequestParam(value = "srcPressentNm",	defaultValue = "")				String srcPressentNm,
	ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcBusinessNum",	srcBusinessNum);
		params.put("srcAreaType",		srcAreaType);
		params.put("srcIsUse",			srcIsUse);
		params.put("srcVendorNm",		srcVendorNm);
		params.put("vendorSearchId",	vendorSearchId);
		params.put("classify",			classify);
		params.put("srcPressentNm",		srcPressentNm);
		if("vendorId".equals(sidx)) {
			sidx = "a."+sidx;
		}
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
		int records = organSvc.getOrganVendorListCnt(params); //조회조건에 따른 카운트
		int total = (int)Math.ceil((float)records / (float)rows);
		
		/*----------------조회------------*/
		List<SmpVendorsDto> list = null;
		if(records>0) list = organSvc.getOrganVendorList(params, page, rows);
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 공급사조회 DB조회후 엑셀다운로드
	 */
	@RequestMapping("organVendorListExcel.sys")
	public ModelAndView organVendorListExcel(
			@RequestParam(value = "sidx",			defaultValue = "a.vendorId")	String sidx,
			@RequestParam(value = "sord",			defaultValue = "desc")			String sord,
			@RequestParam(value = "srcBusinessNum",	defaultValue = "")				String srcBusinessNum,
			@RequestParam(value = "srcAreaType",	defaultValue = "")				String srcAreaType,
			@RequestParam(value = "srcIsUse",		defaultValue = "1")				String srcIsUse,
			@RequestParam(value = "srcVendorNm",	defaultValue = "")				String srcVendorNm,
			@RequestParam(value = "vendorSearchId",	defaultValue = "")				String vendorSearchId,
			@RequestParam(value = "classify",		defaultValue = "")				String classify,
			@RequestParam(value = "srcPressentNm",	defaultValue = "")				String srcPressentNm,
			
			@RequestParam(value = "sheetTitle",		defaultValue = "")				String sheetTitle,
			@RequestParam(value = "excelFileName",	defaultValue = "")				String excelFileName,
			@RequestParam(value = "colLabels",		required = false)				String[] colLabels,
			@RequestParam(value = "colIds",			required = false)				String[] colIds,
			@RequestParam(value = "numColIds",		required = false)				String[] numColIds,
			@RequestParam(value = "figureColIds",	required = false)				String[] figureColIds,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcBusinessNum",	srcBusinessNum);
		params.put("srcAreaType",		srcAreaType);
		params.put("srcIsUse",			srcIsUse);
		params.put("srcVendorNm",		srcVendorNm);
		params.put("vendorSearchId",	vendorSearchId);
		params.put("classify",			classify);
		params.put("srcPressentNm",		srcPressentNm);
		if("vendorId".equals(sidx)) {
			sidx = "a."+sidx;
		}
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		List<SmpVendorsDto> list = organSvc.getOrganVendorList(params, 1, RowBounds.NO_ROW_LIMIT);
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				rtnData.put("vendorCd", list.get(i).getVendorCd());
				rtnData.put("vendorNm", list.get(i).getVendorNm());
				rtnData.put("businessNum", list.get(i).getBusinessNum());
				rtnData.put("areaTypeNm", list.get(i).getAreaTypeNm());
				rtnData.put("isUse", list.get(i).getIsUse());
				rtnData.put("phoneNum", list.get(i).getPhoneNum());
				rtnData.put("pressentNm", list.get(i).getPressentNm());
				rtnData.put("postAddrNum", list.get(i).getPostAddrNum());
				rtnData.put("addres", list.get(i).getAddres());
				rtnData.put("addresDesc", list.get(i).getAddresDesc());
				rtnData.put("createDate", list.get(i).getCreateDate());
				rtnData.put("sharp_mail", list.get(i).getSharp_mail());
				rtnData.put("homePage", list.get(i).getHomePage());
				rtnData.put("classify", list.get(i).getClassify());
				rtnData.put("userLoginYn", list.get(i).getUserLoginYn());
				rtnData.put("userLoginYn", list.get(i).getUserLoginYn());
				rtnData.put("contractYn", list.get(i).getContractYn());
				colDataList.add(rtnData);
			}
		}			
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", colDataList);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("figureColIds", figureColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;					
	}
		
	///////////////////////////////////////////////////////////////////////////// 공급사등록 Start
	/**
	 * 공급사등록
	 */
	@RequestMapping("organVendorReg.sys")
	public ModelAndView organVendorReg( HttpServletRequest req, ModelAndView mav) throws Exception{
		
		//권역코드
		mav.addObject("areaCode", commonSvc.getCodeList("VEN_AREA_CODE", 1));
		//은행코드
		mav.addObject("bankCode", commonSvc.getCodeList("BANKCD", 1));
		//결제조건
		mav.addObject("payCondCode", commonSvc.getCodeList("PAYMCONDCODE", 1));
		
		mav.setViewName("organ/organVendorReg");
		return mav;
	}
	
	/**
	 * 공급사 상세 페이지 이동하는 메소드
	 * 
	 * @param vendorId (공급사 아이디)
	 * @param modelAndView
	 * @param req
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping("organVendorDetail.sys")
	public ModelAndView organVendorDetail( 
			@RequestParam(value = "vendorId",required = true) String vendorId,
			ModelAndView modelAndView, HttpServletRequest req) throws Exception{
		SmpVendorsDto  detailInfo  = this.organSvc.selectVendorsDetail(vendorId);
		List<CodesDto> areaCode    = this.commonSvc.getCodeList("VEN_AREA_CODE", 1);
		List<CodesDto> bankCode    = this.commonSvc.getCodeList("BANKCD", 1);
		List<CodesDto> payCondCode = this.commonSvc.getCodeList("PAYMCONDCODE", 1);
		
		modelAndView.addObject("vendorId",    vendorId);
		modelAndView.addObject("detailInfo",  detailInfo);
		modelAndView.addObject("areaCode",    areaCode); //권역코드
		modelAndView.addObject("bankCode",    bankCode); //은행코드
		modelAndView.addObject("payCondCode", payCondCode); //결제조건
		modelAndView.setViewName("organ/organVendorDetail");
		
		return modelAndView;		
	}	
	
	/**
	 * 공급사 수정 / 등록
	 */
	@RequestMapping("saveVendorReg.sys")
	public ModelAndView saveVendorReg( 
			@RequestParam(value = "oper", required = true) 		        	String oper,			// 법인명
			@RequestParam(value = "vendorNm", required = true) 		        String vendorNm,			// 법인명
			@RequestParam(value = "businessNum1", required = true)          String businessNum1,		// 사업자등록번호1
			@RequestParam(value = "businessNum2", required = true)          String businessNum2,		// 사업자등록번호2
			@RequestParam(value = "businessNum3", required = true)          String businessNum3,		// 사업자등록번호3
			@RequestParam(value = "registNum1", defaultValue = "") 	        String registNum1,			// 법인등록번호1
			@RequestParam(value = "registNum2", defaultValue = "") 	        String registNum2,			// 법인등록번호2
			@RequestParam(value = "vendorBusiType", required = true)        String vendorBusiType,		// 업종
			@RequestParam(value = "vendorBusiClas", required = true)        String vendorBusiClas,		// 업태
			@RequestParam(value = "pressentNm", required = true) 	        String pressentNm,			// 대표자명
			@RequestParam(value = "phoneNum", required = true) 		        String phoneNum,			// 대표전화번호
			@RequestParam(value = "eMail", required = true) 		        String eMail,			    // 회사이메일
			@RequestParam(value = "homePage", defaultValue = "") 	        String homePage,		    // 홈페이지 
			@RequestParam(value = "postAddrNum", required = true)       	String postAddrNum,		    // 주소1 
			@RequestParam(value = "addres", required = true) 		        String addres,				// 주소2 
			@RequestParam(value = "addresDesc", defaultValue = "") 	        String addresDesc,			// 상세주소 
			@RequestParam(value = "faxNum", defaultValue = "") 				String faxNum,				// 팩스번호 
			@RequestParam(value = "refereceDesc", defaultValue = "")		String refereceDesc,		// 참고사항 
			@RequestParam(value = "areaType", required = true) 				String areaType,		    // 권역 
			@RequestParam(value = "payBillType", required = true) 			String payBillType,		    // 결제조건
			@RequestParam(value = "payBillDay", defaultValue="") 			String payBillDay,		    // 결제일
			@RequestParam(value = "accountManagerNm", required = true) 		String accountManagerNm,	// 회계담당자명 
			@RequestParam(value = "accountTelNum", required = true) 		String accountTelNum,		// 회계이동전화 
			@RequestParam(value = "file_biz_reg_list", required = true) 	String file_biz_reg_list, 			
			@RequestParam(value = "file_app_sal_list", required = true) 	String file_app_sal_list, 			
			@RequestParam(value = "file_list1", required = true) 			String file_list1, 			
			@RequestParam(value = "file_list2", required = true) 			String file_list2, 			
			@RequestParam(value = "file_list3", required = true) 			String file_list3,
			@RequestParam(value = "bankCd", required = true) 				String bankCd,				// 은행코드 
			@RequestParam(value = "recipient", required = true) 			String recipient,		    // 예금주명 
			@RequestParam(value = "accountNum", required = true) 			String accountNum,		    // 계좌번호 
			@RequestParam(value = "loginAuthType", defaultValue="20") 		String loginAuthType,		// 로그인인증 
			@RequestParam(value = "isUse", defaultValue="1") 				String isUse,				// 사용여부
			@RequestParam(value = "sharpMail", defaultValue="") 			String sharpMail,				// 회사샵메일
			
			//사용자 정보
			@RequestParam(value = "userNm", required = false) 				String userNm,				// 성명 
			@RequestParam(value = "loginId", required = false) 				String loginId,				// 로그인ID 
			@RequestParam(value = "pwd", required = false) 					String pwd,					// 비밀번호 
			@RequestParam(value = "tel", required = false) 					String tel,					// 전화번호 
			@RequestParam(value = "mobile", required = false) 				String mobile,				// 이동전화번호 
			@RequestParam(value = "userEmail", required = false) 			String userEmail,			// 이메일 
			//	권한정보
			@RequestParam(value = "roleCdArr[]", required = false) 			String[] roleCdArr,
			@RequestParam(value = "roleNmArr[]", required = false) 			String[] roleNmArr,
			@RequestParam(value = "roleDescArr[]", required = false) 		String[] roleDescArr,
			@RequestParam(value = "roleIdArr[]", required = false) 			String[] roleIdArr,

			@RequestParam(value = "userId", required = false) 				String userId,
			@RequestParam(value = "vendorId", required = true) 				String vendorId,
			@RequestParam(value = "trustBillUserId", defaultValue = "") 	String trustBillUserId,
			@RequestParam(value = "trustBillUserNm", defaultValue = "") 	String trustBillUserNm,
			@RequestParam(value = "trustBillUserEmail", defaultValue = "") 	String trustBillUserEmail,
			@RequestParam(value = "trustBillUserTel", defaultValue = "") 	String trustBillUserTel,
			@RequestParam(value = "file_list4", defaultValue = "") 			String file_list4,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> saveMap = new HashMap<String, Object> ();
		
		saveMap.put("vendorNm"         , vendorNm);
		saveMap.put("businessNum"      , businessNum1 + businessNum2 + businessNum3);
		saveMap.put("registNum"        , registNum1 + registNum2);
		saveMap.put("vendorBusiType"   , vendorBusiType);
		saveMap.put("vendorBusiClas"   , vendorBusiClas);
		saveMap.put("pressentNm"       , pressentNm);
		saveMap.put("phoneNum"         , phoneNum);
		saveMap.put("eMail"            , eMail);
		saveMap.put("homePage"         , homePage);
		saveMap.put("postAddrNum"      , postAddrNum);
		saveMap.put("addres"           , addres);
		saveMap.put("addresDesc"       , addresDesc);
		saveMap.put("faxNum"           , faxNum);
		saveMap.put("refereceDesc"     , refereceDesc);
		saveMap.put("areaType"         , areaType);
		saveMap.put("payBillType"      , payBillType);
		saveMap.put("payBillDay"       , payBillDay);
		saveMap.put("accountManagerNm" , accountManagerNm);
		saveMap.put("accountTelNum"    , accountTelNum);
		saveMap.put("bankCd"           , bankCd);
		saveMap.put("recipient"        , recipient);
		saveMap.put("accountNum"       , accountNum);
		saveMap.put("file_biz_reg_list", file_biz_reg_list);
		saveMap.put("file_app_sal_list", file_app_sal_list);
		saveMap.put("file_list1"       , file_list1);
		saveMap.put("file_list2"       , file_list2);
		saveMap.put("file_list3"       , file_list3);
		saveMap.put("trustBillUserId"  , trustBillUserId);
		saveMap.put("trustBillUserNm"  , trustBillUserNm);
		saveMap.put("trustBillUserEmail", trustBillUserEmail);
		saveMap.put("trustBillUserTel" , trustBillUserTel);
		saveMap.put("isUse" 		   , isUse);
		saveMap.put("sharpMail"        , sharpMail);
		
		saveMap.put("loginId"          , loginId);
		saveMap.put("userNm"           , userNm);
		saveMap.put("pwd"              , pwd);
		saveMap.put("tel"              , tel);
		saveMap.put("mobile"           , mobile);
		saveMap.put("userEmail"        , userEmail);
		saveMap.put("loginAuthType"    , loginAuthType);
		saveMap.put("roleCdArr"        , roleCdArr);
		saveMap.put("roleNmArr"        , roleNmArr);
		saveMap.put("roleDescArr"      , roleDescArr);
		saveMap.put("roleIdArr"        , roleIdArr);

		saveMap.put("creatorRemoteIp"  , userInfoDto.getRemoteIp());
		saveMap.put("creatorUserId"    , userInfoDto.getUserId());
		
		saveMap.put("file_list4"       , file_list4);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			// 공급사 등록
			if("add".equals(oper)){
				organSvc.saveVendorReg(saveMap);
			}else if("upd".equals(oper)){
				saveMap.put("userId"	, userId);
				saveMap.put("vendorId"	, vendorId);
				saveMap.put("borgNm"	, vendorNm);
				organSvc.updateVendorReg(saveMap);
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
	
	/**공급사사용자조회
	 */
	@RequestMapping("organVendorUserList.sys")
	public ModelAndView getOrganVendorUserList( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("organ/organVendorUserList");
		return mav;
	}

	/**
	 * 공급사사용자조회 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("organVendorUserListJQGrid.sys")
	public ModelAndView organVendorUserListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "a.vendorId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
			@RequestParam(value = "srcUserNm", defaultValue = "") String srcUserNm,
			@RequestParam(value = "srcLoginId", defaultValue = "") String srcLoginId,
			@RequestParam(value = "srcIsUse", defaultValue = "1") String srcIsUse,		
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);
		params.put("srcUserNm", srcUserNm);
		params.put("srcLoginId", srcLoginId);
		params.put("srcIsUse", srcIsUse);
		if("userId".equals(sidx)) {
			sidx = "a."+sidx;
		}
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
		int records = organSvc.getOrganVendorUserListCnt(params); //조회조건에 따른 카운트
		int total = (int)Math.ceil((float)records / (float)rows);
		
		/*----------------조회------------*/
		List<SmpUsersDto> list = null;
		if(records>0) list = organSvc.getOrganVendorUserList(params, page, rows);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 공급사사용자조회 DB조회후 엑셀 다운로드
	 */
	@RequestMapping("organVendorUserListExcel.sys")
	public ModelAndView organVendorUserListExcel(
			@RequestParam(value = "sidx", defaultValue = "userId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
			@RequestParam(value = "srcUserNm", defaultValue = "") String srcUserNm,
			@RequestParam(value = "srcLoginId", defaultValue = "") String srcLoginId,
			@RequestParam(value = "srcIsUse", defaultValue = "1") String srcIsUse,		

			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);
		params.put("srcUserNm", srcUserNm);
		params.put("srcLoginId", srcLoginId);
		params.put("srcIsUse", srcIsUse);
		if("userId".equals(sidx)) {
			sidx = "a."+sidx;
		}
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		List<SmpUsersDto> list = organSvc.getOrganVendorUserList(params, 1, RowBounds.NO_ROW_LIMIT);
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				rtnData.put("vendorNm",		list.get(i).getVendorNm());
				rtnData.put("areaTypeNm",	list.get(i).getAreaTypeNm());
				rtnData.put("userNm",		list.get(i).getUserNm());
				rtnData.put("loginId",		list.get(i).getLoginId());
				rtnData.put("isUse",		list.get(i).getIsUse());
				rtnData.put("borg_IsUse",	list.get(i).getBorg_IsUse());
				rtnData.put("isLogin",		list.get(i).getIsLogin());
				rtnData.put("tel",			list.get(i).getTel());
				rtnData.put("mobile",		list.get(i).getMobile());
				rtnData.put("isEmail",		list.get(i).getIsEmail());
				rtnData.put("isSms",		list.get(i).getIsSms());
				rtnData.put("createDate",	list.get(i).getCreateDate());
				rtnData.put("eMail",		list.get(i).geteMail());
				rtnData.put("userLoginYn",	list.get(i).getUserLoginYn());
				colDataList.add(rtnData);
			}
		}
		List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("sheetTitle", sheetTitle);
		map1.put("colLabels", colLabels);
		map1.put("colIds", colIds);
		map1.put("numColIds", numColIds);
		map1.put("colDataList", colDataList);
		sheetList.add(map1);
		modelAndView.setViewName("commonExcelViewResolver");
		modelAndView.addObject("excelFileName", excelFileName);
		modelAndView.addObject("sheetList", sheetList);
		return modelAndView;
		
		
	}

	/**
	 * 공급사사용자조회 상세
	 */
	@RequestMapping("selectVendorUserDetail.sys")
	public ModelAndView selectVendorUserDetail(
			@RequestParam(value = "borgId", required = true) String borgId,
			@RequestParam(value = "userId", required = true) String userId,
			HttpServletRequest req, ModelAndView mav) throws Exception{

		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("userId", userId);
		params.put("borgId", borgId);
		
		SmpUsersDto userDto = organSvc.selectVendorUserDetail(params);
		mav.addObject("borgId"	, borgId);
		mav.addObject("userDto"	, userDto);
		mav.setViewName("organ/organVendorUserDetail");
		return mav;
	}

	
	
	/**공급사사용자등록
	 */
	@RequestMapping("organVendorUserReg.sys")
	public ModelAndView organVendorUserReg( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("organ/organVendorUserReg");
//		mav.setViewName("organ/orgranVendorUserRegist");
		return mav;
	}
	
	
	
	/**공급사등록요청조회
	 */
	@RequestMapping("organVendorRegistRequestList.sys")
	public ModelAndView getOrganVendorRegistRequest( HttpServletRequest req, ModelAndView mav) throws Exception{
		
		LoginUserDto userInfoDto = (LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME);
		List<LoginRoleDto> roleList =  userInfoDto.getLoginRoleList();

		String registerCd = null;
		String userRoleCd = null;
		
		for(int i = 0 ; i < roleList.size() ; i++) {
			LoginRoleDto dto = roleList.get(i);
			
			if("ADM_APP".equals(dto.getRoleCd())) {
				userRoleCd	= dto.getRoleCd();
				registerCd 	= "30"; 
				break;
			} else if("ADM_REG".equals(dto.getRoleCd())){
				userRoleCd	= dto.getRoleCd();
				registerCd = "10";
				break;
			} else {
				userRoleCd	= dto.getRoleCd();
				registerCd = "20";
			}
		}

		mav.addObject("userRoleCd"		, userRoleCd);
		mav.addObject("srcRegisterCd"	, registerCd);
		mav.addObject("menuCd"	, organSvc.getMenuCd(req.getParameter("_menuId")));
		mav.setViewName("organ/organVendorRegistRequestList");
		return mav;
	}

	
	/**
	 * 공급사요청 상세
	 */
	@RequestMapping("organVendorRegistRequestDetail.sys")
	public ModelAndView getOrganVendorRegistRequestDetail(
			@RequestParam(value = "vendorId",required = true) String vendorId,
			ModelAndView modelAndView, HttpServletRequest req) throws Exception{
		
		/*----------------조회조건 세팅------------*/
		SmpVendorsDto 				detailInfo 				= organSvc.selectOneReqVendors(vendorId);		// 공급사 마스터
		SmpUsersDto 				userInfo 				= organSvc.selectUserInfo(vendorId);			// 사용자 조회
		
		LoginUserDto userInfoDto = (LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME);
		List<LoginRoleDto> roleList =  userInfoDto.getLoginRoleList();

		String userRoleCd = null;
		
		for(int i = 0 ; i < roleList.size() ; i++) {
			LoginRoleDto dto = roleList.get(i);
			
			// 사용자 기본권한인지의 여부 확인
			if("1".equals(dto.getIsDefault())){
				userRoleCd = dto.getRoleCd();
				break;
			}
		}
		modelAndView.addObject("userRoleCd"				, userRoleCd);

		modelAndView.addObject("vendorId"				, vendorId);
		modelAndView.addObject("detailInfo"				, detailInfo);
		modelAndView.addObject("userInfo"				, userInfo);
		
		//권역코드
		modelAndView.addObject("areaCode", commonSvc.getCodeList("VEN_AREA_CODE", 1));
		//은행코드
		modelAndView.addObject("bankCode", commonSvc.getCodeList("BANKCD", 1));
		//결제조건
		modelAndView.addObject("payCondCode", commonSvc.getCodeList("PAYMCONDCODE", 1));
		
		modelAndView.setViewName("organ/organVendorRegistRequestDetail");
		return modelAndView;		
	}	

	/**공급사등록
	 */
	@RequestMapping("organVendorRegistRequestAdd.sys")
	public ModelAndView getOrganVendorRegistRequestAdd( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("organ/organVendorRegistRequestDetail");
//		mav.setViewName("organ/organVendorRegistRequestAdd");
		return mav;
	}
	
	/**
	 * 고객법인등록결재조회
	 */
	@RequestMapping("organClientRegistApprovalList.sys")
	public ModelAndView getOrganClientResigtApprovalList(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		List<LoginRoleDto> roleList =  userInfoDto.getLoginRoleList();

		String registerCd = null;
		
		for(int i = 0 ; i < roleList.size() ; i++) {
			LoginRoleDto dto = roleList.get(i);
			
			// 사용자 기본권한인지의 여부 확인
			if("1".equals(dto.getIsDefault())){
				
				if("ADM_APP".equals(dto.getRoleCd())){
					registerCd = "30";
				}else if("ADM_REG".equals(dto.getRoleCd())){
					registerCd = "10";
				}else{
					registerCd = "20";
				}
				break;
			}
		}
		
		//공사유형
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orderString", " workNm asc");
		modelAndView.addObject("workInfoList", commonSvc.selectWorkInfo(params));
		//채권관리자
		modelAndView.addObject("admUserList", adjustSvc.getAdjustAlramUserList());		
		
		modelAndView.addObject("srcRegisterCd"	, registerCd);
		modelAndView.setViewName("organ/organClientRegistRequestList");
		return modelAndView;
	}
	/**고객법인등록결재조회 - 상세
	 */
	@RequestMapping("organClientRegistApprovalDetail.sys")
	public ModelAndView getOrganClientResigtApprovalDetail( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("organ/organClientRegistRequestDetail");
//		mav.setViewName("organ/organClientRegistApprovalDetail");
		return mav;
	}
	
	
	
	/**공급사등록결재조회
	 */
	@RequestMapping("organVendorRegistApprovalList.sys")
	public ModelAndView getOrganVendorRegistApprovalList( HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		
		
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		List<LoginRoleDto> roleList =  userInfoDto.getLoginRoleList();

		String registerCd = null;
		
		for(int i = 0 ; i < roleList.size() ; i++) {
			LoginRoleDto dto = roleList.get(i);
			
			// 사용자 기본권한인지의 여부 확인
			if("1".equals(dto.getIsDefault())){
				
				if("ADM_APP".equals(dto.getRoleCd())){
					registerCd = "30";
				}else if("ADM_REG".equals(dto.getRoleCd())){
					registerCd = "10";
				}else{
					registerCd = "20";
				}
				break;
			}
		}
		modelAndView.addObject("srcRegisterCd"	, registerCd);
		modelAndView.addObject("menuCd"	, organSvc.getMenuCd(request.getParameter("_menuId")));
		modelAndView.setViewName("organ/organVendorRegistRequestList");
		return modelAndView;		
	}

	/**공급사등록결재조회 - 상세
	 */
	@RequestMapping("organVendorRegistApprovalDetail.sys")
	public ModelAndView getOrganVendorRegistApprovalDetail( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("organ/organVendorRegistRequestDetail");
//		mav.setViewName("organ/organVendorRegistApprovalDetail");
		return mav;
	}
	
	/**
	 * 감독관리사용자 조회
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("selectSmpDirectInfoList.sys")
	public ModelAndView selectSmpDirectInfoList(
			@RequestParam(value = "sord",defaultValue = "desc") String sord,
			@RequestParam(value = "sidx",defaultValue = "userNm") String sidx,
			@RequestParam(value = "borgId",required = true) String borgId,
			@RequestParam(value = "userId",required = true) String userId,
			ModelAndView modelAndView, HttpServletRequest req) throws Exception{
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("borgId"		, borgId);
		params.put("userId"		, userId);
		params.put("orderString", orderString);
		
		List<SmpUsersDto> selectSmpDirectInfoList = organSvc.selectSmpDirectInfoList(params);	// 기본권한 리스트
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list"	, selectSmpDirectInfoList);
		return modelAndView;		
	}
	
	@RequestMapping("updateReqSmpBranchs.sys")
	public ModelAndView updateReqSmpBranchs(
			@RequestParam(value="branchId", defaultValue="")String branchId,
			@RequestParam(value="file_biz_reg_list",defaultValue="")String file_biz_reg_list,
			@RequestParam(value="file_app_sal_list",defaultValue="")String file_app_sal_list,
			@RequestParam(value="file_list1",defaultValue="")String file_list1,
			@RequestParam(value="file_list2",defaultValue="")String file_list2,
			@RequestParam(value="file_list3",defaultValue="")String file_list3,
			HttpServletRequest request, ModelAndView mav) throws Exception{
		CustomResponse custResponse = new CustomResponse(true);
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("branchId", branchId);
		saveMap.put("file_biz_reg_list", file_biz_reg_list);
		saveMap.put("file_app_sal_list", file_app_sal_list);
		saveMap.put("file_list1", file_list1);
		saveMap.put("file_list2", file_list2);
		saveMap.put("file_list3", file_list3);
		try{
			organSvc.updateReqSmpBranchs(saveMap);
		}catch(Exception e){
			logger.debug("updateReqSmpBranchsError : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
		}
		mav = new ModelAndView("jsonView");
		mav.addObject(custResponse);
		return mav;
	}
	
	/**
	 * 물품공급계약서구분 코드값가져오기
	 */
	@RequestMapping("contractSpecialList.sys")
	public ModelAndView contractSpecialList(
			ModelAndView mav, HttpServletRequest request) throws Exception{
		List<CodesDto> list = commonSvc.getCodeList("CONTRACT_SPECIAL", 1);
		mav = new ModelAndView("jsonView");
		mav.addObject("list", list);
		return mav;
	}
	
	/**
	 * 샵메일이 있는지 체크
	 */
	@RequestMapping("sharpMailRegCheck.sys")
	public ModelAndView sharpMailRegCheck (
			@RequestParam(value="borgId", required=true)String borgId,
			@RequestParam(value="svcTypeCd", required=true)String svcTypeCd,
			HttpServletRequest request, ModelAndView mav) throws Exception{
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("borgId", borgId);
		params.put("svcTypeCd", svcTypeCd);
		
		int count = organSvc.getSharpMailRegCheckCount(params);
		
		mav = new ModelAndView("jsonView");
		mav.addObject("count", count);
		return mav;
	}
	
	/**
	 * 샵메일 등록
	 */
	
	@RequestMapping("sharpMailSave.sys")
	public ModelAndView sharpMailSave(
			@RequestParam(value="borgId", required=true)String borgId,
			@RequestParam(value="svcTypeCd", required=true)String svcTypeCd,
			@RequestParam(value="sharpMailAddress", required=true)String sharpMailAddress,
			HttpServletRequest request, ModelAndView mav) throws Exception{
		
		CustomResponse customResponse = new CustomResponse(true);
		
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("borgId", borgId);
		saveMap.put("svcTypeCd", svcTypeCd);
		saveMap.put("sharpMailAddress", sharpMailAddress);
		
		try{
			organSvc.updateSharpMail(saveMap);
		}catch(Exception e){
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error!....");
			
		}
		mav = new ModelAndView("jsonView");
		mav.addObject("customResponse", customResponse);
		return mav;
	}
	
	
	/**
	 * 공급사 등록요청시 첨부파일 수정
	 */
	@RequestMapping("updateReqSmpVendors.sys")
	public ModelAndView updateReqSmpVendors(
			@RequestParam(value="vendorId", defaultValue="")String vendorId,
			@RequestParam(value="file_biz_reg_list",defaultValue="")String file_biz_reg_list,
			@RequestParam(value="file_app_sal_list",defaultValue="")String file_app_sal_list,
			@RequestParam(value="file_list1",defaultValue="")String file_list1,
			@RequestParam(value="file_list2",defaultValue="")String file_list2,
			@RequestParam(value="file_list3",defaultValue="")String file_list3,
			@RequestParam(value="file_list4",defaultValue="")String file_list4,
			HttpServletRequest request, ModelAndView mav) throws Exception{
		CustomResponse custResponse = new CustomResponse(true);
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("vendorId", vendorId);
		saveMap.put("file_biz_reg_list", file_biz_reg_list);
		saveMap.put("file_app_sal_list", file_app_sal_list);
		saveMap.put("file_list1", file_list1);
		saveMap.put("file_list2", file_list2);
		saveMap.put("file_list3", file_list3);
		saveMap.put("file_list4", file_list4);
		try{
			organSvc.updateReqSmpVendors(saveMap);
		}catch(Exception e){
			logger.debug("updateReqSmpVendorsError : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
		}
		mav = new ModelAndView("jsonView");
		mav.addObject(custResponse);
		return mav;
	}
	
	/** * 법인정보 수정 */
	@RequestMapping("updateCorporationInfo.sys")
	public ModelAndView updateCorporationInfo(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "id", required = true) String id,
			@RequestParam(value = "BORGNM", defaultValue = "") String borgNm,
			@RequestParam(value = "BORGID", required = true) String borgId,
			@RequestParam(value = "ISUSE", defaultValue = "") String isUse,
			@RequestParam(value = "ISPREPAY", defaultValue = "") String isPrepay,
			@RequestParam(value = "ISLIMIT", defaultValue = "") String isLimit,
			@RequestParam(value = "LOAN", defaultValue = "0") int loan,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("borgNm", borgNm);
		saveMap.put("isUse", "Y".equals(isUse) ? "1" : "0" );
		saveMap.put("loan", (loan*1000000) +"");
		saveMap.put("isPrepay", "Y".equals(isPrepay) ? "1" : "0" );
		saveMap.put("isLimit", "Y".equals(isLimit) ? "1" : "0" );
		saveMap.put("borgId", borgId);
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		saveMap.put("remoteIp", loginUserDto.getRemoteIp());
		saveMap.put("updaterId", loginUserDto.getUserId());
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			organSvc.updateCorporationInfo(saveMap);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/** 법인정보 등록 */
	@RequestMapping("insertClientInfo.sys")
	public ModelAndView insertClientInfo(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "topBorgId", defaultValue = "") String topBorgId,
			@RequestParam(value = "borgTypeCd", defaultValue = "") String borgTypeCd,
			@RequestParam(value = "parBorgId", defaultValue = "") String parBorgId,
			@RequestParam(value = "svcTypeCd", defaultValue = "") String svcTypeCd,
			@RequestParam(value = "groupId", defaultValue = "") String groupId,
			@RequestParam(value = "clientId", defaultValue = "") String clientId,
			@RequestParam(value = "branchId", defaultValue = "") String branchId,
			@RequestParam(value = "deptId", defaultValue = "") String deptId,
			
			@RequestParam(value = "BORGNM", defaultValue = "") String borgNm,
			@RequestParam(value = "BORGCD", defaultValue = "") String borgCd,
			@RequestParam(value = "ISUSE", defaultValue = "") String isUse,
			@RequestParam(value = "ISPREPAY", defaultValue = "") String isPrepay,
			@RequestParam(value = "LOAN", defaultValue = "0") String loan,
			@RequestParam(value = "ISLIMIT", defaultValue = "") String isLimit,
			@RequestParam(value = "borgLevel", defaultValue = "") String borgLevel,
			@RequestParam(value = "id", defaultValue = "") String idBorgId,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------저장값 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("borgNm", borgNm);
		saveMap.put("isUse", organSvc.getYnToZeroOne(isUse));
		saveMap.put("remoteIp", loginUserDto.getRemoteIp());
		saveMap.put("creatorId", loginUserDto.getUserId());
		saveMap.put("updaterId", loginUserDto.getUserId());
		saveMap.put("borgCd", borgCd.toUpperCase());
		
		saveMap.put("topBorgId", topBorgId);
		saveMap.put("parBorgId", parBorgId);
		saveMap.put("borgTypeCd", borgTypeCd);
		saveMap.put("svcTypeCd", svcTypeCd);
		saveMap.put("groupId", groupId);
		saveMap.put("clientId", clientId);
		saveMap.put("branchId", branchId);
		saveMap.put("deptId", deptId);
		
		saveMap.put("isPrepay", organSvc.getYnToZeroOne(isPrepay));
		try { saveMap.put("loan", (Integer.parseInt(loan) * 1000000 )); }
		catch(NumberFormatException e) { saveMap.put("loan", 0); }
		saveMap.put("isLimit", organSvc.getYnToZeroOne(isLimit));
		
		saveMap.put("borgLevel", borgLevel);
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			organSvc.insertClientInfo(saveMap);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	
	/** 사업장 등록 시 법인만 따로 조회 */
	@RequestMapping("organBranchSearchForReg.sys")
	public ModelAndView organBranchSearchForReg(
			@RequestParam(value = "clientId", required=true) String clientId,		
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("clientId", clientId);
		
        /*----------------조회------------*/
		SmpBranchsDto detailInfo = organSvc.organBranchSearchForReg(clientId);	// 사업장 마스터

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("data", detailInfo);
		return modelAndView;
	}	
	
	
	@RequestMapping("reqBorgAppMessage.sys")
	public ModelAndView reqBorgAppMessage(
				HttpServletRequest request, ModelAndView mav) throws Exception{
		CustomResponse custResponse = new CustomResponse(true);
		try{
		}catch(Exception e){
			logger.debug("reqBorgAppMessage : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
		}
		mav = new ModelAndView("jsonView");
		mav.addObject(custResponse);
		return mav;
	}
	
	/**
	 * 법인조회 엑셀출력
	 */
	@RequestMapping("corporationInfoListExcel.sys")
	public ModelAndView corporationInfoListExcel(
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 												// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,												// 정렬 조건
			@RequestParam(value = "srcClientNmTxt", defaultValue = "") String srcClientNmTxt,							// 법인명
			@RequestParam(value = "srcIsUseSel", defaultValue = "") String srcIsUseSel,									// 사용여부
			@RequestParam(value = "srcPressentNm", defaultValue = "") String srcPressentNm,								// 대표자명
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		ModelMap params = new ModelMap();
		params.put("srcClientNm",	srcClientNmTxt);
		params.put("srcIsUse",		srcIsUseSel);
		params.put("srcPressentNm",	srcPressentNm);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		//----------------조회------------/
		List<Object> list = (List<Object>)generalDao.selectGernalList("organ.selectCorporationInfo", params);
		
		List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("sheetTitle", sheetTitle);
		map1.put("colLabels", colLabels);
		map1.put("colIds", colIds);
		map1.put("numColIds", numColIds);
		map1.put("colDataList", list);
		sheetList.add(map1);
		modelAndView.setViewName("commonExcelViewResolver");
		modelAndView.addObject("excelFileName", excelFileName);
		modelAndView.addObject("sheetList", sheetList);
		return modelAndView;
	}
	
	/**
	 * 사업장조회 엑셀출력
	 */
	@RequestMapping("branchListExcel.sys")
	public ModelAndView branchListExcel(
			@RequestParam(value = "sidx",				defaultValue = "") String sidx, 					// 정렬할 칼럼 명
			@RequestParam(value = "sord",				defaultValue = "") String sord,						// 정렬 조건
			
			@RequestParam(value = "srcBorgNameLike",	defaultValue = "") String srcBorgNameLike,			//사업장명
			@RequestParam(value = "srcBranchGrad",		defaultValue = "") String srcBranchGrad,			//회원사등급
			@RequestParam(value = "srcAreaType",		defaultValue = "") String srcAreaType,				//권역
			@RequestParam(value = "srcIsUse",			defaultValue = "1") String srcIsUse,				//상태
			@RequestParam(value = "srcWorkId",			defaultValue = "") String srcWorkId,				//공사유형
			@RequestParam(value = "srcAccUser",			defaultValue = "") String srcAccUser,				//채권담당자
			@RequestParam(value = "srcGroupId",			defaultValue = "") String srcGroupId,				
			@RequestParam(value = "srcClientId",		defaultValue = "") String srcClientId,				
			@RequestParam(value = "srcBranchId",		defaultValue = "") String srcBranchId,				
			@RequestParam(value = "srcIsOrderLimit",	defaultValue = "") String srcIsOrderLimit,			//주문제한여부
			@RequestParam(value = "srcPressentNm",		defaultValue = "") String srcPressentNm,			//대표자명
			@RequestParam(value = "srcBusinessNum",		defaultValue = "") String srcBusinessNum,			//사업자등록번호
			@RequestParam(value = "srcPrePay",			defaultValue = "") String srcPrePay,				//선입금여부
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------조회조건 세팅------------*/
		ModelMap params = new ModelMap();
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcBranchGrad", srcBranchGrad);
		params.put("srcAreaType", srcAreaType);
		params.put("srcIsUse", srcIsUse);
		params.put("srcWorkId", srcWorkId);
		params.put("srcAccUser", srcAccUser);
		params.put("srcBorgNameLike", srcBorgNameLike);
		params.put("srcIsOrderLimit", srcIsOrderLimit);
		params.put("srcPrePay", srcPrePay);
		params.put("srcPressentNm", srcPressentNm);
		params.put("srcBusinessNum", srcBusinessNum);
		
		if("BUY".equals(userInfoDto.getSvcTypeCd())) {
			params.put("srcClientId", userInfoDto.getClientId());
		}
		if("branchId".equals(sidx)) {
			sidx = "a."+sidx;
		}
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		//----------------조회------------/
		List<Object> list = generalDao.selectGernalList("organ.selectOrganBranchList", params);
		List<Map<String, Object>> excelList = new ArrayList<Map<String, Object>>();
		for(int i=0; i < list.size(); i++){
			SmpBranchsDto smpBranchsDto = (SmpBranchsDto)list.get(i);
			Map<String, Object> excelMap = new HashMap<String, Object>();
			excelMap.put("branchCd",		smpBranchsDto.getBranchCd());			//업체코드
			excelMap.put("borgNm",			smpBranchsDto.getBorgNm());				//법인명
			excelMap.put("branchNm",		smpBranchsDto.getBranchNm());			//사업장명
			excelMap.put("businessNum",		smpBranchsDto.getBusinessNum());		//사업자등록번호
			excelMap.put("workNm",			smpBranchsDto.getWorkNm());				//공사유형
			excelMap.put("userNm",			smpBranchsDto.getUserNm());				//채권담당자
			excelMap.put("clientStatus1",	smpBranchsDto.getClientStatus1());		//법인사용/주문제한 여부
			excelMap.put("isOrderLimit1",	smpBranchsDto.getIsOrderLimit1());		//주문제한
			excelMap.put("areaTypeNm",		smpBranchsDto.getAreaTypeNm());			//권역
			excelMap.put("branchGrad",		smpBranchsDto.getBranchGrad());			//회원사등급
			excelMap.put("isUse",			smpBranchsDto.getIsUse());				//상태
			excelMap.put("prePay",			smpBranchsDto.getPrePay());				//선입금여부
			excelMap.put("createDate",		smpBranchsDto.getCreateDate());			//등록일
			excelMap.put("userLoginYn",		smpBranchsDto.getUserLoginYn());		//휴면사업장
			excelList.add(excelMap);
		}
		
		List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("sheetTitle", sheetTitle);
		map1.put("colLabels", colLabels);
		map1.put("colIds", colIds);
		map1.put("numColIds", numColIds);
		map1.put("colDataList", excelList);
		sheetList.add(map1);
		modelAndView.setViewName("commonExcelViewResolver");
		modelAndView.addObject("excelFileName", excelFileName);
		modelAndView.addObject("sheetList", sheetList);
		return modelAndView;
	}
	/**
	 * 사용자조회 엑셀출력
	 */
	@RequestMapping("userListExcel.sys")
	public ModelAndView userListExcel(
			@RequestParam(value = "sidx",			defaultValue = "")	String sidx, 				// 정렬할 칼럼 명
			@RequestParam(value = "sord",			defaultValue = "")	String sord,				// 정렬 조건
			
			@RequestParam(value = "srcGroupId",		defaultValue = "")	String srcGroupId,
			@RequestParam(value = "srcClientId",	defaultValue = "")	String srcClientId,
			@RequestParam(value = "srcBranchId",	defaultValue = "")	String srcBranchId,
			@RequestParam(value = "srcUserNm",		defaultValue = "")	String srcUserNm,
			@RequestParam(value = "srcLoginId",		defaultValue = "")	String srcLoginId,
			@RequestParam(value = "srcIsUse",		defaultValue = "1")	String srcIsUse,
			@RequestParam(value = "srcIsDirect",	defaultValue = "1")	String srcIsDirect,
			@RequestParam(value = "srcWorkId",		defaultValue = "")	String srcWorkId,
			
			@RequestParam(value = "sheetTitle",		defaultValue = "")	String sheetTitle,
			@RequestParam(value = "excelFileName",	defaultValue = "")	String excelFileName,
			@RequestParam(value = "colLabels",		required = false)	String[] colLabels,
			@RequestParam(value = "colIds",			required = false)	String[] colIds,
			@RequestParam(value = "numColIds",		required = false)	String[] numColIds,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		ModelMap params = new ModelMap();
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcUserNm", srcUserNm);
		params.put("srcLoginId", srcLoginId);
		params.put("srcIsUse", srcIsUse);
		params.put("srcIsDirect", srcIsDirect);
		params.put("srcWorkId", srcWorkId);
		
		if("userId".equals(sidx)) {
			sidx = "a."+sidx;
		}
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------조회------------*/
		List<Object> list = generalDao.selectGernalList("organ.selectOrganUserList", params);
		List<Map<String, Object>> excelList = new ArrayList<Map<String, Object>>();
		for(int i=0; i < list.size(); i++){
			SmpUsersDto			smpUsersDto	= (SmpUsersDto)list.get(i);
			Map<String, Object>	excelMap	= new HashMap<String, Object>();
			String				borogIsUse	= "";
			borogIsUse = smpUsersDto.getBorg_IsUse();
			borogIsUse = borogIsUse.replace("<font color=\"red\">", "");
			borogIsUse = borogIsUse.replace("</font>", "");
			excelMap.put("branchNm",		smpUsersDto.getBranchNm().replace("&gt;", ">"));		//고객사
			excelMap.put("areaTypeNm",		smpUsersDto.getAreaTypeNm());							//권역
			excelMap.put("userNm",			smpUsersDto.getUserNm());								//사용자명
			excelMap.put("loginId",			smpUsersDto.getLoginId());								//사용자ID
			excelMap.put("isUse",			smpUsersDto.getIsUse());								//사용자상태
			excelMap.put("borg_IsUse",		borogIsUse);											//고객사상태
			excelMap.put("isDirect",		smpUsersDto.getIsDirect());								//감독여부
			excelMap.put("workNm",			smpUsersDto.getWorkNm());								//공사유형
			excelMap.put("isLogin",			smpUsersDto.getIsLogin());								//로그인여부
			excelMap.put("tel",				smpUsersDto.getTel());									//전화번호
			excelMap.put("mobile",			smpUsersDto.getMobile());								//이동전화번호
			excelMap.put("isEmail",			smpUsersDto.getIsEmail().equals("0")?"미발송":"발송");	//Email발송
			excelMap.put("isSms",			smpUsersDto.getIsSms().equals("0")?"미발송":"발송");	//SMS발송
			excelMap.put("createDate",		smpUsersDto.getCreateDate());							//등록일
			excelMap.put("email",			smpUsersDto.geteMail());								//메일
			excelMap.put("userLoginYn",		smpUsersDto.getUserLoginYn());							//휴면계정
			
			excelList.add(excelMap);
		}
		
		List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("sheetTitle", sheetTitle);
		map1.put("colLabels", colLabels);
		map1.put("colIds", colIds);
		map1.put("numColIds", numColIds);
		map1.put("colDataList", excelList);
		sheetList.add(map1);
		modelAndView.setViewName("commonExcelViewResolver");
		modelAndView.addObject("excelFileName", excelFileName);
		modelAndView.addObject("sheetList", sheetList);
		return modelAndView;
	}
	
	@RequestMapping("updateSmpBranchNm.sys")
	public ModelAndView updateSmpBranchNm(
			@RequestParam(value = "branchId", required = true)	String branchId,			// 조직ID
			@RequestParam(value = "branchNm", required = true)	String branchNm,			// 사업장명
			@RequestParam(value = "isOrderApproval", defaultValue = "0")	String isOrderApproval,		// 주문결재 사용여부
		HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		HashMap<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("branchId"				,branchId);
		saveMap.put("branchNm"				,branchNm);
		saveMap.put("userId"				,userInfoDto.getUserId());
		saveMap.put("isOrderApproval"		,isOrderApproval);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			organSvc.updateSmpBranchNm(saveMap);
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
	
	/**운영사메뉴_공급사평가 list  */
	@RequestMapping("getVenEvaluationList.sys")
	public ModelAndView getVenEvaluationList(
			@RequestParam(value = "srcYear"			, defaultValue="" ) String srcYear,		
			@RequestParam(value = "srcMonth"			, defaultValue="" ) String srcMonth,		
			@RequestParam(value = "srcVendorNm"	, defaultValue="" ) String srcVendorNm,		
			@RequestParam(value = "srcVenIsUse"		, defaultValue="" ) String srcVenIsUse,		
			
			@RequestParam(value = "sidx",			defaultValue = "BUYI_REQU_AMOU")	String sidx, 				// 정렬할 칼럼 명
			@RequestParam(value = "sord",			defaultValue = "DESC")	String sord,				// 정렬 조건
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcYear", srcYear);
		params.put("srcMonth", srcMonth);
		params.put("srcVendorNm", srcVendorNm);
		params.put("srcVenIsUse", srcVenIsUse);
		
		String orderString = null;
		if( sidx.equals("DEAL_YEAR")  ){
			orderString = "  CREATEDATE " + sord + "  , VENDORNM ASC";
		}else if (sidx.equals("DELI_INFO") ) {
			orderString = "  CONVERT(INT, EVAL_DAY ) " + sord + "  , VENDORNM ASC";
		}else if (sidx.equals("NEW_MATER_CNT") ) {
			orderString = "  CONVERT(INT, SELECTED_CNT ) " + sord + "  , VENDORNM ASC";
		}else if (sidx.equals("CREDITINFO")  ) {
			orderString = " "+ sidx+" " + sord ;  
		}else if (sidx.equals("VENDORNM") == false ) {
			orderString = "  CONVERT(INT," + sidx + ") " + sord + "  , VENDORNM ASC";
		}else{
			orderString = " VENDORNM "+ sord ;  
		}
		params.put("orderString", orderString);
		/*----------------조회------------*/
		List<Map<String,Object>> list = organSvc.getVenEvaluationList(params);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}	
	/**운영사메뉴_공급사평가 Excel list  */
	@RequestMapping("getVenEvaluationExcel.sys")
	public ModelAndView getVenEvaluationExcel(
			@RequestParam(value = "srcYear"			, defaultValue="" ) String srcYear,		
			@RequestParam(value = "srcMonth"			, defaultValue="" ) String srcMonth,		
			@RequestParam(value = "srcVendorNm"	, defaultValue="" ) String srcVendorNm,		
			@RequestParam(value = "srcVenIsUse"		, defaultValue="" ) String srcVenIsUse,		
			
			@RequestParam(value = "sidx",			defaultValue = "BUYI_REQU_AMOU")	String sidx, 				// 정렬할 칼럼 명
			@RequestParam(value = "sord",			defaultValue = "DESC")	String sord,				// 정렬 조건
			
			@RequestParam(value = "sheetTitle",		defaultValue = "")	String sheetTitle,
			@RequestParam(value = "excelFileName",	defaultValue = "")	String excelFileName,
			@RequestParam(value = "colLabels",		required = false)	String[] colLabels,
			@RequestParam(value = "colIds",			required = false)	String[] colIds,
			@RequestParam(value = "numColIds",		required = false)	String[] numColIds,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcYear", srcYear);
		params.put("srcMonth", srcMonth);
		params.put("srcVendorNm", srcVendorNm);
		params.put("srcVenIsUse", srcVenIsUse);
		
		String orderString = " "+ sidx+" " + sord ;  
		params.put("orderString", orderString);
		
		/*----------------조회------------*/
		List<Map<String,Object>> list = organSvc.getVenEvaluationExcel(params);
		

		List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("sheetTitle", sheetTitle);
		map1.put("colLabels", colLabels);
		map1.put("colIds", colIds);
		map1.put("numColIds", numColIds);
		map1.put("colDataList", list);
		
		sheetList.add(map1);
		modelAndView.setViewName("commonExcelViewResolver");
		modelAndView.addObject("excelFileName", excelFileName);
		modelAndView.addObject("sheetList", sheetList);
		return modelAndView;
	}
}
