package kr.co.bitcube.buyController.controller;

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

import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;


@Controller
@RequestMapping("buyOrgan")
public class BuyOrganCtl {

	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private OrganSvc organSvc;
	
	@Autowired
	private CommonSvc commonSvc;	
	
	@Autowired
	private AdjustSvc adjustSvc;	
	@Autowired
	private GeneralDao generalDao;	
	
	/**사업장조회
	 * @author ParkJoon
	 */
	@RequestMapping("organBuyList.sys")
	public ModelAndView organBuyList( HttpServletRequest req, ModelAndView mav) throws Exception{
		Map<String, Object> params               = new HashMap<String, Object>();
		List<UserDto>       admUserList          = this.adjustSvc.getAdjustAlramUserList();
		List<WorkInfoDto>   workInfoList         = null;
		Boolean             isContractExcludeClt = false;
		LoginUserDto        userInfoDto          = CommonUtils.getLoginUserDto(req);
		String              borgId               = userInfoDto.getBorgId();
		
		params.put("orderString", " workNm asc");
		
		workInfoList         = this.commonSvc.selectWorkInfo(params);
		isContractExcludeClt = this.commonSvc.isContractExcludeClient(borgId); // 계약 제외 대상 법인 여부 조회
		
		mav.addObject("admUserList",          admUserList);
		mav.addObject("workInfoList",         workInfoList);
		mav.addObject("isContractExcludeClt", isContractExcludeClt);
		
		mav.setViewName("organ/organBuyList");
		return mav;
	}
	
	/**
	 * 사업장조회 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("organBuyListJQGrid.sys")
	public ModelAndView organBuyListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "a.branchId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,
			@RequestParam(value = "srcBranchGrad", defaultValue = "") String srcBranchGrad,
			@RequestParam(value = "srcAreaType", defaultValue = "") String srcAreaType,
			@RequestParam(value = "srcIsUse", defaultValue = "1") String srcIsUse,
			
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchGrad", srcBranchGrad);
		params.put("srcAreaType", srcAreaType);
		params.put("srcIsUse", srcIsUse);
		params.put("srcClientId", userInfoDto.getClientId());
		
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
	 * 사용자등록
	 */
	@RequestMapping("organUserRegBuy.sys")
	public ModelAndView organUserRegBuy( HttpServletRequest req, ModelAndView mav) throws Exception{
		
		LoginUserDto loginUserDto = (LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME);
		ModelMap params = new ModelMap();
		
		params.put("branchIsUse", "1") ;
		params.put("srcBorgTypeCd", "BCH") ;
		params.put("srcClientId", loginUserDto.getClientId() ) ;
		
		List<Object> branchList =  generalDao.selectGernalList("common.etc.selectBuyBorgDivList", params);
		mav.addObject("branchList" , branchList );
		mav.setViewName("organ/organUserRegBuy");
		return mav;
	}
	
	/**
	 * 사업장등록
	 */
	@RequestMapping("organBuyReg.sys")
	public ModelAndView organBuyReg( HttpServletRequest req, ModelAndView mav) throws Exception{
		//권역코드
		mav.addObject("areaCode", commonSvc.getCodeList("DELI_AREA_CODE", 1));
		//은행코드
		mav.addObject("bankCode", commonSvc.getCodeList("BANKCD", 1));
//		//회원사등급
//		mav.addObject("mGradeCode", commonSvc.getCodeList("MEMBERGRADE", 1));
		//결제조건
//		mav.addObject("payCondCode", commonSvc.getCodeList("PAYMCONDCODE", 1));
		
		//공사유형
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orderString", " workNm asc");
		mav.addObject("workInfoList", commonSvc.selectWorkInfo(params));
		//채권관리자
		mav.addObject("admUserList", adjustSvc.getAdjustAlramUserList());		
		
		mav.setViewName("organ/organBuyReg");
		return mav;

	}
	
	/**
	 * 사업장상세
	 */
	@RequestMapping("organBuyDetail.sys")
	public ModelAndView organBuyDetail( 
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
		
		modelAndView.setViewName("organ/organBuyDetail");
		return modelAndView;		
	}
	/**
	 * 사용자상세
	 */
	@RequestMapping("organUserDetailBuy.sys")
	public ModelAndView getorganUserDetailBuyl(
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
		mav.setViewName("organ/organUserDetailBuy");
		return mav;
	}
	/**사용자조회
	 * @author ParkJoon
	 */
	@RequestMapping("organBuyUserList.sys")
	public ModelAndView organBuyUserList( HttpServletRequest req, ModelAndView mav) throws Exception{
		Map<String, Object> params               = new HashMap<String, Object>();
		List<WorkInfoDto>   workInfoList         = null;
		Boolean             isContractExcludeClt = false;
		LoginUserDto        loginUserDto         = CommonUtils.getLoginUserDto(req);
		String              borgId               = loginUserDto.getBorgId();
		
		params.put("orderString", " workNm asc");
		
		workInfoList         = this.commonSvc.selectWorkInfo(params);
		isContractExcludeClt = this.commonSvc.isContractExcludeClient(borgId); // 계약 제외 대상 법인 여부 조회
		
		mav.addObject("workInfoList",         workInfoList);
		mav.addObject("isContractExcludeClt", isContractExcludeClt);
		mav.setViewName("organ/organBuyUserList");
		
		return mav;
	}
	
	/**
	 * 사용자조회 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("organBuyUserListJQGrid.sys")
	public ModelAndView organBuyUserListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "a.vendorId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,
			@RequestParam(value = "srcUserNm", defaultValue = "") String srcUserNm,
			@RequestParam(value = "srcLoginId", defaultValue = "") String srcLoginId,
			@RequestParam(value = "srcIsUse", defaultValue = "1") String srcIsUse,		
			@RequestParam(value = "srcIsDirect", defaultValue = "1") String srcIsDirect,		
			@RequestParam(value = "srcWorkId", defaultValue = "") String srcWorkId,		
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
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
	
}
