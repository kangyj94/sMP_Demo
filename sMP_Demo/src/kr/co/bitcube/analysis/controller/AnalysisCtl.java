package kr.co.bitcube.analysis.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.adjust.service.AdjustSvc;
import kr.co.bitcube.analysis.dto.AnalysisDto;
import kr.co.bitcube.analysis.service.AnalysisSvc;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.common.dto.WorkInfoDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;

import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;


@Controller
@RequestMapping("analysis")
public class AnalysisCtl {
	
	private Logger logger = Logger.getLogger(getClass());
	@Autowired
	private AnalysisSvc analysisSvc;
	@Autowired
	private CommonSvc commonSvc;	
	@Autowired
	private AdjustSvc adjustSvc;
	/**
	 * 경영정보요약 페이지 이동
	 */
	@RequestMapping("analysisSummaryList.sys")
	public ModelAndView productAdmList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.setViewName("analysis/analysisSummaryList");
		return modelAndView;
	}
	
	/**
	 * 경영정보요약 조회
	 */
	@RequestMapping("analysisSummaryListJQGrid.sys")
	public ModelAndView analysisSummaryListJQGrid(
			@RequestParam(value = "srcResultToYear", defaultValue = "2010") String srcResultToYear,
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto        loginUserDto = CommonUtils.getLoginUserDto(request);
		Map<String, Object> params       = new HashMap<String, Object>();
		List<AnalysisDto>   list         = null;
		
		modelAndView = new ModelAndView("jsonView");
		
		params.put("srcResultToYear", srcResultToYear);
		params.put("loginUserDto",    loginUserDto);
        
        list = this.analysisSvc.getAnalysisSummaryList(params);
		
		modelAndView.addObject("list", list);
		
		return modelAndView;
	}
	
	/**
	 * 매출경영정보상세 페이지 이동
	 */
	@RequestMapping("analysisSalesList.sys")
	public ModelAndView analysisSalesList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.setViewName("analysis/analysisSalesList");
		return modelAndView;
	}
	
	/**
	 * 매출경영정보상세 조회
	 */
	@RequestMapping("analysisSalesListJQGrid.sys")
	public ModelAndView analysisSalesListJQGrid(
			@RequestParam(value = "srcResultToYear", defaultValue = "2010") String srcResultToYear,
			@RequestParam(value = "srcGroupId", defaultValue = "0") String srcGroupId,
			@RequestParam(value = "srcClientId", defaultValue = "0") String srcClientId,
			@RequestParam(value = "srcBranchId", defaultValue = "0") String srcBranchId,
			@RequestParam(value = "srcWorkInfoId", defaultValue = "") String srcWorkInfoId,
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcResultToYear", srcResultToYear);
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcWorkInfoId", srcWorkInfoId);
		params.put("loginUserDto", loginUserDto);
		
		/*----------------조회건수 및 금액 합계-------------------*/
		Map<String, Object> analysisSalesListTotal = analysisSvc.getAnalysisSalesListCnt(params);
		params.put("totalAmou",analysisSalesListTotal.get("TOTAL_AMOU"));

		/*----------------조회------------*/
		List<AnalysisDto> list =analysisSvc.getAnalysisSalesList(params);
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 매입경영정보상세 페이지 이동
	 */
	@RequestMapping("analysisBuyList.sys")
	public ModelAndView analysisBuyList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.setViewName("analysis/analysisBuyList");
		return modelAndView;
	}
	
	/**
	 * 매입경영정보상세 조회
	 */
	@RequestMapping("analysisBuyListJQGrid.sys")
	public ModelAndView analysisBuyListJQGrid(
			@RequestParam(value = "srcResultToYear", defaultValue = "2010") String srcResultToYear,
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcResultToYear", srcResultToYear);
		params.put("srcVendorId", srcVendorId);
		
        /*----------------조회------------*/
        List<AnalysisDto> list = analysisSvc.getAnalysisBuyList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 고객사별 손익실적 페이지 이동
	 */
	@RequestMapping("analysisCustomerList.sys")
	public ModelAndView analysisCustomerList(
			@RequestParam(value = "resultFromYear", defaultValue = "") String srcResultFromYear,
			@RequestParam(value = "resultFromMonth", defaultValue = "") String srcResultFromMonth,
			@RequestParam(value = "resultToYear", defaultValue = "") String srcResultToYear,
			@RequestParam(value = "resultToMonth", defaultValue = "") String srcResultToMonth,
			@RequestParam(value = "clientid", defaultValue = "") String srcClientid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		if(!"".equals(srcClientid)){
			modelAndView.addObject("srcClientid", srcClientid);
			modelAndView.addObject("resultFromYear", srcResultFromYear);
			modelAndView.addObject("resultFromMonth", srcResultFromMonth);
			modelAndView.addObject("resultToYear", srcResultToYear);
			modelAndView.addObject("resultToMonth", srcResultToMonth);
		}
		modelAndView.setViewName("analysis/analysisCustomerList");
		return modelAndView;
	}
	
	/**
	 * 고객사별 손익실적 페이지 이동
	 */
	@RequestMapping("analysisCustomerListDetail.sys")
	public ModelAndView analysisCustomerListDetail(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("analysis/analysisCustomerListDetail");
		return modelAndView;
	}
	
	/**
	 * 고객사별 손익실적 조회
	 */
	@RequestMapping("analysisCustomerListJQGrid.sys")
	public ModelAndView analysisCustomerListJQGrid(
			@RequestParam(value = "srcResultFromYear", defaultValue = "2010") String srcResultFromYear,
			@RequestParam(value = "srcResultFromMonth", defaultValue = "01") String srcResultFromMonth,
			@RequestParam(value = "srcResultToYear", defaultValue = "") String srcResultToYear,
			@RequestParam(value = "srcResultToMonth", defaultValue = "") String srcResultToMonth,
			@RequestParam(value = "srcGroupId", defaultValue = "0") String srcGroupId,
			@RequestParam(value = "srcClientId", defaultValue = "0") String srcClientId,
			@RequestParam(value = "srcBranchId", defaultValue = "0") String srcBranchId,
			@RequestParam(value = "srcSaleProdAmouFrom", defaultValue = "") String srcSaleProdAmouFrom,
			@RequestParam(value = "srcSaleProdAmouEnd", defaultValue = "") String srcSaleProdAmouEnd,
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcResultFrom", srcResultFromYear+srcResultFromMonth);
		params.put("srcResultTo", srcResultToYear+srcResultToMonth);
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcSaleProdAmouFrom",srcSaleProdAmouFrom);
		params.put("srcSaleProdAmouEnd", srcSaleProdAmouEnd);
		
		
//		if(srcSaleProdAmouFrom.equals("")) {
//			params.put("srcSaleProdAmouFrom", 1.40239846E-45f);
//			if(srcSaleProdAmouEnd.equals("")){
//				params.put("srcSaleProdAmouEnd", 3.40282347E+38f);
//			}
//		}else if(srcSaleProdAmouEnd.equals("")){
//			params.put("srcSaleProdAmouEnd", 3.40282347E+38f);
//		}
		
        /*----------------조회------------*/
        List<AnalysisDto> list = analysisSvc.getAnalysisCustomerList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 사업장 손익실적 조회
	 */
	@RequestMapping("analysisCustomerListDetailJQGrid.sys")
	public ModelAndView analysisCustomerListDetailJQGrid(
			@RequestParam(value = "srcResultFromYear", defaultValue = "2010") String srcResultFromYear,
			@RequestParam(value = "srcResultFromMonth", defaultValue = "01") String srcResultFromMonth,
			@RequestParam(value = "srcResultToYear", defaultValue = "") String srcResultToYear,
			@RequestParam(value = "srcResultToMonth", defaultValue = "") String srcResultToMonth,
			@RequestParam(value = "srcClientId", defaultValue = "0") String srcClientId,
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcResultFrom", srcResultFromYear+srcResultFromMonth);
		params.put("srcResultTo", srcResultToYear+srcResultToMonth);
		params.put("srcClientId", srcClientId);
		
        /*----------------조회------------*/
        List<AnalysisDto> list = analysisSvc.getAnalysisCustomerListDetail(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 고객사의 품목별 손익실적 조회
	 */
	@RequestMapping("analysisCustomerProductListJQGrid.sys")
	public ModelAndView analysisCustomerProductListJQGrid(
			@RequestParam(value = "srcResultFromYear", defaultValue = "2010") String srcResultFromYear,
			@RequestParam(value = "srcResultFromMonth", defaultValue = "01") String srcResultFromMonth,
			@RequestParam(value = "srcResultToYear", defaultValue = "") String srcResultToYear,
			@RequestParam(value = "srcResultToMonth", defaultValue = "") String srcResultToMonth,
			@RequestParam(value = "clientid", defaultValue = "") String clientid,
			@RequestParam(value = "branchid", defaultValue = "") String branchid,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcResultFrom", srcResultFromYear+srcResultFromMonth);
		params.put("srcResultTo", srcResultToYear+srcResultToMonth);
		params.put("clientid", clientid);
		params.put("branchid", branchid);
		
		/*----------------페이징 세팅------------*/
        int records = analysisSvc.getAnalysisCustomerProductListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<AnalysisDto> list = null;
        if(records>0) {
        	list = analysisSvc.getAnalysisCustomerProductList(params, page, rows);
        }

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 공급사별 손익실적 페이지 이동
	 */
	@RequestMapping("analysisVendorList.sys")
	public ModelAndView analysisVendorList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.setViewName("analysis/analysisVendorList");
		return modelAndView;
	}
	
	/**
	 * 공급사별 손익실적 조회
	 */
	@RequestMapping("analysisVendorListJQGrid.sys")
	public ModelAndView analysisVendorListJQGrid(
			@RequestParam(value = "srcResultFromYear", defaultValue = "2010") String srcResultFromYear,
			@RequestParam(value = "srcResultFromMonth", defaultValue = "01") String srcResultFromMonth,
			@RequestParam(value = "srcResultToYear", defaultValue = "") String srcResultToYear,
			@RequestParam(value = "srcResultToMonth", defaultValue = "") String srcResultToMonth,
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcResultFrom", srcResultFromYear+srcResultFromMonth);
		params.put("srcResultTo", srcResultToYear+srcResultToMonth);
		params.put("srcVendorId", srcVendorId);
		
        /*----------------조회------------*/
        List<AnalysisDto> list = analysisSvc.getAnalysisVendorList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 공급사의 품목별 손익실적 조회
	 */
	@RequestMapping("analysisVendoerProductListJQGrid.sys")
	public ModelAndView analysisVendoerProductListJQGrid(
			@RequestParam(value = "srcResultFromYear", defaultValue = "2010") String srcResultFromYear,
			@RequestParam(value = "srcResultFromMonth", defaultValue = "01") String srcResultFromMonth,
			@RequestParam(value = "srcResultToYear", defaultValue = "") String srcResultToYear,
			@RequestParam(value = "srcResultToMonth", defaultValue = "") String srcResultToMonth,
			@RequestParam(value = "vendorid", defaultValue = "") String vendorid,
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcResultFrom", srcResultFromYear+srcResultFromMonth);
		params.put("srcResultTo", srcResultToYear+srcResultToMonth);
		params.put("vendorid", vendorid);
		
        /*----------------조회------------*/
        List<AnalysisDto> list = analysisSvc.getAnalysisVendorProductList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 권역별 손익실적 페이지 이동
	 */
	@RequestMapping("analysisAreaList.sys")
	public ModelAndView analysisAreaList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.setViewName("analysis/analysisAreaList");
		return modelAndView;
	}
	
	/**
	 * 권역별 손익실적 조회
	 */
	@RequestMapping("analysisAreaListJQGrid.sys")
	public ModelAndView analysisAreaListJQGrid(
			@RequestParam(value = "srcResultFromYear", defaultValue = "2010") String srcResultFromYear,
			@RequestParam(value = "srcResultFromMonth", defaultValue = "01") String srcResultFromMonth,
			@RequestParam(value = "srcResultToYear", defaultValue = "") String srcResultToYear,
			@RequestParam(value = "srcResultToMonth", defaultValue = "") String srcResultToMonth,
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcResultFrom", srcResultFromYear+srcResultFromMonth);
		params.put("srcResultTo", srcResultToYear+srcResultToMonth);
		
        /*----------------조회------------*/
        List<AnalysisDto> list = analysisSvc.getAnalysisAreaList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 권역의 품목별 손익실적 조회
	 */
	@RequestMapping("analysisAreaProductListJQGrid.sys")
	public ModelAndView analysisAreaProductListJQGrid(
			@RequestParam(value = "srcResultFromYear", defaultValue = "2010") String srcResultFromYear,
			@RequestParam(value = "srcResultFromMonth", defaultValue = "01") String srcResultFromMonth,
			@RequestParam(value = "srcResultToYear", defaultValue = "") String srcResultToYear,
			@RequestParam(value = "srcResultToMonth", defaultValue = "") String srcResultToMonth,
			@RequestParam(value = "areatype", defaultValue = "") String areatype,
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcResultFrom", srcResultFromYear+srcResultFromMonth);
		params.put("srcResultTo", srcResultToYear+srcResultToMonth);
		params.put("areatype", areatype);
		
        /*----------------조회------------*/
        List<AnalysisDto> list = analysisSvc.getAnalysisAreaProductList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 품목별판매실적 페이지 이동
	 */
	@RequestMapping("analysisProductList.sys")
	public ModelAndView analysisProductList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.setViewName("analysis/analysisProductList");
		return modelAndView;
	}
	
	/**
	 * 품목별 판매실적 조회
	 */
	@RequestMapping("analysisProductListJQGrid.sys")
	public ModelAndView analysisProductListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "good_name") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcResultFromYear", defaultValue = "2010") String srcResultFromYear,
			@RequestParam(value = "srcResultFromMonth", defaultValue = "01") String srcResultFromMonth,
			@RequestParam(value = "srcResultToYear", defaultValue = "") String srcResultToYear,
			@RequestParam(value = "srcResultToMonth", defaultValue = "") String srcResultToMonth,
			@RequestParam(value = "srcGroupId", defaultValue = "0") String srcGroupId,
			@RequestParam(value = "srcClientId", defaultValue = "0") String srcClientId,
			@RequestParam(value = "srcBranchId", defaultValue = "0") String srcBranchId,
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,
			@RequestParam(value = "srcGoodRegYear", defaultValue = "") String srcGoodRegYear,
			@RequestParam(value = "srcCateId", defaultValue = "") String srcCateId,
			@RequestParam(value = "srcProductManager", defaultValue = "") String srcProductManager,
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
		logger.debug("srcGroupId : "+ srcGroupId);
		logger.debug("srcClientId : "+ srcClientId);
		logger.debug("srcBranchId : "+ srcBranchId);
		logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
		
		/*----------------조회조건 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcResultFrom", srcResultFromYear+srcResultFromMonth);
		params.put("srcResultTo", srcResultToYear+srcResultToMonth);
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcGoodRegYear", srcGoodRegYear);
		params.put("srcGoodName", srcGoodName);
		params.put("srcCateId", srcCateId);
		params.put("srcProductManager", srcProductManager);
		params.put("loginUserDto", loginUserDto);
		
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
		Map<String, Integer> records = analysisSvc.getAnalysisProductListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records.get("CNT") / (float)rows);
        /*----------------조회------------*/
        List<AnalysisDto> list = null;
        if(records.get("CNT")>0){
        	params.put("sum_sale_prod_amou", records.get("SUM_SALE_PROD_AMOU"));
        	params.put("sum_orde_quan", records.get("SUM_ORDE_QUAN"));
        	list = analysisSvc.getAnalysisProductList(params, page, rows);
        }
        

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records.get("CNT"));
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 공사유형 리스트
	 */
	@RequestMapping("getWorkInfoList.sys")
	public ModelAndView getWorkInfoList(ModelAndView mav,
										HttpServletRequest request) throws Exception{
		List<Map<String,Object>> list = analysisSvc.getWorkInfoList();
		mav = new ModelAndView("jsonView");
		mav.addObject("list",list);
		return mav;
	}
	
	/**
	 * 연 매출현황 JSP호출
	 */
	@RequestMapping("analysisYearSalesList.sys")
	public ModelAndView analysisYearSalesList(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		return new ModelAndView("analysis/analysisYearSalesList");
	}
	
	/**
	 * 연 매출현황 jqGrid
	 */
	@RequestMapping("analysisYearSalesListJQGrid.sys")
	public ModelAndView analysisYearSalesListJQGrid(
			@RequestParam(value="srcResultYear", defaultValue ="") String srcResultYear,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcResultYear", srcResultYear);
		List<AnalysisDto> list = analysisSvc.getAnalysisGoodRegYearList(params);
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 월 매출현황 JSP호출
	 */
	@RequestMapping("analysisMonthSalesList.sys")
	public ModelAndView analysisMonthSaleList (
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
//		return new ModelAndView("analysis/analysisMonthSalesList");	//기존 당월매출현황을 신규로 바꿈
		return new ModelAndView("analysis/analysisMonthSalesList_new");
	}
	
	/**
	 * 월 매출 현황 jqGrid
	 */
	@RequestMapping("analysisMonthSalesListJQGrid.sys")
	public ModelAndView analysisMonthSalesListJQGrid(
			@RequestParam(value="srcDateFlag", defaultValue="")String srcDateFlag,
			@RequestParam(value="srcResultYear", defaultValue="")String srcResultYear,
			@RequestParam(value="srcResultMonth", defaultValue="")String srcResultMonth,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcDateFlag", srcDateFlag);
		params.put("srcResultYear", srcResultYear);
		params.put("srcResultMonth", srcResultMonth);
		params.put("srcResultFrom", srcResultYear+srcResultMonth);
		List<AnalysisDto> list = analysisSvc.getAnalysisGoodRegMonthList(params);
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("userdata", params);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 공사유형별 월 예상실적 JSP호출
	 */
	@RequestMapping("analysisWorkInfoExpectationSalesList.sys")
	public ModelAndView analysisWorkInfoExpectationSalesList (
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		return new ModelAndView("analysis/analysisWorkInfoExpectationSalesList");
	}
	
	/**
	 * 공사유형별 월 예상실적 jqGrid 
	 */
	@RequestMapping("analysisWorkInfoExpectationSalesListJQGrid.sys")
	public ModelAndView analysisWorkInfoExpectationSalesListJQGrid (
			@RequestParam(value="srcResultYear", defaultValue="")String srcResultYear,
			@RequestParam(value="srcResultMonth", defaultValue="")String srcResultMonth,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcResultMonth", srcResultMonth);
		params.put("srcResultFrom", srcResultYear+srcResultMonth);
		
//		Map<String, Integer> count = analysisSvc.getAnalysisWorkInfoExpectationSalesCnt(params);
		
//		List<AnalysisDto> list = null;
//		if(count.get("CNT") > 0){
//			params.put("receive_list_sum",count.get("RECEIVE_LIST_SUM"));
//			params.put("receive_return_sum", count.get("RECEIVE_RETURN_SUM"));
//			params.put("receive_preorder_sum", count.get("RECEIVE_PREORDER_SUM"));
//			params.put("consignment_sum", count.get("CONSIGNMENT_SUM"));
//			params.put("consignment_preparation_sum", count.get("CONSIGNMENT_PREPARATION_SUM"));
//			params.put("purchase_order_sum", count.get("PURCHASE_ORDER_SUM"));
//			params.put("purchase_request_sum", count.get("PURCHASE_REQUEST_SUM"));
//			params.put("order_request_sum", count.get("ORDER_REQUEST_SUM"));
//			params.put("approval_request_sum", count.get("APPROVAL_REQUEST_SUM"));
//			params.put("summary_tota_amou_sum", count.get("SUMMARY_TOTA_AMOU_SUM"));
//			params.put("assume_sum", count.get("ASSUME_SUM"));
			List<AnalysisDto> list = analysisSvc.getAnalysisWorkInfoExpectationSalesList(params);
//		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		modelAndView.addObject("userdata", params);
		return modelAndView;
	}
	
	
	/**
	 * 일자별 주문실적, 출하실적, 인수실적 JSP호출
	 */
	@RequestMapping("analysisWeekDaySalesList.sys")
	public ModelAndView analysisWeekDaySalesList (
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		return new ModelAndView("analysis/analysisWeekDaySalesList");
	}
	
	/**
	 * 일자별 주문실적, 출하실적, 인수실적 JQGrid
	 */
	@RequestMapping("analysisWeekDaySalesListJQGrid.sys")
	public ModelAndView analysisWeekDaySalesListJQGrid (
			@RequestParam(value="srcResultYear",  defaultValue="") String srcResultYear,
			@RequestParam(value="srcResultMonth", defaultValue="") String srcResultMonth,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("srcResultFrom", srcResultYear + srcResultMonth);
		
		List<AnalysisDto> list = analysisSvc.getAnalysisWeekDaySalesList(params);
		
		modelAndView = new ModelAndView("jsonView");
		
		modelAndView.addObject("list", list);
		
		return modelAndView;
	}
	
	/**===================================================================================================
	 * 채권관리 
	 */
	@RequestMapping("analysisBonds.sys")
	public ModelAndView analysisBonds (
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		
		Date date = new Date();
		Date paramDate = null;
		SimpleDateFormat sdfYear = new SimpleDateFormat("yyyy");
		SimpleDateFormat sdfMonth = new SimpleDateFormat("MM");
		
		String pDate = "";
		
		for(int i = 12 ; i > 0 ; i--){
			
			Calendar cal = Calendar.getInstance();
	        cal.setTime(date);
	        cal.add(Calendar.MONTH, -i);
			paramDate = cal.getTime();
			pDate += ",'"+sdfYear.format(paramDate)+"년 "+sdfMonth.format(paramDate)+"월기준'";
		}
		modelAndView.addObject("pDate", pDate);
		modelAndView.setViewName("analysis/analysisBonds");
		return modelAndView;
	}

	/**
	 * 전체채권현황 JQGrid
	 * @param srcYear
	 * @param srcMonth
	 * @param modelAndView
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("analysisBondsListJQGrid.sys")
	public ModelAndView analysisBondsListJQGrid (
			@RequestParam(value="srcDate", defaultValue="")String srcDate,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("srcDate", srcDate);
		
		List<AnalysisDto> list = analysisSvc.getAnalysisBonds(params);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		
		return modelAndView;
	}

	/**
	 * 월별채권현황 JQGrid
	 * @param srcYear
	 * @param srcMonth
	 * @param modelAndView
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("analysisBondsDetailJQGrid.sys")
	public ModelAndView analysisBondsDetailJQGrid (
			@RequestParam(value="srcYear1", defaultValue="")String srcYear,
			@RequestParam(value="srcMonth1", defaultValue="")String srcMonth,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		Map<String, Object> resultMap = null;
		
		Date date = new Date();
		date.setYear(Integer.parseInt(srcYear)-1900);
		date.setMonth(Integer.parseInt(srcMonth)-1);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		Date 	paramDate = null;
		String 	pDate = "";
		String 	cDate = "";
		int    	cName = 0;
		int 	startMonth = 0;

		for(int i = 0 ; i < 7 ; i++){

			for(int j = 0 ; j < 12 ; j++){
				
				Calendar cal = Calendar.getInstance();
		        cal.setTime(date);
		        cal.add(Calendar.MONTH, (startMonth + j)*-1);
		        
				paramDate = cal.getTime();
				
				if(j == 0){
					cDate = "S"+sdf.format(paramDate) + " AS M" + cName;
					pDate = "[S"+sdf.format(paramDate)+"]";
				}else{
					cDate += ",S"+sdf.format(paramDate) + " AS M" + cName;
					pDate += ",[S"+sdf.format(paramDate)+"]";
				}
				cName++;
			}

			String sqlWhereStr = "";
			Date curDate = new Date();
			
			long compareTime = (curDate.getTime() - date.getTime()) / (1000*60*60*24) / 30;
			
			if(i == 6){
				sqlWhereStr = "WHERE CLOS_YEAR + CLOS_MONTH > CONVERT(VARCHAR(6), DATEADD(MONTH, -"+(12 + i + compareTime)+", GETDATE()),112)";
			}else{
				sqlWhereStr = "WHERE CLOS_YEAR + CLOS_MONTH BETWEEN CONVERT(VARCHAR(6), DATEADD(MONTH, -"+(12 + i + compareTime)+", GETDATE()),112) AND CONVERT(VARCHAR(6), GETDATE(),112)";
			}
			
			params.put("sqlWhereStr", sqlWhereStr ); 
			params.put("cDate", cDate); 
			params.put("pDate", pDate); 
			
			
			resultMap = analysisSvc.getAnalysisBondsDetail(params);
			list.add(i, resultMap);

			cName = 0;
			startMonth++;
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		
		return modelAndView;
	}
	/*#######################20140217##############################*/
	/**
	 * 채권관리업체
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("analysisBondsCorp.sys")
	public ModelAndView analysisBondsCorpList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orderString", " workNm asc");
		List<UserDto> admUserList = adjustSvc.getAdjustAlramUserList();
		List<WorkInfoDto> workInfoList = commonSvc.selectWorkInfo(params);
		modelAndView.addObject("admUserList", admUserList);
		modelAndView.addObject("workInfoList", workInfoList);
		modelAndView.setViewName("analysis/analysisBondsCorpList");
		return modelAndView;
	}
	
	@RequestMapping("analysisBondsCorpListJQGrid.sys")
	public ModelAndView analysisBondsCorpListJQGrid(
			@RequestParam(value = "srcBondDiv", defaultValue = "") String srcBondDiv,
			@RequestParam(value = "srcAccUser", defaultValue = "") String srcAccUser,
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
//		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
		logger.debug("#############채권관리업체##############");
		logger.debug("srcBondDiv : "+ srcBondDiv);//채원구분
		logger.debug("srcAccUser : "+ srcAccUser);//채권담당자
		logger.debug("srcBranchId : "+ srcBranchId);//사업장조회
		logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("srcBranchId", srcBranchId);
		params.put("srcAccUser", srcAccUser);
		params.put("srcBondDiv", srcBondDiv);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        int records = analysisSvc.getAnalysisBondsCorpListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<AnalysisDto> list = analysisSvc.getAnalysisBondsCorpList(params, page, rows);

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
	@RequestMapping("analysisBondsCorpListExcel.sys")
	public ModelAndView analysisBondsCorpListExcel(
			@RequestParam(value = "sidx", defaultValue = "branchId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcAccUser", defaultValue = "") String srcAccUser,
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,
			@RequestParam(value = "srcBondDiv", defaultValue = "") String srcBondDiv,
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcAccUser", srcAccUser);
		params.put("srcBondDiv", srcBondDiv);
		params.put("srcBranchId", srcBranchId);
		if("BUY".equals(userInfoDto.getSvcTypeCd())) {
			params.put("srcClientId", userInfoDto.getClientId());
		}
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------조회------------*/
		List<AnalysisDto> list = analysisSvc.getAnalysisBondsCorpList(params, 1, RowBounds.NO_ROW_LIMIT);
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				rtnData.put("branchnm", list.get(i).getBranchnm().replace("&gt;", ">"));
				rtnData.put("businessnum", list.get(i).getBusinessNum());
				rtnData.put("usernm", list.get(i).getUsernm());
				rtnData.put("sum_amou", list.get(i).getSum_amou());
				rtnData.put("clos_sale_date", list.get(i).getClos_sale_date());
				rtnData.put("st_over_date", list.get(i).getSt_over_date());
				rtnData.put("clos_over_date", list.get(i).getClos_over_date());
				rtnData.put("rece_name", list.get(i).getRece_name());
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
	/*#######################20140217 끝##############################*/
	
	/**
	 * 품목별 판매실적 일괄 엑셀출력
	 */
	@RequestMapping("analysisProductListExcel.sys")
	public ModelAndView analysisProductListExcel (
			@RequestParam(value = "srcResultFromYear", defaultValue = "2010") String srcResultFromYear,
			@RequestParam(value = "srcResultFromMonth", defaultValue = "01") String srcResultFromMonth,
			@RequestParam(value = "srcResultToYear", defaultValue = "") String srcResultToYear,
			@RequestParam(value = "srcResultToMonth", defaultValue = "") String srcResultToMonth,
			@RequestParam(value = "srcGroupId", defaultValue = "0") String srcGroupId,
			@RequestParam(value = "srcClientId", defaultValue = "0") String srcClientId,
			@RequestParam(value = "srcBranchId", defaultValue = "0") String srcBranchId,
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
			@RequestParam(value = "srcGoodIdenNumb", defaultValue = "") String srcGoodIdenNumb,
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,
			@RequestParam(value = "srcCateId", defaultValue = "") String srcCateId,
			@RequestParam(value = "srcProductManager", defaultValue = "") String srcProductManager,
			@RequestParam(value = "sidx", defaultValue = "good_name") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcResultFrom", srcResultFromYear+srcResultFromMonth);
		params.put("srcResultTo", srcResultToYear+srcResultToMonth);
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcGoodIdenNumb", srcGoodIdenNumb);
		params.put("srcGoodName", srcGoodName);
		params.put("srcCateId", srcCateId);
		params.put("srcProductManager", srcProductManager);
		params.put("loginUserDto", loginUserDto);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);

		/*----------------조회------------*/
		List<AnalysisDto> list =  analysisSvc.getAnalysisProductList(params, 1, RowBounds.NO_ROW_LIMIT);
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i=0; i<list.size();i++){
				String result = "";
//				try{
//					String[] tempGoodStSpecDesc = new String[Constances.PROD_GOOD_ST_SPEC.length]; 
//					for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {
//						tempGoodStSpecDesc[idx] = Constances.PROD_GOOD_ST_SPEC[idx];
//					}
//					if(null != list.get(i).getGood_St_Spec_Desc()){
//						String[] tempGoodStSpecDescArray =  list.get(i).getGood_St_Spec_Desc().split("‡");
//							for(int idx = 0 ; idx < tempGoodStSpecDescArray.length ; idx++) {
//								if(tempGoodStSpecDescArray[idx].toString().trim().length()  > 0) {
//									result += tempGoodStSpecDesc[idx]+":"+ tempGoodStSpecDescArray[idx] + " ";
//								}
//							}
//					}
//					if(!"".equals(result)) result = "[" + result + "]";
//					String[] tempGoodSpecDesc = new String[Constances.PROD_GOOD_SPEC.length]; 
//					for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {
//						tempGoodSpecDesc[idx] = Constances.PROD_GOOD_SPEC[idx];
//					}
//					if(null != list.get(i).getGood_Spec_Desc()){
//						String[] tempGoodSpecDescArray = list.get(i).getGood_Spec_Desc().split("‡");
//						for(int idx = 0 ; idx < tempGoodSpecDescArray.length ; idx++) {
//							if(tempGoodSpecDescArray[idx].toString().trim().length()  > 0) {
//								if(idx == 0 ) {
//									result += "  "+ tempGoodSpecDescArray[idx] + "  ";
//								} else {
//									result += tempGoodSpecDesc[idx]+":"+ tempGoodSpecDescArray[idx] + " ";
//								}
//							}
//						}
//					}
//				}catch(Exception e){result="";}		
				Map<String, Object> rtnData = new HashMap<String, Object>();
				rtnData.put("good_iden_numb", list.get(i).getGood_iden_numb());
				rtnData.put("cate_name1", list.get(i).getCate_name1());
				rtnData.put("cate_name2", list.get(i).getCate_name2());
				rtnData.put("cate_name3", list.get(i).getCate_name3());
				rtnData.put("good_name", list.get(i).getGood_name());
				rtnData.put("vendornm", list.get(i).getVendornm());
				rtnData.put("businessNum", list.get(i).getBusinessNum());
				rtnData.put("orde_cnt", list.get(i).getOrde_cnt());
				rtnData.put("orde_quan", list.get(i).getOrde_quan());
				rtnData.put("sale_prod_amou", list.get(i).getSale_prod_amou());
				rtnData.put("purc_prod_amou", list.get(i).getPurc_prod_amou());
				rtnData.put("prof_amou", list.get(i).getProf_amou());
				rtnData.put("goodClasCode", list.get(i).getGoodClasCode());
				rtnData.put("goodSpec", list.get(i).getGood_Spec());
				rtnData.put("productManager", list.get(i).getProductManager());
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
