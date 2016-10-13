package kr.co.bitcube.common;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.bitcube.common.dao.CommonDao;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.ActivitiesDto;
import kr.co.bitcube.common.dto.LoginRoleDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.RequestUtils;
import kr.co.bitcube.system.exception.SystemUserLoginException;

import org.apache.log4j.Logger;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Aspect
public class ControllerAspect {
	@Autowired                         private CommonSvc        commonSvc;
	@Autowired                         private CommonDao        commonDao;
	@Autowired                         private GeneralDao       generalDao;
	@Resource(name="seqMenuAccessLog") private EgovIdGnrService seqMenuAccessLog;
	                                   private Logger           logger = Logger.getLogger(getClass());
	                                   
	/**
	 * 호출 메소드의 HttpServletRequest 파라미터를 반환하는 메소드
	 * 
	 * @param args
	 * @return HttpServletRequest
	 * @throws Exception
	 */
	private HttpServletRequest getHttpServletRequest(Object[] args) throws Exception{
		HttpServletRequest result = null;
		int                i      = 0;
		
		for(i = 0; i < args.length; i++) {
			Object obj = args[i];
			
			if(obj instanceof HttpServletRequest){
				result = (HttpServletRequest)obj;
			}
			else if(obj instanceof MultipartHttpServletRequest){
				result = (MultipartHttpServletRequest)obj;
			}
		}
		
		if(result != null){
			RequestUtils.debugRequestParameter(result);
		}
		
		return result;
	}
	
	/**
	 * 호출 메소드의 modelMap 파라미터에 로그인 사용자 정보를 추가하는 메소드
	 * @param args
	 * @param request
	 * @param userInfoDto
	 * @return Object[]
	 * @throws Exception
	 */
	private Object[] setUserInfoDtoToModelMap(Object[] args, HttpServletRequest request) throws Exception{
		Object       obj         = null;
		LoginUserDto userInfoDto = this.getLoginUserDto(request);
		int          i           = 0;
		int          argsLength  = args.length;
		
		for(i = 0; i < argsLength; i++) {
			obj = args[i];
			
			if(obj instanceof ModelMap) {
				ModelMap paramMap = RequestUtils.bind(request, null);
				
				paramMap.put("userInfoDto", userInfoDto);
				
				args[i] = paramMap;
			}
		}
		
		return args;
	}
	
	/**
	 * _menuId의 값이 없고, _menuCd의 값이 있을 경우 _menuCd의 값으로 _menuId의 값을 조회하여 세팅하는 메소드
	 * 
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	private String getMenuId(HttpServletRequest request) throws Exception{
		String menuId = request.getParameter("_menuId");
		String menuCd = request.getParameter("_menuCd");
		
		if((menuId == null) && (menuCd != null)){	
			menuId = this.commonDao.selectMenuIdForMenuCd(menuCd);
			
			request.setAttribute("_menuId", menuId);
		}
		
		menuId = CommonUtils.nvl(menuId);
		
		return menuId;
	}
	
	/**
	 * request에 사용자 화면권한 리스트를 셋팅하고 메뉴 아이디에 해당하는 메뉴명을 반환하는 메소드
	 * 
	 * @param request
	 * @param userInfoDto
	 * @param menuId
	 * @return String
	 * @throws Exception
	 */
	private String setUseActivityList(HttpServletRequest request, LoginUserDto userInfoDto, String menuId) throws Exception{
		List<LoginRoleDto>  roleList            = userInfoDto.getLoginRoleList();
		List<ActivitiesDto> useActivityList     = this.commonSvc.getUseActivityList(menuId, roleList);
		String              menuNm              = "";
		ActivitiesDto       activitiesDto       = null;
		int                 useActivityListSize = 0;
		
		if(useActivityList != null){
			useActivityListSize = useActivityList.size();
		}
		
		if(useActivityListSize > 0) {	//menuId가 0이거나 없을 경우 예외처리
			activitiesDto = useActivityList.get(0);
			menuNm        = activitiesDto.getMenuNm();
			
			if(request != null) {
				request.setAttribute("useActivityList", useActivityList);
			}
		}
		
		return menuNm;
	}
	
