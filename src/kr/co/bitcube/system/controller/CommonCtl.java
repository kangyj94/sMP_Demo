package kr.co.bitcube.system.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.board.dto.BoardDto;
import kr.co.bitcube.board.service.BoardSvc;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginRoleDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.DefaultSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.evaluate.controller.EvaluateCtl;
import kr.co.bitcube.evaluate.service.EvaluateSvc;
import kr.co.bitcube.evaluation.controller.EvaluationCtl;
import kr.co.bitcube.product.service.ProductSvc;
import kr.co.bitcube.system.service.BorgSvc;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("system")
public class CommonCtl {

	@Autowired
	private BorgSvc borgSvc;
	@Autowired
	private BoardSvc boardSvc;
	@Autowired
	private DefaultSvc defaultSvc;
	@Autowired
	private EvaluateCtl evaluateCtl;
	@Autowired
	private EvaluationCtl evaluationCtl;
	@Autowired
	private ProductSvc productSvc;
	@Autowired
	private EvaluateSvc evaluateSvc;
	@Autowired
	private GeneralDao generalDao;
	
	@RequestMapping("topMenu.sys")
	public ModelAndView topMenu(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("system/topMenu");
		return modelAndView;
	}
	@RequestMapping("treeFrame/header.sys")
	public ModelAndView treeFrameHeader(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("system/treeFrame/header");
		return modelAndView;
	}
	@RequestMapping("treeFrame/left.sys")
	public ModelAndView treeFrameLeft(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		if(!"ADM".equals(userInfoDto.getSvcTypeCd())){
			modelAndView.addObject("CONTRACT_FLAG", borgSvc.getContractSignature(userInfoDto));
			//물품공급 계약이 되지 않은 업체는 레프트 메뉴 안보이게 처리
			modelAndView.setViewName("system/treeFrame/left");
		}else{
			modelAndView.setViewName("system/treeFrame/left");
		}
		return modelAndView;
	}
	
	private boolean systemDefaultAdmIsSpecial(LoginUserDto userInfoDto) throws Exception{
		List<LoginRoleDto> roleList = userInfoDto.getLoginRoleList();
		LoginRoleDto       role     = null;
		String             roleCd   = null;
		int                i        = 0;
		int                roleSize = 0;
		boolean            result   = false;
		
		if(roleList != null){
			roleSize = roleList.size();
		}
		
		for(i = 0; i < roleSize; i++){
			role   = roleList.get(i);
			roleCd = role.getRoleCd();
			
			if(
				Constances.ETC_SPECIAL_SKB.equals(roleCd) ||
				Constances.ETC_SPECIAL_SKT.equals(roleCd) ||
				Constances.ETC_SPECIAL_CON.equals(roleCd)
			){
				if(Constances.ETC_SPECIAL_SKB.equals(roleCd)) userInfoDto.setSKBMng(true);
				if(Constances.ETC_SPECIAL_SKT.equals(roleCd)) userInfoDto.setSKTMng(true);
				result = true;
				break;
			}
		}
		
		return result;
	}
	
	/**
	 * 관리자 
	 * 
	 * @param modelAndView
	 * @return ModelAndView
	 * @throws Exception
	 */
	private ModelAndView systemDefaultAdm(HttpServletRequest request) throws Exception{
		ModelAndView              modelAndView       = new ModelAndView();
		String                    veiwName           = null;
		LoginUserDto              userInfoDto        = CommonUtils.getLoginUserDto(request); // 로그인 사용자 정보 조회
		List<BoardDto>            noticeList         = this.defaultSvc.systemDefaultNoticeList(userInfoDto, false, 4); // 공지사항 리스트 조회
		List<Map<String, String>> batchList          = null;
		List<Map<String, String>> productRequestList = null;
		Map<String, String>       sideCount          = null;
		Map<String, String>       vocCount           = null;
		Map<String, String>       smilePoint         = null;
		boolean                   isSpecial          = this.systemDefaultAdmIsSpecial(userInfoDto); // 매니저 여부
		
		if(isSpecial){
			veiwName = "system/managerManagement";
		}
		else{
			batchList          = this.defaultSvc.selectAdmBatchList(); // 배치 정보 조회
			sideCount          = this.defaultSvc.selectAmdSideCount(); // 사이드 카운트 정보 조회
			vocCount           = this.defaultSvc.selectAdmVocInfo(userInfoDto); // voc 정보 조회
			smilePoint         = this.defaultSvc.selectAdmSmilePointInfo(); // 스마일 지수 정보 조회
			productRequestList = this.defaultSvc.selectAdmProductRequestList(); // 신규상품 리스트 조회
			veiwName           = "system/systemManagement";
			
			modelAndView.addObject("batchList",          batchList);
			modelAndView.addObject("sideCount",          sideCount);
			modelAndView.addObject("vocCount",           vocCount);
			modelAndView.addObject("smilePoint",         smilePoint);
			modelAndView.addObject("productRequestList", productRequestList);
		}
		
		modelAndView.addObject("noticeList", noticeList);
		modelAndView.setViewName(veiwName);
		
		return modelAndView;
	}
	
