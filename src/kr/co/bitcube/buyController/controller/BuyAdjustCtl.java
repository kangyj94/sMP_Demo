package kr.co.bitcube.buyController.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.adjust.dto.AdjustDto;
import kr.co.bitcube.adjust.service.AdjustSvc;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.utils.Constances;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("BuyAdjust")
public class BuyAdjustCtl {
	
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private AdjustSvc adjustSvc;
	
	/**
	 * 고객사 채무관리 페이지
	 */
	@RequestMapping("adjustBuyBondsOccurrence.sys")
	public ModelAndView adjustBuyBondsOccurrence (
			HttpServletRequest request, ModelAndView mav) throws Exception{
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		mav.addObject("branchList"	, adjustSvc.selectBranchsByClientId(userInfoDto.getClientId()));
		mav.setViewName("adjust/adjustBuyBondsOccurrence");
		return mav;
	}
	
	/**
	 * 고객사 채무관리 페이지 JQGrid
	 */
	@RequestMapping("adjustBuyBondsCompanyListJQGrid.sys")
	public ModelAndView adjustBuyBondsCompanyListJQGrid (
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "clos_sale_date") String sidx,
			@RequestParam(value = "sord", defaultValue = "asc") String sord,			
			@RequestParam(value = "clientId", required=true) String clientId,			
			@RequestParam(value = "srcPayStat", defaultValue="") String srcPayStat,			
			@RequestParam(value = "srcTranStat", defaultValue="") String srcTranStat,			
			@RequestParam(value = "srcClosStartYear", defaultValue="") String srcClosStartYear,			
			@RequestParam(value = "srcClosStartMonth", defaultValue="") String srcClosStartMonth,			
			@RequestParam(value = "srcClosEndYear", defaultValue="") String srcClosEndYear,			
			@RequestParam(value = "srcClosEndMonth", defaultValue="") String srcClosEndMonth,			
			@RequestParam(value = "srcBranchId", defaultValue="") String srcBranchId,			
			@RequestParam(value = "srcTransferStatus", defaultValue="") String srcTransferStatus,			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		
		String preZero = "";
		
		params.put("clientId"			, clientId);
		params.put("srcPayStat"			, srcPayStat);
		params.put("srcTranStat"		, srcTranStat);
		params.put("srcBranchId"		, srcBranchId);
		params.put("srcTransferStatus", srcTransferStatus);

		if(srcClosStartMonth.length() == 1) preZero = "0";
		params.put("srcClosStartDate"	, srcClosStartYear + preZero + srcClosStartMonth);
		preZero = "";
		if(srcClosEndMonth.length() == 1) preZero = "0";
		params.put("srcClosEndDate"		, srcClosEndYear + preZero + srcClosEndMonth);

		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        /*----------------조회------------*/
        List<AdjustDto> list = adjustSvc.adjustBranchBondsCompanyList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	
}