	/**
	 * 메뉴 접근 로그 생성
	 * 
	 * @param userInfoDto
	 * @param menuId
	 * @param menuNm
	 * @throws Exception
	 */
	private void insertMenuAccessLog(HttpServletRequest request) throws Exception{
		Map<String, Object> accessMap   = new HashMap<String, Object>();
		String              logId       = null;
		String              menuId      = this.getMenuId(request); // 메뉴 아이디 조회
		String              menuNm      = null;
		LoginUserDto        userInfoDto = this.getLoginUserDto(request);
		
		if("".equals(menuId) == false){
			menuNm = this.setUseActivityList(request, userInfoDto, menuId); // 메뉴이동시 화면권한셋팅 후 메뉴명 반환
			
			try {
				logId = this.seqMenuAccessLog.getNextStringId();
				
				accessMap.put("logId",       logId);
				accessMap.put("userInfoDto", userInfoDto);
				accessMap.put("menuId",      menuId);
				accessMap.put("menuNm",      menuNm);
				
				this.commonDao.insertMenuAccessLog(accessMap);
			}
			catch(Exception e) {
				this.logger.error("Menu Access Log Insert Error : " + e);
			}
		}
	}
	
	/**
	 * 고객사 화면에 공통으로 필요한 정보를 셋팅하는 메소드
	 * 
	 * @param request
	 * @param userInfoDto
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private void setBuyCommonInfo(HttpServletRequest request) throws Exception{
		ModelMap            daoParam        = new ModelMap();
		LoginUserDto        userInfoDto     = this.getLoginUserDto(request);
		String              borgId          = userInfoDto.getBorgId();
		String              userId          = userInfoDto.getUserId();
		String              svcTypeCd       = userInfoDto.getSvcTypeCd();
		String              areaType        = userInfoDto.getAreaType();
		String              workId          = userInfoDto.getWorkId();
		String              cartCountString = null;
		String              headerStep01    = null;
		String              headerStep02    = null;
		String              headerStep03    = null;
		String              headerStep05    = null;
		String              quick04         = null;
		String              quick05         = null;
		Map<String, String> headerStepMap   = null;
		Map<String, String> quickInfo       = null;
		int                 cartCount       = 0;
		
		if("BUY".equals(svcTypeCd)) {
			daoParam.put("branchid", borgId);
			daoParam.put("userid",   userId);
			daoParam.put("areaType", areaType);
			daoParam.put("workId",   workId);
			
			cartCount       = (Integer)this.generalDao.selectGernalObject("order.cart.selectCartCount", daoParam);
			cartCountString = Integer.toString(cartCount);
			
			quickInfo = (Map<String, String>)this.generalDao.selectGernalObject("common.default.selectBuyQuickList", daoParam);
			quick04   = quickInfo.get("quick04");
			quick05   = quickInfo.get("quick05");
			
			daoParam.clear();
			daoParam.put("borgId", borgId);
			daoParam.put("userId", userId);
			
//			logger.debug("jameskang menuId : "+getMenuId(request));
//			logger.debug("jameskang getPathTranslated : "+request.getPathTranslated() + ", getMethod : "+request.getMethod()+", getPathInfo : "+request.getPathInfo()+", getServletPath : "+request.getServletPath());
			
//			if("0".equals(getMenuId(request))) {	//메인만 Display
			if("/system/systemDefault.sys".equals(request.getServletPath())) {
				headerStepMap = (Map<String, String>)this.generalDao.selectGernalObject("common.default.selectClientHeaderInfo", daoParam);
				headerStep01  = headerStepMap.get("headerStep01");
				headerStep02  = headerStepMap.get("headerStep02");
				headerStep03  = headerStepMap.get("headerStep03");
				headerStep05  = headerStepMap.get("headerStep05");
			}
			
			request.setAttribute("headerStep01", headerStep01); // 주문
			request.setAttribute("headerStep02", headerStep02); // 배송준비
			request.setAttribute("headerStep03", headerStep03); // 배송
			request.setAttribute("headerStep04", headerStep03); // 물품인수대기
			request.setAttribute("headerStep05", headerStep05); // 정산대기
			request.setAttribute("cartCount",    cartCountString); // 장바구니 카운트
			request.setAttribute("quick04",    quick04); 		// 주문 취소 미승인건
			request.setAttribute("quick05",    quick05); 		// 반품 요청 미승인건
		}
	}
	
	/**
	 * 공급사 접수 대기 카운트 조회
	 * 
	 * @param borgId
	 * @return String
	 * @throws Exception
	 */
	private String setVenCommonInfoHeaderStep01(String borgId) throws Exception{
		String   result        = null;
		ModelMap param         = new ModelMap();
		Integer  resultInteger = null;
		
		param.put("startDate",    CommonUtils.getCustomDay("MONTH", -1));
		param.put("endDate",      CommonUtils.getCurrentDate());
		param.put("purcStatFlag", "40");
		param.put("orderNumber",  "");
		param.put("borgId",       borgId);
		
		resultInteger = (Integer)this.generalDao.selectGernalObject("order.purchase.selectVenOrderPurchaseCnt", param);
		result        = Integer.toString(resultInteger);
		result        = CommonUtils.getDecimalAmount(result);
		
		return result;
	}
	