	/**
	 * 스마일 평가 지수 조사 관련
	 * 
	 * @param userInfoDto
	 * @param svcType
	 * @return Map
	 * @throws Exception
	 */
	private Map<String,Object> getSmileEvalInfo(LoginUserDto userInfoDto, String svcType) throws Exception{
		ModelMap           params        = new ModelMap();
		Map<String,Object> smileEvalInfo = null;
		
		params.put("userInfoDto",    userInfoDto );
		params.put("EVAL_SVCTYPECD", svcType );
		
		smileEvalInfo =  this.evaluateSvc.getSmileEvalInfo(params);
		
		return smileEvalInfo;
	}
	
	/**
	 * 고객사
	 * 
	 * @param modelAndView
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private ModelAndView systemDefaultBuy(HttpServletRequest request, ModelMap paramMap) throws Exception{
		ModelAndView              modelAndView        = new ModelAndView();
		LoginUserDto              userInfoDto         = CommonUtils.getLoginUserDto(request); // 로그인 사용자 정보 조회
		String                    loginId             = userInfoDto.getLoginId();
		String                    borgId              = userInfoDto.getBorgId();
		List<Map<String, Object>> cate                = null;
		List<BoardDto>            noticeList          = null;
		List<BoardDto>            emergencyList       = null;
		List<Object>              mainDisplayList     = null;
		List<Object>              mainInvoiceList     = null;
		Map<String, Object>       mainExpireSettleMap = null;
		Map<String, Object>       mainOverExpireSettleMap = null;
		Map<String, Object>       mainNoneSettleMap   = null;
		Map<String, Object>	      smileEvalInfo       = null;
		Map<String, String>       managerUserInfo     = null;
		ModelMap                  daoParam            = new ModelMap();
		boolean                   isEvaluate          = userInfoDto.isEvaluate();
		
		if(isEvaluate && Constances.ETC_ISEVALUATION) {
			cate = this.productSvc.getSideCateList(borgId);
			
			userInfoDto.setEvaluate(false);
			CommonUtils.setLoginInUserSession(request, Constances.SESSION_NAME, userInfoDto);
			CommonUtils.setLoginInUserSession(request, "cate",                  cate);
			
			modelAndView = this.evaluateCtl.buyEvaluate(request, modelAndView);
		}
		else if("XXXXXXXXXX".equals(loginId)){	// 임시로 만든 비회원 유저의 loginId
			cate = this.productSvc.getSideCateList(borgId);
			
			CommonUtils.setLoginInUserSession(request, Constances.SESSION_NAME, userInfoDto);
			CommonUtils.setLoginInUserSession(request, "cate",                  cate);
			
			modelAndView = this.evaluationCtl.evaluateAppllication(request, paramMap, modelAndView);
		}
		else{
			daoParam.put("branchId", borgId);
			
			managerUserInfo     = (Map<String, String>)this.generalDao.selectGernalObject("common.default.selectManagerUserInfo", daoParam);
			noticeList          = this.defaultSvc.systemDefaultNoticeList(userInfoDto, false, 7); // 공지사항 리스트 조회
			emergencyList       = this.defaultSvc.systemDefaultNoticeList(userInfoDto, true,  9); // 긴급 공지사항 리스트 조회
			mainDisplayList     = this.generalDao.selectGernalList("common.default.selectMainDisplay", paramMap);	//메인전시 상품
			mainInvoiceList     = this.generalDao.selectGernalList("common.default.selectMainInvoice", paramMap);	//메인 세금계산서
			mainNoneSettleMap   = (Map<String, Object>) this.generalDao.selectGernalObject("common.default.selectMainNoneSettle",   paramMap);	//메인 미결제대금
			mainExpireSettleMap = (Map<String, Object>) this.generalDao.selectGernalObject("common.default.selectMainExpireSettle", paramMap);	//메인 최근만기도래금
			mainOverExpireSettleMap = (Map<String, Object>) this.generalDao.selectGernalObject("common.default.selectMainOverExpireSettle", paramMap);	//메인 최근만기도래금
			smileEvalInfo       =  this.getSmileEvalInfo(userInfoDto, "BUY"); // 스마일 평가 지수 조사 관련 
			
			modelAndView.addObject("noticeList",          noticeList);
			modelAndView.addObject("emergencyList",       emergencyList);
			modelAndView.addObject("smileEvalInfo",       smileEvalInfo);
			modelAndView.addObject("mainDisplayList",     mainDisplayList);
			modelAndView.addObject("mainInvoiceList",     mainInvoiceList);
			modelAndView.addObject("mainNoneSettleMap",   mainNoneSettleMap);
			modelAndView.addObject("mainExpireSettleMap", mainExpireSettleMap);
			modelAndView.addObject("mainOverExpireSettleMap", mainOverExpireSettleMap);
			modelAndView.addObject("managerUserInfo",     managerUserInfo);
			modelAndView.setViewName("system/buyDefault");
		}
		
		return modelAndView;
	}
	
	/**
	 * 공급사
	 * 
	 * @param request
	 * @return ModelAndView
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	private ModelAndView systemDefaultVen(HttpServletRequest request) throws Exception{
		ModelAndView              modelAndView       = new ModelAndView();
		LoginUserDto              userInfoDto        = CommonUtils.getLoginUserDto(request); // 로그인 사용자 정보 조회
		List<Map<String, Object>> cate               = null;
		List<BoardDto>            noticeList         = null;
		List<BoardDto>            emergencyList      = null;
		List<Map<String, String>> taxList            = null;
		List<Object>              branchBestList     = null;
		List<Object>              goodBestList       = null;
		String                    borgId             = userInfoDto.getBorgId();
		Map<String, Object>	      smileEvalInfo      = null;
		Map<String, String>       supplyInfo         = null;
		Map<String, String>       smileInfo          = null;
		Map<String, String>       venManagerUserInfo = null;
		Map<String, String>       productList        = null;
		ModelMap                  paramMap           = new ModelMap();
		boolean                   isEvaluate         = userInfoDto.isEvaluate();
		
		if(isEvaluate && Constances.ETC_ISEVALUATION) {
			cate = this.productSvc.getSideCateList(borgId);
			
			userInfoDto.setEvaluate(false);
			CommonUtils.setLoginInUserSession(request, Constances.SESSION_NAME, userInfoDto);
			CommonUtils.setLoginInUserSession(request, "cate",                  cate);
			
			modelAndView = evaluateCtl.buyEvaluate(request, modelAndView);
		}
		else {
			paramMap.put("borgId", borgId);
			
			noticeList         = this.defaultSvc.systemDefaultNoticeList(userInfoDto, false, 7); // 공지사항 리스트 조회
			emergencyList      = this.defaultSvc.systemDefaultNoticeList(userInfoDto, true,  9); // 긴급 공지사항 리스트 조회
			productList        = this.defaultSvc.selectVenDefaultProductList(borgId); // 상품 현황 리스트 조회
			supplyInfo         = this.defaultSvc.selectVenDefaultSupplyList(borgId); // 공급 현황 리스트 조회
			taxList            = this.defaultSvc.selectVenDefaultTexList(borgId); // 세금계산서 리스트 조회
			smileInfo          = this.defaultSvc.selectVenDefaultSmileInfo(borgId); // 스마일 지수
			smileEvalInfo      = this.getSmileEvalInfo(userInfoDto, "VEN"); // 스마일 평가 지수 조사 관련
			branchBestList     = this.generalDao.selectGernalList("common.default.selectVendorBranchBestList", paramMap); // 구매사 현황 베스트
			goodBestList       = this.generalDao.selectGernalList("common.default.selectVendorGoodBestList",   paramMap); // 상품별 현황 베스트
			venManagerUserInfo = (Map<String, String>)this.generalDao.selectGernalObject("common.default.selectVenManagerUserInfo", paramMap);
			
			modelAndView.addObject("noticeList",         noticeList);
			modelAndView.addObject("productList",        productList);
			modelAndView.addObject("emergencyList",      emergencyList);
			modelAndView.addObject("smileEvalInfo",      smileEvalInfo);
			modelAndView.addObject("branchBestList",     branchBestList);
			modelAndView.addObject("goodBestList",       goodBestList);
			modelAndView.addObject("supplyInfo",         supplyInfo);
			modelAndView.addObject("taxList",            taxList);
			modelAndView.addObject("smileInfo",          smileInfo);
			modelAndView.addObject("venManagerUserInfo", venManagerUserInfo);
			modelAndView.setViewName("system/venDefault");
		}
		
		return modelAndView;
	}
	
	/**
	 * 로그인 사용자 타입에 따른 기본 화면으로 이동하는 메소드
	 * 
	 * @param managementFlag
	 * @param request
	 * @param modelAndView
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping("systemDefault.sys")
	public ModelAndView systemDefault(HttpServletRequest request, ModelMap paramMap) throws Exception {
		LoginUserDto   userInfoDto  = CommonUtils.getLoginUserDto(request); // 로그인 사용자 정보 조회
		String         svcTypeCd    = userInfoDto.getSvcTypeCd();
		ModelAndView   modelAndView = null;
		List<BoardDto> list         = (List<BoardDto>) this.boardSvc.selectNoticePopBoardNoList(svcTypeCd, userInfoDto);
		
		if("ADM".equals(svcTypeCd)) { // 관리자
			modelAndView = this.systemDefaultAdm(request); 
		}
		else if("BUY".equals(svcTypeCd)) { // 고객사
			modelAndView = this.systemDefaultBuy(request, paramMap);
		}
		else if("VEN".equals(svcTypeCd)) { // 공급사
			modelAndView = this.systemDefaultVen(request);
		}
		else if("CEN".equals(svcTypeCd)){ // 물류센터
			modelAndView = new ModelAndView();
			
			modelAndView.setViewName("system/centerDefault");
		}
		
		modelAndView.addObject("popup_list", list);
		
		return modelAndView;
	}
	
	@RequestMapping("systemHome.sys")
	public ModelAndView systemHome(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName(Constances.SYSTEM_TREE_FRAME_PATH);	//트리형 메뉴
		return modelAndView;
	}
	
	@RequestMapping("systemManager.sys")
	public ModelAndView systemManager(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("svcTypeCd", "ADM");
		searchMap.put("borgTypeCd", "BCH");
		searchMap.put("isUse", "1");
		modelAndView.setViewName("system/borg/systemManagerList");
		modelAndView.addObject("adminBorgList", borgSvc.getBorgTreeList(searchMap));
		return modelAndView;
	}
	
	@RequestMapping("manual.sys")
	public ModelAndView manual(
			@RequestParam(value="header", required=true)String header,
			@RequestParam(value="manualPath", required=true)String manualPath,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("header", header);
		modelAndView.addObject("manualPath", manualPath);
		modelAndView.setViewName("common/manual");
		return modelAndView;
	}
	
	@RequestMapping("managerManagementIframe.sys")
	public ModelAndView managerManagementIframe(HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		LoginUserDto        userInfoDto   = CommonUtils.getLoginUserDto(request); // 로그인 사용자 정보 조회
		List<BoardDto>      noticeList    = this.defaultSvc.systemDefaultNoticeList(userInfoDto, false, 4); // 공지사항 리스트 조회
		List<BoardDto>      emergencyList = this.defaultSvc.systemDefaultNoticeList(userInfoDto, true,  9); // 긴급 공지사항 리스트 조회
		Map<String, String> bondInfo      = this.defaultSvc.selectManagerBondInfo(userInfoDto); // 채권 정보 조회
		
		modelAndView.addObject("noticeList",    noticeList);
		modelAndView.addObject("emergencyList", emergencyList);
		modelAndView.addObject("bondInfo",      bondInfo);
		modelAndView.setViewName("system/managerManagementIframe");
		
		return modelAndView;
	}		
}