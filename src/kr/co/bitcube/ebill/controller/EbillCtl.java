package kr.co.bitcube.ebill.controller;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.ebill.dto.EbillDto;
import kr.co.bitcube.ebill.service.EbillSvc;

import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("ebill")
public class EbillCtl {
	
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private EbillSvc eBillSvc;

	
	@RequestMapping("ebillBranchList.sys")
	public ModelAndView ebillBranchList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("ebill/ebillBranchList");
	}
	
	/**
	 * 고객사 세금계산서 목록 
	 */
	@RequestMapping("ebillBranchListJQGrid.sys")
	public ModelAndView ebillBranchListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "SALE_SEQU_NUMB") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,			
			@RequestParam(value = "srcStartYear"	, defaultValue = "") String srcStartYear,
			@RequestParam(value = "srcStartMonth"	, defaultValue = "") String srcStartMonth,
			@RequestParam(value = "srcEndYear"	, defaultValue = "") String srcEndYear,
			@RequestParam(value = "srcEndMonth"	, defaultValue = "") String srcEndMonth,
			@RequestParam(value = "srcBorgName"	, defaultValue = "") String srcBorgName,
			@RequestParam(value = "srcClientId"	, defaultValue = "") String srcClientId,
			@RequestParam(value = "srcBranchId"	, defaultValue = "") String srcBranchId,
			@RequestParam(value = "srcBusinessNum"	, defaultValue = "") String srcBusinessNum,

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
		paramMap.put("srcClientId"	, srcClientId);
		paramMap.put("srcBranchId"	, srcBranchId);
		paramMap.put("svcTypeCd"	, userInfoDto.getSvcTypeCd());
		paramMap.put("srcBusinessNum"	, srcBusinessNum);
		
		if("BUY".equals(userInfoDto.getSvcTypeCd())){
			paramMap.put("clientId"	, srcClientId);
		}

		String orderString = " " + sidx + " " + sord + " ";
		paramMap.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        int records = eBillSvc.selectEbillBranchListCnt(paramMap);
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<EbillDto> list = null;
        if(records>0) list = eBillSvc.selectEbillBranchList(paramMap, page, rows);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 고객사 세금계산서 목록 엑셀다운로드 
	 */
	@RequestMapping("ebillBranchListExcel.sys")
	public ModelAndView ebillBranchListExcel(
			@RequestParam(value = "sidx", defaultValue = "SALE_SEQU_NUMB") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,			
			@RequestParam(value = "srcStartYear"	, defaultValue = "") String srcStartYear,
			@RequestParam(value = "srcStartMonth"	, defaultValue = "") String srcStartMonth,
			@RequestParam(value = "srcEndYear"	, defaultValue = "") String srcEndYear,
			@RequestParam(value = "srcEndMonth"	, defaultValue = "") String srcEndMonth,
			@RequestParam(value = "srcBorgName"	, defaultValue = "") String srcBorgName,
			@RequestParam(value = "srcClientId"	, defaultValue = "") String srcClientId,
			@RequestParam(value = "srcBranchId"	, defaultValue = "") String srcBranchId,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
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
		paramMap.put("srcBorgNm"	, srcBorgName);
		paramMap.put("svcTypeCd"	, userInfoDto.getSvcTypeCd());
		
		if("BUY".equals(userInfoDto.getSvcTypeCd())){
			paramMap.put("clientId"	, srcClientId);
			paramMap.put("srcBranchId"	, srcBranchId);
		}
		
		String orderString = " " + sidx + " " + sord + " ";
		paramMap.put("orderString", orderString);
		
		/*----------------조회------------*/
		List<EbillDto> list = eBillSvc.selectEbillBranchList(paramMap, 1, RowBounds.NO_ROW_LIMIT);
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				rtnData.put("clos_date", list.get(i).getClos_date());
				rtnData.put("borgNm", list.get(i).getBorgNm());
				rtnData.put("businessNum", list.get(i).getBusinessNum());
				rtnData.put("sale_requ_amou", list.get(i).getSale_requ_amou());
				rtnData.put("sale_requ_vtax", list.get(i).getSale_requ_vtax());
				rtnData.put("sale_sequ_name", list.get(i).getSale_sequ_name());
				rtnData.put("sale_tota_amou", list.get(i).getSale_tota_amou());
				rtnData.put("sap_jour_numb", list.get(i).getSap_jour_numb());
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
	
	@RequestMapping("ebillVendorList.sys")
	public ModelAndView ebillVendorList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("ebill/ebillVendorList");
	}
	
	/**
	 * 공급사 세금계산서 목록 
	 */
	@RequestMapping("ebillVendorListJQGrid.sys")
	public ModelAndView ebillVendorListJQGrid(
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
	 * 공급사 세금계산서 목록 엑셀다운로드 
	 */
	@RequestMapping("ebillVendorListExcel.sys")
	public ModelAndView ebillVendorListExcel(
			@RequestParam(value = "sidx", defaultValue = "BUYI_SEQU_NUMB") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,			
			@RequestParam(value = "srcStartYear"	, defaultValue = "") String srcStartYear,
			@RequestParam(value = "srcStartMonth"	, defaultValue = "") String srcStartMonth,
			@RequestParam(value = "srcEndYear"	, defaultValue = "") String srcEndYear,
			@RequestParam(value = "srcEndMonth"	, defaultValue = "") String srcEndMonth,
			@RequestParam(value = "srcBorgName"	, defaultValue = "") String srcBorgName,
			@RequestParam(value = "srcVendorId"	, defaultValue = "") String srcVendorId,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,	
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
		
		/*----------------조회------------*/
		List<EbillDto> list = eBillSvc.selectEbillVendorList(paramMap, 1, RowBounds.NO_ROW_LIMIT);

		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				rtnData.put("clos_date", list.get(i).getClos_date());
				rtnData.put("borgNm", list.get(i).getBorgNm());
				rtnData.put("businessNum", list.get(i).getBusinessNum());
				rtnData.put("buyi_requ_amou", list.get(i).getBuyi_requ_amou());
				rtnData.put("buyi_requ_vtax", list.get(i).getBuyi_requ_vtax());
				rtnData.put("buyi_tota_amou", list.get(i).getBuyi_tota_amou());
				rtnData.put("sap_jour_numb", list.get(i).getSap_jour_numb());
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
}