	/**
	 * 공급사 출하 대기 카운트 조회
	 * 
	 * @param borgId
	 * @return String
	 * @throws Exception
	 */
	private String setVenCommonInfoHeaderStep02(String borgId) throws Exception{
		String   result        = null;
		ModelMap param         = new ModelMap();
		Integer  resultInteger = null;
		
		param.put("srcVendorId",      borgId);
		param.put("srcPurcStartDate", CommonUtils.getCustomDay("MONTH", -2));
		param.put("srcPurcEndDate",   CommonUtils.getCurrentDate());
		
		resultInteger = (Integer)this.generalDao.selectGernalObject("order.orderRequest.selectVenHeaderDeliCnt", param);
		result        = Integer.toString(resultInteger);
		result        = CommonUtils.getDecimalAmount(result);
		
		return result;
	}
	
	/**
	 * 공급사 인수 대기 카운트 조회
	 * 
	 * @param borgId
	 * @return String
	 * @throws Exception
	 */
	private String setVenCommonInfoHeaderStep04(String borgId) throws Exception{
		String   result        = null;
		ModelMap param         = new ModelMap();
		Integer  resultInteger = null;
		
		param.put("srcOrderStartDate", CommonUtils.getCustomDay("DAY", -7));
		param.put("srcOrderEndDate",   CommonUtils.getCurrentDate());
		param.put("srcVendorId",       borgId);
		
		resultInteger = (Integer)this.generalDao.selectGernalObject("order.orderRequest.selectVenHeaderReceCnt", param);
		result        = Integer.toString(resultInteger);
		result        = CommonUtils.getDecimalAmount(result);
		
		return result;
	}
	
	/**
	 * 공급사 정산 대기 카운트 조회
	 * 
	 * @param borgId
	 * @return String
	 * @throws Exception
	 */
	private String setVenCommonInfoHeaderStep05(String borgId) throws Exception{
		String   result        = null;
		ModelMap param         = new ModelMap();
		Integer  resultInteger = null;
		
		param.put("srcOrdeIdenNumb",   "");
		param.put("srcGoodName",       "");
		param.put("srcGoodIdenNumb",   "");
		param.put("srcIsBill",         "0");
		param.put("srcOrdeStat",       "");
		param.put("srcOrderDateFlag",  "");
		param.put("srcOrderStartDate", CommonUtils.getCustomDay("MONTH", -2));
		param.put("srcOrderEndDate",   CommonUtils.getCurrentDate());
		param.put("srcVendorId",       borgId);
		
		resultInteger = (Integer)this.generalDao.selectGernalObject("order.orderRequest.selectVenReceInfoCnt", param);
		result        = Integer.toString(resultInteger);
		result        = CommonUtils.getDecimalAmount(result);
		
		return result;
	}
	
