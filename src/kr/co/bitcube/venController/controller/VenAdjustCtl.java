package kr.co.bitcube.venController.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.sap.tc.logging.standard.Logger;

import kr.co.bitcube.adjust.dto.AdjustDto;
import kr.co.bitcube.adjust.service.AdjustSvc;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.ebill.dto.EbillDto;
import kr.co.bitcube.ebill.service.EbillSvc;

@Controller
@RequestMapping("venAdjust")
public class VenAdjustCtl {

	@Autowired
	private EbillSvc eBillSvc;
	
	@Autowired
	private AdjustSvc adjustSvc;

	@RequestMapping("ebillVenList.sys")
	public ModelAndView ebillVendorList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("ebill/ebillVenList");
	}
	
	/**
	 * 공급사 세금계산서 목록 
	 */
	@RequestMapping("ebillVenListJQGrid.sys")
	public ModelAndView ebillVenListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "SALE_SEQU_NUMB") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,			
			@RequestParam(value = "srcStartYear"	, defaultValue = "") String srcStartYear,
			@RequestParam(value = "srcStartMonth"	, defaultValue = "") String srcStartMonth,
			@RequestParam(value = "srcEndYear"	, defaultValue = "") String srcEndYear,
			@RequestParam(value = "srcEndMonth"	, defaultValue = "") String srcEndMonth,
			@RequestParam(value = "srcBorgName"	, defaultValue = "") String srcBorgName,
			@RequestParam(value = "srcVendorId"	, defaultValue = "") String srcVendorId,
			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String	srcStatDate = "";
		String  srcEndDate = "";
		
		if(!"".equals(srcStartYear) && !"".equals(srcStartMonth)){
			srcStartMonth = srcStartMonth.length() == 1 ? "0" + srcStartMonth : srcStartMonth;
			srcStatDate = srcStartYear + srcStartMonth;
		}
		
		if(!"".equals(srcEndYear) && !"".equals(srcEndMonth)){
			srcEndMonth = srcEndMonth.length() == 1 ? "0" + srcEndMonth : srcEndMonth;
			srcEndDate = srcEndYear + srcEndMonth;
		}
		
		paramMap.put("srcStatDate"	, srcStatDate);
		paramMap.put("srcEndDate"	, srcEndDate);
		paramMap.put("srcBorgNm"	, srcBorgName);
		paramMap.put("svcTypeCd"	, userInfoDto.getSvcTypeCd());
		
		if("VEN".equals(userInfoDto.getSvcTypeCd())){
			paramMap.put("vendorId"		, srcVendorId);
		}
		
		String orderString = " " + sidx + " " + sord + " ";
		paramMap.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
		int records = eBillSvc.selectEbillVendorListCnt(paramMap);
		int total = (int)Math.ceil((float)records / (float)rows);
		
		/*----------------조회------------*/
		List<EbillDto> list = null;
		if(records>0) list = eBillSvc.selectEbillVendorList(paramMap, page, rows);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	

	/**
	 * 공급사 채무관련 페이지 호출
	 */
	@RequestMapping("adjustVenDebtOccur.sys")
	public ModelAndView adjustVenDebtOccurrence(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {

		modelAndView.setViewName("adjust/adjustVenDebtOccur");
		return modelAndView;
	}
	
	/**
	 * 공급사 채무관련 
	 */
	@RequestMapping("adjustVenDebtCompanyListJQGrid.sys")
	public ModelAndView adjustVenDebtCompanyListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "clos_buyi_date") String sidx,
			@RequestParam(value = "sord", defaultValue = "asc") String sord,			
			@RequestParam(value = "vendorId", required=true) String vendorId,			
			@RequestParam(value = "srcPayStat", defaultValue="") String srcPayStat,						
			@RequestParam(value = "srcClosStartYear", defaultValue="") String srcClosStartYear,			
			@RequestParam(value = "srcClosStartMonth", defaultValue="") String srcClosStartMonth,			
			@RequestParam(value = "srcClosEndYear", defaultValue="") String srcClosEndYear,			
			@RequestParam(value = "srcClosEndMonth", defaultValue="") String srcClosEndMonth,			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		String preZero = "";
		
		params.put("vendorId"			, vendorId);
		params.put("srcPayStat"			, srcPayStat);

		if(srcClosStartMonth.length() == 1) preZero = "0";
		params.put("srcClosStartDate"	, srcClosStartYear + preZero + srcClosStartMonth);
		preZero = "";
		if(srcClosEndMonth.length() == 1) preZero = "0";
		params.put("srcClosEndDate"		, srcClosEndYear + preZero + srcClosEndMonth);

		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        /*----------------조회------------*/
        List<AdjustDto> list = adjustSvc.adjustVenDebtCompanyList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	


}
