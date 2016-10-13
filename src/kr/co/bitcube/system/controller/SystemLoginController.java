package kr.co.bitcube.system.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.common.dao.CommonDao;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.BorgDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.service.WebChatService;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.product.service.ProductSvc;
//import kr.co.bitcube.common.utils.UserAgentParser;
import kr.co.bitcube.system.dto.NonUsersDto;
import kr.co.bitcube.system.exception.SystemUserLoginException;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("system")
public class SystemLoginController {

	private Logger logger = Logger.getLogger(getClass());
	@Autowired private CommonSvc commonSvc;
	@Autowired private CommonDao commonDao;
	@Autowired private GeneralDao generalDao;
	@Autowired private ProductSvc productSvc;
	
	@Autowired WebChatService webChatService; // 로그 여부를 웹 체팅에 알리기 위해 추가(2012-05-24, tytolee)
	
	/**
	 * 실제로그인하여 사용자정보을 세션에 담는다.
	 * @param loginId
	 * @param password
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("systemLogin.sys")
	public ModelAndView systemLogin(
			@RequestParam(value = "loginId", required = true) String loginId,
			@RequestParam(value = "password", required = true) String password,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("loginId", loginId);
		searchMap.put("password", password);
		LoginUserDto loginUserDto = commonSvc.getLoginUserInfo(searchMap);
		String clientIp = request.getHeader("Proxy-Client-IP");
		if(clientIp == null) {
			clientIp = request.getHeader("WL-Proxy-Client-IP");
			if(clientIp == null) {
				clientIp = request.getHeader("X-Forwarded-For");
				if(clientIp == null) clientIp = request.getRemoteAddr();
			}
		}
		loginUserDto.setRemoteIp(clientIp);
		loginUserDto.setLastLoginDate(CommonUtils.getCurrentDateTime());
		
		/*------------------브라우저 버전 확인--------------*/
		//이재찬 대리 요청으로 운영사 브라우저 버전 검사 해제
//		String browserInfo = "";
//		try {
//			String userAgent = request.getHeader("User-Agent");
//			UserAgentParser userAgentParser = new UserAgentParser(userAgent);
//			browserInfo = "Browser Name:" + userAgentParser.getBrowserName() + " Browser Version:" + userAgentParser.getBrowserVersion() + "OS Name:"
//				+ userAgentParser.getBrowserOperatingSystem();
//			if("ADM".equals(loginUserDto.getSvcTypeCd())) {
//				if("MSIE".equals(userAgentParser.getBrowserName())) {
//					
//					if(userAgent.indexOf("MSIE 6.0")>-1 || userAgent.indexOf("MSIE 7.0")>-1 || userAgent.indexOf("MSIE 8.0")>-1) {
//						throw new SystemUserLoginException("Explorer 9 이상 또는 다른 브라우져를 사용하십시오");
//					}
//				}
//			}
//		} catch (NumberFormatException e) {
//			
//			
//		}
		
		/*----------메뉴사용유무에 따라 webChatService 처리----------*/
//		List<LoginMenuDto> staticMenuList = loginUserDto.getStaticMenuList();	//고정메뉴리스트
		boolean isChat = false;	//메신저 사용여부
//		for(LoginMenuDto loginMenuDto : staticMenuList) {
//			if("SYS_CHAT".equals(loginMenuDto.getMenuCd())) { isChat = true; break; }
//		}
		
		if(isChat) {	//메신저 메뉴 사용
			CommonUtils.setLoginInUserSession(request, Constances.SESSION_NAME, loginUserDto, this.webChatService);
			CommonUtils.setLoginInUserSession(request, "cate", productSvc.getSideCateList(loginUserDto.getBorgId()));
		} else {	//메신저 메뉴 미사용
			CommonUtils.setLoginInUserSession(request, Constances.SESSION_NAME, loginUserDto);
			CommonUtils.setLoginInUserSession(request, "cate", productSvc.getSideCateList(loginUserDto.getBorgId()));
		}
		
		if("BUY".equals(loginUserDto.getSvcTypeCd()) || "VEN".equals(loginUserDto.getSvcTypeCd())) {
			modelAndView.setViewName("redirect:systemDefault.sys");
		}else{
			modelAndView.setViewName(Constances.SYSTEM_TREE_FRAME_PATH);
		}
		