	/**
	 * 공급사 화면에 공통으로 필요한 정보를 셋팅하는 메소드
	 * 
	 * @param request
	 * @param userInfoDto
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private void setVenCommonInfo(HttpServletRequest request) throws Exception{
		LoginUserDto        userInfoDto       = this.getLoginUserDto(request);
		String              svcTypeCd         = userInfoDto.getSvcTypeCd();
		String              borgId            = userInfoDto.getBorgId();
		String              userId            = userInfoDto.getUserId();
		String              headerStep01      = null;
		String              headerStep02      = null;
		String              headerStep04      = null;
		String              headerStep05      = null;
		String              quick01           = null;
		String              quick02           = null;
		String              quick03           = null;
		String              quick04           = null;
		String              quick05           = null;
		String              srcOrderStartDate = CommonUtils.getCustomDay("MONTH", -2);
		String              srcOrderEndDate   = CommonUtils.getCurrentDate();
		Map<String, String> quickInfo         = null;
		ModelMap            daoParam          = new ModelMap();
		int                 quick05Int        = 0;
		
		if("VEN".equals(svcTypeCd)) {
			
//			logger.debug("jameskang menuId : "+getMenuId(request));
//			logger.debug("jameskang getPathTranslated : "+request.getPathTranslated() + ", getMethod : "+request.getMethod()+", getPathInfo : "+request.getPathInfo()+", getServletPath : "+request.getServletPath());
			
//			if("0".equals(getMenuId(request))) {	//메인만 Display
			if("/system/systemDefault.sys".equals(request.getServletPath())) {
				headerStep01 = this.setVenCommonInfoHeaderStep01(borgId); // 공급사 접수 대기 카운트 조회
				headerStep02 = this.setVenCommonInfoHeaderStep02(borgId); // 공급사 출하 대기 카운트 조회
				headerStep04 = this.setVenCommonInfoHeaderStep04(borgId); // 공급사 인수 대기 카운트 조회
				headerStep05 = this.setVenCommonInfoHeaderStep05(borgId); // 공급사 정산 대기 카운트 조회
			}
			
			daoParam.put("borgId", borgId);
			daoParam.put("userId", userId);
			
//			quickInfo = (Map<String, String>)this.generalDao.selectGernalObject("common.default.selectVendorQuickList", daoParam);
//			quick01   = quickInfo.get("quick01");
//			quick02   = quickInfo.get("quick02");
//			quick03   = quickInfo.get("quick03");
//			quick04   = quickInfo.get("quick04");
//			quick05   = quickInfo.get("quick05");
			
//			daoParam.clear();
//			daoParam.put("srcOrderStatusFlag", "59");
//			daoParam.put("srcOrderStartDate",  srcOrderStartDate);
//			daoParam.put("srcOrderEndDate",    srcOrderEndDate);
//			daoParam.put("srcVendorId",        borgId);
			
//			quick05Int = this.generalDao.selectGernalCount("order.orderRequest.selectVODListCnt", daoParam);
//			quick05    = Integer.toString(quick05Int);
			
			request.setAttribute("headerStep01", headerStep01);
			request.setAttribute("headerStep02", headerStep02);
			request.setAttribute("headerStep03", headerStep04);
			request.setAttribute("headerStep04", headerStep04);
			request.setAttribute("headerStep05", headerStep05); // 정산대기
			request.setAttribute("quick01",      quick01); // 반품요청
			request.setAttribute("quick02",      quick02); // 입찰
			request.setAttribute("quick03",      quick03); // 신규상품제안
			request.setAttribute("quick04",      quick04); // 재고입고
			request.setAttribute("quick05",      quick05); // 주문취소요청
		}
	}
	
	/**
	 * aspect 로그를 기록하는 메소드
	 * 
	 * @param joinPoint
	 * @throws Exception
	 */
	private void aspectLogInfo(ProceedingJoinPoint joinPoint) throws Exception{
		Object                  target       = joinPoint.getTarget();
		Class<? extends Object> targetClass  = target.getClass();
		Signature               targetMethod = joinPoint.getSignature();
		StringBuffer            stringBuffer = new StringBuffer();
		String                  className    = targetClass.getName();
		String                  methodName   = targetMethod.getName();
		String                  debug        = null;
		
		stringBuffer.append("============Class.Method Name : ");
		stringBuffer.append(className);
		stringBuffer.append(".");
		stringBuffer.append(methodName);
		stringBuffer.append("()=============");
		
		debug = stringBuffer.toString();
		
		logger.debug(debug);
	}
	
