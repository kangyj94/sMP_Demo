package kr.co.bitcube.organ.controller;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.ReceiveInfoDto;
import kr.co.bitcube.common.dto.SmsEmailInfo;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.organ.service.ReqBorgSvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("organ")

public class ReqBorgController {
	
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private ReqBorgSvc reqBorgSvc;

	@Autowired
	private CommonSvc commonSvc;
	
	/** 고객법인 등록팝업 호출
	 */
	@RequestMapping("reqBranchPop.sys")
	public ModelAndView reqBranchPop( HttpServletRequest req, ModelAndView mav) throws Exception{
		
		//권역코드
		mav.addObject("areaCode", commonSvc.getCodeList("DELI_AREA_CODE", 1));
		//은행코드
		mav.addObject("bankCode", commonSvc.getCodeList("BANKCD", 1));
		//회원사등급
		mav.addObject("mGradeCode", commonSvc.getCodeList("MEMBERGRADE", 1));
		//결제조건
		mav.addObject("payCondCode", commonSvc.getCodeList("PAYMCONDCODE", 1));
		
		mav.setViewName("organ/reqBranchPop");
		return mav;
	}
	
	/**
	 * 고객법인 등록 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("saveBranchPop.sys")
	public ModelAndView saveBranchPop(
			// 고객법인 마스터
			@RequestParam(value = "clientNm", required = true) 		        String clientNm,			// 법인명
			@RequestParam(value = "clientCd", required = true) 		        String clientCd,			// 법인코드
			@RequestParam(value = "businessNum1", required = true)          String businessNum1,		// 사업자등록번호1
			@RequestParam(value = "businessNum2", required = true)          String businessNum2,		// 사업자등록번호2
			@RequestParam(value = "businessNum3", required = true)          String businessNum3,		// 사업자등록번호3
			@RequestParam(value = "registNum1", defaultValue = "") 	        String registNum1,			// 법인등록번호1
			@RequestParam(value = "registNum2", defaultValue = "") 	        String registNum2,			// 법인등록번호2
			@RequestParam(value = "branchBustType", required = true)        String branchBustType,		// 업종
			@RequestParam(value = "branchBustClas", required = true)        String branchBustClas,		// 업태
			@RequestParam(value = "pressentNm", required = true) 	        String pressentNm,			// 대표자명
			@RequestParam(value = "phoneNum", required = true) 		        String phoneNum,			// 대표전화번호
			@RequestParam(value = "eMail", required = true) 		        String eMail,			    // 회사이메일
			@RequestParam(value = "homePage", defaultValue = "") 	        String homePage,		    // 홈페이지 
			@RequestParam(value = "postAddrNum", required = true)       	String postAddrNum,		    // 주소1 
			@RequestParam(value = "addres", required = true) 		        String addres,				// 주소2 
			@RequestParam(value = "addresDesc", defaultValue = "") 	        String addresDesc,			// 상세주소 
			@RequestParam(value = "faxNum", defaultValue = "") 				String faxNum,				// 팩스번호 
			@RequestParam(value = "refereceDesc", defaultValue = "")		String refereceDesc,		// 참고사항 
			@RequestParam(value = "file_biz_reg_list", required = true) 	String file_biz_reg_list,	// 사업자등록첨부 
			@RequestParam(value = "file_app_sal_list", defaultValue = "") 	String file_app_sal_list,	// 신용평가서첨부 
			@RequestParam(value = "file_list1", defaultValue = "")          String file_list1,			// 기타첨부1 
			@RequestParam(value = "file_list2", defaultValue = "")          String file_list2,		    // 기타첨부2 
			@RequestParam(value = "file_list3", defaultValue = "")          String file_list3,		    // 기타첨부3 
			@RequestParam(value = "areaType", required = true) 				String areaType,		    // 권역 
			@RequestParam(value = "branchGrad", required = true) 			String branchGrad,		    // 회원사등급 
			@RequestParam(value = "payBillType", required = true) 			String payBillType,		    // 결제조건
			@RequestParam(value = "payBillDay", defaultValue="") 			String payBillDay,		    // 결제일
			@RequestParam(value = "accountManagerNm", required = true) 		String accountManagerNm,	// 회계담당자명 
			@RequestParam(value = "accountTelNum", required = true) 		String accountTelNum,		// 회계이동전화 
			@RequestParam(value = "bankCd", required = true) 				String bankCd,				// 은행코드 
			@RequestParam(value = "recipient", required = true) 			String recipient,		    // 예금주명 
			@RequestParam(value = "accountNum", required = true) 			String accountNum,		    // 계좌번호 
			@RequestParam(value = "loginId", required = true) 				String loginId,				// 로그인아이디 
			@RequestParam(value = "pwd", required = true) 					String pwd,					// 비밀번호 
			@RequestParam(value = "userNm", required = true) 				String userNm,				// 성명 
			@RequestParam(value = "tel", required = true) 					String tel,					// 전화번호 
			@RequestParam(value = "mobile", required = true) 				String mobile,				// 이동전화번호 
			@RequestParam(value = "userEmail", required = true) 			String userEmail,			// 이메일 
			@RequestParam(value = "userDn", required = true) 				String userDn,				// 공인인증서 정보 
			// 배송처 정보
			@RequestParam(value = "shippingPlaceArr[]", required = false) String[] shippingPlaceArr,					// 배송처명
			@RequestParam(value = "shippingPhoneNumArr[]", required = false) String[] shippingPhoneNumArr,			// 배송처 전화번호
			@RequestParam(value = "shippingAddresArr[]", required = false) String[] shippingAddresArr,				// 배송처 주소
			@RequestParam(value = "sharpMail", required = true) String sharpMail,					// 샵메일
			//물품공급계약서 등록
			@RequestParam(value="contractVersionArray[]", defaultValue="") String[] contractVersionArray,
			@RequestParam(value="contractClassifyArray[]", defaultValue="") String[] contractClassifyArray,
		HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		if(logger.isDebugEnabled()) {
			logger.debug("-------------------------start!---------------------------");
			Enumeration<String> paramEnum = request.getParameterNames();
			while(paramEnum.hasMoreElements()) {
				String paramString = paramEnum.nextElement();
				String []fieldValues = request.getParameterValues(paramString);
				int i = 0;
				for(String fieldValue : fieldValues) {
					logger.debug("Search FieldName : " + paramString + ",  FieldValue["+(i++)+"] : "+fieldValue);
				}
			}
			logger.debug("-------------------------end!---------------------------");
		}
		
		HashMap<String, Object> borgMap = new HashMap<String, Object>();
		borgMap.put("clientNm"			,clientNm);
		borgMap.put("clientCd"			,clientCd.toUpperCase());
		borgMap.put("businessNum"		,businessNum1 + businessNum2 + businessNum3);
		borgMap.put("registNum"			,registNum1 + registNum2);
		borgMap.put("branchBustType"	,branchBustType);
		borgMap.put("branchBustClas"	,branchBustClas);
		borgMap.put("pressentNm"		,pressentNm);
		borgMap.put("phoneNum"			,phoneNum);
		borgMap.put("eMail"				,eMail);
		borgMap.put("homePage"			,homePage);
		borgMap.put("postAddrNum"		,postAddrNum);
		borgMap.put("addres"			,addres);
		borgMap.put("addresDesc"		,addresDesc);
		borgMap.put("faxNum"			,faxNum);
		borgMap.put("refereceDesc"		,refereceDesc);
		borgMap.put("file_biz_reg_list"	,file_biz_reg_list);
		borgMap.put("file_app_sal_list"	,file_app_sal_list);
		borgMap.put("file_list1"		,file_list1);
		borgMap.put("file_list2"		,file_list2);
		borgMap.put("file_list3"		,file_list3);
		borgMap.put("areaType"			,areaType);
		borgMap.put("branchGrad"		,branchGrad);
		borgMap.put("payBillType"		,payBillType);
		borgMap.put("payBillDay"		,payBillDay);
		borgMap.put("accountManagerNm"	,accountManagerNm);
		borgMap.put("accountTelNum"		,accountTelNum);
		borgMap.put("bankCd"			,bankCd);
		borgMap.put("recipient"			,recipient);
		borgMap.put("accountNum"		,accountNum);
		borgMap.put("loginId"			,loginId);
		borgMap.put("pwd"				,pwd);
		borgMap.put("userNm"			,userNm);
		borgMap.put("tel"				,tel);
		borgMap.put("mobile"			,mobile);
		borgMap.put("userEmail"			,userEmail);
		borgMap.put("remoteIp"			,request.getRemoteAddr());
		borgMap.put("creatUserId"		,"");
		borgMap.put("userDn"			,userDn);
		
		borgMap.put("shippingPlaceArr"		,shippingPlaceArr);
		borgMap.put("shippingPhoneNumArr"	,shippingPhoneNumArr);	
		borgMap.put("shippingAddresArr"		,shippingAddresArr);	
		borgMap.put("sharpMail"		,sharpMail);
		
		borgMap.put("contractVersionArray"		,contractVersionArray);
		borgMap.put("contractClassifyArray"		,contractClassifyArray);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			reqBorgSvc.saveReqBranch(borgMap);
			
			/** SMS 발송 **/
			//B2B운영자권한에게 SMS발송
//			List<SmsEmailInfo> receiveInfoList = commonSvc.getApproverSmsEmailInfoByRoleCd("ADM_B2B_MAN");
			String smsStr 		= null;
			SmsEmailInfo dto 	= null;
			
//			if(receiveInfoList != null && receiveInfoList.size() > 0){
//				for(int i = 0 ; i <  receiveInfoList.size() ; i++){
//					dto = receiveInfoList.get(i);
					//sms발송여부와 상관없이 무조건 발송되게 처리
//					if(dto.isSms()){
//						smsStr = "[OK플라자] [" + clientNm + "]에서 구매사 등록을 요청하였습니다";
//						commonSvc.sendRightSms(dto.getMobileNum(), smsStr);
//					}
//				}
//			}
			//코드관리에 있는 사용자만 sms발송
			List<CodesDto> unconditionalList = commonSvc.getCodeList("ORGAN_REQ_SMS", 1);
			smsStr = "[OK플라자] [" + clientNm + "]에서 구매사 등록을 요청하였습니다";
			commonSvc.unconditionalSmsList(unconditionalList, smsStr);
			
			
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
	 * 공급사 등록 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("saveVendorPop.sys")
	public ModelAndView saveVendorPop(
			// 고객법인 마스터
			@RequestParam(value = "vendorNm", required = true)				String vendorNm,				//법인명
			@RequestParam(value = "businessNum1", required = true)			String businessNum1,			//사업자등록번호1
			@RequestParam(value = "businessNum2", required = true)			String businessNum2,			//사업자등록번호2
			@RequestParam(value = "businessNum3", required = true)			String businessNum3,			//사업자등록번호3
			@RequestParam(value = "registNum1", defaultValue = "")			String registNum1,				//법인등록번호1
			@RequestParam(value = "registNum2", defaultValue = "")			String registNum2,				//법인등록번호2
			@RequestParam(value = "vendorBustType", required = true)		String vendorBustType,			//업종
			@RequestParam(value = "vendorBustClas", required = true)		String vendorBustClas,			//업태
			@RequestParam(value = "pressentNm", required = true)			String pressentNm,				//대표자명
			@RequestParam(value = "phoneNum", required = true)				String phoneNum,				//대표전화번호
			@RequestParam(value = "eMail", required = true)					String eMail,					//회사이메일
			@RequestParam(value = "homePage", defaultValue = "")			String homePage,				//홈페이지 
			@RequestParam(value = "postAddrNum", required = true)			String postAddrNum,				//주소1 
			@RequestParam(value = "addres", required = true)				String addres,					//주소2 
			@RequestParam(value = "addresDesc", defaultValue = "")			String addresDesc,				//상세주소 
			@RequestParam(value = "faxNum", defaultValue = "") 				String faxNum,					//팩스번호 
			@RequestParam(value = "refereceDesc", defaultValue = "")		String refereceDesc,			//참고사항 
			@RequestParam(value = "file_biz_reg_list", required = true) 	String file_biz_reg_list,		//사업자등록첨부 
			@RequestParam(value = "file_app_sal_list", defaultValue = "")	String file_app_sal_list,		//신용평가서첨부 
			@RequestParam(value = "file_list1", defaultValue = "")			String file_list1,				//기타첨부1 
			@RequestParam(value = "file_list2", defaultValue = "")			String file_list2,				//기타첨부2 
			@RequestParam(value = "file_list3", defaultValue = "")			String file_list3,				//회사소개서 			
			@RequestParam(value = "areaType", required = true) 				String areaType,				//권역 
			@RequestParam(value = "payBillType", required = true) 			String payBillType,				//결제조건
			@RequestParam(value = "payBillDay", defaultValue="") 			String payBillDay,				//결제일
			@RequestParam(value = "accountManagerNm", required = true) 		String accountManagerNm,		//회계담당자명 
			@RequestParam(value = "accountTelNum", required = true) 		String accountTelNum,			//회계이동전화 
			@RequestParam(value = "bankCd", required = true) 				String bankCd,					//은행코드 
			@RequestParam(value = "recipient", required = true) 			String recipient,				//예금주명 
			@RequestParam(value = "accountNum", required = true) 			String accountNum,				//계좌번호 
			@RequestParam(value = "loginId", required = true) 				String loginId,					//로그인아이디 
			@RequestParam(value = "pwd", required = true) 					String pwd,						//비밀번호 
			@RequestParam(value = "userNm", required = true) 				String userNm,					//성명 
			@RequestParam(value = "tel", required = true) 					String tel,						//전화번호 
			@RequestParam(value = "mobile", required = true) 				String mobile,					//이동전화번호 
			@RequestParam(value = "userEmail", required = true) 			String userEmail,				//이메일 
			@RequestParam(value = "userDn", required = true)				String userDn,					//공인인증서 정보
			@RequestParam(value = "sharpMail", required = true)				String sharpMail,				//회사샵메일
			@RequestParam(value = "classify", required = true)				String classify,				//공급사 구분
			//물품공급계약서 등록
			@RequestParam(value="contractVersionArray[]", defaultValue="") String[] contractVersionArray,
			@RequestParam(value="contractClassifyArray[]", defaultValue="") String[] contractClassifyArray,
			@RequestParam(value = "file_list4", defaultValue = "")			String file_list4,				//기타첨부4 	
			
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		HashMap<String, Object> borgMap = new HashMap<String, Object>();
		borgMap.put("vendorNm"			,vendorNm);
		borgMap.put("businessNum"		,businessNum1 + businessNum2 + businessNum3);
		borgMap.put("registNum"			,registNum1 + registNum2);
		borgMap.put("vendorBustType"	,vendorBustType);
		borgMap.put("vendorBustClas"	,vendorBustClas);
		borgMap.put("pressentNm"		,pressentNm);
		borgMap.put("phoneNum"			,phoneNum);
		borgMap.put("eMail"				,eMail);
		borgMap.put("homePage"			,homePage);
		borgMap.put("postAddrNum"		,postAddrNum);
		borgMap.put("addres"			,addres);
		borgMap.put("addresDesc"		,addresDesc);
		borgMap.put("faxNum"			,faxNum);
		borgMap.put("refereceDesc"		,refereceDesc);
		borgMap.put("file_biz_reg_list"	,file_biz_reg_list);
		borgMap.put("file_app_sal_list"	,file_app_sal_list);
		borgMap.put("file_list1"		,file_list1);
		borgMap.put("file_list2"		,file_list2);
		borgMap.put("file_list3"		,file_list3); 
		borgMap.put("areaType"			,areaType);
		borgMap.put("payBillType"		,payBillType);
		borgMap.put("payBillDay"		,payBillDay);
		borgMap.put("accountManagerNm"	,accountManagerNm);
		borgMap.put("accountTelNum"		,accountTelNum);
		borgMap.put("bankCd"			,bankCd);
		borgMap.put("recipient"			,recipient);
		borgMap.put("accountNum"		,accountNum);
		borgMap.put("loginId"			,loginId);
		borgMap.put("pwd"				,pwd);
		borgMap.put("userNm"			,userNm);
		borgMap.put("tel"				,tel);
		borgMap.put("mobile"			,mobile);
		borgMap.put("userEmail"			,userEmail);
		borgMap.put("remoteIp"			,request.getRemoteAddr());
		borgMap.put("userDn"			,userDn);
		borgMap.put("sharpMail"			, sharpMail);
		borgMap.put("classify"			, classify);
		
		borgMap.put("contractVersionArray"		,contractVersionArray);
		borgMap.put("contractClassifyArray"		,contractClassifyArray);
		borgMap.put("file_list4"		,file_list4);
		
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			reqBorgSvc.saveReqVendor(borgMap);

			/** SMS 발송 **/
			List<SmsEmailInfo> receiveInfoList = commonSvc.getApproverSmsEmailInfoByRoleCd("ADM_B2B_MAN");
			String smsStr 		= null;
			SmsEmailInfo dto 	= null;
			
			if(receiveInfoList != null && receiveInfoList.size() > 0){
				
				for(int i = 0 ; i <  receiveInfoList.size() ; i++){
					try {
						dto = receiveInfoList.get(i);
						//sms발송여부와 상관없이 무조건 발송되게 처리
//						if(dto.isSms()){	
							smsStr = "[OK플라자] [" + vendorNm + "]에서 공급사등록을 요청하였습니다";
							commonSvc.sendRightSms(dto.getMobileNum(), smsStr);
//						}
					} catch (Exception e) {
						logger.error("SMS(managerSmsEmailInfoList) Save Error : "+e);
					}
				}
			}
			
			//송태리, 변지희 두 사람의 경우 무조건 sms발송
//			List<CodesDto> unconditionalList = commonSvc.getCodeList("ORGAN_REQ_SMS", 1);
//			commonSvc.unconditionalSmsList(unconditionalList, smsStr);
			
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
	
	@RequestMapping("reqBorgDupCheck.sys")
	public ModelAndView reqBorgDupCheck(
					@RequestParam(value = "clientCd", required = true) String clientCd,
					HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		CustomResponse custResponse = reqBorgSvc.reqBorgDupCheck(clientCd);
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}

	@RequestMapping("loginIdDupCheck.sys")
	public ModelAndView loginIdDupCheck(
			@RequestParam(value = "loginId", required = true) String loginId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		CustomResponse custResponse = reqBorgSvc.loginIdDupCheck(loginId);
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;		
	}
}