		return modelAndView;
	}
	
	/**
	 * 로그인 사용자 ID, Password 체크
	 * @param loginId
	 * @param password
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("loginCheckPop.sys")
	public ModelAndView loginCheckPop(
			@RequestParam(value = "loginId", required = true) String loginId,
			@RequestParam(value = "password", defaultValue = "") String password,
			@RequestParam(value = "belongBorgId", defaultValue = "") String belongBorgId,
			@RequestParam(value = "belongSvcTypeCd", defaultValue = "") String belongSvcTypeCd,
			@RequestParam(value = "chk_flag", defaultValue = "0") String chk_flag,
			
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------체크값 세팅------------*/
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("loginId", loginId);
		searchMap.put("password", password);
		searchMap.put("belongBorgId", belongBorgId);
		searchMap.put("belongSvcTypeCd", belongSvcTypeCd);
		searchMap.put("chk_flag", chk_flag);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = commonSvc.getUserAuthByLoginIdPassword(searchMap);
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	@RequestMapping("loginAuthCheck.sys")
	public ModelAndView loginAuthCheck(
			@RequestParam(value = "authFlag", required = true) String authFlag,
			@RequestParam(value = "loginId", required = true) String loginId,
			@RequestParam(value = "srcMoblieNum", required = true) String srcMoblieNum,
			@RequestParam(value = "srcAuthNum", required = true) String srcAuthNum,
			HttpServletRequest request, ModelAndView modelAndView, ModelMap searchMap) throws Exception {
		CustomResponse custResponse = new CustomResponse(true);
		/*----------------체크값 세팅------------*/
		searchMap.put("loginId", loginId);
		searchMap.put("srcMoblieNum", srcMoblieNum);
		searchMap.put("srcAuthNum", srcAuthNum);
		
		/*----------------수행및 결과값 리턴------------*/
		if("1".equals(authFlag) || "3".equals(authFlag)) {	//로그인 인증
			int authCnt = commonSvc.getMobileAuthCnt(searchMap);
			if(authCnt==0) {
				custResponse.setSuccess(false);
				custResponse.setMessage("인증키가 맞지 않습니다.");
			} else {	
				//1. 인증완료 구매사,공급사여부 체크
				//2. 구매사라면 기본,개인,특별계약서 서명 버전확인하여 버전이 틀리면 newIdx:사업장ID return
				//3. 공급사라면 서명 버전확인하여 버전이 틀리면 newIdx:공급사ID return
				String borgId = commonSvc.getBorgIdContractBorgUser(loginId);
				if(!"".equals(borgId)) {
					custResponse.setNewIdx(borgId);	//서명해야 한다면 조직ID return
				}
			}
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	@RequestMapping("loginContractCheck.sys")
	public ModelAndView loginContractCheck(
			@RequestParam(value = "loginId", required = true) String loginId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		CustomResponse custResponse = new CustomResponse(true);
		String         borgId       = this.commonSvc.getBorgIdContractBorgUser(loginId);
		
		if("".equals(borgId) == false) {
			custResponse.setNewIdx(borgId);	//서명해야 한다면 조직ID return
		}
		if("305054".equals(borgId) == true) { // 로그인한 공급사가 스미토모일 경우 예외처리. 
			custResponse.setNewIdx(null);
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		
		return modelAndView;
	}
	
	@RequestMapping("systemLogout.sys")
	public ModelAndView systemLogout(HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		boolean     isChat      = false; //메신저 사용여부

		if(isChat){	//메신저 사용
			CommonUtils.setLogOutUserSession(request, Constances.SESSION_NAME, this.webChatService);
		}
		else{	//메신저 미사용
			CommonUtils.setLogOutUserSession(request, Constances.SESSION_NAME);
		}
		
		return new ModelAndView("redirect:" + Constances.SYSTEM_LOGIN_PATH);
	}
	
	@RequestMapping("belongSystemLogin.sys")
	public ModelAndView belongSystemLogin(
			@RequestParam(value = "belongBorgId", required = true) String belongBorgId,
			@RequestParam(value = "belongSvcTypeCd", defaultValue = "") String belongSvcTypeCd,
			@RequestParam(value = "moveUserId", defaultValue = "") String moveUserId,
			@RequestParam(value = "adminUserId", defaultValue = "") String adminUserId,
			@RequestParam(value = "adminBorgId", defaultValue = "") String adminBorgId,
			@RequestParam(value = "adminBorgNm", defaultValue = "") String adminBorgNm,
			@RequestParam(value = "adminSvcTypeCd", defaultValue = "") String adminSvcTypeCd,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto beforeloginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> searchMap = new HashMap<String, Object>();
		
		if(!"".equals(moveUserId))
			searchMap.put("userId", moveUserId);
		else
			searchMap.put("userId", beforeloginUserDto.getUserId());
		
		searchMap.put("belongBorgId", belongBorgId);
		searchMap.put("svcTypeCd", belongSvcTypeCd);
		LoginUserDto loginUserDto = commonSvc.getLoginUserInfo(searchMap);
		
		/*------------------------운영자가 조직이동했을 때 다시 운영자 페이지로 돌아오기 위해 세팅 시작---------------------*/
		if(!"".equals(adminUserId)) {
			BorgDto tmpBorgDto = new BorgDto();
			tmpBorgDto.setAdminUserId(adminUserId);
			tmpBorgDto.setBorgId(adminBorgId);
//			tmpBorgDto.setBorgNm("에스케이텔레시스주식회사");
			tmpBorgDto.setBorgNm("유앤팜스뱅크");
			tmpBorgDto.setSvcTypeCd(adminSvcTypeCd);
			List<BorgDto> belongBorgList = loginUserDto.getBelongBorgList();
			belongBorgList.add(tmpBorgDto);
			loginUserDto.setBelongBorgList(belongBorgList);
		}
		/*------------------------운영자가 조직이동했을 때 다시 운영자 페이지로 돌아오기 위해 세팅 끝---------------------*/
		String clientIp = request.getHeader("Proxy-Client-IP");
		if(clientIp == null) {
			clientIp = request.getHeader("WL-Proxy-Client-IP");
			if(clientIp == null) {
				clientIp = request.getHeader("X-Forwarded-For");
				if(clientIp == null) clientIp = request.getRemoteAddr();
			}
		}
		loginUserDto.setRemoteIp(clientIp);
		loginUserDto.setLastLoginDate(CommonUtils.getCurrentDateTime());
		
		this.systemLogout(request, modelAndView);	//로그아웃처리
		/*----------메뉴사용유무에 따라 webChatService 처리----------*/
//		List<LoginMenuDto> staticMenuList = loginUserDto.getStaticMenuList();	//고정메뉴리스트
		boolean isChat = false;	//메신저 사용여부
//		for(LoginMenuDto loginMenuDto : staticMenuList) {
//			if("SYS_CHAT".equals(loginMenuDto.getMenuCd())) { isChat = true; break; }
//		}
		if(isChat) {	//메신저 메뉴 사용
			CommonUtils.setLoginInUserSession(request, Constances.SESSION_NAME, loginUserDto, this.webChatService);
			CommonUtils.setLoginInUserSession(request, "cate", productSvc.getSideCateList(loginUserDto.getBorgId()));
		} else {	//메신저 메뉴 미사용
			CommonUtils.setLoginInUserSession(request, Constances.SESSION_NAME, loginUserDto);
			CommonUtils.setLoginInUserSession(request, "cate", productSvc.getSideCateList(loginUserDto.getBorgId()));
		}

		modelAndView.setViewName(Constances.SYSTEM_TREE_FRAME_PATH);
		return modelAndView;
	}
	
	@RequestMapping("getBlank.sys")
	public ModelAndView getBlank(HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return null;
	}
	
	/*------------------------------비회원로그인 시작----------------------------------*/
	/**
	 * 신규자재제안 비회원로그인 체크
	 * @param bussName
	 * @param businessNum
	 * @param guestPassword
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("guestCheckPop.sys")
	public ModelAndView guestCheckPop(
			@RequestParam(value = "bussName", required = true) String bussName,
			@RequestParam(value = "businessNum", required = true) String businessNum,
			@RequestParam(value = "userNm", required = true) String userNm,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("bussName", bussName);
		searchMap.put("businessNum", businessNum);
		String userId = commonSvc.getGuestUserIdByLoginId("xxxxxxxxxx");
		searchMap.put("userId", userId);
		searchMap.put("remoteIp", request.getRemoteAddr());
		searchMap.put("userNm", userNm);
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			int businessNumCnt = commonDao.selectBusinessCnt(searchMap);
			if(businessNumCnt>0) {
				custResponse.setSuccess(false);
				custResponse.setMessage("이미 가입된 업체 입니다.<br/>회원로그인을 이용해주세요.");
			} else {
				int noneBusinessCnt = commonDao.selectNoneBusinessCnt(searchMap);	//비회원 사업자등록번호 개수
				if(noneBusinessCnt>0) {
					int checkNmCnt = commonDao.selectNoneBusinessNumNameCnt(searchMap);
					if(checkNmCnt==0) {
						custResponse.setSuccess(false);
						custResponse.setMessage("사업자명과 사업자번호가 맞지 않습니다.<br/>다시 입력해 주십시오");
					} else {
						custResponse.setNewIdx(1);	//기존 비회원고객
					}
				} else {
					custResponse.setNewIdx(0);	//신규 비회원고객
				}
			}
//			String nonUserId = commonSvc.saveGuestUser(searchMap);
//			custResponse.setNewIdx(nonUserId);	//비회원 로그인ID
		} catch(SystemUserLoginException se) {
			logger.error("Exception : "+se);
			
		} catch(Exception e){
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("비회원 로그인중 에러가 발생하였습니다.\n관리자에게 문의해주세요.");			
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	@RequestMapping("guestRegist.sys")
	public ModelAndView guestRegist(
			@RequestParam(value = "bussName", required = true) String bussName,
			@RequestParam(value = "businessNum", required = true) String businessNum,
			@RequestParam(value = "guestPassword", required = true) String guestPassword,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		CustomResponse custResponse = new CustomResponse(true);
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("bussName", bussName);
		saveMap.put("businessNum", businessNum);
		saveMap.put("guestPassword", guestPassword);
		saveMap.put("userNm", bussName);
		String nonUserId = commonSvc.saveGuestResist(saveMap);
		custResponse.setNewIdx(nonUserId);	//비회원 로그인ID
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	@RequestMapping("guestConfirm.sys")
	public ModelAndView guestConfirm(
			@RequestParam(value = "businessNum", required = true) String businessNum,
			@RequestParam(value = "guestPassword", required = true) String guestPassword,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		CustomResponse custResponse = new CustomResponse(true);
		ModelMap paramMap = new ModelMap();
		paramMap.put("businessNum", businessNum);
		paramMap.put("guestPassword", guestPassword);
		String nonUserId = (String) generalDao.selectGernalObject("common.etc.selectGuestNoneUserId",paramMap);
		if(nonUserId==null || "".equals(nonUserId)) {
			custResponse.setSuccess(false);
		} else {
			custResponse.setNewIdx(nonUserId);
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	@RequestMapping("guestLogin.sys")
	public ModelAndView guestLogin(
			@RequestParam(value = "nonUserId", required = true) String nonUserId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		NonUsersDto nonUserDto = commonSvc.getNonUserInfo(nonUserId);
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("userId", nonUserDto.getUserId());
		searchMap.put("belongBorgId", nonUserDto.getBorgId());
		searchMap.put("svcTypeCd", "VEN");
		LoginUserDto loginUserDto = commonSvc.getLoginUserInfo(searchMap);
		loginUserDto.setBorgNm(nonUserDto.getBusinessNum());
		loginUserDto.setBorgNms(nonUserDto.getUserNm());
		loginUserDto.setGuest(true);
		loginUserDto.setNonUserId(nonUserId);
		loginUserDto.setNonUsersDto(nonUserDto);
		String clientIp = request.getHeader("Proxy-Client-IP");
		if(clientIp == null) {
			clientIp = request.getHeader("WL-Proxy-Client-IP");
			if(clientIp == null) {
				clientIp = request.getHeader("X-Forwarded-For");
				if(clientIp == null) clientIp = request.getRemoteAddr();
			}
		}
		loginUserDto.setRemoteIp(clientIp);
		loginUserDto.setLastLoginDate(CommonUtils.getCurrentDateTime());
		CommonUtils.setLoginInUserSession(request, Constances.SESSION_NAME, loginUserDto);
		CommonUtils.setLoginInUserSession(request, "cate", productSvc.getSideCateList(loginUserDto.getBorgId()));
		
		searchMap.put("nonUserId", nonUserId);
		searchMap.put("remoteIp", clientIp);
		commonDao.updateGuestUser(searchMap);
		
		modelAndView.setViewName(Constances.SYSTEM_TREE_FRAME_PATH);	//이부분 비회원 Default 화면경로
		return modelAndView;
	}
	/*------------------------------비회원로그인 끝----------------------------------*/
	
	
	/**
	 * 계약서 등록처리
	 * @param svcTypeCd
	 * @param businessNum
	 * @param contract_userNm
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
//	팀장님 물품공급계약서 작업
//	@RequestMapping("contractRegist.sys")
//	public ModelAndView contractRegist(
//			@RequestParam(value = "svcTypeCd", required = true) String svcTypeCd,
//			@RequestParam(value = "businessNum", required = true) String businessNum,
//			@RequestParam(value = "contract_userNm", required = true) String contract_userNm,
//			@RequestParam(value = "contract_version", required = true) String contract_version,
//			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
//		
//		Map<String, Object> saveMap = new HashMap<String, Object>();
//		saveMap.put("svcTypeCd", svcTypeCd);
//		saveMap.put("businessNum", businessNum);
//		saveMap.put("contract_userNm", contract_userNm);
//		saveMap.put("contract_version", contract_version);
//
//		/*----------------처리수행 및 성공여부 세팅------------*/
//		CustomResponse custResponse = commonSvc.saveContractRegist(saveMap);
//		
//		modelAndView.setViewName("jsonView");
//		modelAndView.addObject(custResponse);
//		return modelAndView;
//	}
}