	/**
	 * 로그인 사용자 정보를 반환하는 메소드
	 * 
	 * @param request
	 * @return LoginUserDto
	 * @throws Exception
	 */
	private LoginUserDto getLoginUserDto(HttpServletRequest request) throws Exception{
		HttpSession  httpSession  = request.getSession();
		LoginUserDto userInfoDto  = (LoginUserDto)httpSession.getAttribute(Constances.SESSION_NAME);
		
		return userInfoDto;
	}
	
	/**
	 * 메뉴 이동 여부를 반환하는 메소드
	 * 
	 * @param returnObj
	 * @return boolean
	 * @throws Exception
	 */
	private boolean isMoveMenu(Object returnObj) throws Exception{
		ModelAndView model      = null;
		String       viewName   = null;
		boolean      isMoveMenu = false;
		
		if((returnObj != null) && (returnObj instanceof ModelAndView)){
			model    = (ModelAndView)returnObj;
			viewName = model.getViewName();
			
			if(("jsonView".equals(viewName) == false) && ("commonExcelViewResolver".equals(viewName) == false)){
				isMoveMenu = true;
			}
		}
		
		return isMoveMenu;
	}
	                            
	/**
	 * 컨트롤러 메소드 호출 전후 처리하는 메소드
	 * 
	 * @param joinPoint
	 * @return Object
	 * @throws Exception
	 * @throws Throwable
	 */
	@Around("execution(public * kr.co.bitcube.*.controller.*.*(..)) " + "&& bean(*Ctl)")
	public Object execute(ProceedingJoinPoint joinPoint) throws Exception, Throwable {
		Object             returnObj   = null;
		Object[]           args        = joinPoint.getArgs();		
		HttpServletRequest request     = this.getHttpServletRequest(args); // 리퀘스트 정보 반환
		LoginUserDto       userInfoDto = this.getLoginUserDto(request);
		boolean            isMoveMenu  = false;
		
		this.aspectLogInfo(joinPoint); // aspect log 기록
		
		if(userInfoDto == null){
			logger.error(" No Session Infomation Called...!"); 
			
			throw new SystemUserLoginException("Lose Your Infomation!..");
		}
		else{
			args       = this.setUserInfoDtoToModelMap(args, request); // 호출 메소드 modelmap 파라미터에 사용자 정보 셋팅
			returnObj  = joinPoint.proceed(args);
			isMoveMenu = this.isMoveMenu(returnObj); // 메뉴 이동 여부
			
			if(isMoveMenu){
				this.insertMenuAccessLog(request); // 메뉴이동시 화면권한 가져오면서 로그 생성
				
				if(request != null){
					this.setBuyCommonInfo(request); // 고객사 화면에 필요한 공통 정보 셋팅
					this.setVenCommonInfo(request); // 공급사 화면에 필요한 공통 정보 셋팅
				}
			} 
		}
		
		return returnObj;
	}
}